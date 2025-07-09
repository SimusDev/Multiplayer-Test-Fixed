extends SB_SModule
class_name SB_SModuleGameData

@export_dir var objects_path: String = ""

var _objects: Array[SB_WorldObject] = []

signal load_finished()

func get_objects() -> Array[SB_WorldObject]:
	return _objects

func _ready() -> void:
	for file in SD_FileSystem.get_all_files_with_extension_from_directory(objects_path, SD_FileExtensions.EC_RESOURCE):
		var resource: Resource = load(file)
		if resource is SB_WorldObject:
			_objects.append(resource)
			resource.register()

	load_finished.emit()

func _exit_tree() -> void:
	SB_WorldObject.clear_references()
