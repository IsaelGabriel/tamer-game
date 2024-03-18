extends Node

var _skills = []

var skills_available = []
var hand = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(12):
		_skills.append("Skill %d" % i)

	skills_available = _skills.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		refresh_hand()

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
		
