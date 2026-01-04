extends Control

@export var MAX_MESSAGES: int = 100
@export var font_size: int = 9
@export var message_prefab: PackedScene
@export var _vbox: VBoxContainer
@export var _scroll: ScrollContainer

var _messages: Dictionary[String, Node] = {}

func init_message(message: SD_ConsoleMessage) -> void:
	var instance: Control = _messages.get(message.get_as_string(), null)
	if instance:
		instance.count += 1
	else:
		instance = message_prefab.instantiate()
		instance.message = message
		_messages[message.get_as_string()] = instance
		instance.tree_exiting.connect(_on_message_tree_exiting.bind(message.get_as_string()))
		_vbox.add_child(instance)
		_vbox.move_child(instance, 0)
		
		var child_count: int = _vbox.get_child_count()
		if child_count <= 0:
			return
		
		if child_count >= MAX_MESSAGES:
			var ui_msg: Control = _vbox.get_child(child_count - 1)
			ui_msg.queue_free()
			
	
	instance.color = message.color
	instance.font_size = font_size
	instance.update_message(message.get_as_string())
	


func _on_message_tree_exiting(msg: String) -> void:
	_messages.erase(msg)

func clear_messages() -> void:
	for i in _vbox.get_children():
		i.queue_free()
	
	_messages.clear()
