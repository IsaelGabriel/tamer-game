extends Control

enum BattleUIState {
	SKILL_CARD,
	MONSTER_CARD,
	TARGET_SELECTION,
	SKILL_ANIMATION
}

enum StateCall {
	START,
	PROCESS,
	END
}

@export var main_container: Container
@export var target_texture: TextureRect

var state_func: Dictionary = {
	BattleUIState.SKILL_CARD:
		func(state_call: StateCall, _delta: float = 0.0): pass,
	BattleUIState.MONSTER_CARD:
		func(state_call: StateCall, _delta: float = 0.0): pass,
	BattleUIState.TARGET_SELECTION:
		func(state_call: StateCall, _delta: float = 0.0): pass,
	BattleUIState.SKILL_ANIMATION:
		func(state_call: StateCall, _delta: float = 0.0): pass
}

var current_state: BattleUIState:
	set(value):
		if current_state == value or not value: return
		if current_state:
			state_func[current_state].call(StateCall.END)
		current_state = value
		state_func[current_state].call(StateCall.START)

func _ready():
	current_state = BattleUIState.MONSTER_CARD
