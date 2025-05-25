extends SD_WorldNodeSaver
class_name SD_WorldNodePropertySaver

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

func save_property(property: SD_WorldSaverProperty, data: SD_WorldSavedData = _saved_data) -> void:
	if (not data) or (not property):
		return
	
	var node_data: SD_WorldSavedNodeData = data.create_or_get_data_from_node(node)
	node_data.save_property(property.name, node.get(property.name))
	property_saved.emit(property.name, node.get(property.name))

func load_property(property: SD_WorldSaverProperty, data: SD_WorldSavedData = _saved_data) -> void:
	if (not data) or (not property):
		return
	
	var node_data: SD_WorldSavedNodeData = data.get_data_from_node(node)
	if not node_data:
		return
	
	var loaded_value: Variant = node_data.load_property(property.name)
	
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

		
		
	node.set(property.name, loaded_value)
	property_loaded.emit(property.name, loaded_value)

func _try_duplicate_resource(resource: Variant, subresources: bool = false) -> Resource:
	if not resource is Resource:
		return resource
	
	if not DUPLICATE_RESOURCE_EXCEPTIONS.has(resource.get_class()):
		return resource.duplicate(subresources)
	return resource
