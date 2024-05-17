extends "res://scripts/battle_monster.gd"

class_name EnemyBattleMonster

class BMSEnemyForward:
	extends BattleMonsterState
	
	var speed: float
	var base: Sprite2D
	var goal: Sprite2D
	var sprite: Sprite2D
	var interpolation_timer: float = 0.0
	var skill_manager: SkillManagerComponent
	
	func start():
		speed = _battle_monster.monster.speed
		base = _battle_monster.base
		goal = _battle_monster.goal
		sprite = _battle_monster.sprite
		skill_manager = _battle_monster.skill_manager
		
		sprite.flip_h = true
	
	func process(delta):
		if BattleMonster.MOVEMENT_PAUSED: return
		interpolation_timer += delta * speed * MOVEMENT_INTERPOLATION_MULTIPLIER
		interpolation_timer = min(interpolation_timer, 1.0)
		sprite.position = base.position.lerp(goal.position, interpolation_timer)
		if interpolation_timer >= 1.0:
			var skill = skill_manager.hand[0]
			skill_manager.call_skill_from_hand(0)
			_battle_monster.called_skill.emit(_battle_monster, skill)
			_battle_monster.state = BMSEnemyReturn.new(_battle_monster)

class BMSEnemyReturn:
	extends BattleMonsterState
	
	var speed: float
	var base: Sprite2D
	var goal: Sprite2D
	var sprite: Sprite2D
	var interpolation_timer: float = 0.0
	
	func start():
		speed = _battle_monster.monster.speed
		base = _battle_monster.base
		goal = _battle_monster.goal
		sprite = _battle_monster.sprite
		
		sprite.flip_h = false
	
	func process(delta):
		if BattleMonster.MOVEMENT_PAUSED: return
		interpolation_timer += delta * speed * MOVEMENT_INTERPOLATION_MULTIPLIER
		interpolation_timer = min(interpolation_timer, 1.0)
		sprite.position = goal.position.lerp(base.position, interpolation_timer)
		if interpolation_timer >= 1.0:
			_battle_monster.state = BMSEnemyForward.new(_battle_monster)

func _ready():
	super()
	state = BMSEnemyForward.new(self)
