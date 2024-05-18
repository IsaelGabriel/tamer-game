class_name Monster

var name = "Monster"
var max_hp = 10
var hp = 10 :
	set(value):
		if value < 0: hp = 0
		elif value > max_hp: hp = max_hp
		else: hp = value
 
var speed = 20

var skills = ["Hit", "Hit", "Hit", "Hit", "Heal", "Heal", "Heal"]

signal taken_damage(monster: Monster, ammount: int)
signal got_healed(monster: Monster, ammount: int)

func _init(name:String):
	self.name = name

func take_damage(dealer: Monster, ammount: int):
	hp -= ammount
	taken_damage.emit(self, ammount)

func get_healing(healer: Monster, ammount: int):
	hp += ammount
	got_healed.emit(self, ammount)
