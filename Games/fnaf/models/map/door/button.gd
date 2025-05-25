extends Node3D

@export var energy_consumer: FW_EnergyConsumer
@export var light: OmniLight3D
@export var mesh: MeshInstance3D

@export var COLOR_PRESSED: Color = Color(1, 1, 1, 1)
@export var COLOR_NORMAL: Color = Color(1, 1, 1, 1)

func _ready() -> void:
	energy_consumer.updated.connect(update)
	mesh.set_surface_override_material(0, mesh.get_surface_override_material(0).duplicate())
	update()

func update() -> void:
	light.visible = energy_consumer.get_status()
	
	var material: StandardMaterial3D = mesh.get_surface_override_material(0)
	if energy_consumer.get_status():
		material.albedo_color = COLOR_PRESSED
	else:
		material.albedo_color = COLOR_NORMAL

func _on_w_interactable_area_3d_interacted(by: W_Interactor3D) -> void:
	if SD_Multiplayer.is_server():
		energy_consumer.set_status(not energy_consumer.get_status())
		$AudioStreamPlayer3D.play_synced()
