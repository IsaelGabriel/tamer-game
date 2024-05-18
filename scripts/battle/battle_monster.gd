extends Node2D

class_name BattleMonster

const LANE_WIDTH: float = 600
const MOVEMENT_INTERPOLATION_MULTIPLIER: float = 0.01
static var MOVEMENT_PAUSED: bool = false

var interpolation_timer: float = 0.0

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
		StateCall.PROCESS:
			if next_skill == -1 or not target: return
			current_state = BattleMonsterState.FORWARD
		StateCall.END: pass

func state_forward(state_call: StateCall, delta: float = 0.0):
	match state_call:
		StateCall.START:
			interpolation_timer = 0.0
			sprite.flip_h = not is_player
		StateCall.PROCESS:
			if BattleMonster.MOVEMENT_PAUSED: return
			interpolation_timer += delta * monster.speed * MOVEMENT_INTERPOLATION_MULTIPLIER
			interpolation_timer = min(interpolation_timer, 1.0)
			sprite.position = base.position.lerp(goal.position, interpolation_timer)
			if interpolation_timer >= 1.0:
				current_state = BattleMonsterState.USE_SKILL
		StateCall.END: pass

func state_use_skill(state_call: StateCall, delta: float = 0.0):
	match state_call:
		StateCall.START: pass
		StateCall.PROCESS:
			if MOVEMENT_PAUSED: return
			skill_manager.call_skill_from_hand(next_skill, target)
			next_skill = -1
			target = null
			current_state = BattleMonsterState.BACK
		StateCall.END: pass

func state_back(state_call: StateCall, delta: float = 0.0):
	match state_call:
		StateCall.START:
			interpolation_timer = 0.0
			sprite.flip_h = is_player
		StateCall.PROCESS:
			if BattleMonster.MOVEMENT_PAUSED: return
			interpolation_timer += delta * monster.speed * MOVEMENT_INTERPOLATION_MULTIPLIER
			interpolation_timer = min(interpolation_timer, 1.0)
			sprite.position = goal.position.lerp(base.position, interpolation_timer)
			if interpolation_timer >= 1.0:
				current_state = BattleMonsterState.AWAIT_COMMAND
		StateCall.END: pass


var current_state: BattleMonsterState:
	set(value):
		if current_state:
			state_func[current_state].call(StateCall.END)
		current_state = value
		if value:
			state_func[current_state].call(StateCall.START)

#endregion

#region Skills
var next_skill: int = -1: # Skill index from hand to be called next
	set(value):
		next_skill = value
		if value == -1: return
		skill_queue.erase(value)
		for i in range(0, len(skill_queue)):
			if skill_queue[i] > value: skill_queue[i] -= 1
		
var skill_queue: Array[int] = [] # Index of the to-be-called skills from hand
var target: BattleMonster

signal called_skill(battle_monster: BattleMonster, skill: StringName)
#endregion

func _ready():
	skill_manager.load_skills(monster.skills)
	sprite.position = base.position
	is_player = false

func _process(delta):
	if current_state:
		state_func[current_state].call(StateCall.PROCESS, delta)
