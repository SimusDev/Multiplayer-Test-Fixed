extends Control


var _console: SD_Console

@export var _button_prefab: PackedScene
@export var _container: VBoxContainer

signal tip_selected(cmd: SD_ConsoleCommand)

func initialize(con: SD_Console) -> void:
	_console = con

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
					select_tip_by_index(0)
				"up":
					current_tip_index -= 1
					current_tip_index = select_tip_by_index(current_tip_index)
				"down":
					current_tip_index += 1
					current_tip_index = select_tip_by_index(current_tip_index)
	

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
	tip_selected.emit(cmd)
