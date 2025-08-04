extends Button

var resource: SourceSpawnPointResource

var ui: CanvasLayer

func _ready() -> void:
	text = "%s, %s" % [str(resource.name), str(resource.global_position)]

func _on_pressed() -> void:
	ui._selected_spawn(resource)
