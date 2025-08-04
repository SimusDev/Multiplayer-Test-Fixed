extends CanvasLayer

@export var container: Control
@export var container_spawn: Control
@export var slot: PackedScene
@export var spawn: PackedScene

var _playable: R_SourcePlayer
var _spawn: SourceSpawnPointResource

func _ready() -> void:
	for player in R_SourcePlayer.get_list():
		var ui: Control = slot.instantiate()
		ui.resource = player
		ui.ui = self
		container.add_child(ui)
	
	for spawn in SourcePlayerSpawner.as_node().spawnpoints:
		var ui: Control = self.spawn.instantiate()
		ui.resource = spawn
		ui.ui = self
		container_spawn.add_child(ui)
	

func _selected_player(player: R_SourcePlayer) -> void:
	_playable = player

func _selected_spawn(resource: SourceSpawnPointResource) -> void:
	_spawn = resource
	SourcePlayerSpawner.as_node().request_spawn(_playable, _spawn)
	SourcePlayerSpawner.as_node().close_interface()
