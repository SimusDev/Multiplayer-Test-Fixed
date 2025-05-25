extends SD_Config
class_name SD_ConfigEncrypted

func _init() -> void:
	super()
	
	if SD_Platforms.is_debug_build():
		return
	
	encryption = "61GV0F-sAt"
