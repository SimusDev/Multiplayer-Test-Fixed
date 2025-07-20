extends Node
class_name C_NabludatorItemActions

var _usings: Array = []
var entity_viewmodel: C_NabludatorEntityViewModel
var item: R_NabludatorItem

static func find_in(node: Node) -> C_NabludatorItemActions:
	return node.get_meta("C_NabludatorItemActions")

func _ready() -> void:
	SD_Network.register_function(_set_use_s)
	SD_Network.register_variable(self, "_usings")
	SD_Network.var_sync_from_server(self, ["_usings"])

func set_use(value: bool, id: String) -> void:
	SD_Network.call_func(_set_use_s, [value, id])

func use(value: bool, id: String) -> void:
	SD_Network.call_func(_use_s, [value, id])

func _use_s(value: bool, id: String) -> void:
	_set_use_s(true, id)
	_set_use_s(false, id)
	

func _set_use_s(value: bool, id: String) -> void:
	if _usings.has(id) and value == false:
		_usings.erase(id)
		_using_changed(value, id)
		return
	
	if value and !_usings.has(id):
		_usings.append(id)
		_using_changed(value, id)
		return
	

func _using_changed(value: bool, id: String) -> void:
	pass
