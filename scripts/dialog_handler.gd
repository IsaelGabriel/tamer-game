extends Node

@onready var dialog_box = load("res://nodes/dialog_box.tscn")

var current_box: DialogBox = null
var text_queue: Array = []

func display_dialog(text: String):
	get_tree().paused = true
	if current_box == null:
		current_box = dialog_box.instantiate()
		add_child(current_box)
		current_box.show_dialog(text)
	else:
		text_queue.append(text)

func end_dialog():
	if len(text_queue) > 0:
		current_box.show_dialog(text_queue[0])
		text_queue.remove_at(0)
	else:
		current_box.queue_free()
		await get_tree().create_timer(0.01).timeout
		get_tree().paused = false
