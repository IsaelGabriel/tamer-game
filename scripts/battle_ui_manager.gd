extends Control

class_name BattleUIManager

#region State
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

var state_information: Dictionary = {}

var state_func: Dictionary = {
	BattleUIState.SKILL_CARD: state_skill_card,
	BattleUIState.MONSTER_CARD: state_monster_card,
	BattleUIState.TARGET_SELECTION: state_target_selection,
	BattleUIState.SKILL_ANIMATION: state_skill_animation
}

func state_skill_card(state_call: StateCall, _delta: float = 0.0):
	match state_call:
		StateCall.START:
			battle.player_monsters[selected_monster_card_index].skill_cards_active = true
		StateCall.PROCESS:
			if Input.is_action_just_pressed("ui_down"):
				current_state = BattleUIState.MONSTER_CARD
		StateCall.END:
			battle.player_monsters[selected_monster_card_index].skill_cards_active = false

func state_monster_card(state_call: StateCall, _delta: float = 0.0):
	match state_call:
		StateCall.START:
			monster_card_container.visible = true
		StateCall.PROCESS:
			selected_monster_card_index += int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
			if Input.is_action_just_pressed("ui_up"):
				current_state = BattleUIState.SKILL_CARD
		StateCall.END:
			monster_card_container.visible = false

func state_target_selection(state_call: StateCall, _delta: float = 0.0):
	match state_call:
		StateCall.START: pass
		StateCall.PROCESS: pass
		StateCall.END: pass

func state_skill_animation(state_call: StateCall, _delta: float = 0.0):
	match state_call:
		StateCall.START: pass
		StateCall.PROCESS: pass
		StateCall.END: pass

var current_state: BattleUIState:
	set(value):
		# if not value: return
		if current_state:
			state_func[current_state].call(StateCall.END)
		state_information.clear()
		current_state = value
		if value: state_func[current_state].call(StateCall.START)

#endregion

#region Prefabs
const PREFABS = {
	"monster_card" = preload("res://nodes/battle_monster_card.tscn"),
	"skill_card" = preload("res://nodes/skill_card.tscn")
}
#endregion

#region Elements
@export var main_container: Container
@export var target_texture: TextureRect

var monster_card_container: HBoxContainer
var skill_card_containers: Array[HBoxContainer]

var selected_monster_card_index: int = 0:
	set(value):
		monster_card_container.get_child(selected_monster_card_index).selected = false
		if value < 0: value = battle.total_player_monsters - 1
		if value >= battle.total_player_monsters: value = 0
		monster_card_container.get_child(value).selected = true
		selected_monster_card_index = value
#endregion

@onready var battle: BattleManager = get_parent()

func start():
	generate_monster_cards()
	current_state = BattleUIState.MONSTER_CARD

func _process(delta):
	if not current_state: return
	state_func[current_state].call(StateCall.PROCESS, delta)

func generate_monster_cards():
	monster_card_container = HBoxContainer.new()
	monster_card_container.alignment = BoxContainer.ALIGNMENT_CENTER
	main_container.add_child(monster_card_container)
	
	for battle_monster in battle.player_monsters:
		var card = PREFABS.monster_card.instantiate()
		card.monster = battle_monster.monster
		monster_card_container.add_child(card)
	monster_card_container.visible = false
	await get_tree().create_timer(0.001).timeout
	monster_card_container.get_child(0).selected = true
