extends Node2D

@export var objects: Array[SimusNetObject]

var _test: Dictionary[int, SimusNetIdentity] = {}

func _ready() -> void:
	#for i in objects:
		#i.create_instance()
	
	SimusNetEvents.event_active_status_changed.listen(_active_status_changed)
	
	SimusNetRPC.register([_test_rpc], SimusNetRPCConfig.new())

func _process_identity(i: SimusNetIdentity) -> void:
	pass

func _on_timer_timeout() -> void:
	if SimusNetConnection.is_server():
		#var b: PackedByteArray = PackedByteArray()
		#b.resize(1)
		#b.encode_u8(0, 10)
		#SimusNetRPC.invoke(_test_rpc, load("res://simusnet.tres"), load("res://simusnet.tres"))
		
		var packet: PackedByteArray = PackedByteArray()
		packet.resize(48)
		packet.encode_u16(0, 100)
		
		var args: Array = []
		_test_godot_rpc.rpc(0, 100, [packet])

func _test_rpc(resource: Resource) -> void:
	print("recieved rpc from: ", SimusNetRemote.sender_id)
	print(resource)

@rpc("authority", "call_remote", "reliable")
func _test_godot_rpc(id0: Variant = null, id1: Variant = null, id2: Variant = null) -> void:
	print(id0, ", ", id1, ", ", id2)

func _active_status_changed() -> void:
	$CanvasLayer.visible = !SimusNetConnection.is_active()

func _on_host_pressed() -> void:
	SimusNetConnectionENet.create_server(8080)

func _on_connect_pressed() -> void:
	SimusNetConnectionENet.create_client(%LineEdit.text, 8080)
