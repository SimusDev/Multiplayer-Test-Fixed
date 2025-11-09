extends SourceItem

func _ready() -> void:
	super()
	play_animation(_pick)

func use() -> void:
	if not can_use():
		return
	
	play_animation(_fire)
	super()
