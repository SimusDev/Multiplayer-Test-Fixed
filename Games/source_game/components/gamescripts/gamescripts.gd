extends Node
class_name SourceGameScripts

@export_dir var path: String = ""

func _ready() -> void:
	await get_parent().ready
	
	for file: String in SD_FileSystem.get_all_files_with_extension_from_directory(path, SD_FileExtensions.EC_SCRIPT):
		var script: Script = load(file)
		
		var node: R_SourceGameScript = R_SourceGameScript.new()
		node.set_script(script)
		node.name = file.replacen(SourceGame.GAME_PATH, "").validate_node_name()
		add_child(node)
	
	for i in get_children():
		if i.has_method("_start"):
			i._start()
