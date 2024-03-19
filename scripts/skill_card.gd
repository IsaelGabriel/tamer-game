extends Control

class_name SkillCard

@export var name_label: Label

var skill_name: String = "Skill" :
	set(value):
		name_label.text = value
		skill_name = value
