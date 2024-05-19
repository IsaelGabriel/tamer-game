class_name SkillList

#region ConstImports
const TargetType = Constants.TargetType
const SkillType = Constants.SkillType

#endregion

static var SKILLS = {
	"hit" : Skill.new("Hit", # Name
						"Hit once, causing physical damage.", # Description
						0.75, # Accuracy
						SkillType.PHYSICAL, # Skill Type
						TargetType.ENEMY, # Target Type
						"skill_hit"),
	"heal" : Skill.new("Self Heal", # Name
						"Restores HP.", # Description
						1.0, # Accuracy
						SkillType.EFFECT, # Skill Type
						TargetType.SELF, # Target Type
						"skill_heal"),
}
