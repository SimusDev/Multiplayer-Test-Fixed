extends EL_SModule
class_name EL_SModuleGameData

@export_dir var resources_path: String = ""

@export var _resources: Array[Resource] = []

signal load_finished()

func _ready() -> void:
	for file in SD_FileSystem.get_all_files_with_all_extenions_from_directory(resources_path):
		continue
		
		var resource: Resource = load(file)
		if resource is Resource:
			_resources.append(resource)
			SimusDev.console.write_info("resource file loaded: %s" % resource.resource_path)
			await get_tree().process_frame
	
	load_finished.emit()
