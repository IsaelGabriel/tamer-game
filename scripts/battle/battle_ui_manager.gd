extends Control

class_name BattleUIManager

#region ConstImports
const StateCall = Constants.StateCall
#endregion

const TargetType = Constants.TargetType

#region Prefabs
const PREFABS = {
	"monster_card" = preload("res://nodes/battle_monster_card.tscn"),
	"skill_card" = preload("res://nodes/skill_card.tscn")
}
#endregion

#region State
enum BattleUIState {
	NONE,
	SKILL_CARD,
	MONSTER_CARD,
	TARGET_SELECTION,
	SKILL_ANIMATION
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
			skill_card_container.visible = true
		StateCall.PROCESS:
			var monster = battle.player_monsters[selected_monster_card_index]
			var hand = monster.skill_manager.hand
			var index_change = int(Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("left"))
			selected_skill_card_index += index_change
			if selected_skill_card_index < 0: selected_skill_card_index = len(hand) - 1
			elif selected_skill_card_index >= len(hand): selected_skill_card_index = 0
			if selected_skill_card_index == monster.next_skill:
				selected_skill_card_index += index_change
				if selected_skill_card_index < 0: selected_skill_card_index = len(hand) - 1
				elif selected_skill_card_index >= len(hand): selected_skill_card_index = 0
			
			for i in range(0, len(hand)):
				if i >= skill_card_container.get_child_count():
					skill_card_container.add_child(PREFABS.skill_card.instantiate())
				var card = skill_card_container.get_child(i)
				card.visible = true
				card.skill_name = hand[i]
				card.index = monster.skill_queue.find(i)
				card.locked = false
				if monster.next_skill != -1:
					if card.index != -1: card.index += 1
					if i == monster.next_skill:
						card.index = 0
						card.locked = true
				card.selected = i == selected_skill_card_index
			for i in range(len(hand), skill_card_container.get_child_count()):
				skill_card_container.get_child(i).visible = false
			
			if Input.is_action_just_pressed("confirm"):
				if monster.next_skill != selected_skill_card_index:
					if selected_skill_card_index in monster.skill_queue:
						monster.skill_queue.erase(selected_skill_card_index)
						monster.targets.erase(selected_skill_card_index)
					else:
						current_state = BattleUIState.TARGET_SELECTION
						return
			
			if Input.is_action_just_pressed("cancel"):
				current_state = BattleUIState.MONSTER_CARD
		StateCall.END:
			skill_card_container.visible = false

func state_monster_card(state_call: StateCall, _delta: float = 0.0):
	match state_call:
		StateCall.START:
			monster_card_container.visible = true
			target_texture.position = battle.player_monsters[0].sprite.get_global_transform_with_canvas().get_origin()
			target_texture.visible = true
		StateCall.PROCESS:
			selected_monster_card_index += int(Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("left"))
			target_texture.position = battle.player_monsters[selected_monster_card_index].sprite.get_global_transform_with_canvas().get_origin()
			for i in range(0, monster_card_container.get_child_count()):
				monster_card_container.get_child(i).skill_queue_ready = (not battle.player_monsters[i].skill_queue.is_empty())
			if Input.is_action_just_pressed("confirm"):
				current_state = BattleUIState.SKILL_CARD
		StateCall.END:
			monster_card_container.visible = false
			target_texture.visible = false

func state_target_selection(state_call: StateCall, _delta: float = 0.0):
	match state_call:
		StateCall.START:
			BattleMonster.MOVEMENT_PAUSED = true
			skill_card_container.visible = true
			target_type = SkillList.SKILLS[battle.player_monsters[selected_monster_card_index].skill_manager.hand[selected_skill_card_index]]["target"]
			target_index = 0
			target_texture.visible = target_type != TargetType.SELF
			target_texture.position = battle.player_monsters[0].sprite.get_global_transform_with_canvas().get_origin()
			
		StateCall.PROCESS:
			var target_found = false
			var target: BattleMonster
			target_index += int(Input.is_action_just_pressed("down") or Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("up") or Input.is_action_just_pressed("left"))
			match target_type:
				TargetType.SELF:
					target = battle.player_monsters[selected_monster_card_index]
					target_texture.visible = false
					target_found = true
				TargetType.ALLY:
					if target_index < 0: target_index = battle.total_player_monsters - 1
					if target_index >= battle.total_player_monsters: target_index = 0
					target = battle.player_monsters[target_index]
				TargetType.ENEMY:
					if target_index < 0: target_index = battle.total_enemy_monsters - 1
					if target_index >= battle.total_enemy_monsters: target_index = 0
					target = battle.enemy_monsters[target_index]
			
			target_texture.position = target.sprite.get_global_transform_with_canvas().get_origin()
			
			if target_found or Input.is_action_just_pressed("confirm"):
				battle.player_monsters[selected_monster_card_index].targets[selected_skill_card_index] = target
				battle.player_monsters[selected_monster_card_index].skill_queue.append(selected_skill_card_index)
				current_state = BattleUIState.SKILL_CARD
				return
			
			if Input.is_action_just_pressed("cancel"):
				current_state = BattleUIState.SKILL_CARD
				
		StateCall.END: 
			BattleMonster.MOVEMENT_PAUSED = false
			skill_card_container.visible = false
			target_texture.visible = false

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


#region Elements
@export var main_container: Container
@export var target_texture: TextureRect

var monster_card_container: HBoxContainer
var skill_card_container: HBoxContainer

var selected_monster_card_index: int = 0:
	set(value):
		monster_card_container.get_child(selected_monster_card_index).selected = false
		if value < 0: value = battle.total_player_monsters - 1
		if value >= battle.total_player_monsters: value = 0
		monster_card_container.get_child(value).selected = true
		selected_monster_card_index = value

var selected_skill_card_index: int

#endregion

#region TargetSelection
var target_type: TargetType
var target_index: int

#endregion

@onready var battle: BattleManager = get_parent()

func start():
	generate_monster_cards()
	skill_card_container = HBoxContainer.new()
	skill_card_container.alignment = BoxContainer.ALIGNMENT_CENTER
	skill_card_container.visible = false
	main_container.add_child(skill_card_container)
	
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
