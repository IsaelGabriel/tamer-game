extends Node

class_name BattleManager

@onready var player_battle_monster_prefab = preload("res://nodes/player_battle_monster.tscn")
@onready var enemy_battle_monster_prefab = preload("res://nodes/enemy_battle_monster.tscn")

@export_category("UI")
@export var skill_card_container: HBoxContainer

@export_category("Monsters")
@export_range(1, 10) var total_player_monsters: int = 1
@export_range(1, 10) var total_enemy_monsters: int = 1

@export_range(0, 8000) var monster_y_offset: int = 50
@export var monster_scale: float = 1.0

var player_monsters: Array[PlayerBattleMonster]
var enemy_monsters: Array[EnemyBattleMonster]

func _ready():
	# Spawn Battle Monsters
	var screen_center = get_viewport().content_scale_size / 2
	for i in range(0, total_player_monsters):
		var monster = player_battle_monster_prefab.instantiate()
		monster.skill_card_container = skill_card_container
		monster.position = Vector2(screen_center.x / 2, calculate_monster_y(i, total_player_monsters))
		monster.scale *= monster_scale
		add_child(monster)
		player_monsters.append(monster)
	
	for i in range(0, total_enemy_monsters):
		var monster = enemy_battle_monster_prefab.instantiate()
		monster.position = Vector2(screen_center.x * 3 / 2, calculate_monster_y(i, total_enemy_monsters))
		monster.scale *= monster_scale
		add_child(monster)
		enemy_monsters.append(monster)
	player_monsters[0].skill_cards_active = true

func calculate_monster_y(index: int, total: int) -> float:
	var start_y = (get_viewport().content_scale_size.y - monster_y_offset * (total - 1)) / 2
	return start_y + monster_y_offset * index
