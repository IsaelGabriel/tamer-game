extends Node

class_name SkillManagerComponent

@onready var caster: BattleMonster = get_parent()
@onready var monster: Monster

var _skills = []

var skills_available = []
var hand = []

func load_skills():
	_skills = monster.skills.duplicate()
	refresh_skills()
	refresh_hand()

func call_skill_from_hand(index: int, target: BattleMonster):
	var skill = hand[index]
	DialogHandler.display_dialog("%s %s used %s." % ["Ally" if caster.is_player else "Foe", monster.name, hand[index]])
	call(SkillList.SKILLS[skill]["effect"]["active"], target)
	caster.called_skill.emit(caster, skill)
	hand.remove_at(index)
	if len(hand) == 0: refresh_hand()

func refresh_hand():
	if len(hand) >= 4: return
	for i in range(min(4, len(skills_available))):
		var rng = randi() % len(skills_available)
		hand.append(skills_available[rng])
		skills_available.remove_at(rng)
	
	if len(skills_available) == 0 and len(hand) == 0: refresh_skills()

func refresh_skills():
	skills_available = _skills.duplicate()

# Skill functions

func skill_hit(target: BattleMonster):
	var data = SkillList.SKILLS["Hit"]["data"]
	target.monster.take_damage(monster, data["ammount"])
	
func skill_heal(target: BattleMonster):
	var data = SkillList.SKILLS["Heal"]["data"]
	if(monster.hp.current < monster.hp.max):
		var old_hp = monster.hp.current
		monster.get_healing(monster, data["ammount"])
	else:
		DialogHandler.display_dialog("%s was too healthy to heal itself." % monster.name)
