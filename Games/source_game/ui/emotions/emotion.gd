extends Button

var emotions: SourceEmotions
var resource: R_SourceEmotion

func _ready() -> void:
	text = resource.name
