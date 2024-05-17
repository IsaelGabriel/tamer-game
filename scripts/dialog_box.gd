extends CanvasLayer

class_name DialogBox

const CHAR_TIME = 0.025

@onready var dialog_text = $MarginContainer/MarginContainer/HBoxContainer/DialogText
@onready var next_icon = $MarginContainer/MarginContainer/HBoxContainer/NextIcon

var current_text: String
var current_time: float

func _ready():
	dialog_text.text = ""
	next_icon.modulate.a = 0x0
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	if current_time > 0:
		current_time -= delta
	else:
		handle_dialog(delta)

func show_dialog(text: String):
	dialog_text.text = ""
	next_icon.modulate.a = 0x0
	current_text = text

func handle_dialog(delta):
	if len(dialog_text.text) < len(current_text):
		var time_multiplier = 0.5 if Input.is_action_pressed("ui_accept") else 1.0
		dialog_text.text += current_text[len(dialog_text.text)]
		current_time = CHAR_TIME * time_multiplier
	else:
		next_icon.modulate.a = 0xFF
		if Input.is_action_just_pressed("ui_accept"):
			DialogHandler.end_dialog()
