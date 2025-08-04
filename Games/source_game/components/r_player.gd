extends R_SourceEntity
class_name R_SourcePlayer

static var _list: Array[R_SourcePlayer] = []

static func get_list() -> Array[R_SourcePlayer]:
	return _list

func _get_section() -> String:
	return "player"

func is_visible() -> bool:
	return false

func _registered() -> void:
	super()
	_list.append(self)

func _unregistered() -> void:
	super()
	_list.erase(self)
