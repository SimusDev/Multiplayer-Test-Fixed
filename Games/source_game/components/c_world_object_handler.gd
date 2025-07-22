extends Node
class_name C_SourceObjectHandler

@export_dir var base_dir: String
@export var object_dirs: PackedStringArray

var _resources: Array[R_SourceWorldObject]

func _ready() -> void:
	for dir in object_dirs:
		var dir_path: String = base_dir.path_join(dir)
		for file in SD_FileSystem.get_all_files_with_extension_from_directory(dir_path, SD_FileExtensions.EC_RESOURCE):
			var resource: Resource = load(file)
			if resource is R_SourceWorldObject:
				_resources.append(resource)
				resource.register()
				
