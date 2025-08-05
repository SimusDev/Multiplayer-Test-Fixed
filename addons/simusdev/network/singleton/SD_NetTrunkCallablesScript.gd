@tool
extends Node
class_name SD_NetTrunkCallablesScript

@export_multiline var source: String = ""
@export var max_channels: int = 32
@export_tool_button("Generate Code") var _tb_generate_code = _generate_code

func _generate_code() -> void:
	var source: String = source
	var generated: String = ""
	for id in max_channels:
		var str_id: String = str(id)
		generated += source % [str_id, str_id, str_id, str_id, str_id, str_id, str_id, str_id, str_id]
	
	DisplayServer.clipboard_set(generated)




#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 0)
func _recieve_call_from_rpc_reliable0(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 0

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 0)
func _recieve_call_from_rpc_unreliable0(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 0

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 0)
func _recieve_call_from_rpc_unreliable_ordered0(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 0

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 1)
func _recieve_call_from_rpc_reliable1(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 1

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 1)
func _recieve_call_from_rpc_unreliable1(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 1

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 1)
func _recieve_call_from_rpc_unreliable_ordered1(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 1

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 2)
func _recieve_call_from_rpc_reliable2(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 2

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 2)
func _recieve_call_from_rpc_unreliable2(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 2

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 2)
func _recieve_call_from_rpc_unreliable_ordered2(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 2

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 3)
func _recieve_call_from_rpc_reliable3(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 3

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 3)
func _recieve_call_from_rpc_unreliable3(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 3

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 3)
func _recieve_call_from_rpc_unreliable_ordered3(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 3

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 4)
func _recieve_call_from_rpc_reliable4(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 4

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 4)
func _recieve_call_from_rpc_unreliable4(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 4

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 4)
func _recieve_call_from_rpc_unreliable_ordered4(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 4

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 5)
func _recieve_call_from_rpc_reliable5(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 5

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 5)
func _recieve_call_from_rpc_unreliable5(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 5

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 5)
func _recieve_call_from_rpc_unreliable_ordered5(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 5

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 6)
func _recieve_call_from_rpc_reliable6(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 6

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 6)
func _recieve_call_from_rpc_unreliable6(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 6

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 6)
func _recieve_call_from_rpc_unreliable_ordered6(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 6

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 7)
func _recieve_call_from_rpc_reliable7(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 7

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 7)
func _recieve_call_from_rpc_unreliable7(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 7

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 7)
func _recieve_call_from_rpc_unreliable_ordered7(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 7

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 8)
func _recieve_call_from_rpc_reliable8(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 8

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 8)
func _recieve_call_from_rpc_unreliable8(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 8

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 8)
func _recieve_call_from_rpc_unreliable_ordered8(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 8

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 9)
func _recieve_call_from_rpc_reliable9(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 9

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 9)
func _recieve_call_from_rpc_unreliable9(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 9

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 9)
func _recieve_call_from_rpc_unreliable_ordered9(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 9

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 10)
func _recieve_call_from_rpc_reliable10(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 10

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 10)
func _recieve_call_from_rpc_unreliable10(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 10

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 10)
func _recieve_call_from_rpc_unreliable_ordered10(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 10

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 11)
func _recieve_call_from_rpc_reliable11(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 11

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 11)
func _recieve_call_from_rpc_unreliable11(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 11

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 11)
func _recieve_call_from_rpc_unreliable_ordered11(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 11

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 12)
func _recieve_call_from_rpc_reliable12(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 12

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 12)
func _recieve_call_from_rpc_unreliable12(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 12

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 12)
func _recieve_call_from_rpc_unreliable_ordered12(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 12

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 13)
func _recieve_call_from_rpc_reliable13(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 13

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 13)
func _recieve_call_from_rpc_unreliable13(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 13

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 13)
func _recieve_call_from_rpc_unreliable_ordered13(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 13

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 14)
func _recieve_call_from_rpc_reliable14(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 14

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 14)
func _recieve_call_from_rpc_unreliable14(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 14

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 14)
func _recieve_call_from_rpc_unreliable_ordered14(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 14

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 15)
func _recieve_call_from_rpc_reliable15(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 15

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 15)
func _recieve_call_from_rpc_unreliable15(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 15

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 15)
func _recieve_call_from_rpc_unreliable_ordered15(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 15

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 16)
func _recieve_call_from_rpc_reliable16(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 16

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 16)
func _recieve_call_from_rpc_unreliable16(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 16

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 16)
func _recieve_call_from_rpc_unreliable_ordered16(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 16

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 17)
func _recieve_call_from_rpc_reliable17(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 17

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 17)
func _recieve_call_from_rpc_unreliable17(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 17

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 17)
func _recieve_call_from_rpc_unreliable_ordered17(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 17

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 18)
func _recieve_call_from_rpc_reliable18(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 18

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 18)
func _recieve_call_from_rpc_unreliable18(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 18

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 18)
func _recieve_call_from_rpc_unreliable_ordered18(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 18

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 19)
func _recieve_call_from_rpc_reliable19(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 19

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 19)
func _recieve_call_from_rpc_unreliable19(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 19

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 19)
func _recieve_call_from_rpc_unreliable_ordered19(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 19

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 20)
func _recieve_call_from_rpc_reliable20(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 20

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 20)
func _recieve_call_from_rpc_unreliable20(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 20

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 20)
func _recieve_call_from_rpc_unreliable_ordered20(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 20

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 21)
func _recieve_call_from_rpc_reliable21(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 21

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 21)
func _recieve_call_from_rpc_unreliable21(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 21

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 21)
func _recieve_call_from_rpc_unreliable_ordered21(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 21

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 22)
func _recieve_call_from_rpc_reliable22(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 22

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 22)
func _recieve_call_from_rpc_unreliable22(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 22

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 22)
func _recieve_call_from_rpc_unreliable_ordered22(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 22

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 23)
func _recieve_call_from_rpc_reliable23(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 23

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 23)
func _recieve_call_from_rpc_unreliable23(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 23

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 23)
func _recieve_call_from_rpc_unreliable_ordered23(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 23

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 24)
func _recieve_call_from_rpc_reliable24(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 24

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 24)
func _recieve_call_from_rpc_unreliable24(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 24

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 24)
func _recieve_call_from_rpc_unreliable_ordered24(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 24

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 25)
func _recieve_call_from_rpc_reliable25(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 25

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 25)
func _recieve_call_from_rpc_unreliable25(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 25

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 25)
func _recieve_call_from_rpc_unreliable_ordered25(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 25

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 26)
func _recieve_call_from_rpc_reliable26(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 26

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 26)
func _recieve_call_from_rpc_unreliable26(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 26

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 26)
func _recieve_call_from_rpc_unreliable_ordered26(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 26

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 27)
func _recieve_call_from_rpc_reliable27(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 27

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 27)
func _recieve_call_from_rpc_unreliable27(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 27

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 27)
func _recieve_call_from_rpc_unreliable_ordered27(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 27

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 28)
func _recieve_call_from_rpc_reliable28(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 28

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 28)
func _recieve_call_from_rpc_unreliable28(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 28

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 28)
func _recieve_call_from_rpc_unreliable_ordered28(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 28

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 29)
func _recieve_call_from_rpc_reliable29(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 29

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 29)
func _recieve_call_from_rpc_unreliable29(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 29

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 29)
func _recieve_call_from_rpc_unreliable_ordered29(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 29

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 30)
func _recieve_call_from_rpc_reliable30(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 30

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 30)
func _recieve_call_from_rpc_unreliable30(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 30

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 30)
func _recieve_call_from_rpc_unreliable_ordered30(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 30

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 31)
func _recieve_call_from_rpc_reliable31(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 31

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable", 31)
func _recieve_call_from_rpc_unreliable31(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 31

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)

@rpc("any_peer", "call_remote", "unreliable_ordered", 31)
func _recieve_call_from_rpc_unreliable_ordered31(serialized: Variant) -> void:
	var from_peer: int = multiplayer.get_remote_sender_id()
	var channel: int = 31

	get_parent()._recieve_call_from_local(from_peer, serialized, channel)
