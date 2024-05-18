class_name Monster

var name = "Monster"
var hp: MonsterAttribute
var speed: MonsterAttribute 
var accuracy: MonsterAttribute
var atk: MonsterAttribute
var def: MonsterAttribute

var skills = ["Hit", "Hit", "Hit", "Hit", "Heal", "Heal", "Heal"]

signal taken_damage(monster: Monster, ammount: int)
signal got_healed(monster: Monster, ammount: int)

func _init(name:String, hp: int = 10, speed: int = 20, accuracy: float = 0.7, atk: int = 2, def: int = 2):
	self.name = name
	self.hp = MonsterAttribute.new(hp, true)
	self.speed = MonsterAttribute.new(speed, false)
	self.accuracy = MonsterAttribute.new(accuracy, false)
	self.atk = MonsterAttribute.new(atk, false)
	self.def = MonsterAttribute.new(def, false)

func take_damage(dealer: Monster, ammount: int):
	hp.current -= ammount
	taken_damage.emit(self, ammount)

func get_healing(healer: Monster, ammount: int):
	hp.current += ammount
	got_healed.emit(self, ammount)

static func new_random(hp: Array, speed: Array, accuracy: Array, atk: Array, def: Array) -> Monster:
	var rng = func(r: Array): return randf_range(r[0], r[-1])
	return Monster.new("Random Monster", int(rng.call(hp)), rng.call(speed), rng.call(accuracy), rng.call(atk), rng.call(def))
