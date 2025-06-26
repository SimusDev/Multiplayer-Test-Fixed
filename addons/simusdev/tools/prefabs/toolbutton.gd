extends Button

func init(tool_name: String) -> void:
	$Label.text = tool_name

func _on_pressed() -> void:
	SimusDev.tools.open($Label.text)
