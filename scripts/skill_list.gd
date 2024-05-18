class_name SkillList

#region ConstImports
const TargetType = Constants.TargetType
const SkillType = Constants.SkillType

#endregion

const SKILLS = {
	"Hit" : { # 0x00
		"type" : SkillType.PHYSICAL,
		"description" : "Hit once, causing physical damage.",
		"target" : TargetType.ENEMY,
		"effect" : {
			"active" : "skill_hit"
		},
		"data" : {
			"ammount" : 5
		}
	},
	"Heal" : { # 0x01
		"type" : SkillType.EFFECT,
		"description" : "Restores HP.",
		"target" : TargetType.SELF,
		"effect" : {
			"active" : "skill_heal"
		},
		"data" : {
			"ammount" : 5
		}
	}
}
