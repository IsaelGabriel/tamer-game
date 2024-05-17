extends Node

class_name SkillManagerComponent

@onready var caster = get_parent()
@onready var monster: Monster = caster.monster

var _skills = []

var skills_available = []
var hand = []

func load_skills(skill_names: Array):
	_skills = skill_names
	refresh_skills()
	refresh_hand()

func call_skill_from_hand(index: int, target: BattleMonster):
	DialogHandler.display_dialog("%s %s used %s." % ["Foe" if caster is EnemyBattleMonster else "Ally", monster.name, hand[index]])
	call(SkillList.SKILLS[hand[index]]["effect"]["active"], target)
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


# Skill functions

func skill_hit(target: BattleMonster):
	var data = SkillList.SKILLS["Hit"]["data"]
	target.monster.take_damage(monster, data["ammount"])
	DialogHandler.display_dialog("%s %s took %d damage." % ["Foe" if target is EnemyBattleMonster else "Ally", target.monster.name, data["ammount"]])
	
func skill_heal(target: BattleMonster):
	var data = SkillList.SKILLS["Heal"]["data"]
	if(monster.hp < monster.max_hp):
		var old_hp = monster.hp
		monster.get_healing(monster, data["ammount"])
		DialogHandler.display_dialog("%s healed itself by %d." % [monster.name, monster.hp - old_hp])
	else:
		DialogHandler.display_dialog("%s was too healthy to heal itself." % monster.name)
