enum SkillType {
	PHYSICAL,
	EFFECT
}

enum TargetType {
	SELF,
	ALLY,
	ENEMY
}

const SKILLS = [
	{ # 0x00
		"name" : "Hit",
		"type" : SkillType.PHYSICAL,
		"description" : "Hit once, causing physical damage.",
		"target" : TargetType.ENEMY,
		"effect" : [
			["register", [0x0, "Monster"]], # Load "Monster" into 0x0
			["register", [0x1, "%s hits."]], # Load "%s hits." into 0x1
			["format", [0x1, 0x1, [0x0]]], # Formats 0x1 and saves into 0x1
			["show", [0x1]], # Shows 0x1
			["register", [0x1, 5]], # Load 5 into 0x1
			["deal_dmg", [0x1]], # Deal damage to target
			["register", [0x0, "Success!"]], # Load "Success!"
			["show", [0x0]] # Shows 0x0
			]
	}
]
