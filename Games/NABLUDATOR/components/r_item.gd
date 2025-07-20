extends Resource
class_name R_NabludatorItem

@export var name:String = ""
@export var code:String = ""
@export var viewmodel: R_NabludatorViewModel
@export var actions: R_NabludatorItemActions

var data: C_NabludatorItemData

@export_group("Animations")
@export var _animation_library:AnimationLibrary
@export var _use:String = "fire"
@export var _pick:String = "pick"

@export_group("Sound")
@export var pick_sound:AudioStream
@export var use_sound:AudioStream
