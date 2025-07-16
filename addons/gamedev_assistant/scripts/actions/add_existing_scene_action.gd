                                                                 
@tool
extends Node

const yfynmwtp = preload("action_parser_utils.gd")
const mwcqxqtd = preload("edit_node_action.gd")

static func execute(usnpcmxd: String, xuwbkovx: String, llqtbuuy: String, gblghvtr: String, qzimoyux: Dictionary) -> bool:
    var ugzcgeas = EditorPlugin.new().get_editor_interface()
    var hqouabhy = ugzcgeas.get_open_scenes()
    
    var cdnxymcu = load(xuwbkovx)
    if not cdnxymcu is PackedScene:
        push_error("Invalid scene file: " + xuwbkovx)
        return false
    
    if llqtbuuy in hqouabhy:
        return dzwukgqd(usnpcmxd, cdnxymcu, llqtbuuy, gblghvtr, qzimoyux)
    else:
        return hcvkkspw(usnpcmxd, cdnxymcu, llqtbuuy, gblghvtr, qzimoyux)

static func dzwukgqd(ulvhsfej: String, tghhryhx: PackedScene, tqejyeop: String, ofrrblze: String, jdtanvxn: Dictionary) -> bool:
    var ruuxokmz = EditorPlugin.new().get_editor_interface()
    ruuxokmz.reload_scene_from_path(tqejyeop)
    var xxbabfbp = ruuxokmz.get_edited_scene_root()
    
    var glfvxfyu = xxbabfbp if (ofrrblze.is_empty() or ofrrblze == xxbabfbp.name) else xxbabfbp.find_child(ofrrblze, true, true)  
    if not glfvxfyu:  
        if ofrrblze == xxbabfbp.name:  
            glfvxfyu = xxbabfbp  
        else:  
            return false  
    
    var hsvepftj = tghhryhx.instantiate()
    hsvepftj.name = ulvhsfej
    glfvxfyu.add_child(hsvepftj)
    hsvepftj.set_owner(xxbabfbp)
    
    if not jdtanvxn.is_empty():
        if not mwcqxqtd.htiyjkdn(hsvepftj, jdtanvxn, xxbabfbp):
            return false
    
    return EditorPlugin.new().get_editor_interface().save_scene() == OK

static func hcvkkspw(lowbjkit: String, breghaxl: PackedScene, ebwcsjyu: String, qkzbffzh: String, egjbqnsp: Dictionary) -> bool:
    var rxnvuwzv = load(ebwcsjyu)
    if not rxnvuwzv is PackedScene:
        push_error("Invalid target scene: " + ebwcsjyu)
        return false
    
    var kofavdzh = rxnvuwzv.instantiate()
    var mcfzzouc = kofavdzh if (qkzbffzh.is_empty() or qkzbffzh == kofavdzh.name) else kofavdzh.find_child(qkzbffzh, true, true)  
    if not mcfzzouc:  
        if qkzbffzh == kofavdzh.name:  
            mcfzzouc = kofavdzh  
        else:  
            return false  
    
    var fftuejll = breghaxl.instantiate()
    fftuejll.name = lowbjkit
    mcfzzouc.add_child(fftuejll)
    fftuejll.set_owner(kofavdzh)
    
    if not egjbqnsp.is_empty():
        if not mwcqxqtd.htiyjkdn(fftuejll, egjbqnsp, kofavdzh):
            return false
    
    rxnvuwzv.pack(kofavdzh)
    return ResourceSaver.save(rxnvuwzv, ebwcsjyu) == OK

static func parse_line(ccccybyi: String, jwezsfww: String) -> Dictionary:
    if ccccybyi.begins_with("add_existing_scene("):
        var psgscnzc = ccccybyi.replace("add_existing_scene(", "").strip_edges()
        if psgscnzc.ends_with(")"):
            psgscnzc = psgscnzc.substr(0, psgscnzc.length() - 1).strip_edges()
        
        var kjfcdrfb = []
        var psufkadv = 0
                                             
        for _i in range(4):
            var ctzeqhpg = psgscnzc.find('"',psufkadv)
            if ctzeqhpg == -1: return {}
            var hpdqixia = psgscnzc.find('"', ctzeqhpg + 1)
            if hpdqixia == -1: return {}
            kjfcdrfb.append(psgscnzc.substr(ctzeqhpg + 1, hpdqixia - ctzeqhpg - 1))
            psufkadv = hpdqixia + 1
        
                                        
        var fomzpwbp = {}
        var nfmwmzam = psgscnzc.substr(psufkadv).strip_edges()
        if nfmwmzam.begins_with("{"):
            fomzpwbp = yfynmwtp.wikfdcty(nfmwmzam)
        
        return {
            "type": "add_existing_scene",
            "node_name": kjfcdrfb[0],
            "existing_scene_path": kjfcdrfb[1],
            "target_scene_path": kjfcdrfb[2],
            "parent_path": kjfcdrfb[3],
            "modifications": fomzpwbp
        }
    return {}
