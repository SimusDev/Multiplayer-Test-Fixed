@tool
extends SD_SettingsAdsSDK
class_name SD_SettingsAdsSDKYandex

@export_tool_button("Copy Head Include") var _ysdk_toolbutton = _ysdk_toolbutton_copy_head_include

func _ysdk_toolbutton_copy_head_include() -> void:
	var file: FileAccess = FileAccess.open("res://addons/simusdev/monetization/templates/html_head_include_yandex.txt", FileAccess.READ)
	DisplayServer.clipboard_set(file.get_as_text())
