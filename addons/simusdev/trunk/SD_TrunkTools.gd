extends SD_Trunk
class_name SD_TrunkTools

var console: SD_TrunkConsole
var canvas: SD_TrunkCanvas

const TOOLS_PATH: String = "res://addons/simusdev/tools/"

var _available_tools: Dictionary[String, String] = {}

func get_available_tool_list() -> Array[String]:
	return _available_tools.keys() as Array[String]

func _ready() -> void:
	console = SimusDev.console
	canvas = SimusDev.canvas
	
	for path in SD_FileSystem.get_files_with_extension_from_directory(TOOLS_PATH, SD_FileExtensions.EC_SCENE):
		if path is String:
			register_tool(path)

	var commands: Array[SD_ConsoleCommand] = [
		console.create_command("tools.open"),
	]
	
	for cmd in commands:
		cmd.executed.connect(_on_command_executed.bind(cmd))
	
	
	for scenetool in SimusDev.get_settings().tools:
		if scenetool:
			register_tool_from_scene(scenetool)

func get_tool_canvas() -> CanvasLayer:
	return canvas.get_layer(1)

func register_tool(scene_path: String) -> void:
	var scene: PackedScene = load(scene_path)
	if scene:
		var tool: String = scene_path.get_basename()
		_available_tools[tool] = scene_path
		console.write_from_object(self, "TOOL REGISTERED!: %s; USE tools.open %s FOR OPEN THE INTERFACE!" % [tool, tool], SD_ConsoleCategories.CATEGORY.WARNING)
	else:
		console.write_from_object(self, "FAILED TO REGISTER TOOL: %s" % [scene_path], SD_ConsoleCategories.CATEGORY.WARNING)

func unregister_tool(tool: String) -> void:
	if _available_tools.has(tool):
		console.write_from_object(self, "TOOL UNREGISTERED: %s" % [_available_tools[tool]], SD_ConsoleCategories.CATEGORY.WARNING)
		_available_tools.erase(tool)

func unregister_tool_from_scene(scene: PackedScene) -> void:
	if scene:
		unregister_tool(scene.resource_path.get_basename())

func register_tool_from_scene(scene: PackedScene) -> void:
	if scene:
		register_tool(scene.resource_path)

func load_tool_scene(tool_path: String) -> PackedScene:
	var actual_path: String = _available_tools.get(tool_path, "")
	if actual_path.is_empty():
		return
	
	var loaded: PackedScene = load(actual_path)
	if not loaded:
		console.write_from_object(self, "failed to load tool scene: %s" % [actual_path], SD_ConsoleCategories.CATEGORY.ERROR)
		return null
	return loaded

func open(path: String) -> Node:
	var scene: PackedScene = load_tool_scene(path)
	if scene:
		return canvas.create_scene(scene.resource_path, get_tool_canvas())
	return null

func _on_command_executed(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"tools.open":
			open(cmd.get_value())
