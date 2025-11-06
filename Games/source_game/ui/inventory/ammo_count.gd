extends Control

var inventory: SourceInventory

func _ready() -> void:
	hide()
	SourceViewModelRoot3D.local.on_update.connect(_on_view_update)

func _on_view_update() -> void:
	print(SourceViewModelRoot3D.local.view_node)
	visible = SourceViewModelRoot3D.local.view_node is SourceFireWeapon
	
