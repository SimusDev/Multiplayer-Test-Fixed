extends CanvasLayer

@export var container: Control
@export var container_spawn: Control
@export var slot: PackedScene
@export var spawn: PackedScene

var _playable: R_SourcePlayer
var _spawn: SourceSpawnPointResource

func _ready() -> void:
	_full_update()
	
	while true:
		await get_tree().create_timer(1.0).timeout
		_full_update()

func _full_update() -> void:
	_update_players()
	_update_spawnpoints()

func _update_players() -> void:
	SD_Nodes.clear_all_children(container)
	print(R_SourceWorldObject.get_reference_list())
	for player in R_SourcePlayer.get_list():
		print(player)
		var ui: Control = slot.instantiate()
		ui.resource = player
		ui.ui = self
		container.add_child(ui)

func _update_spawnpoints() -> void:
	SD_Nodes.clear_all_children(container_spawn)
	
	for sp in SourcePlayerSpawner.as_node().spawnpoints:
		var ui: Control = self.spawn.instantiate()
		ui.resource = sp
		ui.ui = self
		container_spawn.add_child(ui)

func _selected_player(player: R_SourcePlayer) -> void:
	_playable = player

func _selected_spawn(resource: SourceSpawnPointResource) -> void:
	_spawn = resource
	SourcePlayerSpawner.as_node().request_spawn(_playable, _spawn)
	SourcePlayerSpawner.as_node().close_interface()
