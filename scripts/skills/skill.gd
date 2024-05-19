class_name Skill

const TargetType = Constants.TargetType
const SkillType = Constants.SkillType

var name: StringName
var description: String
var accuracy: float:
	set(value): accuracy = clamp(value, 0.0, 1.0)
var function: StringName # func(skill: Skill, caster: BattleMonster, target: BattleMonster)
var process: StringName # func(skill: Skill, delta: float)
var target_type: TargetType
var type: SkillType
var data: Dictionary
var to_be_removed: bool = false # When on a SkillManagerComponent list, is removed in next frame

func _init(name: StringName, description: String, accuracy: float, type: SkillType, target_type: TargetType, function: StringName, process: StringName = ""):
	self.name = name
	self.description = description
	self.accuracy = accuracy
	self.type = type
	self.target_type = target_type
	self.function = function
	self.process = process
	self.data = {}

func duplicate() -> Skill:
	return Skill.new(name, description, accuracy, type, target_type, function, process)
