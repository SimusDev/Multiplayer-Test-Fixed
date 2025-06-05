                                                                 
@tool
extends Node

const rppqzfvp = preload("action_parser_utils.gd")
const ttnzvilh = preload("edit_node_action.gd")

static func execute(jognhbkv: String, vugixhxk: String, ylhcuova: String, hdehbzrl: String, qkcsuuos: Dictionary) -> bool:
    var rggygzix = EditorPlugin.new().get_editor_interface()
    var nbsbgzmg = rggygzix.get_open_scenes()
    
    var seizltlt = load(vugixhxk)
    if not seizltlt is PackedScene:
        push_error("Invalid scene file: " + vugixhxk)
        return false
    
    if ylhcuova in nbsbgzmg:
        return zckxlsds(jognhbkv, seizltlt, ylhcuova, hdehbzrl, qkcsuuos)
    else:
        return ftlopfmu(jognhbkv, seizltlt, ylhcuova, hdehbzrl, qkcsuuos)

static func zckxlsds(tqjrxdml: String, asajaash: PackedScene, evnxpvby: String, vkfwvpxh: String, bhfwzxae: Dictionary) -> bool:
    var btqzjqjc = EditorPlugin.new().get_editor_interface()
    btqzjqjc.reload_scene_from_path(evnxpvby)
    var ojhbtmks = btqzjqjc.get_edited_scene_root()
    
    var rxrhsgyz = ojhbtmks if (vkfwvpxh.is_empty() or vkfwvpxh == ojhbtmks.name) else ojhbtmks.find_child(vkfwvpxh, true, true)  
    if not rxrhsgyz:  
        if vkfwvpxh == ojhbtmks.name:  
            rxrhsgyz = ojhbtmks  
        else:  
            return false  
    
    var myvctaxj = asajaash.instantiate()
    myvctaxj.name = tqjrxdml
    rxrhsgyz.add_child(myvctaxj)
    myvctaxj.set_owner(ojhbtmks)
    
    if not bhfwzxae.is_empty():
        if not ttnzvilh.edkidcyn(myvctaxj, bhfwzxae, ojhbtmks):
            return false
    
    return EditorPlugin.new().get_editor_interface().save_scene() == OK

static func ftlopfmu(ohgmornc: String, srnbvvbp: PackedScene, idsuzkvy: String, imxzouzy: String, somhyvtz: Dictionary) -> bool:
    var axxiwbny = load(idsuzkvy)
    if not axxiwbny is PackedScene:
        push_error("Invalid target scene: " + idsuzkvy)
        return false
    
    var amxbnyzh = axxiwbny.instantiate()
    var sgisvdtx = amxbnyzh if (imxzouzy.is_empty() or imxzouzy == amxbnyzh.name) else amxbnyzh.find_child(imxzouzy, true, true)  
    if not sgisvdtx:  
        if imxzouzy == amxbnyzh.name:  
            sgisvdtx = amxbnyzh  
        else:  
            return false  
    
    var gqvnpvhh = srnbvvbp.instantiate()
    gqvnpvhh.name = ohgmornc
    sgisvdtx.add_child(gqvnpvhh)
    gqvnpvhh.set_owner(amxbnyzh)
    
    if not somhyvtz.is_empty():
        if not ttnzvilh.edkidcyn(gqvnpvhh, somhyvtz, amxbnyzh):
            return false
    
    axxiwbny.pack(amxbnyzh)
    return ResourceSaver.save(axxiwbny, idsuzkvy) == OK

static func parse_line(xvkjgwnh: String, ncjniipz: String) -> Dictionary:
    if xvkjgwnh.begins_with("add_existing_scene("):
        var mxroqivc = xvkjgwnh.replace("add_existing_scene(", "").strip_edges()
        if mxroqivc.ends_with(")"):
            mxroqivc = mxroqivc.substr(0, mxroqivc.length() - 1).strip_edges()
        
        var ujwpabip = []
        var pemwctzt = 0
                                             
        for _i in range(4):
            var hxqdqrnh = mxroqivc.find('"',pemwctzt)
            if hxqdqrnh == -1: return {}
            var hebpmred = mxroqivc.find('"', hxqdqrnh + 1)
            if hebpmred == -1: return {}
            ujwpabip.append(mxroqivc.substr(hxqdqrnh + 1, hebpmred - hxqdqrnh - 1))
            pemwctzt = hebpmred + 1
        
                                        
        var sysnvcrn = {}
        var ehlritls = mxroqivc.substr(pemwctzt).strip_edges()
        if ehlritls.begins_with("{"):
            sysnvcrn = rppqzfvp.wljdwntt(ehlritls)
        
        return {
            "type": "add_existing_scene",
            "node_name": ujwpabip[0],
            "existing_scene_path": ujwpabip[1],
            "target_scene_path": ujwpabip[2],
            "parent_path": ujwpabip[3],
            "modifications": sysnvcrn
        }
    return {}
