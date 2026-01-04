extends RefCounted
class_name SD_Signal

var _listeners: Array[Callable] = []

var _name: String = ""
var _object: Object = null

func _init(name: String = "", object: Object = null) -> void:
	_name = name
	_object = object

func get_listeners() -> Array[Callable]:
	return _listeners

func invoke(...args: Array) -> void:
	for i in _listeners:
		if (!i.is_valid()):
			_listeners.erase(i)
			continue
		
		if args.size() == i.get_argument_count():
			i.callv(args)
			continue
		
		SD_Console.i().write_error("[SD_Signal (%s) (%s)] callable args count must == SD_Signal invoked args count!" %[_object, _name])
		for id in args.size():
			var value: Variant = args[id]
			if value is Object:
				var _base_script: Script = SD_Components.get_base_script_from(value.get_script())
				var script_name: String = ""
				var global_name: String = ""
				if _base_script:
					script_name = _base_script.get_global_name()
				if value.get_script():
					global_name = value.get_script().get_global_name()
				
				
				SD_Console.i().write_error("argument[%s] type is: %s (%s) %s:%s" % [id, value, value.get_script(), global_name, script_name])
			else:
				SD_Console.i().write_error("argument[%s] type is: %s" % [id, type_string(typeof(value))])
				
		
		
	
	

func add_listener(callable: Callable) -> void:
	if !_listeners.has(callable):
		_listeners.append(callable)

func remove_listener(callable: Callable) -> void:
	if _listeners.has(callable):
		_listeners.erase(callable)
