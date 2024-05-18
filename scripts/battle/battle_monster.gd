extends Node2D

class_name BattleMonster

const LANE_WIDTH: float = 600
const MOVEMENT_INTERPOLATION_MULTIPLIER: float = 0.01
static var MOVEMENT_PAUSED: bool = false

#region Monster
var monster: Monster = Monster.new("Test Monster")
var is_player: bool = false: 
	set(value):
		is_player = value
		if is_player:
			base.position.x = -(LANE_WIDTH / 2)
			goal.position.x = LANE_WIDTH / 2
		else:
			base.position.x = LANE_WIDTH / 2
			goal.position.x = -(LANE_WIDTH / 2)
#endregion

#region Elements
@onready var skill_manager: SkillManagerComponent = $SkillManagerComponent
@onready var sprite: Sprite2D = $Sprite2D
@onready var base: Sprite2D = $Base
@onready var goal: Sprite2D = $Goal
#endregion

#region State
enum BattleMonsterState {
	AWAIT_COMMAND,
	FORWARD,
	USE_SKILL,
	BACK,
}

enum StateCall {
	START,
	PROCESS,
	END
}

var state_func: Dictionary = {
	BattleMonsterState.AWAIT_COMMAND: state_await_command,
	BattleMonsterState.FORWARD: state_forward,
	BattleMonsterState.USE_SKILL: state_use_skill,
	BattleMonsterState.BACK: state_back
}

func state_await_command(state_call: StateCall, delta: float = 0.0):
	match state_call:
		StateCall.START: pass
		StateCall.PROCESS: pass
		StateCall.END: pass

func state_forward(state_call: StateCall, delta: float = 0.0):
	match state_call:
		StateCall.START: pass
		StateCall.PROCESS: pass
		StateCall.END: pass

func state_use_skill(state_call: StateCall, delta: float = 0.0):
	match state_call:
		StateCall.START: pass
		StateCall.PROCESS: pass
		StateCall.END: pass

func state_back(state_call: StateCall, delta: float = 0.0):
	match state_call:
		StateCall.START: pass
		StateCall.PROCESS: pass
		StateCall.END: pass


var current_state: BattleMonsterState:
	set(value):
		if current_state:
			state_func[current_state].call(StateCall.END)
		current_state = value
		if value:
			state_func[current_state].call(StateCall.START)

#endregion
signal called_skill(battle_monster: BattleMonster, skill: String)

func _ready():
	skill_manager.load_skills(monster.skills)
	sprite.position = base.position
	is_player = false

func _process(delta):
	if current_state:
		state_func[current_state].call(StateCall.PROCESS, delta)
