@tool
extends Node
class_name SimusNetRPCProccessor

@export_multiline var source: String = ""
@export_tool_button("Generate Code") var _tb_generate_code = _generate_code

func _generate_code() -> void:
	var source: String = source
	var generated: String = ""
	for id in SimusNetChannels.MAX:
		var str_id: String = str(id)
		generated += source % [str_id, str_id, str_id, str_id, str_id, str_id, str_id, str_id, str_id]
	
	DisplayServer.clipboard_set(generated)

func _recieve(peer: int, channel: int, identity: Variant, method: Variant, args: Variant = null) -> void:
	get_parent()._processor_recieve_rpc_from_peer(peer, channel, identity, method, args)

func _parse_and_get_function(channel: int, transfer: SimusNetRPC.TRANSFER_MODE) -> String:
	return "_rpc_%s_%s" % [transfer, channel]

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 0)
func _rpc_0_0(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 0, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 0)
func _rpc_1_0(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 0, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 0)
func _rpc_2_0(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 0, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 1)
func _rpc_0_1(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 1, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 1)
func _rpc_1_1(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 1, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 1)
func _rpc_2_1(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 1, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 2)
func _rpc_0_2(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 2, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 2)
func _rpc_1_2(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 2, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 2)
func _rpc_2_2(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 2, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 3)
func _rpc_0_3(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 3, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 3)
func _rpc_1_3(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 3, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 3)
func _rpc_2_3(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 3, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 4)
func _rpc_0_4(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 4, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 4)
func _rpc_1_4(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 4, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 4)
func _rpc_2_4(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 4, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 5)
func _rpc_0_5(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 5, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 5)
func _rpc_1_5(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 5, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 5)
func _rpc_2_5(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 5, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 6)
func _rpc_0_6(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 6, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 6)
func _rpc_1_6(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 6, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 6)
func _rpc_2_6(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 6, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 7)
func _rpc_0_7(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 7, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 7)
func _rpc_1_7(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 7, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 7)
func _rpc_2_7(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 7, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 8)
func _rpc_0_8(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 8, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 8)
func _rpc_1_8(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 8, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 8)
func _rpc_2_8(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 8, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 9)
func _rpc_0_9(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 9, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 9)
func _rpc_1_9(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 9, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 9)
func _rpc_2_9(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 9, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 10)
func _rpc_0_10(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 10, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 10)
func _rpc_1_10(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 10, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 10)
func _rpc_2_10(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 10, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 11)
func _rpc_0_11(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 11, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 11)
func _rpc_1_11(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 11, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 11)
func _rpc_2_11(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 11, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 12)
func _rpc_0_12(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 12, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 12)
func _rpc_1_12(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 12, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 12)
func _rpc_2_12(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 12, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 13)
func _rpc_0_13(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 13, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 13)
func _rpc_1_13(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 13, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 13)
func _rpc_2_13(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 13, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 14)
func _rpc_0_14(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 14, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 14)
func _rpc_1_14(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 14, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 14)
func _rpc_2_14(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 14, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 15)
func _rpc_0_15(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 15, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 15)
func _rpc_1_15(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 15, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 15)
func _rpc_2_15(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 15, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 16)
func _rpc_0_16(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 16, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 16)
func _rpc_1_16(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 16, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 16)
func _rpc_2_16(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 16, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 17)
func _rpc_0_17(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 17, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 17)
func _rpc_1_17(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 17, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 17)
func _rpc_2_17(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 17, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 18)
func _rpc_0_18(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 18, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 18)
func _rpc_1_18(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 18, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 18)
func _rpc_2_18(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 18, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 19)
func _rpc_0_19(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 19, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 19)
func _rpc_1_19(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 19, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 19)
func _rpc_2_19(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 19, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 20)
func _rpc_0_20(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 20, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 20)
func _rpc_1_20(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 20, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 20)
func _rpc_2_20(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 20, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 21)
func _rpc_0_21(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 21, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 21)
func _rpc_1_21(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 21, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 21)
func _rpc_2_21(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 21, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 22)
func _rpc_0_22(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 22, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 22)
func _rpc_1_22(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 22, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 22)
func _rpc_2_22(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 22, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 23)
func _rpc_0_23(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 23, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 23)
func _rpc_1_23(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 23, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 23)
func _rpc_2_23(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 23, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 24)
func _rpc_0_24(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 24, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 24)
func _rpc_1_24(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 24, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 24)
func _rpc_2_24(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 24, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 25)
func _rpc_0_25(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 25, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 25)
func _rpc_1_25(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 25, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 25)
func _rpc_2_25(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 25, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 26)
func _rpc_0_26(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 26, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 26)
func _rpc_1_26(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 26, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 26)
func _rpc_2_26(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 26, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 27)
func _rpc_0_27(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 27, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 27)
func _rpc_1_27(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 27, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 27)
func _rpc_2_27(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 27, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 28)
func _rpc_0_28(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 28, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 28)
func _rpc_1_28(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 28, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 28)
func _rpc_2_28(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 28, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 29)
func _rpc_0_29(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 29, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 29)
func _rpc_1_29(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 29, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 29)
func _rpc_2_29(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 29, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 30)
func _rpc_0_30(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 30, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 30)
func _rpc_1_30(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 30, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 30)
func _rpc_2_30(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 30, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 31)
func _rpc_0_31(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 31, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 31)
func _rpc_1_31(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 31, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 31)
func _rpc_2_31(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 31, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 32)
func _rpc_0_32(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 32, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 32)
func _rpc_1_32(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 32, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 32)
func _rpc_2_32(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 32, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 33)
func _rpc_0_33(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 33, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 33)
func _rpc_1_33(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 33, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 33)
func _rpc_2_33(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 33, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 34)
func _rpc_0_34(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 34, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 34)
func _rpc_1_34(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 34, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 34)
func _rpc_2_34(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 34, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 35)
func _rpc_0_35(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 35, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 35)
func _rpc_1_35(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 35, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 35)
func _rpc_2_35(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 35, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 36)
func _rpc_0_36(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 36, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 36)
func _rpc_1_36(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 36, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 36)
func _rpc_2_36(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 36, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 37)
func _rpc_0_37(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 37, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 37)
func _rpc_1_37(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 37, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 37)
func _rpc_2_37(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 37, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 38)
func _rpc_0_38(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 38, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 38)
func _rpc_1_38(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 38, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 38)
func _rpc_2_38(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 38, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 39)
func _rpc_0_39(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 39, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 39)
func _rpc_1_39(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 39, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 39)
func _rpc_2_39(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 39, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 40)
func _rpc_0_40(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 40, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 40)
func _rpc_1_40(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 40, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 40)
func _rpc_2_40(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 40, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 41)
func _rpc_0_41(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 41, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 41)
func _rpc_1_41(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 41, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 41)
func _rpc_2_41(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 41, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 42)
func _rpc_0_42(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 42, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 42)
func _rpc_1_42(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 42, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 42)
func _rpc_2_42(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 42, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 43)
func _rpc_0_43(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 43, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 43)
func _rpc_1_43(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 43, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 43)
func _rpc_2_43(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 43, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 44)
func _rpc_0_44(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 44, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 44)
func _rpc_1_44(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 44, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 44)
func _rpc_2_44(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 44, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 45)
func _rpc_0_45(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 45, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 45)
func _rpc_1_45(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 45, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 45)
func _rpc_2_45(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 45, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 46)
func _rpc_0_46(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 46, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 46)
func _rpc_1_46(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 46, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 46)
func _rpc_2_46(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 46, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 47)
func _rpc_0_47(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 47, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 47)
func _rpc_1_47(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 47, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 47)
func _rpc_2_47(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 47, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 48)
func _rpc_0_48(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 48, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 48)
func _rpc_1_48(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 48, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 48)
func _rpc_2_48(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 48, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 49)
func _rpc_0_49(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 49, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 49)
func _rpc_1_49(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 49, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 49)
func _rpc_2_49(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 49, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 50)
func _rpc_0_50(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 50, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 50)
func _rpc_1_50(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 50, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 50)
func _rpc_2_50(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 50, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 51)
func _rpc_0_51(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 51, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 51)
func _rpc_1_51(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 51, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 51)
func _rpc_2_51(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 51, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 52)
func _rpc_0_52(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 52, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 52)
func _rpc_1_52(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 52, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 52)
func _rpc_2_52(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 52, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 53)
func _rpc_0_53(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 53, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 53)
func _rpc_1_53(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 53, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 53)
func _rpc_2_53(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 53, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 54)
func _rpc_0_54(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 54, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 54)
func _rpc_1_54(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 54, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 54)
func _rpc_2_54(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 54, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 55)
func _rpc_0_55(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 55, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 55)
func _rpc_1_55(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 55, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 55)
func _rpc_2_55(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 55, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 56)
func _rpc_0_56(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 56, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 56)
func _rpc_1_56(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 56, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 56)
func _rpc_2_56(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 56, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 57)
func _rpc_0_57(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 57, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 57)
func _rpc_1_57(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 57, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 57)
func _rpc_2_57(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 57, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 58)
func _rpc_0_58(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 58, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 58)
func _rpc_1_58(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 58, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 58)
func _rpc_2_58(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 58, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 59)
func _rpc_0_59(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 59, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 59)
func _rpc_1_59(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 59, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 59)
func _rpc_2_59(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 59, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 60)
func _rpc_0_60(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 60, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 60)
func _rpc_1_60(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 60, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 60)
func _rpc_2_60(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 60, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 61)
func _rpc_0_61(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 61, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 61)
func _rpc_1_61(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 61, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 61)
func _rpc_2_61(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 61, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 62)
func _rpc_0_62(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 62, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 62)
func _rpc_1_62(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 62, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 62)
func _rpc_2_62(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 62, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 63)
func _rpc_0_63(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 63, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 63)
func _rpc_1_63(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 63, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 63)
func _rpc_2_63(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 63, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 64)
func _rpc_0_64(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 64, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 64)
func _rpc_1_64(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 64, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 64)
func _rpc_2_64(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 64, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 65)
func _rpc_0_65(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 65, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 65)
func _rpc_1_65(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 65, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 65)
func _rpc_2_65(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 65, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 66)
func _rpc_0_66(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 66, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 66)
func _rpc_1_66(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 66, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 66)
func _rpc_2_66(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 66, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 67)
func _rpc_0_67(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 67, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 67)
func _rpc_1_67(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 67, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 67)
func _rpc_2_67(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 67, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 68)
func _rpc_0_68(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 68, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 68)
func _rpc_1_68(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 68, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 68)
func _rpc_2_68(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 68, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 69)
func _rpc_0_69(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 69, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 69)
func _rpc_1_69(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 69, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 69)
func _rpc_2_69(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 69, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 70)
func _rpc_0_70(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 70, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 70)
func _rpc_1_70(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 70, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 70)
func _rpc_2_70(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 70, identity, method, args)


#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "unreliable", 71)
func _rpc_0_71(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 71, identity, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 71)
func _rpc_1_71(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 71, identity, method, args)

@rpc("any_peer", "call_remote", "reliable", 71)
func _rpc_2_71(identity: Variant, method: Variant, args: Variant = null) -> void:
	_recieve(multiplayer.get_remote_sender_id(), 71, identity, method, args)
