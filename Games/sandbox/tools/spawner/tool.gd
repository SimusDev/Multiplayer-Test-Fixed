extends Control

@export var _container: GridContainer

@onready var player: SB_PlayerComponent = SB_PlayerComponent.get_local()

@export var _object_scene: PackedScene

var _ui_list: Array[Control] = []

var _selected: SB_WorldObject

signal selected(object: SB_WorldObject)

var _cmd_selected: SB_ConCommand
var _cmd_search: SB_ConCommand
var _cmd_x: SB_ConCommand
var _cmd_y: SB_ConCommand
var _cmd_z: SB_ConCommand

var settings := SB_LevelSpawnSettings.new()

func set_selected(object: SB_WorldObject) -> void:
	if not object:
		return
	
	_selected = object
	selected.emit(object)
	
	_cmd_selected.get_source().set_value(object.id)
	
	$l_object.text = object.id
	$l_x.text = _cmd_x.get_source().get_value_as_string()
	$l_y.text = _cmd_y.get_source().get_value_as_string()
	$l_z.text = _cmd_z.get_source().get_value_as_string()

func _ready() -> void:
	if SB_WorldObject.get_reference_list().is_empty():
		return
	
	_cmd_selected = SB_ConCommand.get_or_create_client("spawner.selected", "null")
	_cmd_search = SB_ConCommand.get_or_create_client("spawner.search", "null")
	_cmd_x = SB_ConCommand.get_or_create_client("spawner.x", 0)
	_cmd_y = SB_ConCommand.get_or_create_client("spawner.y", 0)
	_cmd_z = SB_ConCommand.get_or_create_client("spawner.z", 0)
	
	for object in SB_WorldObject.get_reference_list():	
		var ui: Control = _object_scene.instantiate()
		_ui_list.append(ui)
		_container.add_child(ui)
		ui.pressed.connect(_on_ui_pressed.bind(ui.object))
		ui.init(object, self)
		$SD_UIControlSearch.bind(object.id, ui)
	
	var picked_object: SB_WorldObject = SB_WorldObject.get_reference_list()[0]
	
	if _cmd_selected.get_source().get_value_as_string() == "null":
		_cmd_selected.get_source().set_value(picked_object.id)
		_cmd_search.get_source().set_value(picked_object.id)
	
	var selected_obj: SB_WorldObject = SB_WorldObject.get_by_id(_cmd_selected.get_source().get_value_as_string())
	
	set_selected(selected_obj)

func _on_ui_pressed(object: SB_WorldObject) -> void:
	set_selected(object)

func request_spawn(settings: SB_LevelSpawnSettings) -> void:
	var object: SB_WorldObject = SB_WorldObject.get_by_id($l_object.text)
	
	if !object:
		return
	
	if !is_instance_valid(player):
		return
	
	var x: float = _cmd_x.get_source().get_value_as_float()
	var y: float = _cmd_y.get_source().get_value_as_float()
	var z: float = _cmd_z.get_source().get_value_as_float()
	var s_position: Vector3 = Vector3(x, y, z)
	settings.position = s_position
	
	player.get_level().spawn_request(object, true, settings)

func _on_spawn_button_pressed() -> void:
	_cmd_x.get_source().set_value(float($l_x.text))
	_cmd_y.get_source().set_value(float($l_y.text))
	_cmd_z.get_source().set_value(float($l_z.text))
	
	request_spawn(settings)
	


func _on_sd_ui_control_search_updated(key: String) -> void:
	_cmd_search.get_source().set_value(key)
