                                                                  
@tool
extends Node

const dvgwgsek = preload("action_parser_utils.gd")

static func execute(nfdeslxz: String, rjhgqnda: String, nlgkwnbu: String) -> bool:
    var amzyxouq = nfdeslxz.get_base_dir()
    if not DirAccess.dir_exists_absolute(amzyxouq):
        DirAccess.make_dir_recursive_absolute(amzyxouq)
    
    if !ClassDB.class_exists(nlgkwnbu): return false
    
    var phofyari = PackedScene.new()
    var yhtwaijf = ClassDB.instantiate(nlgkwnbu)
    yhtwaijf.name = rjhgqnda
    phofyari.pack(yhtwaijf)
    
    var npflvetr = ResourceSaver.save(phofyari, nfdeslxz)
    if npflvetr == OK and Engine.is_editor_hint():
        EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()
    return npflvetr == OK

static func parse_line(pahlgilg: String, xjqgvjfi: String) -> Dictionary:
    if pahlgilg.begins_with("create_scene("):
        var cqdsszov = dvgwgsek.yoxlteic(pahlgilg)
        if cqdsszov.size() >= 3:
            return {
                "type": "create_scene",
                "path": cqdsszov[0],
                "root_name": cqdsszov[1],
                "root_type": cqdsszov[2]
            }
    return {}
