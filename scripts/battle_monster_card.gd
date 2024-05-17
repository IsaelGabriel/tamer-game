extends Control

class_name BattleMonsterCard

@onready var name_label: Label = $MarginContainer/VBoxContainer/NameLabel
@onready var hp_label: Label = $MarginContainer/VBoxContainer/HPLabel
@onready var status_label: Label = $MarginContainer/VBoxContainer/StatusLabel

var monster: Monster

var selected = false : 
	set(value):
		position.y = -20 if value else 0
		selected = value

func _process(_delta):
	if monster == null: return
	name_label.text = monster.name
	hp_label.text = "%d / %d" % [monster.hp, monster.max_hp]
	status_label.text = ""
