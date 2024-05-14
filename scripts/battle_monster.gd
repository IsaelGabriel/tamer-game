extends Node2D

class_name BattleMonster

static var MOVEMENT_PAUSED: bool = false

class BattleMonsterState:
	var _battle_monster
	
	func _init(battle_monster: BattleMonster):
		self._battle_monster = battle_monster
	
	func start(): pass
	func process(_delta): pass
	func end(): pass

var monster: Monster = Monster.new("Test Monster")

@export var skill_manager: SkillManagerComponent
@export var sprite: Sprite2D
@export var base: Sprite2D
@export var goal: Sprite2D

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
	
	DialogHandler.display_dialog("%s has arrived!" % monster.name)

func _process(delta):
	if state != null:
		state.process(delta)

func get_monster():
	return monster

