extends Button

@export var map:Node
@export var data: FW_CameraData

@onready var panel: Panel = $Panel

@onready var camera_container: FW_CameraContainer = FW_CameraContainer.instance

func _ready() -> void:
	camera_container.switched.connect(_on_camera_switched)
	text = "CAM %s" % data.code
	
	update_interface()

func update_interface() -> void:
	panel.visible = data == camera_container.get_current_data()

func _on_camera_switched(to: FW_CameraData) -> void:
	update_interface()
	$AudioStreamPlayer.play()
	

func _on_pressed() -> void:
	camera_container.switch(data)
	map.noise_animation_player.stop()
	map.noise_animation_player.play("shader_noise")
