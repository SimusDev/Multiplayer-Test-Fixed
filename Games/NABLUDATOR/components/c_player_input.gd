extends Node
class_name C_NabludatorPlayerInput

@export var viewmodel: C_NabludatorEntityViewModel

@export var hotbar_slots: PackedStringArray = [
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
]

func _ready() -> void:
	if !viewmodel.is_node_ready():
		await viewmodel.ready

func _on_sd_node_input_on_input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return
	
	if event is InputEventKey:
		var key: String = event.as_text_key_label().to_lower()
		if key in hotbar_slots:
			var id: int = int(key) - 1
			viewmodel.select(id)
