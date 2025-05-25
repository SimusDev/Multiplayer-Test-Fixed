extends Control

@onready var energy: FW_EnergyComponent = FW_EnergyComponent.get_instance()
@onready var time: FW_TimeComponent = FW_TimeComponent.get_instance()

@onready var label_time: SD_Label = $label_time
@onready var label_powerleft: SD_Label = $label_powerleft

@export var usage_textures: Array[Texture]

func _ready() -> void:
	energy.updated.connect(_on_energy_updated)
	energy.usage_changed.connect(_on_usage_changed)
	
	_on_energy_updated()
	_on_time_updated()
	_on_usage_changed()

func _on_usage_changed() -> void:
	$usage_texture.texture = SD_Array.get_value_from_array(usage_textures, energy.usage, usage_textures[usage_textures.size() - 1])

func _physics_process(delta: float) -> void:
	_on_time_updated()

func _on_energy_updated() -> void:
	label_powerleft.text = "POWER LEFT: %s" % str(int(energy.get_energy())) + "%"

func _on_time_updated() -> void:
	label_time.text = time.get_time_as_string()
