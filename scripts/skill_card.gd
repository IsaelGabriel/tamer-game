extends Control

class_name SkillCard

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var index_label: Label = $VBoxContainer/IndexLabel

var skill_name: String = "Skill" :
	set(value):
		name_label.text = value
		skill_name = value

var selected = true : 
	set(value):
		if value:
			position.y = -20
		else:
			position.y = 0
		selected = value

var index = -1:
	set(value):
		index_label.text = str(value + 1) if (value >= 0) else ""
		index = value
