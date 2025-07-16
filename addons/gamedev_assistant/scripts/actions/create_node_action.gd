                                                                 
@tool
extends Node

const xzhmrlcu = preload("action_parser_utils.gd")
const wesuqrny = preload("edit_node_action.gd")

static func execute(cctdjrdu: String, dymbobih: String, udkolste: String, auczrzww: String, xuplzhvm: Dictionary = {}) -> bool:
    var gpucfkhe = EditorPlugin.new().get_editor_interface()
    var njkcgkka = gpucfkhe.get_open_scenes()
    
                                                               
    for scene in njkcgkka:  
        if scene == udkolste:  
            print("Adding to open scene: ", scene)  
            gpucfkhe.reload_scene_from_path(udkolste)
            return kplfjnvq(cctdjrdu, dymbobih, gpucfkhe.get_edited_scene_root(), auczrzww, xuplzhvm)  

                                                                                                       
    print("Adding to closed scene: ", udkolste)  
    return sgbztqad(cctdjrdu, dymbobih, udkolste, auczrzww, xuplzhvm)  

static func kplfjnvq(vvcxpkbj: String, xatzmsay: String, efmzdcvy: Node, ljnxanps: String, vzyhuolu: Dictionary = {}) -> bool:
    if !ClassDB.class_exists(xatzmsay): 
        push_error("Node %s doesnt exist" % [xatzmsay])
        return false
    var nmbwnuok = ClassDB.instantiate(xatzmsay)
    nmbwnuok.name = vvcxpkbj
    
                                                         
    var sbvveamc = efmzdcvy if (ljnxanps.is_empty() or ljnxanps == efmzdcvy.name) else efmzdcvy.find_child(ljnxanps, true, true)  
    if not sbvveamc:  
        if ljnxanps == efmzdcvy.name:  
            sbvveamc = efmzdcvy  
        else:  
            return false  
    
    sbvveamc.add_child(nmbwnuok)    
    nmbwnuok.set_owner(efmzdcvy)
    
                                
    if not vzyhuolu.is_empty():
        if not wesuqrny.htiyjkdn(nmbwnuok, vzyhuolu, efmzdcvy):
            return false
    
                                                    
    return EditorInterface.save_scene() == OK

static func sgbztqad(ogbrrtkj: String, jcycacuc: String, uufqyvly: String, ritiosaa: String, ngelzgyp: Dictionary = {}) -> bool:
    var rkxakngr = load(uufqyvly)
    if !rkxakngr is PackedScene: return false
    
    var tulycogm = rkxakngr.instantiate()
    var zwkgenck = ClassDB.instantiate(jcycacuc)
    zwkgenck.name = ogbrrtkj
    
                                                         
    var qahoknsb = tulycogm if (ritiosaa.is_empty() or ritiosaa == tulycogm.name) else tulycogm.find_child(ritiosaa, true, true)  
    if not qahoknsb:  
        if ritiosaa == tulycogm.name:  
            qahoknsb = tulycogm  
        else:  
            return false  
    
    qahoknsb.add_child(zwkgenck)
    zwkgenck.set_owner(tulycogm)
    
                                
    if not ngelzgyp.is_empty():
        if not wesuqrny.htiyjkdn(zwkgenck, ngelzgyp, tulycogm):
            return false
    
                                                          
    rkxakngr.pack(tulycogm)

    return ResourceSaver.save(rkxakngr, uufqyvly) == OK

static func parse_line(kxzizpsr: String, itscmtxo: String) -> Dictionary:
    if kxzizpsr.begins_with("create_node("):
                                                                              
        var zxlpityw = xzhmrlcu.mgzsgqxz(kxzizpsr)
        if zxlpityw.size() < 3:
            return {}
        
                                                                 
        var fsxjfobm = {}
        var urudnmck = kxzizpsr.find("{")
        var wuglsxnc = kxzizpsr.rfind("}")
        
        if urudnmck != -1 and wuglsxnc != -1:
            var zdzxlfbk = kxzizpsr.substr(urudnmck, wuglsxnc - urudnmck + 1)
            fsxjfobm = xzhmrlcu.wikfdcty(zdzxlfbk)
        
        return {
            "type": "create_node",
            "name": zxlpityw[0],
            "node_type": zxlpityw[1],
            "scene_path": zxlpityw[2],
            "parent_path": zxlpityw[3] if zxlpityw.size() > 3 else "",
            "modifications": fsxjfobm
        }
    return {}
