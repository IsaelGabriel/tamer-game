extends Node

var _skill_names = ["Hit","Hit","Hit","Hit","Heal","Heal","Heal"]
var _skills = []

var skills_available = []
var hand = []

# Called when the node enters the scene tree for the first time.
func _ready():
	load_skills()

func load_skills():
	for skill_name in _skill_names:
		var skill_resource = CustomResourceLoader.information["skills"][skill_name].duplicate()
		var skill = {}
		skill["name"] = skill_name
		skill["description"] = skill_resource["description"]
		skill["target"] = skill_resource["target"]
		match skill_resource["type"]:
			"attack":
				skill["value"] = skill_resource["base_damage"]
				match skill_resource["formula"]:
					"basic":
						skill["method"] = "basic_attack"
						break
				break
			"healing":
				skill["value"] = skill_resource["base_healing"]
				match skill_resource["formula"]:
					"basic":
						skill["method"] = "basic_healing"
						break
				break
		_skills.append(skill)

func call_skill_from_hand(index: int):
	call(hand[index]["method"], hand[index])
	hand.remove_at(index)

func refresh_hand():
	hand = []
	for i in range(min(4, len(skills_available))):
		var rng = randi() % len(skills_available)
		hand.append(skills_available[rng])
		skills_available.remove_at(rng)
	
	for skill in hand:
		print(skill)
	print()
		
	if len(skills_available) == 0:
		skills_available = _skills.duplicate()
		print("REFRESHED SKILLS\n")
		

# Skill functions

func basic_attack(skill_info: Dictionary):
	# TODO: Ask for target
	print("ATTACK CALLED: %s" % skill_info["name"])
	
func basic_healing(skill_info: Dictionary):
	print("HEALING CAST: %s" % skill_info["name"])
