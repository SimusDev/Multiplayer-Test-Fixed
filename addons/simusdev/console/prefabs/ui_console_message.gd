extends Label

var color: Color = Color(1, 1, 1, 1)
var count: int = 1
var font_size: int = 1


func _process(delta: float) -> void:
	if !is_visible_in_tree():
		return
	
	modulate.a = lerp(modulate.a, 1.0, delta * 10)

func update_message(msg: String) -> void:
	get_parent().move_child(self, 0)
	label_settings = label_settings.duplicate()
	label_settings.font_size = font_size
	modulate.a = 0.0
	self_modulate = color
	text = msg
	if count >= 2:
		text = "%s (%s)" % [msg, str(count)]
		
