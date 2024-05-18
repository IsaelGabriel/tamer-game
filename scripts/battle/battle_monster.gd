extends Node2D

class_name BattleMonster

const LANE_WIDTH: float = 600
const MOVEMENT_INTERPOLATION_MULTIPLIER: float = 0.01
static var MOVEMENT_PAUSED: bool = false

var interpolation_timer: float = 0.0

#region Monster
var monster: Monster = Monster.new("Test Monster") :
	set(value):
		if not value: return
		monster = value
		skill_manager.monster = monster
		skill_manager.load_skills()

var is_player: bool
#endregion

#region Elements
@onready var skill_manager: SkillManagerComponent = $SkillManagerComponent
@onready var sprite: Sprite2D = $Sprite2D
@onready var base: Sprite2D = $Base
@onready var goal: Sprite2D = $Goal
#endregion

#region State
enum BattleMonsterState {
	NONE,
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
	BattleMonsterState.NONE: func(state_call: StateCall, delta: float = 0.0): return,
	BattleMonsterState.AWAIT_COMMAND: state_await_command,
	BattleMonsterState.FORWARD: state_forward,
	BattleMonsterState.USE_SKILL: state_use_skill,
	BattleMonsterState.BACK: state_back
}

func state_await_command(state_call: StateCall, delta: float = 0.0):
	match state_call:
		StateCall.START: pass
		StateCall.PROCESS:
			if skill_queue.is_empty(): return
			next_skill = skill_queue.pop_front()
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
			skill_manager.call_skill_from_hand(next_skill, targets[next_skill])
			targets.erase(next_skill)
			skill_queue.erase(next_skill)
			for i in range(0, len(skill_queue)):
				if skill_queue[i] > next_skill: skill_queue[i] -= 1
			next_skill = -1
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
		if current_state != null:
			state_func[current_state].call(StateCall.END)
		current_state = value
		if value != null:
			state_func[current_state].call(StateCall.START)

#endregion

#region Skills
var next_skill: int = -1 # Skill index from hand to be called next
var skill_queue: Array[int] = [] # Index of the to-be-called skills from hand # [index, target] pairs
var targets: Dictionary

signal called_skill(battle_monster: BattleMonster, skill: StringName)
#endregion

func _ready():
	skill_manager.load_skills()
	
	if is_player:
		base.position.x = -(LANE_WIDTH / 2)
		goal.position.x = LANE_WIDTH / 2
	else:
		base.position.x = LANE_WIDTH / 2
		goal.position.x = -(LANE_WIDTH / 2)
	
	current_state = BattleMonsterState.AWAIT_COMMAND

func _process(delta):
	if current_state:
		state_func[current_state].call(StateCall.PROCESS, delta)
