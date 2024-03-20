extends Node2D

class_name BattleMonster

var monster: Monster = Monster.new("Test Monster")

@export var skill_manager: SkillManagerComponent
@export var skill_card_container: HBoxContainer

@onready var skill_card_prefab = load("res://nodes/skill_card.tscn")

@onready var selected_skill_index = 0:
	set(value):
		var hand_number = len(skill_manager.hand)
		for child in skill_card_container.get_children():
			child.selected = false
		if value < 0: selected_skill_index = hand_number - 1
		elif value >= hand_number: selected_skill_index = 0
		else: selected_skill_index = value
		skill_card_container.get_child(selected_skill_index).selected = true
		

func _ready():
	skill_manager.load_skills(monster.skills)
	for skill in skill_manager.hand:
		var skill_card = skill_card_prefab.instantiate()
		skill_card.skill_name = skill["name"]
		skill_card_container.add_child(skill_card)
	await get_tree().create_timer(0.01).timeout
	skill_card_container.get_child(0).selected = true

func _process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		selected_skill_index -= 1
	if Input.is_action_just_pressed("ui_right"):
		selected_skill_index += 1
	if Input.is_action_just_pressed("ui_accept"):
		skill_manager.call_skill_from_hand(selected_skill_index)
		skill_card_container.remove_child(skill_card_container.get_child(selected_skill_index))
		if skill_card_container.get_child_count() == 0:
			for skill in skill_manager.hand:
				var skill_card = skill_card_prefab.instantiate()
				skill_card.skill_name = skill["name"]
				skill_card_container.add_child(skill_card)
		selected_skill_index = 0
		await get_tree().create_timer(0.01).timeout
		skill_card_container.get_child(0).selected = true
