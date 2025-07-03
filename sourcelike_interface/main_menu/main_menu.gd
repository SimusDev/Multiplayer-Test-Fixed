extends Control
class_name slike_main_menu

@export var ingame: bool = true

@export var switcher: slike_menu_switcher

func _ready() -> void:
	if ingame:
		$bg.hide()
		$SD_UIInterfaceMenu.close()
	
	else:
		$SD_UIInterfaceMenu.open()
		SimusDev.cursor.reset_mode()

func open() -> void:
	$SD_UIInterfaceMenu.open()

func close() -> void:
	$SD_UIInterfaceMenu.close()

func change_visibile_status() -> void:
	if visible:
		close()
	else:
		open()

static func find_above(node: Node) -> slike_main_menu:
	if node == SimusDev.get_tree().root:
		return null
	
	if node is slike_main_menu:
		return node
	
	return find_above(node.get_parent())
