extends Node2D

class_name Monster

@export var skill_manager: SkillManagerComponent

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		skill_manager.call_skill_from_hand(0)
