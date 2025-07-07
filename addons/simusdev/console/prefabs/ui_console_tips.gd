extends Control


var _console: SD_Console

@export var _button_prefab: PackedScene
@export var _container: VBoxContainer

signal tip_selected(cmd: SD_ConsoleCommand)
signal tip_selected_text(text: String)

var _saved_messages: SD_ConsoleCommand
var _saved_messages_max_count: int = 10
var _saved_message_id: int = -1

var settings: Dictionary = {}

func initialize(con: SD_Console) -> void:
	settings = SimusDev.get_settings().console
	_console = con
	
	_saved_messages = con.create_command("console.saved.messages", []).set_private()
	_console.on_try_executed.connect(_on_try_executed)
	

func clear_tips() -> void:
	current_tip_index = -1
	for i in _container.get_children():
		i.queue_free()

func update_tips(text: String = "") -> void:
	clear_tips()
	
	if !_console or text.is_empty():
		return
	
	
	var commands: Array[SD_ConsoleCommand] = _console.get_commands_list()
	var founded_commands: Array[SD_ConsoleCommand] = []
	for cmd in commands:
		if cmd.is_private() and settings.get("hide_private_commands", true):
			continue
		
		if cmd.get_code().find(text) != -1:
			founded_commands.append(cmd)
	
	for cmd in founded_commands:
		var tip: Control = _button_prefab.instantiate()
		_container.add_child(tip)
		tip.initialize(cmd)
		tip.pressed.connect(select_tip_command.bind(cmd))


var current_tip_index: int = -1
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_released():
			var key: String = event.as_text_key_label().to_lower()
			match key:
				"tab":
					switch_current_tip()
				"up":
					switch_saved_message(1)
				"down":
					switch_saved_message(-1)

func switch_current_tip() -> void:
	current_tip_index += 1
	current_tip_index = select_tip_by_index(current_tip_index)

func switch_saved_message(range: int = 0) -> void:
	var array: Array = _saved_messages.get_value_as_array()
	if array.is_empty():
		return
	
	_saved_message_id += range
	
	if _saved_message_id > array.size() - 1:
		_saved_message_id = 0
	if _saved_message_id < 0:
		_saved_message_id = array.size() - 1
	
	var saved_tip: String = SD_Array.get_value_from_array(array, _saved_message_id, "")
	if not saved_tip.is_empty():
		tip_selected_text.emit(saved_tip)

func get_tips() -> Array[Control]:
	var result: Array[Control] = []
	for i in _container.get_children():
		if i is Control:
			result.append(i)
	return result
	

func select_tip_by_index(index: int) -> int:
	if index < -1:
		index = -1
	
	var tips: Array[Control] = get_tips()
	if index > tips.size() - 1:
		index = tips.size() - 1
		
	if tips.size() == 0:
		return index
	
	var selected_tip: Control = SD_Array.get_value_from_array(tips, index)
	if selected_tip:
		select_tip_command(selected_tip.get_command())
	
	return index

func select_tip_command(cmd: SD_ConsoleCommand) -> void:
	if not cmd:
		return
	
	if cmd.is_private():
		return
	
	tip_selected.emit(cmd)
	


func _on_try_executed(exec: String) -> void:
	var array: Array = _saved_messages.get_value_as_array()
	if array.size() > _saved_messages_max_count:
		array.pop_back()
	
	array.push_front(exec)
	_saved_messages.set_value(array)
	
	_saved_message_id = -1

func _on_sd_node_console_commands_on_executed(command: SD_ConsoleCommand) -> void:
	match command.get_code():
		"clear":
			_saved_messages.set_value([])
