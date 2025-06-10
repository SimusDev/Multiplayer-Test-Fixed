extends Resource
class_name R_GameMap

@export var visible:bool = true

@export var is_favorite:bool = false
@export_file("*tscn") var scene_path: String = ""
@export var code: String = ""
@export var name: String = ""
@export var icon: Texture = null
@export_multiline var description: String = ""
