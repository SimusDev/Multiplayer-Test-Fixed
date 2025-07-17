
extends Node3D
class_name SB_EntitySkin

@export var _source: Node3D

@export var m_current_skin: SB_WorldEntitySkin

var _preview: bool = false : set = _set_preview

@export_group("References")
var _node: Node

func _ready() -> void:
	SD_Network.register_function(set_skin)
	
	if !_source:
		_source = get_parent()
	
	_update()

func set_skin(skin: SB_WorldEntitySkin) -> void:
	SD_Network.call_func(_set_skin, [skin])

func _set_skin(skin: SB_WorldEntitySkin) -> void:
	m_current_skin = skin
	_update()

func _set_preview(val: bool) -> void:
	if !Engine.is_editor_hint():
		return
	
	_preview = val
	if _preview:
		_clear_skin()
		_change_upd_skin()
	else:
		_clear_skin()


func _clear_skin() -> void:
	if is_instance_valid(_node):
		_node.queue_free()
	
	for i in get_children():
		i.queue_free()

func _change_upd_skin() -> void:
	await get_tree().process_frame
	if !m_current_skin:
		return
		
	
	var scene: PackedScene = m_current_skin.prefab
	if scene:
		_node = scene.instantiate()
		_node.name = "skin"
		
		if !Engine.is_editor_hint():
			if _node is Node3D:
				_node.visible = not SD_Multiplayer.is_authority(self)
		
		add_child(_node)
		_node.owner = self
	

func _update() -> void:
	if SD_Multiplayer.is_dedicated_server() or Engine.is_editor_hint():
		return
	
	_clear_skin()
	_change_upd_skin()

func get_skin() -> SB_WorldEntitySkin:
	return m_current_skin
