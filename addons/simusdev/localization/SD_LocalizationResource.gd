@tool
extends Resource
class_name SD_LocalizationResource

@export_multiline var DATA = ""

@export_tool_button("Reimport") var _tb_import: Callable = import

func _loaded_by_resource_loader() -> void:
	SimusDev.localization.import_from_resource(self)

func import() -> void:
	_loaded_by_resource_loader()
