extends Node3D

@export var ip: String = "localhost"
@export var port: int = 8080

@export var object: PackedScene
@export var spawn_pos: Vector3 = Vector3.ZERO

@export var objects: Node3D

@export var typed_array: Array[SD_NetPlayerResource] = []
@export var typed_dictionary: Dictionary[SD_NetPlayerResource, SD_NetPlayerResource] = {}

@export var resource_test_uid: Resource

func _ready() -> void:
	SD_Network.register_all_functions(self)
	
	
	#print(type_string(typed_array.get_typed_builtin()))
	#print(typed_array.get_typed_class_name())
	#print(typed_array.get_typed_script())
	
	var serialize_test: Array = [
		SD_NetPlayerResource.new(),
		SD_NetPlayerResource.new(),
		SD_NetPlayerResource.new(),
		SD_NetPlayerResource.new(),
		SD_NetPlayerResource.new(),
		SD_NetPlayerResource.new(),
	]
	
	var serialize_test2: Dictionary = {
		"0123": SD_NetPlayerResource.new(),
		"serialize!!!": SD_NetPlayerResource.new(),
		self: self,
	}
	
	#print(SD_NetworkSerializer.parse(serialize_test))
	#print(SD_NetworkSerializer.parse(serialize_test2))
	
	#print(SD_NetworkSerializer.parse("/root/Game/World/Level3D/LevelSection3D/Props/MegaUltraProp"))
	
	#print(resource_test_uid.get_id_for_path(resource_test_uid.resource_path))

func _on_server_pressed() -> void:
	if SD_Network.create_server(port):
		$CanvasLayer.hide()

func _on_client_pressed() -> void:
	if SD_Network.create_client(ip, port):
		$CanvasLayer.hide()

func _input(event: InputEvent) -> void:
	if $CanvasLayer.visible:
		return
		
	if event is InputEventMouseButton:
		if event.is_pressed():
			SD_Network.call_func(spawn, [$objects.get_child_count()])

func spawn(id: int) -> void:
	var instance: RigidBody3D = object.instantiate()
	instance.name = str(id)
	instance.position = spawn_pos
	objects.add_child(instance)
