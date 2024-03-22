extends Node2D

class_name BattleMonster

class BattleMonsterState:
	var _battle_monster
	
	func _init(battle_monster: BattleMonster):
		self._battle_monster = battle_monster
	
	func start(): pass
	func process(_delta): pass
	func end(): pass

class BMSAwaitCommand :
	extends BattleMonsterState
	
	var skill_manager : SkillManagerComponent
	var skill_card_container : HBoxContainer
	
	var selected_skill_index: int = 0:
		set(value):
			var hand_number = len(skill_manager.hand)
			for child in skill_card_container.get_children():
				child.selected = false
			if value < 0: selected_skill_index = hand_number - 1
			elif value >= hand_number: selected_skill_index = 0
			else: selected_skill_index = value
			skill_card_container.get_child(selected_skill_index).selected = true
	
	
	func start():
		skill_manager = _battle_monster.skill_manager
		skill_card_container = _battle_monster.skill_card_container
		for skill in skill_manager.hand:
			var skill_card = _battle_monster.skill_card_prefab.instantiate()
			skill_card.skill_name = skill["name"]
			skill_card_container.add_child(skill_card)
		await _battle_monster.get_tree().create_timer(0.01).timeout
		skill_card_container.get_child(0).selected = true
	
	func process(_delta):
		if Input.is_action_just_pressed("ui_left"):
			selected_skill_index -= 1
		if Input.is_action_just_pressed("ui_right"):
			selected_skill_index += 1
		if Input.is_action_just_pressed("ui_accept"):
			var skill = skill_manager.hand[selected_skill_index]
			skill_manager.call_skill_from_hand(selected_skill_index)
			_battle_monster.called_skill.emit(_battle_monster, skill)
			skill_card_container.remove_child(skill_card_container.get_child(selected_skill_index))
			_battle_monster.state = BMSReturn.new(_battle_monster)
	
	func end():
		for child in skill_card_container.get_children():
			child.queue_free()
			
class BMSForward:
	extends BattleMonsterState
	
	var speed: float
	var base: Sprite2D
	var goal: Sprite2D
	var sprite: Sprite2D
	var interpolation_timer: float = 0.0
	
	func start():
		speed = _battle_monster.monster.speed
		base = _battle_monster.base
		goal = _battle_monster.goal
		sprite = _battle_monster.sprite
		
		sprite.flip_h = false
	
	func process(delta):
		interpolation_timer += delta * speed * 0.01
		interpolation_timer = min(interpolation_timer, 1.0)
		sprite.position = base.position.lerp(goal.position, interpolation_timer)
		if interpolation_timer >= 1.0:
			_battle_monster.state = BMSAwaitCommand.new(_battle_monster)

class BMSReturn:
	extends BattleMonsterState
	
	var speed: float
	var base: Sprite2D
	var goal: Sprite2D
	var sprite: Sprite2D
	var interpolation_timer: float = 0.0
	
	func start():
		speed = _battle_monster.monster.speed
		base = _battle_monster.base
		goal = _battle_monster.goal
		sprite = _battle_monster.sprite
		
		sprite.flip_h = true
	
	func process(delta):
		interpolation_timer += delta * speed * 0.01
		interpolation_timer = min(interpolation_timer, 1.0)
		sprite.position = goal.position.lerp(base.position, interpolation_timer)
		if interpolation_timer >= 1.0:
			_battle_monster.state = BMSForward.new(_battle_monster)

var monster: Monster = Monster.new("Test Monster")

@export var skill_manager: SkillManagerComponent
@export var skill_card_container: HBoxContainer
@export var sprite: Sprite2D
@export var base: Sprite2D
@export var goal: Sprite2D

@onready var skill_card_prefab = load("res://nodes/skill_card.tscn")
		
@onready var state: BattleMonsterState = null :
	set(value):
		if state:
			state.end()
		state = value
		state.start()

signal called_skill(battle_monster: BattleMonster, skill: String)

func _ready():
	skill_manager.load_skills(monster.skills)
	sprite.position = base.position
	
	state = BMSForward.new(self)

func _process(delta):
	if state != null:
		state.process(delta)

