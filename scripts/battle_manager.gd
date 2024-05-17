extends Node

class_name BattleManager

@onready var player_battle_monster_prefab = preload("res://nodes/player_battle_monster.tscn")
@onready var enemy_battle_monster_prefab = preload("res://nodes/enemy_battle_monster.tscn")

@onready var monster_card_prefab = preload("res://nodes/battle_monster_card.tscn")

@export_category("UI")
@export var ui_container: MarginContainer

@export_category("Monsters")
@export_range(1, 10) var total_player_monsters: int = 1
@export_range(1, 10) var total_enemy_monsters: int = 1
@export_range(0, 60) var movement_start_countdown: float = 10.0

@export_category("Spawn Area")
@export var top_margin: float = 0
@export var bottom_margin: float = 0
@export var monster_scale: float = 1.0

var monster_card_container: HBoxContainer

var player_monsters: Array[PlayerBattleMonster]
var enemy_monsters: Array[EnemyBattleMonster]
var selected_monster_card_index: int = 0:
	set(value):
		monster_card_container.get_child(selected_monster_card_index).selected = false
		if value < 0: value = total_player_monsters - 1
		if value >= total_player_monsters: value = 0
		monster_card_container.get_child(value).selected = true
		selected_monster_card_index = value

func _ready():
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
	
	generate_monster_cards()
	movement_countdown()

func calculate_monster_y(index: int, total: int) -> float:
	var height = get_viewport().content_scale_size.y - (bottom_margin + top_margin)
	var y = top_margin + (height * (index+1) / (total+1))
	return y

func generate_monster_cards():
	monster_card_container = HBoxContainer.new()
	monster_card_container.alignment = BoxContainer.ALIGNMENT_CENTER
	ui_container.add_child(monster_card_container)
	
	for battle_monster in player_monsters:
		var card = monster_card_prefab.instantiate()
		card.monster = battle_monster.monster
		monster_card_container.add_child(card)
	await get_tree().create_timer(0.001).timeout
	monster_card_container.get_child(0).selected = true

func movement_countdown():
	BattleMonster.MOVEMENT_PAUSED = true
	await get_tree().create_timer(movement_start_countdown).timeout
	BattleMonster.MOVEMENT_PAUSED = false

func _process(_delta):
	if monster_card_container.visible:
		selected_monster_card_index += int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
		if Input.is_action_just_pressed("ui_up"):
			player_monsters[selected_monster_card_index].skill_cards_active = true
			monster_card_container.visible = false
	else:
		if Input.is_action_just_pressed("ui_down"):
			player_monsters[selected_monster_card_index].skill_cards_active = false
			monster_card_container.visible = true
