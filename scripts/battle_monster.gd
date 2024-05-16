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

@onready var skill_manager: SkillManagerComponent = $SkillManagerComponent
@onready var sprite: Sprite2D = $Sprite2D
@onready var base: Sprite2D = $Base
@onready var goal: Sprite2D = $Goal

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

func _process(delta):
	if state != null:
		state.process(delta)

func get_monster():
	return monster

