extends SD_NetTrunk
class_name SD_NetTrunkHandShake

func _initialized() -> void:
	singleton.on_handshake_success.connect(_on_success)
	singleton.on_handshake_error.connect(_on_error)

func _on_success(s: SD_NetSuccess) -> void:
	singleton.debug_print("handshake success! %s" % s.message, SD_ConsoleCategories.CATEGORY.SUCCESS)

func _on_error(e: SD_NetError) -> void:
	singleton.debug_print("handshake error! %s" % e.message, SD_ConsoleCategories.CATEGORY.ERROR)
