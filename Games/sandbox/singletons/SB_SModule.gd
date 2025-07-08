extends Node
class_name SB_SModule

func _enter_tree() -> void:
	SimusDev.console.write_from_object(self, "module entered tree", SD_ConsoleCategories.CATEGORY.INFO)
