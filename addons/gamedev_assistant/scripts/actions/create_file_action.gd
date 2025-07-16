                                                                 
@tool
extends Node

const aaxywrfu = preload("action_parser_utils.gd")

static func execute(gujagdqc: String, ayhzpkin: String) -> bool:
    var vmebaarw = gujagdqc.get_base_dir()
    if not DirAccess.dir_exists_absolute(vmebaarw):
        DirAccess.make_dir_recursive_absolute(vmebaarw)
    
    var prnrcqgi = FileAccess.open(gujagdqc, FileAccess.WRITE)
    if prnrcqgi:
        prnrcqgi.store_string(ayhzpkin)
        prnrcqgi.close()
        if Engine.is_editor_hint():
            EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()
        return true
    return false

static func parse_line(wmffbiku: String, dhatqfcr: String) -> Dictionary:
    if wmffbiku.begins_with("create_file("):
        var iqpcyvew = aaxywrfu.huqphypz(wmffbiku)
        return {
            "type": "create_file",
            "path": iqpcyvew,
            "content": aaxywrfu.dxujsmkd(iqpcyvew, dhatqfcr)
        }
    return {}
