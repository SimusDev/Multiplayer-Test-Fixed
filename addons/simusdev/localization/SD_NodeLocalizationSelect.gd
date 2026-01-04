@tool
extends SD_NodeLocalization
class_name SD_NodeLocalizationSelect

@export var autoselect_at_start: bool = false

@export_dir var path_to_localization_folder: String

signal selected(language: String)

var _resource_loader := SD_NodeResourceLoader.new()

func _ready() -> void:
	_resource_loader.name = "_resource_loader"
	_resource_loader.load_at_start = false
	add_child(_resource_loader)
	
	if not path_to_localization_folder.is_empty():
		_resource_loader.loading_finished.connect(_on_resource_loader_finished)
		_resource_loader.initial_paths.append(path_to_localization_folder)
		_resource_loader.load_resources()
		return
	
	if autoselect_at_start:
		try_select_proper_language()

func _on_resource_loader_finished() -> void:
	try_select_proper_language()

func select_language(language: String) -> void:
	localization.set_current_languge(language)

func try_select_proper_language() -> void:
	if not SD_BooleansStorage.create("localization.autoselected"):
		return
	
	var proper_language: String = ""
	var available_languages: PackedStringArray = localization.get_available_languages()
	var os_language: String = OS.get_locale_language()
	
	if available_languages.has(os_language):
		proper_language = os_language
	else:
		if !available_languages.is_empty():
			proper_language = available_languages[0]
	
	
	select_language(proper_language)
	
