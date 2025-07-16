@tool
extends Node
class_name SD_NetTrunkCallablesScript

@export var max_channels: int = 32
@export_tool_button("Generate Code") var _tb_generate_code = _generate_code

func _generate_code() -> void:
	var source: String = get_parent().source
	var generated: String = ""
	for id in max_channels:
		var str_id: String = str(id)
		generated += source % [str_id, str_id, str_id, str_id, str_id, str_id]
	
	DisplayServer.clipboard_set(generated)



#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 0)
func _recieve_call_from_rpc_reliable0(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 0)
func _recieve_call_from_rpc_unreliable0(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 0)
func _recieve_call_from_rpc_unreliable_ordered0(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 1)
func _recieve_call_from_rpc_reliable1(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 1)
func _recieve_call_from_rpc_unreliable1(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 1)
func _recieve_call_from_rpc_unreliable_ordered1(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 2)
func _recieve_call_from_rpc_reliable2(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 2)
func _recieve_call_from_rpc_unreliable2(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 2)
func _recieve_call_from_rpc_unreliable_ordered2(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 3)
func _recieve_call_from_rpc_reliable3(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 3)
func _recieve_call_from_rpc_unreliable3(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 3)
func _recieve_call_from_rpc_unreliable_ordered3(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 4)
func _recieve_call_from_rpc_reliable4(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 4)
func _recieve_call_from_rpc_unreliable4(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 4)
func _recieve_call_from_rpc_unreliable_ordered4(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 5)
func _recieve_call_from_rpc_reliable5(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 5)
func _recieve_call_from_rpc_unreliable5(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 5)
func _recieve_call_from_rpc_unreliable_ordered5(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 6)
func _recieve_call_from_rpc_reliable6(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 6)
func _recieve_call_from_rpc_unreliable6(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 6)
func _recieve_call_from_rpc_unreliable_ordered6(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 7)
func _recieve_call_from_rpc_reliable7(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 7)
func _recieve_call_from_rpc_unreliable7(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 7)
func _recieve_call_from_rpc_unreliable_ordered7(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 8)
func _recieve_call_from_rpc_reliable8(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 8)
func _recieve_call_from_rpc_unreliable8(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 8)
func _recieve_call_from_rpc_unreliable_ordered8(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 9)
func _recieve_call_from_rpc_reliable9(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 9)
func _recieve_call_from_rpc_unreliable9(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 9)
func _recieve_call_from_rpc_unreliable_ordered9(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 10)
func _recieve_call_from_rpc_reliable10(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 10)
func _recieve_call_from_rpc_unreliable10(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 10)
func _recieve_call_from_rpc_unreliable_ordered10(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 11)
func _recieve_call_from_rpc_reliable11(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 11)
func _recieve_call_from_rpc_unreliable11(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 11)
func _recieve_call_from_rpc_unreliable_ordered11(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 12)
func _recieve_call_from_rpc_reliable12(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 12)
func _recieve_call_from_rpc_unreliable12(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 12)
func _recieve_call_from_rpc_unreliable_ordered12(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 13)
func _recieve_call_from_rpc_reliable13(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 13)
func _recieve_call_from_rpc_unreliable13(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 13)
func _recieve_call_from_rpc_unreliable_ordered13(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 14)
func _recieve_call_from_rpc_reliable14(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 14)
func _recieve_call_from_rpc_unreliable14(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 14)
func _recieve_call_from_rpc_unreliable_ordered14(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 15)
func _recieve_call_from_rpc_reliable15(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 15)
func _recieve_call_from_rpc_unreliable15(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 15)
func _recieve_call_from_rpc_unreliable_ordered15(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 16)
func _recieve_call_from_rpc_reliable16(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 16)
func _recieve_call_from_rpc_unreliable16(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 16)
func _recieve_call_from_rpc_unreliable_ordered16(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 17)
func _recieve_call_from_rpc_reliable17(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 17)
func _recieve_call_from_rpc_unreliable17(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 17)
func _recieve_call_from_rpc_unreliable_ordered17(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 18)
func _recieve_call_from_rpc_reliable18(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 18)
func _recieve_call_from_rpc_unreliable18(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 18)
func _recieve_call_from_rpc_unreliable_ordered18(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 19)
func _recieve_call_from_rpc_reliable19(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 19)
func _recieve_call_from_rpc_unreliable19(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 19)
func _recieve_call_from_rpc_unreliable_ordered19(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 20)
func _recieve_call_from_rpc_reliable20(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 20)
func _recieve_call_from_rpc_unreliable20(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 20)
func _recieve_call_from_rpc_unreliable_ordered20(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 21)
func _recieve_call_from_rpc_reliable21(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 21)
func _recieve_call_from_rpc_unreliable21(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 21)
func _recieve_call_from_rpc_unreliable_ordered21(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 22)
func _recieve_call_from_rpc_reliable22(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 22)
func _recieve_call_from_rpc_unreliable22(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 22)
func _recieve_call_from_rpc_unreliable_ordered22(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 23)
func _recieve_call_from_rpc_reliable23(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 23)
func _recieve_call_from_rpc_unreliable23(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 23)
func _recieve_call_from_rpc_unreliable_ordered23(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 24)
func _recieve_call_from_rpc_reliable24(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 24)
func _recieve_call_from_rpc_unreliable24(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 24)
func _recieve_call_from_rpc_unreliable_ordered24(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 25)
func _recieve_call_from_rpc_reliable25(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 25)
func _recieve_call_from_rpc_unreliable25(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 25)
func _recieve_call_from_rpc_unreliable_ordered25(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 26)
func _recieve_call_from_rpc_reliable26(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 26)
func _recieve_call_from_rpc_unreliable26(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 26)
func _recieve_call_from_rpc_unreliable_ordered26(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 27)
func _recieve_call_from_rpc_reliable27(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 27)
func _recieve_call_from_rpc_unreliable27(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 27)
func _recieve_call_from_rpc_unreliable_ordered27(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 28)
func _recieve_call_from_rpc_reliable28(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 28)
func _recieve_call_from_rpc_unreliable28(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 28)
func _recieve_call_from_rpc_unreliable_ordered28(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 29)
func _recieve_call_from_rpc_reliable29(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 29)
func _recieve_call_from_rpc_unreliable29(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 29)
func _recieve_call_from_rpc_unreliable_ordered29(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 30)
func _recieve_call_from_rpc_reliable30(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 30)
func _recieve_call_from_rpc_unreliable30(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 30)
func _recieve_call_from_rpc_unreliable_ordered30(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

#//////////////////////////////////////////////////////////////////////////////////////////////////
@rpc("any_peer", "call_remote", "reliable", 31)
func _recieve_call_from_rpc_reliable31(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable", 31)
func _recieve_call_from_rpc_unreliable31(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)

@rpc("any_peer", "call_remote", "unreliable_ordered", 31)
func _recieve_call_from_rpc_unreliable_ordered31(from_peer: int, serialized: Variant) -> void:
	get_parent()._recieve_call_from_local(from_peer, serialized)
