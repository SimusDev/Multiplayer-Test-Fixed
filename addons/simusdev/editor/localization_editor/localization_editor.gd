@tool
class_name SD_EditorUILocalization extends Control

signal resource_changed

var sections:Dictionary[String, String]
var current_lang: String = ""

@export var resource:SD_LocalizationResource : set = set_resource, get = get_resource
func set_resource(new_res:SD_LocalizationResource) -> void:
	resource = new_res
	resource_changed.emit()
func get_resource() -> SD_LocalizationResource:
	return resource
@export_group("Prefabs")
@export var editable_key:PackedScene


@onready var language_sections: HBoxContainer = $Languages/HBoxContainer
@onready var editable_keys: VBoxContainer = $KeysScroll/VBoxContainer


func _ready() -> void:
	pass

func _load_file(path:String) -> void:
	var new_res = load(path)
	if new_res is SD_LocalizationResource:
		resource = new_res
		_parse_resource_data()

func _parse_resource_data() -> void:
	var _languages:PackedStringArray = detect_languages(resource)
	for lang in _languages:
		sections.get_or_add(lang, get_section_body(resource, lang))
	
	_add_section_buttons()
	_add_editable_keys()

func _add_section_buttons() -> void:
	for c in language_sections.get_children():
		language_sections.remove_child(c)
		c.queue_free()
	for key in sections.keys():
		var section_btn:SD_EditorUILanguageSectionButton = SD_EditorUILanguageSectionButton.new()
		section_btn.section = key
		section_btn.pressed.connect(_select_section.bind(section_btn.section))
		language_sections.add_child(section_btn)

func _add_editable_keys() -> void:
	for c in editable_keys.get_children():
		editable_keys.remove_child(c)
		c.queue_free()
	
	if current_lang.is_empty():
		return

	var keys: PackedStringArray = get_section_keys(resource, current_lang)
	var body_lines = get_section_body(resource, current_lang).split("\n")
	
	for k in keys:
		var key_value = ""
		for line in body_lines:
			if line.begins_with(k):
				key_value = line.split("=", true, 1)[1].strip_edges()
				break
		
		var inst = editable_key.instantiate() as SD_EditorUIEditableKey
		editable_keys.add_child(inst)
		inst.setup(k, key_value)
		
		inst.value_changed.connect(func(new_val):
			add_section_key(resource, current_lang, k, new_val)
			sections[current_lang] = get_section_body(resource, current_lang)
		)

func _select_section(section: String) -> void:
	current_lang = section
	_add_editable_keys()

static func get_resource_data(res:SD_LocalizationResource) -> String:
	return res.DATA

static func get_section_keys(res: SD_LocalizationResource, lang: String) -> PackedStringArray:
	var body = get_section_body(res, lang)
	if body.is_empty():
		return []
		
	var keys = PackedStringArray()
	var lines = body.split("\n")
	
	for line in lines:
		if "=" in line:
			var parts = line.split("=", true, 1)
			var key = parts[0].strip_edges()
			if not key.is_empty():
				keys.append(key)
	return keys

static func add_section_key(res:SD_LocalizationResource, lang:String, new_key_name:String, new_key_value:String) -> void:
	var lines = res.DATA.split("\n")
	var new_lines = PackedStringArray()
	
	var current_lang = ""
	var key_found = false
	var section_found = false
	
	var entry = new_key_name + " = \"" + new_key_value + "\""
	
	var i = 0
	while i < lines.size():
		var line = lines[i].strip_edges()
		
		if line.begins_with("[") and line.ends_with("]"):
			if current_lang == lang and not key_found:
				new_lines.append(entry)
				key_found = true
				
			current_lang = line
			new_lines.append(line)
			if current_lang == lang:
				section_found = true
		elif current_lang == lang:
			# Если нашли ключ в нужной секции — заменяем его
			if line.begins_with(new_key_name + " ") or line.begins_with(new_key_name + "="):
				new_lines.append(entry)
				key_found = true
			elif not line.is_empty():
				new_lines.append(line)
		else:
			new_lines.append(line)
		i += 1

	if current_lang == lang and not key_found:
		new_lines.append(entry)
		key_found = true

	if not section_found:
		if new_lines.size() > 0 and not new_lines[-1].is_empty():
			new_lines.append("")
		new_lines.append(lang)
		new_lines.append(entry)
	
	res.DATA = "\n".join(new_lines)

static func get_section_body(res:SD_LocalizationResource, lang:String) -> String:
	var lines := res.DATA.split("\n")
	var result_lines := PackedStringArray()
	var is_reading := false

	for line in lines:
		line = line.strip_edges()
		if line.is_empty():
			continue
			
		if line.begins_with("[") and line.ends_with("]"):
			if line == lang:
				is_reading = true
				continue
			elif is_reading:
				break
		
		if is_reading:
			result_lines.append(line)
			
	return "\n".join(result_lines)

static func detect_languages(res:SD_LocalizationResource) -> PackedStringArray:
	var result_sections:PackedStringArray = []
	for line:String in res.DATA.split("\n"):
		if line.is_empty():
			continue
		if line.begins_with("[") and line.ends_with("]"):
			result_sections.append(line)
	
	return result_sections
