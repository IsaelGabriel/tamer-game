extends Node

class_name BattleManager

static var CURRENT: BattleManager = null

@onready var player_battle_monster_prefab = preload("res://nodes/player_battle_monster.tscn")
@onready var enemy_battle_monster_prefab = preload("res://nodes/enemy_battle_monster.tscn")

@export_category("UI")
@export var ui_container: MarginContainer
@export var target_texture: TextureRect
@export var ui_manager: BattleUIManager

@export_category("Monsters")
@export_range(1, 10) var total_player_monsters: int = 1
@export_range(1, 10) var total_enemy_monsters: int = 1
@export_range(0, 60) var movement_start_countdown: float = 10.0

@export_category("Spawn Area")
@export var top_margin: float = 0
@export var bottom_margin: float = 0
@export var monster_scale: float = 1.0

var player_monsters: Array[PlayerBattleMonster]
var enemy_monsters: Array[EnemyBattleMonster]

func _ready():
	if CURRENT != self and CURRENT != null:
		CURRENT.queue_free()
	CURRENT = self
	# Spawn Battle Monsters
	var screen_center = get_viewport().content_scale_size / 2
	for i in range(0, total_player_monsters):
		var monster = player_battle_monster_prefab.instantiate()
		var skill_card_container = HBoxContainer.new()
		skill_card_container.alignment = BoxContainer.ALIGNMENT_CENTER
		monster.skill_card_container = skill_card_container
		monster.position = Vector2(screen_center.x / 2, calculate_monster_y(i, total_player_monsters))
		monster.scale *= monster_scale
		ui_container.add_child(skill_card_container)
		add_child(monster)
		player_monsters.append(monster)
	
	for i in range(0, total_enemy_monsters):
		var monster = enemy_battle_monster_prefab.instantiate()
		monster.position = Vector2(screen_center.x * 3 / 2, calculate_monster_y(i, total_enemy_monsters))
		monster.scale *= monster_scale
		add_child(monster)
		enemy_monsters.append(monster)
	
	ui_manager.start()
	movement_countdown()
	DialogHandler.display_dialog("BATTLE START IN %d SECONDS!!!" % int(movement_start_countdown))

func calculate_monster_y(index: int, total: int) -> float:
	var height = get_viewport().content_scale_size.y - (bottom_margin + top_margin)
	var y = top_margin + (height * (index+1) / (total+1))
	return y

func movement_countdown():
	BattleMonster.MOVEMENT_PAUSED = true
	await get_tree().create_timer(movement_start_countdown).timeout
	BattleMonster.MOVEMENT_PAUSED = false
