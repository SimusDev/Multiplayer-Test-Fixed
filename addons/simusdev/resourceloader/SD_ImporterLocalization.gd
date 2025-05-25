extends SD_Importer
class_name SD_ImporterLocalization

static func load(path: String) -> SD_Config:
	return SimusDev.localization.import_from_file(path)
