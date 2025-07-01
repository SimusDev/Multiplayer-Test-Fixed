extends Control

@onready var mp_api: SD_MultiplayerSingleton = SD_Multiplayer.get_singleton()

@onready var menu_switcher := slike_menu_switcher.find_above(self)

@export var message: Label
@export var bar: ProgressBar

var _loader: SD_NodeSceneLoader

func _ready() -> void:
	menu_switcher.switched.connect(_on_menu_switched)
	menu_switcher.switched_from.connect(_on_menu_switched_from)


func _on_menu_switched(node: Node) -> void:
	if node != self:
		return
	
	bar.hide()
	$refresh.stop()
	$refresh.start(0.0)
	
	message.show()
	message.text = "LOADING..."
	
	mp_api.server_disconnected.connect(_on_server_disconnected)
	
	Maps.server_ready_recieved.connect(_on_server_ready_recieved)
	
	if SD_Multiplayer.is_server():
		_on_server_ready_recieved(true, R_GameMap.selected)

func _on_menu_switched_from(node: Node) -> void:
	if node != self:
		return
	
	$refresh.stop()
	mp_api.server_disconnected.disconnect(_on_server_disconnected)
	Maps.server_ready_recieved.disconnect(_on_server_ready_recieved)
	
	if is_instance_valid(_loader):
		_loader.queue_free()
		_loader = null

func _on_server_ready_recieved(ready: bool, map: R_GameMap) -> void:
	if ready:
		
		$refresh.stop()
		message.text = "MAP RECIEVED: %s, LOADING..." % map.name
		
		if is_instance_valid(_loader):
			_loader.queue_free()
			_loader = null
		
		#bar.show()
		_loader = SD_NodeSceneLoader.new()
		_loader.SCENE_PATH = map.scene_path
		_loader.loading_finished.connect(_on_loader_loading_finished.bind(map))
		#_loader.USE_SUB_THREADS = true
		add_child(_loader)
		update_progressbar()
		
		

func _on_loader_loading_finished(scene: PackedScene, map: R_GameMap) -> void:
	Maps.set_current_map_scene(scene)
	Maps.set_current_map(map)
	Maps.load_gameworld()
	
	

func update_progressbar() -> void:
	if is_instance_valid(_loader):
		bar.value = _loader.get_loading_percents()

func _process(delta: float) -> void:
	update_progressbar()

func _on_server_disconnected() -> void:
	menu_switcher.switch_to_initial()

func _on_cancel_pressed() -> void:
	SD_Multiplayer.close_peer()
	menu_switcher.switch_to_initial()

func _on_refresh_timeout() -> void:
	Maps.request_server_ready()
