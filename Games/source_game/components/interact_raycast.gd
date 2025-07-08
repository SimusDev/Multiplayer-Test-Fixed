class_name SourceInteractRaycast extends RayCast3D

signal collider_changed
signal object_detected(obj)

@export var player:SourcePlayer
var collider:Node3D = null : set = set_collider

var current_object = null

func set_collider(_collider:Variant):
	collider = _collider
	collider_changed.emit(collider)
	
	
	if SourcePlayerUI.instance:
		if !_collider or _collider is SourcePlayer:
			SourcePlayerUI.get_instance().object_info.hide()
			current_object = null
			return
	
		if _collider.is_in_group("props"):
			SourcePlayerUI.get_instance().object_info.show()
			detect_object(_collider)
		else:
			SourcePlayerUI.get_instance().object_info.hide()

func _process(_delta: float) -> void:
	if !is_multiplayer_authority():
		return
	set_collider(get_collider())

func detect_object(obj:RigidBody3D):
	var object_info = SourcePlayerUI.get_instance().get_node("object_info")
	object_info.get_node("name_label").text = str(obj.name)
	
	var camera = player.camera.camera
	var screen_pos = camera.unproject_position(obj.global_position)
	object_info.position = screen_pos - Vector2(128, 128)
	
	if current_object == obj: return
	
	current_object = obj
	#SoundPlayer.play_global_audio(preload("res://sounds/hl2/buttons/button17.wav"))
	object_detected.emit(obj)

func detect_entity(ent:Node3D):
	if !is_multiplayer_authority():
		return

#OHALERA








#
