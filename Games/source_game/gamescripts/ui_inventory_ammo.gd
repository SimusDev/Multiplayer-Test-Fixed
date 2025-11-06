extends R_SourceGameScript

var path: String = "res://Games/source_game/ui/inventory/ammo_count.tscn"

var scene: PackedScene

var instance: Control

func _ready() -> void:
	if SD_Network.is_dedicated_server():
		return
	
	scene = load(path)
	
	S_EventPlayerUICreated.as_event().published.connect(_on_ui_create.bind(S_EventPlayerUICreated.as_event()))

func _on_ui_create(event: S_EventPlayerUICreated) -> void:
	instance = scene.instantiate()
	instance.hide()
	instance.inventory = event.playable.inventory
	event.ui.add_child(instance)
	SourceViewModelRoot3D.local.on_update.connect(_on_view_update)

func _on_view_update() -> void:
	instance.visible = SourceViewModelRoot3D.local.view_node is SourceFireWeapon
	
