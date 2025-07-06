extends Resource
class_name SD_PopupAnimationResource

@export var open: Animation
@export var close: Animation

@export var audio_open: Array[AudioStream] = [] 
@export var audio_close: Array[AudioStream] = [] 
@export var audio_bus: String = "Master"
@export var audio_volume_db: float = 0.0
