class_name SourcePlayer extends SourceEntity

static var instance:SourcePlayer

func _ready() -> void:
	super()
	if is_multiplayer_authority():
		instance = self
