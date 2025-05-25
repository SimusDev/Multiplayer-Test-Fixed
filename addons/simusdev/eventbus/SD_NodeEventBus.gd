@icon("res://addons/simusdev/icons/Timer.svg")
extends Node
class_name SD_NodeEventBus

var _events_by_code := {}
var _events_list: Array[SD_Event] = []

@onready var console: SD_TrunkConsole = SimusDev.console
@onready var _base: SD_TrunkEventBus = SimusDev.eventbus

func create_event(code: String) -> SD_Event:
	if has_event_by_code(code):
		write("cant create exist event(%s)" % code, SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	var event := SD_Event.new()
	event.set_code(code)
	write("event created(%s)" % code, SD_ConsoleCategories.CATEGORY.INFO)
	return event

func write(text, category: int) -> SD_ConsoleMessage:
	if not _base.DEBUG:
		return null
	return console.write_from_object(self, text, category)

func create_events(codes: Array[String]) -> Array[SD_Event]:
	var result: Array[SD_Event]
	for code in codes:
		var event := create_event(code)
		result.append(event)
	return result

func add_event(event: SD_Event) -> void:
	if _events_list.has(event):
		return
	
	_events_by_code[event.get_code()] = event
	_events_list.append(event)

func remove_event(event: SD_Event) -> void:
	if not _events_list.has(event):
		return
	
	_events_by_code.erase(event.get_code())
	_events_list.erase(event)

func get_event_by_code(code: String) -> SD_Event:
	return _events_by_code.get(code, null)

func get_events_by_code(codes: Array[String]) -> Array[SD_Event]:
	var result: Array[SD_Event] = []
	for code in codes:
		var event: SD_Event = get_event_by_code(code)
		if event:
			result.append(event)
	return result

func get_event_list() -> Array[SD_Event]:
	return _events_list

func has_event(event: SD_Event) -> bool:
	return _events_list.has(event)

func has_event_by_code(code: String) -> bool:
	return _events_by_code.has(code)
