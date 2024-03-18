extends Node

const BASE_PATH = "res://custom_resources/"

const JSON_NAMES = [
	"skills"
]

var information = {}

func _ready():
	for key in JSON_NAMES:
		var json_text = FileAccess.get_file_as_string(BASE_PATH + key + ".json")
		information[key] = JSON.parse_string(json_text)
