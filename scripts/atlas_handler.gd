class_name AtlasHandler

#const ATLAS_PATH: StringName = "res://sprite_atlas.png"
const ATLAS_SIZE: Vector2i = Vector2i(256, 256)

#region ArmorConsts
const ARMOR_PART_SIZE: Vector2i = Vector2i(32, 32)

const ARMOR_CORE_START: Vector2i = Vector2i(0, 0)
const ARMOR_CORE_LENGTH: int = 2
const ARMOR_ARM_START: Vector2i = Vector2i(0, 32)
const ARMOR_ARM_LENGTH: int = 4
const ARMOR_BASE_START: Vector2i = Vector2i(0, 64)
const ARMOR_BASE_LENGTH: int = 4
#endregion

static func get_part_rect(index: int, start: Vector2i, length: int):
	var rect: Rect2i = Rect2i()
	rect.position = start
	rect.size = ARMOR_PART_SIZE
	rect.position.x += ARMOR_PART_SIZE.x * index * length
	rect.position.y += int(rect.position.x / ATLAS_SIZE.x)
	rect.position.x = rect.position.x % ATLAS_SIZE.x
	return rect

static func get_core_rect(index: int) -> Rect2i:
	return get_part_rect(index, ARMOR_CORE_START, ARMOR_CORE_LENGTH)

static func get_arm_rect(index: int) -> Rect2i:
	return get_part_rect(index, ARMOR_ARM_START, ARMOR_ARM_LENGTH)
	
static func get_base_rect(index: int) -> Rect2i:
	return get_part_rect(index, ARMOR_BASE_START, ARMOR_BASE_LENGTH)
