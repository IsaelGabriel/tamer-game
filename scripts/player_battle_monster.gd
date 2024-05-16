extends BattleMonster

class_name PlayerBattleMonster

class BMSAwaitCommand :
	extends BattleMonsterState
	
	var skill_manager : SkillManagerComponent
	var skill_card_container : HBoxContainer
	var called_skill: bool = false
	
	func start():
		skill_manager = _battle_monster.skill_manager
		skill_card_container = _battle_monster.skill_card_container
		call_first_skill()
	
	func process(delta):
		if not called_skill: call_first_skill()

	func call_first_skill():
		if not _battle_monster.skill_queue.is_empty():
			var card = _battle_monster.skill_queue.pop_front()
			var index = skill_card_container.get_children().find(card)
			var skill = skill_manager.hand[index]
			skill_manager.call_skill_from_hand(index)
			_battle_monster.called_skill.emit(_battle_monster, skill)
			called_skill = true
			card.queue_free()
			_battle_monster.skill_queue.erase(card)
			_battle_monster.refresh_skill_cards()
			_battle_monster.state = BMSReturn.new(_battle_monster)

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
		if BattleMonster.MOVEMENT_PAUSED: return
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
		if BattleMonster.MOVEMENT_PAUSED: return
		interpolation_timer += delta * speed * 0.01
		interpolation_timer = min(interpolation_timer, 1.0)
		sprite.position = goal.position.lerp(base.position, interpolation_timer)
		if interpolation_timer >= 1.0:
			_battle_monster.state = BMSForward.new(_battle_monster)

@export var skill_card_container: HBoxContainer

@onready var skill_card_prefab = load("res://nodes/skill_card.tscn")

var skill_queue = []
var selected_skill_card_index: int = 0:
		set(value):
			var hand_number = len(skill_manager.hand)
			for child in skill_card_container.get_children():
				child.selected = false
			if value < 0: selected_skill_card_index = hand_number - 1
			elif value >= hand_number: selected_skill_card_index = 0
			else: selected_skill_card_index = value
			skill_card_container.get_child(selected_skill_card_index).selected = true


func _ready():
	super()
	state = BMSForward.new(self)
	refresh_skill_cards()

func _process(delta):
	super(delta)
	process_skill_cards()

func process_skill_cards():
	if Input.is_action_just_pressed("ui_left"):
		selected_skill_card_index -= 1
	if Input.is_action_just_pressed("ui_right"):
		selected_skill_card_index += 1
	if Input.is_action_just_pressed("ui_accept"):
		var card = skill_card_container.get_child(selected_skill_card_index)
		if card in skill_queue:
			skill_queue.erase(card)
		else:
			skill_queue.append(card)
	refresh_skill_cards()
		
	
func refresh_skill_cards():
	var cards = skill_card_container.get_children()
	var hand = skill_manager.hand
	
	for i in range(0, len(hand)):
		if i >= len(cards):
			var skill_card = skill_card_prefab.instantiate()
			skill_card_container.add_child(skill_card)
			cards.append(skill_card)
		cards[i].index = skill_queue.find(cards[i])
		cards[i].skill_name = hand[i]
		
	await get_tree().create_timer(0.01).timeout
	var i = selected_skill_card_index
	selected_skill_card_index = 0
	selected_skill_card_index = i
	
