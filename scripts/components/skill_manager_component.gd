extends Node

class_name SkillManagerComponent

const MAX_HAND_SIZE = 4

@onready var caster: BattleMonster = get_parent()
@onready var monster: Monster

var skills_available: Array[Skill] = []
var hand: Array[Skill] = []

func load_skills():
	refresh_skills()
	refresh_hand()

func call_skill_from_hand(index: int, target: BattleMonster):
	var skill = hand[index]
	DialogHandler.display_dialog("%s %s used %s." % ["Ally" if caster.is_player else "Foe", monster.name, skill.name])
	call(skill.function, skill, target)
	caster.called_skill.emit(caster, skill)
	hand.remove_at(index)
	if len(hand) == 0: refresh_hand()

func refresh_hand():
	if len(hand) >= MAX_HAND_SIZE: return
	for i in range(min(MAX_HAND_SIZE, len(skills_available))):
		var rng = randi() % len(skills_available)
		hand.append(skills_available[rng].duplicate())
		skills_available.remove_at(rng)
	
	if len(skills_available) == 0 and len(hand) == 0: refresh_skills()

func refresh_skills():
	skills_available = []
	for skill_key in monster.skills:
		skills_available.append(SkillList.SKILLS[skill_key].duplicate())

#region SkillFuncs
func skill_hit(skill: Skill, target: BattleMonster):
	target.monster.take_damage(caster.monster, 5)

func skill_heal(skill: Skill, target: BattleMonster):
	if(monster.hp.current < monster.hp.max):
		var old_hp = monster.hp.current
		monster.get_healing(monster, 5)
	else:
		DialogHandler.display_dialog("%s was too healthy to heal itself." % monster.name)
#endregion
