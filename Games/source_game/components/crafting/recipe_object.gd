extends RigidBody3D

@onready var reference: R_SourceRecipe = R_SourceRecipe.find_in(self) as R_SourceRecipe

@onready var label: Label = $SubViewportContainer/Label

func _ready() -> void:
	label.text = "ingridients:\n"
	
	for input in reference.input:
		var text: String = "%s, x%s\n" % [input.source.id, str(input.quantity)]
		label.text += text
