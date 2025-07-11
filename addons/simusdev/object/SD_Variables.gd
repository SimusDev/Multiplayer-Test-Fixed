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
