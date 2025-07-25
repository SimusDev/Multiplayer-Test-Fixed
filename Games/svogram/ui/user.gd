extends Control

@onready var icon: TextureRect = $icon
@onready var label: Label = $Label
 
func init(player: SD_NetworkPlayer) -> void:
	label.text = player.get_username()
