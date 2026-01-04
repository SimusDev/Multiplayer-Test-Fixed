@tool
extends TabContainer

var _settings: SD_PluginViewSettings 

func _ready() -> void:
	_settings = SD_EngineSettings.create_or_get().editor_view
	await _instantiate_all()
	_settings.on_custom_tabs_changed.connect(_instantiate_all)

func _instantiate_all() -> void:
	await _clear_tabs()
	_instantiate_tabs(_settings._BUILTIN_TABS)
	_instantiate_tabs(_settings.custom_tabs)
	

func _clear_tabs() -> void:
	for i in get_children():
		i.queue_free()
		await i.tree_exited

func _instantiate_tabs(tabs: Array[PackedScene]) -> void:
	for i in tabs:
		if !is_instance_valid(i):
			continue
		
		add_child.call_deferred(i.instantiate(), true)
		
