extends Control
class_name slike_main_menu

@export var ingame: bool = true
@export var switcher: slike_menu_switcher

@export var bg_textures_folder:String
@export var placeholder_bg:Texture

func _ready() -> void:
	set_random_bg_texture()
	
	if ingame:
		$bg.hide()
		$SD_UIInterfaceMenu.close()
	
	else:
		show()
		SimusDev.cursor.reset_mode()
	
	if not ingame:
		if SD_Multiplayer.is_dedicated_server():
			SimusDev.console.write_events("dedicated server is running...")
			SimusDev.console.write_info("game name: %s" % Maps.dedicated_server.game_map.name)
			
			SD_Multiplayer.create_server(Maps.dedicated_server.port, true)
			Maps.server_change_map_to(Maps.dedicated_server.game_map)

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

func pick_random_bg() -> Texture:
	if bg_textures_folder == "":
		return placeholder_bg
	return load(SD_FileSystem.get_all_files_with_extension_from_directory(bg_textures_folder, SD_FileExtensions.EC_TEXTURE).pick_random())
func set_random_bg_texture() -> void:
	$bg.texture = pick_random_bg()
