class_name Monster

var name = "Monster"
var hp: MonsterAttribute = MonsterAttribute.new(10, true)
var speed: MonsterAttribute = MonsterAttribute.new(20, false)

var skills = ["Hit", "Hit", "Hit", "Hit", "Heal", "Heal", "Heal"]

signal taken_damage(monster: Monster, ammount: int)
signal got_healed(monster: Monster, ammount: int)

func _init(name:String):
	self.name = name

func take_damage(dealer: Monster, ammount: int):
	hp.current -= ammount
	taken_damage.emit(self, ammount)

func get_healing(healer: Monster, ammount: int):
	hp.current += ammount
	got_healed.emit(self, ammount)
