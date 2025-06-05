                                                                 
@tool
extends Node

const weinyyfz = preload("action_parser_utils.gd")

static func execute(rlejkbjt: String, jspmdmtq: String) -> bool:
    var gpsghtlo = rlejkbjt.get_base_dir()
    if not DirAccess.dir_exists_absolute(gpsghtlo):
        DirAccess.make_dir_recursive_absolute(gpsghtlo)
    
    var yeoluhqt = FileAccess.open(rlejkbjt, FileAccess.WRITE)
    if yeoluhqt:
        yeoluhqt.store_string(jspmdmtq)
        yeoluhqt.close()
        if Engine.is_editor_hint():
            EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()
        return true
    return false

static func parse_line(poylotsb: String, dtxduacu: String) -> Dictionary:
    if poylotsb.begins_with("create_file("):
        var ylnukkrj = weinyyfz.arsaclkr(poylotsb)
        return {
            "type": "create_file",
            "path": ylnukkrj,
            "content": weinyyfz.fgakxepz(ylnukkrj, dtxduacu)
        }
    return {}
