class_name MonsterAttribute

var min : float = 0
var max : float
var current: float :
	set(value):
		current = clamp(value, min, max)
	get:
		var n = current
		for m in modifiers:
			n += m
		if cap_value: n = clamp(n, min, max)
		return n

var cap_value: bool

var modifiers: Array[float] = []

func _init(max: float, cap_value: bool):
	self.max = max
	self.current = max
	self.cap_value = cap_value
	
func add_modifier(modifier: float):
	modifiers.append(modifier)

func remove_modifier(modifier: float):
	modifiers.erase(modifier)
