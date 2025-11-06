class_name SourceMaterial extends StandardMaterial3D

enum MaterialTypes {
	Metal,
	Wood,
	Water,
	Grass,
	Glass,
	
}

@export var type:MaterialTypes
@export var footsteps_audio:Array[AudioStream]
@export var soft_impact_audio:Array[AudioStream]
@export var hard_impact_audio:Array[AudioStream]
@export var bullet_impact_audio:Array[AudioStream]
