extends Button

@export var resource: R_CS_Team

@onready var color: ColorRect = $color
@onready var team_name: Label = $team_name

func _ready() -> void:
	color.color = resource.color
	team_name.text = resource.name
