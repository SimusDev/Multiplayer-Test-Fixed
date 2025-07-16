extends Label

var sender_name:String = "pidoras"
var message_text:String = "vsem privet ya huesos"

var format_text = "[%s]:  %s"

func _ready() -> void:
	_update()

func _update():
	text = format_text % [sender_name, message_text]
