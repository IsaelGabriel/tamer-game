extends Control

class_name BattleMonsterCard

@onready var name_label: Label = $MarginContainer/VBoxContainer/NameLabel
@onready var hp_label: Label = $MarginContainer/VBoxContainer/HPLabel
@onready var status_label: Label = $MarginContainer/VBoxContainer/StatusLabel
@onready var queue_label: Label = $MarginContainer/VBoxContainer/QueueLabel

var monster: Monster

var selected: bool = false : 
	set(value):
		position.y = -20 if value else 0
		selected = value

var skill_queue_ready: bool = false

func _process(_delta):
	if monster == null: return
	name_label.text = monster.name
	hp_label.text = "%d / %d" % [monster.hp, monster.max_hp]
	status_label.text = ""
	queue_label.text = "" if skill_queue_ready else "[ADD SKILLS]"
