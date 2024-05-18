extends Node

class_name BattleManager

static var CURRENT: BattleManager = null

const BATTLE_MONSTER_PREFAB = preload("res://nodes/battle_monster.tscn")

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

var player_monsters: Array[BattleMonster]
var enemy_monsters: Array[BattleMonster]

func _ready():
	if CURRENT != self and CURRENT != null:
		CURRENT.queue_free()
	CURRENT = self
	# Spawn Battle Monsters
	var screen_center = get_viewport().content_scale_size / 2
	for i in range(0, total_player_monsters):
		var monster = BATTLE_MONSTER_PREFAB.instantiate()
		#var skill_card_container = HBoxContainer.new()
		#skill_card_container.alignment = BoxContainer.ALIGNMENT_CENTER
		#monster.skill_card_container = skill_card_container
		monster.is_player = true
		monster.position = Vector2(screen_center.x / 2, calculate_monster_y(i, total_player_monsters))
		monster.scale *= monster_scale
		#ui_container.add_child(skill_card_container)
		add_child(monster)
		monster.sprite.position = monster.base.position
		player_monsters.append(monster)
	
	for i in range(0, total_enemy_monsters):
		var monster = BATTLE_MONSTER_PREFAB.instantiate()
		monster.is_player = false
		monster.position = Vector2(screen_center.x * 3 / 2, calculate_monster_y(i, total_enemy_monsters))
		monster.scale *= monster_scale
		add_child(monster)
		monster.sprite.position = monster.base.position
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

func _process(_delta):
	for monster in enemy_monsters:
		if monster.skill_queue.is_empty() and monster.current_state == BattleMonster.BattleMonsterState.AWAIT_COMMAND:
			monster.skill_queue.append(0)
			monster.targets[0] = player_monsters[0]
