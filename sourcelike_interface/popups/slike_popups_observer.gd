extends Node
class_name slike_popups_observer

var _opened: Array[String] = []

func init_path(path: String, popup: Node) -> void:
	_opened.append(path)
	popup.tree_exited.connect(_on_popup_tree_exited.bind(path))

func _on_popup_tree_exited(path: String) -> void:
	_remove_path(path)

func _remove_path(path: String) -> void:
	_opened.erase(path)

func has_path(path: String) -> bool:
	return _opened.has(path)

static func get_or_create(node: Node) -> slike_popups_observer:
	if node.has_meta("_slike_popups_observer"):
		return node.get_meta("_slike_popups_observer")
	
	var observer := slike_popups_observer.new()
	node.set_meta("_slike_popups_observer", observer)
	node.add_child(observer)
	return observer
