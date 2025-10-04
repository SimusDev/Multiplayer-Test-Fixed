extends R_SourceGameScript


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SD_Console.i().write_info("hello from test gamescript!!!")
