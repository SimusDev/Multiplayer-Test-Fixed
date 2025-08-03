@static_unload
extends SD_Object
class_name SD_Variables

static func variant_to_string(variant: Variant) -> String:
	return var_to_str(variant)

static func string_to_variant(string: String, default_value: Variant = null) -> Variant:
	var parsed: Variant = str_to_var(string)
	if parsed == null:
		return default_value
	return parsed

static var __instantiate_class_script: String = "
extends RefCounted

func instantiate(name: String) -> Variant:
	return %s.new()

"

static func instantiate_class(name: String) -> Variant:
	var __class_instantiator: RefCounted = RefCounted.new()
	var script: GDScript = GDScript.new()
	script.source_code = __instantiate_class_script % [name]
	script.reload()
	__class_instantiator.set_script(script)
	return __class_instantiator.instantiate(name)
