@tool
@static_unload
extends SD_Object
class_name SD_Platforms

#match OS.get_name():
#    "Windows", "UWP":
#        print("Windows")
#    "macOS":
#        print("macOS")
#    "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
#        print("Linux/BSD")
#    "Android":
#        print("Android")
#    "iOS":
#        print("iOS")
#    "Web":
#        print("Web")

const P_WINDOWS := ["Windows", "UWP"]
const P_MAC_OS := ["macOS"]
const P_LINUX_OR_BSD := ["Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD"]
const P_ANDROID := ["Android"]
const P_IOS := ["iOS"]
const P_WEB := ["Web"]

static func get_name() -> String:
	return OS.get_name()

static func is_platform(p_array: Array) -> bool:
	var sorted := PackedStringArray(p_array)
	return get_name() in sorted

static func is_windows() -> bool:
	return is_platform(P_WINDOWS)

static func is_mac_os() -> bool:
	return is_platform(P_MAC_OS)

static func is_linux_or_bsd() -> bool:
	return is_platform(P_LINUX_OR_BSD)

static func is_android() -> bool:
	return is_platform(P_ANDROID)

static func is_ios() -> bool:
	return is_platform(P_IOS)

static func is_web() -> bool:
	return is_platform(P_WEB)

static func is_pc() -> bool:
	return is_windows() or is_mac_os() or is_linux_or_bsd()

static func is_mobile() -> bool:
	return is_android() or is_ios()

static func is_debug_build() -> bool:
	return OS.is_debug_build()

static func is_release_build() -> bool:
	return !is_debug_build()

static func is_editor_hint() -> bool:
	return Engine.is_editor_hint()

static func is_app_hint() -> bool:
	return !is_editor_hint()

static func has_feature_editor() -> bool:
	return OS.has_feature("editor")

static func is_project_builded() -> bool:
	if is_release_build():
		return true
	
	return is_debug_build() and not has_feature_editor()

static func has_debug_console_feature() -> bool:
	return true
