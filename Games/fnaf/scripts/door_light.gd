extends SpotLight3D

@export var light_component:FW_LightComponent

func _ready() -> void:
	light_component.status_changed.connect(_on_status_changed)

func _on_status_changed():
	visible = light_component.get_status()
