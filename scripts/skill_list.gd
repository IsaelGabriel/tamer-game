class_name SkillList

enum SkillType {
	PHYSICAL,
	EFFECT
}

enum TargetType {
	SELF,
	ALLY,
	ENEMY
}

const SKILLS = {
	"Hit" : { # 0x00
		"type" : SkillType.PHYSICAL,
		"description" : "Hit once, causing physical damage.",
		"target" : TargetType.ENEMY,
		"effect" : {
			"active" : "skill_hit"
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
