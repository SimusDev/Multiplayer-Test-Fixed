extends Control

signal favorite_changed

@export var resource: R_GameMap

@onready var icon: TextureRect = $Popup/content/icon
@onready var map_name: Label = $Popup/head/title
@onready var desc: Label = $Popup/content/desc

var lobby:SourceLobby = null

func _ready() -> void:
	if !resource:
		return
	favorite_changed.connect(update)
	favorite_changed.emit()
	icon.texture = resource.icon
	map_name.text = resource.name
	desc.text = resource.description
	
	#$play.visible = SimusDev.multiplayerAPI.is_server()

func _on_play_pressed() -> void:
	Maps.server_change_map_to(resource)
func _on_favorite_pressed() -> void:
	set_favorite(!resource.is_favorite)

func set_favorite(value:bool):
	resource.is_favorite = value
	favorite_changed.emit()
	if is_instance_valid(lobby):
		lobby._update_map_list()

func update():
	$Popup/head/favorite.visible = resource.is_favorite
