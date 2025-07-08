extends SB_SModule
class_name SB_SModuleGameData

@export_dir var objects_path: String = ""

@export var _objects: Array[SB_WorldObject] = []

signal load_finished()

func get_objects() -> Array[SB_WorldObject]:
	return _objects

func _ready() -> void:
	for file in SD_FileSystem.get_all_files_with_all_extenions_from_directory(objects_path):
		
		var resource: Resource = load(file)
		if resource is SB_WorldObject:
			_objects.append(resource)
			SimusDev.console.write_info("object file loaded: %s" % resource.resource_path)
	
	load_finished.emit()

func _exit_tree() -> void:
	SB_WorldObject.clear_references()
