@tool
@static_unload
extends SD_Object
class_name SD_Random

static var rng := RandomNumberGenerator.new()

static func get_rng() -> RandomNumberGenerator:
	rng.randomize()
	return rng

static func get_rfloat() -> float:
	return get_rng().randf()
static func get_rfloat_range(from: float, to: float) -> float:
	return get_rng().randf_range(from, to)

static func get_rint() -> int:
	return get_rng().randi()
static func get_rint_range(from: int, to: int) -> int:
	return get_rng().randi_range(from, to)
