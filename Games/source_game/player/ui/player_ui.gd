class_name SourcePlayerUI extends Control

static var instance:SourcePlayerUI = null : set = set_instance, get = get_instance

#region PLAYER REFERENCES
@onready var source_playable:SourcePlayable = SourcePlayable.get_local()
@onready var player_health:SourceHealth = SourceHealth.find_in(SourcePlayable.get_local().root)

#endregion

#region INSTANCE REFERENCES
@onready var nickname:Label = get_node("nickname")
@onready var v_container:VBoxContainer = nickname.get_node("VBoxContainer")
@onready var health_label:Label = v_container.get_node("health")
@onready var voice_chat_label:Label = v_container.get_node("voice_chat_label")
@onready var time_label: Label = $time
@onready var interactable_info:Label = $crosshair/interactable_info
#endregion

static func get_instance() -> SourcePlayerUI: return instance
static func set_instance(value) -> void: instance = value

func _ready() -> void:
	set_instance(self)
	nickname.text = source_playable.network.get_username()
	source_playable._voice_active.connect(_on_voice_active)
	
	var player = source_playable.root
	if player is SourceEntity:
		player.interact_raycast.selected.connect(on_interactor_selected)
	
	if is_instance_valid(player_health):
		update()
		player_health.health_changed.connect(update)
	
	var event := S_EventPlayerUICreated.as_event()
	event.playable = source_playable
	event.ui = self
	event.publish()
	
	_on_every_half_sec_timeout()

func on_interactor_selected(object:Object) -> void:
	if object == null:
		interactable_info.hide()
		return
	
	if object is SourceInteractable:
		interactable_info.show()
		
		if object.info == "":
			interactable_info.text = object.name
			return
		
		interactable_info.text = object.info

func _on_voice_active(value:bool) -> void:
	voice_chat_label.visible = value

func update():
	health_label.text = "health: %s" % [ snappedf(player_health.health, 0.1) ]

func _on_every_half_sec_timeout() -> void:
	if SourceEnvironment.is_ready_to_work():
		time_label.text = SourceEnvironment.get_game_time()
