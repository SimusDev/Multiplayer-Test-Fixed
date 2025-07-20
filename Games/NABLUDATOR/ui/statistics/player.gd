extends Control

var player: SD_NetworkPlayer

@onready var label: SD_RichTextLabelSimple = $label

func _ready() -> void:
	player.serverdata_changed.connect(update)
	update("kills", player.serverdata_get_value("kills", 0))
	update("deaths", player.serverdata_get_value("deaths", 0))

func update(key: Variant, value: Variant) -> void:
	match key:
		"kills":
			update_statistic()
		"deaths":
			update_statistic()

func update_statistic() -> void:
	var text: String = "[color=yellow]%s[/color]\nkills:%s\ndeaths:%s" % [player.get_username(), str(player.serverdata_get_value("kills", 0)), str(player.serverdata_get_value("deaths", 0))]
	label.text = text
