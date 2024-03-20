extends Control

class_name SkillCard

@export var name_label: Label

var skill_name: String = "Skill" :
	set(value):
		name_label.text = value
		skill_name = value

var selected = false : 
	set(value):
		if value:
			position.y = -20
		else:
			position.y = 0
		selected = value
