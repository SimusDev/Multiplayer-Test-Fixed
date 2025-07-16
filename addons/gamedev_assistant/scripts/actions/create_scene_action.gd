                                                                  
@tool
extends Node

const majasoht = preload("action_parser_utils.gd")

static func execute(nfogvnsu: String, xvwtymlu: String, xhgpkzic: String) -> bool:
    var vmwvrwky = nfogvnsu.get_base_dir()
    if not DirAccess.dir_exists_absolute(vmwvrwky):
        DirAccess.make_dir_recursive_absolute(vmwvrwky)
    
    if !ClassDB.class_exists(xhgpkzic): return false
    
    var kgttdxoc = PackedScene.new()
    var ytqwrbhh = ClassDB.instantiate(xhgpkzic)
    ytqwrbhh.name = xvwtymlu
    kgttdxoc.pack(ytqwrbhh)
    
    var xdnjyxgl = ResourceSaver.save(kgttdxoc, nfogvnsu)
    if xdnjyxgl == OK and Engine.is_editor_hint():
        EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()
    return xdnjyxgl == OK

static func parse_line(qvyaawyz: String, bkvvawae: String) -> Dictionary:
    if qvyaawyz.begins_with("create_scene("):
        var iggwuolm = majasoht.ijfolnxk(qvyaawyz)
        if iggwuolm.size() >= 3:
            return {
                "type": "create_scene",
                "path": iggwuolm[0],
                "root_name": iggwuolm[1],
                "root_type": iggwuolm[2]
            }
    return {}
