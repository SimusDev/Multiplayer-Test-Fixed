extends SD_ModLoader
class_name SD_TrunkModLoader

const MODS_PATH: String = "runtime://mods"

func _ready() -> void:
	initialize(MODS_PATH)
