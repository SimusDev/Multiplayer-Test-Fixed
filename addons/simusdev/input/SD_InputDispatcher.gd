extends SD_Object
class_name SD_InputDispatcher

static func from_string(key_string: String) -> Array[InputEvent]:
	var events: Array[InputEvent]
	
	var splitted: PackedStringArray = key_string.split(";", false)
	for key in splitted:
		key = key.to_lower()
		
		var event: InputEvent
		
		if key.begins_with(SD_Input.PREFIX_MOUSE):
			event = InputEventMouseButton.new()
			var parsed_index_string: String = key.replacen(SD_Input.PREFIX_MOUSE, "")
			var index: int = int(parsed_index_string)
			event.button_index = index
			events.append(event)
		
		else:
			event = InputEventKey.new()
			event.keycode = OS.find_keycode_from_string(key)
			events.append(event)
		
	
	
	return events

static func from_events(events: Array[InputEvent]) -> String:
	var parsed_key: String = ""
	
	for event in events:
		parsed_key += ";"
		
		if event is InputEventMouseButton:
			parsed_key += SD_Input.PREFIX_MOUSE + str(event.button_index)
		if event is InputEventKey:
			var key: String = event.as_text_physical_keycode()
			if key.is_empty():
				key = event.as_text_keycode()
			parsed_key += key.to_lower()
			
	
	
	parsed_key = parsed_key.replacen(" ", "")
	if parsed_key.begins_with(";"):
		parsed_key = parsed_key.erase(0, 1)
	return parsed_key
