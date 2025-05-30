extends SD_WorldNodeSaver
class_name SD_WorldNodePropertySaver

enum MULTIPLAYER_MODE {
	SERVER,
	CLIENT,
	BOTH,
}

enum LOAD_MODE {
	READY,
	NODE_READY,
	ENTER_TREE,
}

@export var multiplayer_mode: MULTIPLAYER_MODE = MULTIPLAYER_MODE.SERVER
@export var load_mode: LOAD_MODE = LOAD_MODE.READY
@export var load_when_save_loaded: bool = false
@export var load_at_start: bool = true
@export var properties_to_save: Array[SD_WorldSaverProperty] = []

signal property_loaded(property: String, value: Variant)
signal property_saved(property: String, value: Variant)

const DUPLICATE_RESOURCE_EXCEPTIONS: Array[String] = [
	"PackedScene",
]

func _ready() -> void:
	super()
	
	if load_at_start:
		if load_mode == LOAD_MODE.READY:
			load_properties()
			return
		
		if load_mode == LOAD_MODE.NODE_READY:
			await node.ready
			load_properties()

func _enter_tree() -> void:
	if load_at_start:
		if load_mode == LOAD_MODE.ENTER_TREE:
			load_properties()

func _on_world_saver_loaded(data: SD_WorldSavedData) -> void:
	super(data)
	
	if load_when_save_loaded:
		load_properties()

func _on_world_saver_save_begin(data: SD_WorldSavedData) -> void:
	super(data)
	
	save_properties()

func save_properties(data: SD_WorldSavedData = _saved_data) -> void:
	for property in properties_to_save:
		save_property(property, data)

func load_properties(data: SD_WorldSavedData = _saved_data) -> void:
	for property in properties_to_save:
		load_property(property, data)

func _check_multiplayer_authority() -> bool:
	if not SD_Multiplayer.is_active():
		return true
	
	match multiplayer_mode:
		MULTIPLAYER_MODE.SERVER:
			return SD_Multiplayer.is_server()
		MULTIPLAYER_MODE.CLIENT:
			return !SD_Multiplayer.is_server()
		MULTIPLAYER_MODE.BOTH:
			return true
	
	return false

func save_property(property: SD_WorldSaverProperty, data: SD_WorldSavedData = _saved_data) -> void:
	if not _check_multiplayer_authority():
		return
	
	if (not data) or (not property):
		return
	
	
	var node_data: SD_WorldSavedNodeData = data.create_or_get_data_from_node(node)
	
	for property_name in property.list:
		node_data.save_property(property_name, node.get(property_name))
		property_saved.emit(property_name, node.get(property_name))

func load_property(property: SD_WorldSaverProperty, data: SD_WorldSavedData = _saved_data) -> void:
	if not _check_multiplayer_authority():
		return
	
	if (not data) or (not property):
		return
	
	var node_data: SD_WorldSavedNodeData = data.get_data_from_node(node)
	if not node_data:
		return
	
	for property_name in property.list:
		if not node_data.has_property(property_name):
			return
		
		var loaded_value: Variant = node_data.load_property(property_name)
		
		if property.duplicate:
			if loaded_value is Array:
				loaded_value = loaded_value.duplicate(property.duplicate_deep)
			if loaded_value is Dictionary:
				loaded_value = loaded_value.duplicate(property.duplicate_deep)
			
			if property.duplicate_resources:
				if loaded_value is Resource:
					_try_duplicate_resource(loaded_value, property.duplicate_deep)
				if loaded_value is Array:
					var duplicated_array: Array = []
					for i in loaded_value:
						var d: Variant = _try_duplicate_resource(i, property.duplicate_deep)
						duplicated_array.append(i)
					loaded_value = duplicated_array

			
			
		node.set(property_name, loaded_value)
		property_loaded.emit(property_name, loaded_value)

func _try_duplicate_resource(resource: Variant, subresources: bool = false) -> Resource:
	if not resource is Resource:
		return resource
	
	if not DUPLICATE_RESOURCE_EXCEPTIONS.has(resource.get_class()):
		return resource.duplicate(subresources)
	return resource
