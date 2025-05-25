extends SD_Importer
class_name SD_ImporterScript

static func load(path: String) -> Object:
	var scripted_node := SD_GameScript.new()
	
	
	
	var script_src := "
extends SD_GameScript

"
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null
	var file_text: String = file.get_as_text()
	var file_name: String = path.get_file().get_basename()
	
	
	var script := GDScript.new()
	script_src += file_text
	script.set_source_code(script_src)
	script.reload()
	scripted_node.set_script(script)
	
	scripted_node.path = file_name
	
	return scripted_node
