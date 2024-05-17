extends Control

class_name BattleMonsterCard

@onready var name_label: Label = $MarginContainer/VBoxContainer/NameLabel
@onready var hp_label: Label = $MarginContainer/VBoxContainer/HPLabel
@onready var status_label: Label = $MarginContainer/VBoxContainer/StatusLabel

var monster_name: String:
	set(value):
		name_label.text = value
		monster_name = value

var hp_text: String:
	set(value):
		hp_label.text = value
		hp_text = value

var status: Array:
	set(value):
		status_label.text = ", ".join(value)
		status = value

func _ready():
	monster_name = "[NO_NAME]"
	hp_text = "NULL"
	status = []
