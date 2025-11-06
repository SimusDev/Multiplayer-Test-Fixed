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
#endregion

static func get_instance() -> SourcePlayerUI: return instance
static func set_instance(value) -> void: instance = value

func _ready() -> void:
	set_instance(self)
	nickname.text = source_playable.network.get_username()
	source_playable._voice_active.connect(_on_voice_active)
	
	if is_instance_valid(player_health):
		update()
		player_health.health_changed.connect(update)
	
	var event := S_EventPlayerUICreated.as_event()
	event.playable = source_playable
	event.ui = self
	event.publish()
	

func _on_voice_active(value:bool) -> void:
	voice_chat_label.visible = value

func update():
	health_label.text = "health: %s" % [ snappedf(player_health.health, 0.1) ]
