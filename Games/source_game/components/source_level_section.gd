extends Node3D
class_name SourceLevelSection3D

@export var networked: bool = false
@export var can_clear: bool = true
@export var section: String

static var _sections: Dictionary[String, SourceLevelSection3D] = {}

static func get_by_name(section: String) -> SourceLevelSection3D:
	return _sections.get(section)

static func clear_nodes() -> void:
	for section in _sections:
		var node: SourceLevelSection3D = _sections[section]
		if node.can_clear:
			for i in node.get_children():
				i.queue_free()

func _ready() -> void:
	if networked and !SD_Network.is_server():
		SD_Nodes.clear_all_children(self)
	
	
	if section.is_empty():
		section = name
	
	_sections[section] = self
	
	child_entered_tree.connect(_on_child_entered_tree)
	for i in get_children():
		_on_child_entered_tree(i)
	
	

func _enter_tree() -> void:
	if networked:
		SourceGame.instance._spawner.register(self)

func _exit_tree() -> void:
	if networked:
		SourceGame.instance._spawner.unregister(self)

func _on_child_entered_tree(child: Node) -> void:
	if !child.is_node_ready():
		await child.ready
	
	var source_object: SourceObject = SD_Components.find_first(child, SourceObject)
	
	var node_script: GDScript = SourceObject
	var object: R_SourceWorldObject = R_SourceWorldObject.find_in(child)
	if object:
		node_script = object.get_node_script()
		
	
	if not source_object:
		source_object = node_script.new()
		source_object.name = "object" 
		child.add_child(source_object)
	
	if object:
		object._instantiated(child)
