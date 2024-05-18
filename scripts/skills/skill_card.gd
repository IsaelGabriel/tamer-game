extends Control

class_name SkillCard

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var index_label: Label = $VBoxContainer/IndexLabel

@export_color_no_alpha var color: Color
@export_color_no_alpha var locked_color: Color

var skill_name: String = "Skill" :
	set(value):
		name_label.text = value
		skill_name = value

var selected: bool = true : 
	set(value):
		if value:
			position.y = -20
		else:
			position.y = 0
		selected = value

var index: int = -1:
	set(value):
		index_label.text = str(value + 1) if (value >= 0) else ""
		index = value

var locked: bool = false:
	set(value):
		locked = value
		self_modulate = locked_color if locked else color
