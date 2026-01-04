@tool
extends EditorPlugin

var export_plugin : SD_EditorExportPluginMobileAds

func _enter_tree():
	export_plugin = SD_EditorExportPluginMobileAds.new()
	add_export_plugin(export_plugin)


func _exit_tree():
	remove_export_plugin(export_plugin)
	export_plugin = null


class SD_EditorExportPluginMobileAds extends EditorExportPlugin:
	var _plugin_name = "GodotMobileAds"
	
	var _bin_name: String = "GodotAndroidYandexAds"
	
	func _supports_platform(platform):
		if platform is EditorExportPlatformAndroid:
			return true
		return false
	
	func _get_android_libraries(platform, debug):
		if debug:
			return PackedStringArray([SD_EditorPlugins.get_path_to_plugin("MobileAds") + "bin/debug/" + _bin_name + "-debug.aar"])
		else:
			return PackedStringArray([SD_EditorPlugins.get_path_to_plugin("MobileAds") + "bin/release/" + _bin_name + "-release.aar"])
	
	func _get_android_dependencies(platform, debug):
		if debug:
			return PackedStringArray(["com.yandex.android:mobileads:7.3.0"])
		else:
			return PackedStringArray(["com.yandex.android:mobileads:7.3.0"])
	
	func _get_name():
		return _plugin_name
