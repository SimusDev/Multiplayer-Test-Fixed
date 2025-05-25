extends Object
class_name SD_MPRecievedDBData

var _peer_id: int
var _key: String = ""
var _value: Variant = null

func get_peer_id() -> int:
	return _peer_id

func get_key() -> String:
	return _key

func get_value() -> Variant:
	return _value

func to_data_string() -> String:
	var _str: String = "peer_id: %s\nkey: %s\nvalue: %s\n" % [
		str(_peer_id),
		_key,
		str(_value)
	]
	return _str
