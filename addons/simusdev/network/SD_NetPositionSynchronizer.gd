@tool
extends SD_NetVariableSynchronizer
class_name SD_NetPositionSynchronizer

func _ready() -> void:
	super()


func _on_editor_initialize() -> void:
	if synchronize.is_empty():
		synchronize = {
			"position": true,
			"rotation": true,
			"scale": true,
		}
	allow_serialize = false
	transfer_mode = MultiplayerPeer.TransferMode.TRANSFER_MODE_UNRELIABLE
	tickrate = get_default_tickrate()
	interpolation = true
	channel = "position"

func get_default_tickrate() -> float:
	return 32
