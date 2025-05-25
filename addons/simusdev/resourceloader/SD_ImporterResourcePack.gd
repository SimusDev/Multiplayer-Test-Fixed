extends SD_Importer
class_name SD_ImporterResourcePack

static func load(path: String) -> SD_ResourcePack:
	var status: bool = ProjectSettings.load_resource_pack(path, true)
	if status:
		var pack := SD_ResourcePack.new()
		pack.path = path
		return pack
	return null
	
