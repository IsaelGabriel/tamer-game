extends Node2D

class_name BattleMonster

var monster: Monster = Monster.new("Test Monster")

@export var skill_manager: SkillManagerComponent
@export var skill_card_container: HBoxContainer

@onready var skill_card_prefab = load("res://nodes/skill_card.tscn")

func _ready():
	skill_manager.load_skills(monster.skills)
	for skill in skill_manager.hand:
		var skill_card = skill_card_prefab.instantiate()
		skill_card.skill_name = skill["name"]
		skill_card_container.add_child(skill_card)
