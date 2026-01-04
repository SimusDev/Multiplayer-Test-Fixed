@static_unload
extends SD_Object
class_name SD_StringStuff

static func format_with_commas(value: int) -> String:
	var s: String = str(value)
	var result: String = ""
	var count: int = 0
	for i in range(s.length() - 1, -1, -1):
		result = s[i] + result
		count += 1
		if count % 3 == 0 and i != 0:
			result = "," + result
	return result
