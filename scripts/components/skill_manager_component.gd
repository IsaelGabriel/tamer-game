extends Node

class_name SkillManagerComponent

@onready var caster = get_parent()
@onready var monster: Monster = caster.get_monster()

var _skills = []

var skills_available = []
var hand = []

func load_skills(skill_names: Array):
	_skills = skill_names
	refresh_skills()
	refresh_hand()

func call_skill_from_hand(index: int):
	# TODO: Method that handles targets (called before skill)
	display_message("%s used %s." % [monster.name, hand[index]])
	call(SkillList.SKILLS[hand[index]]["effect"]["active"])
	hand.remove_at(index)
	if len(hand) == 0: refresh_hand()

func refresh_hand():
	if len(hand) >= 4: return
	for i in range(min(4-len(hand), len(skills_available))):
		var rng = randi() % len(skills_available)
		hand.append(skills_available[rng])
		skills_available.remove_at(rng)
	
	if len(skills_available) == 0 and len(hand) == 0: refresh_skills()

func refresh_skills():
	skills_available = _skills.duplicate()

# Basic functions

func display_message(str: String):
	print(str)

# Skill functions

func skill_hit():
	display_message("Success!")
	
func skill_heal():
	var data = SkillList.SKILLS["Heal"]["data"]
	if(monster.hp < monster.max_hp):
		var old_hp = monster.hp
		monster.get_healing(monster, data["ammount"])
		display_message("%s healed itself by %d." % [monster.name, monster.hp - old_hp])
	else:
		display_message("%s was too healthy to heal itself." % monster.name)
