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


func _recieve(peer: int, channel: int, object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(peer, channel, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 0)
func _r_rpc_r0(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 0, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 0)
func _r_rpc_u0(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 0, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 0)
func _r_rpc_uo0(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 0, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 1)
func _r_rpc_r1(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 1, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 1)
func _r_rpc_u1(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 1, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 1)
func _r_rpc_uo1(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 1, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 2)
func _r_rpc_r2(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 2, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 2)
func _r_rpc_u2(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 2, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 2)
func _r_rpc_uo2(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 2, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 3)
func _r_rpc_r3(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 3, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 3)
func _r_rpc_u3(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 3, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 3)
func _r_rpc_uo3(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 3, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 4)
func _r_rpc_r4(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 4, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 4)
func _r_rpc_u4(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 4, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 4)
func _r_rpc_uo4(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 4, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 5)
func _r_rpc_r5(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 5, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 5)
func _r_rpc_u5(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 5, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 5)
func _r_rpc_uo5(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 5, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 6)
func _r_rpc_r6(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 6, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 6)
func _r_rpc_u6(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 6, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 6)
func _r_rpc_uo6(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 6, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 7)
func _r_rpc_r7(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 7, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 7)
func _r_rpc_u7(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 7, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 7)
func _r_rpc_uo7(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 7, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 8)
func _r_rpc_r8(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 8, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 8)
func _r_rpc_u8(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 8, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 8)
func _r_rpc_uo8(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 8, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 9)
func _r_rpc_r9(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 9, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 9)
func _r_rpc_u9(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 9, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 9)
func _r_rpc_uo9(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 9, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 10)
func _r_rpc_r10(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 10, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 10)
func _r_rpc_u10(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 10, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 10)
func _r_rpc_uo10(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 10, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 11)
func _r_rpc_r11(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 11, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 11)
func _r_rpc_u11(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 11, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 11)
func _r_rpc_uo11(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 11, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 12)
func _r_rpc_r12(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 12, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 12)
func _r_rpc_u12(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 12, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 12)
func _r_rpc_uo12(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 12, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 13)
func _r_rpc_r13(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 13, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 13)
func _r_rpc_u13(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 13, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 13)
func _r_rpc_uo13(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 13, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 14)
func _r_rpc_r14(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 14, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 14)
func _r_rpc_u14(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 14, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 14)
func _r_rpc_uo14(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 14, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 15)
func _r_rpc_r15(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 15, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 15)
func _r_rpc_u15(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 15, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 15)
func _r_rpc_uo15(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 15, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 16)
func _r_rpc_r16(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 16, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 16)
func _r_rpc_u16(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 16, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 16)
func _r_rpc_uo16(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 16, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 17)
func _r_rpc_r17(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 17, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 17)
func _r_rpc_u17(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 17, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 17)
func _r_rpc_uo17(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 17, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 18)
func _r_rpc_r18(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 18, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 18)
func _r_rpc_u18(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 18, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 18)
func _r_rpc_uo18(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 18, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 19)
func _r_rpc_r19(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 19, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 19)
func _r_rpc_u19(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 19, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 19)
func _r_rpc_uo19(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 19, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 20)
func _r_rpc_r20(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 20, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 20)
func _r_rpc_u20(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 20, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 20)
func _r_rpc_uo20(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 20, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 21)
func _r_rpc_r21(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 21, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 21)
func _r_rpc_u21(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 21, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 21)
func _r_rpc_uo21(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 21, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 22)
func _r_rpc_r22(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 22, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 22)
func _r_rpc_u22(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 22, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 22)
func _r_rpc_uo22(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 22, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 23)
func _r_rpc_r23(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 23, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 23)
func _r_rpc_u23(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 23, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 23)
func _r_rpc_uo23(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 23, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 24)
func _r_rpc_r24(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 24, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 24)
func _r_rpc_u24(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 24, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 24)
func _r_rpc_uo24(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 24, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 25)
func _r_rpc_r25(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 25, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 25)
func _r_rpc_u25(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 25, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 25)
func _r_rpc_uo25(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 25, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 26)
func _r_rpc_r26(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 26, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 26)
func _r_rpc_u26(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 26, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 26)
func _r_rpc_uo26(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 26, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 27)
func _r_rpc_r27(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 27, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 27)
func _r_rpc_u27(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 27, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 27)
func _r_rpc_uo27(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 27, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 28)
func _r_rpc_r28(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 28, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 28)
func _r_rpc_u28(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 28, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 28)
func _r_rpc_uo28(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 28, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 29)
func _r_rpc_r29(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 29, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 29)
func _r_rpc_u29(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 29, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 29)
func _r_rpc_uo29(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 29, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 30)
func _r_rpc_r30(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 30, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 30)
func _r_rpc_u30(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 30, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 30)
func _r_rpc_uo30(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 30, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 31)
func _r_rpc_r31(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 31, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 31)
func _r_rpc_u31(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 31, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 31)
func _r_rpc_uo31(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 31, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 32)
func _r_rpc_r32(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 32, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 32)
func _r_rpc_u32(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 32, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 32)
func _r_rpc_uo32(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 32, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 33)
func _r_rpc_r33(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 33, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 33)
func _r_rpc_u33(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 33, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 33)
func _r_rpc_uo33(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 33, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 34)
func _r_rpc_r34(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 34, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 34)
func _r_rpc_u34(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 34, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 34)
func _r_rpc_uo34(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 34, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 35)
func _r_rpc_r35(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 35, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 35)
func _r_rpc_u35(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 35, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 35)
func _r_rpc_uo35(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 35, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 36)
func _r_rpc_r36(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 36, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 36)
func _r_rpc_u36(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 36, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 36)
func _r_rpc_uo36(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 36, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 37)
func _r_rpc_r37(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 37, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 37)
func _r_rpc_u37(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 37, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 37)
func _r_rpc_uo37(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 37, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 38)
func _r_rpc_r38(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 38, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 38)
func _r_rpc_u38(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 38, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 38)
func _r_rpc_uo38(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 38, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 39)
func _r_rpc_r39(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 39, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 39)
func _r_rpc_u39(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 39, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 39)
func _r_rpc_uo39(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 39, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 40)
func _r_rpc_r40(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 40, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 40)
func _r_rpc_u40(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 40, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 40)
func _r_rpc_uo40(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 40, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 41)
func _r_rpc_r41(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 41, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 41)
func _r_rpc_u41(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 41, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 41)
func _r_rpc_uo41(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 41, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 42)
func _r_rpc_r42(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 42, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 42)
func _r_rpc_u42(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 42, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 42)
func _r_rpc_uo42(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 42, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 43)
func _r_rpc_r43(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 43, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 43)
func _r_rpc_u43(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 43, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 43)
func _r_rpc_uo43(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 43, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 44)
func _r_rpc_r44(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 44, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 44)
func _r_rpc_u44(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 44, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 44)
func _r_rpc_uo44(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 44, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 45)
func _r_rpc_r45(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 45, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 45)
func _r_rpc_u45(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 45, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 45)
func _r_rpc_uo45(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 45, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 46)
func _r_rpc_r46(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 46, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 46)
func _r_rpc_u46(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 46, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 46)
func _r_rpc_uo46(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 46, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 47)
func _r_rpc_r47(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 47, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 47)
func _r_rpc_u47(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 47, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 47)
func _r_rpc_uo47(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 47, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 48)
func _r_rpc_r48(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 48, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 48)
func _r_rpc_u48(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 48, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 48)
func _r_rpc_uo48(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 48, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 49)
func _r_rpc_r49(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 49, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 49)
func _r_rpc_u49(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 49, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 49)
func _r_rpc_uo49(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 49, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 50)
func _r_rpc_r50(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 50, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 50)
func _r_rpc_u50(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 50, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 50)
func _r_rpc_uo50(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 50, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 51)
func _r_rpc_r51(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 51, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 51)
func _r_rpc_u51(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 51, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 51)
func _r_rpc_uo51(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 51, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 52)
func _r_rpc_r52(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 52, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 52)
func _r_rpc_u52(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 52, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 52)
func _r_rpc_uo52(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 52, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 53)
func _r_rpc_r53(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 53, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 53)
func _r_rpc_u53(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 53, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 53)
func _r_rpc_uo53(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 53, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 54)
func _r_rpc_r54(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 54, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 54)
func _r_rpc_u54(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 54, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 54)
func _r_rpc_uo54(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 54, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 55)
func _r_rpc_r55(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 55, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 55)
func _r_rpc_u55(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 55, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 55)
func _r_rpc_uo55(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 55, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 56)
func _r_rpc_r56(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 56, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 56)
func _r_rpc_u56(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 56, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 56)
func _r_rpc_uo56(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 56, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 57)
func _r_rpc_r57(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 57, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 57)
func _r_rpc_u57(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 57, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 57)
func _r_rpc_uo57(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 57, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 58)
func _r_rpc_r58(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 58, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 58)
func _r_rpc_u58(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 58, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 58)
func _r_rpc_uo58(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 58, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 59)
func _r_rpc_r59(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 59, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 59)
func _r_rpc_u59(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 59, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 59)
func _r_rpc_uo59(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 59, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 60)
func _r_rpc_r60(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 60, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 60)
func _r_rpc_u60(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 60, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 60)
func _r_rpc_uo60(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 60, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 61)
func _r_rpc_r61(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 61, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 61)
func _r_rpc_u61(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 61, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 61)
func _r_rpc_uo61(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 61, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 62)
func _r_rpc_r62(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 62, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 62)
func _r_rpc_u62(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 62, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 62)
func _r_rpc_uo62(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 62, object, method, args)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 63)
func _r_rpc_r63(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 63, object, method, args)

@rpc("any_peer", "call_remote", "unreliable", 63)
func _r_rpc_u63(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 63, object, method, args)

@rpc("any_peer", "call_remote", "unreliable_ordered", 63)
func _r_rpc_uo63(object: Variant, method: Variant, args: Array = []) -> void:
	get_parent()._recieve_call_from_local(multiplayer.get_remote_sender_id(), 63, object, method, args)
