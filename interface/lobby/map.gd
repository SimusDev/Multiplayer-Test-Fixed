extends Control

@export var resource: R_GameMap

@onready var icon: TextureRect = $TextureRect
@onready var map_and_desc: Label = $map_and_desc

func _ready() -> void:
	if !resource:
		return
	
	icon.texture = resource.icon
	map_and_desc.text = "%s\n%s" % [resource.name, resource.description]
	
	$play.visible = SimusDev.multiplayerAPI.is_server()

func _on_play_pressed() -> void:
	Maps.server_change_map_to(resource)
