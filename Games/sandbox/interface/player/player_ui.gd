extends CanvasLayer

func _ready() -> void:
	$client_or_server.text = "SERVER"
	if SD_Multiplayer.is_not_server():
		$client_or_server.text = "CLIENT"
	
	
