@tool
extends SD_Trunk
class_name SD_TrunkAutoLoad

const _BUILTIN_PATHS: PackedStringArray = [
	"res://addons/simusdev/editor/autoload/"
]

func _ready() -> void:
	for path in _BUILTIN_PATHS:
		var resources: Array[SD_AutoLoad] = find_resources(path)
		for resource in resources:
			register(resource)

static func find_resources(path: String) -> Array[SD_AutoLoad]:
	var result: Array[SD_AutoLoad] = []
	for file in SD_FileSystem.get_all_files_with_extension_from_directory(path, SD_FileExtensions.EC_RESOURCE):
		var resource: Resource = load(file)
		if resource is SD_AutoLoad:
			result.append(resource)
	return result

func register(resource: SD_AutoLoad) -> void:
	if resource.editor and !Engine.is_editor_hint():
		return
	
	if resource.scene:
		var holder := SD_AutoLoadHolder.new()
		holder.add_child(resource.scene.instantiate())
		SimusDev.add_child(holder)
	else:
		push_error("scene not found! %s" % resource.resource_path)
