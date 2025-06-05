                                                                 
@tool
extends Node

const fobjmeca = preload("action_parser_utils.gd")
const hewebawr = preload("edit_node_action.gd")

static func execute(pzatjjfp: String, fxowuhwf: String, txhqnqvq: String, uyxwkgwb: String, lebjjefm: Dictionary = {}) -> bool:
    var cpcjyiqo = EditorPlugin.new().get_editor_interface()
    var qxlvfjoy = cpcjyiqo.get_open_scenes()
    
                                                               
    for scene in qxlvfjoy:  
        if scene == txhqnqvq:  
            print("Adding to open scene: ", scene)  
            cpcjyiqo.reload_scene_from_path(txhqnqvq)
            return nwbyuhyn(pzatjjfp, fxowuhwf, cpcjyiqo.get_edited_scene_root(), uyxwkgwb, lebjjefm)  

                                                                                                       
    print("Adding to closed scene: ", txhqnqvq)  
    return cihuqkhs(pzatjjfp, fxowuhwf, txhqnqvq, uyxwkgwb, lebjjefm)  

static func nwbyuhyn(sqgkshux: String, xgssvbmy: String, vbfvsqbo: Node, mlcuhpkp: String, xsgfbpsk: Dictionary = {}) -> bool:
    if !ClassDB.class_exists(xgssvbmy): 
        push_error("Node %s doesnt exist" % [xgssvbmy])
        return false
    var mskcxsrd = ClassDB.instantiate(xgssvbmy)
    mskcxsrd.name = sqgkshux
    
                                                         
    var gjxucrdt = vbfvsqbo if (mlcuhpkp.is_empty() or mlcuhpkp == vbfvsqbo.name) else vbfvsqbo.find_child(mlcuhpkp, true, true)  
    if not gjxucrdt:  
        if mlcuhpkp == vbfvsqbo.name:  
            gjxucrdt = vbfvsqbo  
        else:  
            return false  
    
    gjxucrdt.add_child(mskcxsrd)    
    mskcxsrd.set_owner(vbfvsqbo)
    
                                
    if not xsgfbpsk.is_empty():
        if not hewebawr.edkidcyn(mskcxsrd, xsgfbpsk, vbfvsqbo):
            return false
    
                                                    
    return EditorInterface.save_scene() == OK

static func cihuqkhs(yxajduor: String, ohqpszko: String, jusxcolm: String, kawodfsi: String, potkajkb: Dictionary = {}) -> bool:
    var fmxjmwfw = load(jusxcolm)
    if !fmxjmwfw is PackedScene: return false
    
    var vdyoprey = fmxjmwfw.instantiate()
    var keoqcxjx = ClassDB.instantiate(ohqpszko)
    keoqcxjx.name = yxajduor
    
                                                         
    var rpionlvy = vdyoprey if (kawodfsi.is_empty() or kawodfsi == vdyoprey.name) else vdyoprey.find_child(kawodfsi, true, true)  
    if not rpionlvy:  
        if kawodfsi == vdyoprey.name:  
            rpionlvy = vdyoprey  
        else:  
            return false  
    
    rpionlvy.add_child(keoqcxjx)
    keoqcxjx.set_owner(vdyoprey)
    
                                
    if not potkajkb.is_empty():
        if not hewebawr.edkidcyn(keoqcxjx, potkajkb, vdyoprey):
            return false
    
                                                          
    fmxjmwfw.pack(vdyoprey)

    return ResourceSaver.save(fmxjmwfw, jusxcolm) == OK

static func parse_line(ykselhov: String, fzbhmsuh: String) -> Dictionary:
    if ykselhov.begins_with("create_node("):
                                                                              
        var kqmtcoay = fobjmeca.ezzqlaxc(ykselhov)
        if kqmtcoay.size() < 3:
            return {}
        
                                                                 
        var xedrrfje = {}
        var rciysiid = ykselhov.find("{")
        var frtepxml = ykselhov.rfind("}")
        
        if rciysiid != -1 and frtepxml != -1:
            var xxgiscpo = ykselhov.substr(rciysiid, frtepxml - rciysiid + 1)
            xedrrfje = fobjmeca.wljdwntt(xxgiscpo)
        
        return {
            "type": "create_node",
            "name": kqmtcoay[0],
            "node_type": kqmtcoay[1],
            "scene_path": kqmtcoay[2],
            "parent_path": kqmtcoay[3] if kqmtcoay.size() > 3 else "",
            "modifications": xedrrfje
        }
    return {}
