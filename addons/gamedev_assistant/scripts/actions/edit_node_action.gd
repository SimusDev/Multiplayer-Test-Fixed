                                                               
@tool
extends Node

const qenbzsba = preload("action_parser_utils.gd")

static func execute(qxqgpidy: String, plldmbuc: String, ybluryrz: Dictionary) -> bool:
    var bgwmbnaw = EditorPlugin.new().get_editor_interface()
    var yicbptea = bgwmbnaw.get_open_scenes()

                                   
    for scene in yicbptea:
        if scene == plldmbuc:
                                                     
            bgwmbnaw.reload_scene_from_path(plldmbuc)
                                                             
            return gfhnsruu(qxqgpidy, bgwmbnaw.get_edited_scene_root(), ybluryrz)

                                                        
                                               
    return gjadjpuy(qxqgpidy, plldmbuc, ybluryrz)


static func gfhnsruu(euuuzlqq: String, sopkyeqj: Node, xqoohlvl: Dictionary) -> bool:
    var bldkuxug = sopkyeqj.find_child(euuuzlqq, true, true)
    
    if not bldkuxug and euuuzlqq == sopkyeqj.name:
        bldkuxug = sopkyeqj

    if not bldkuxug:
        push_error("Node '%s' not found in open scene root '%s'." % [euuuzlqq, sopkyeqj.name])
        return false

                                                 
    if not edkidcyn(bldkuxug, xqoohlvl, sopkyeqj):
        return false
        
                                                    
    return EditorInterface.save_scene() == OK


static func gjadjpuy(veeipgvj: String, elgsxwsf: String, mimcztrk: Dictionary) -> bool:
    var hbgrypvs = load(elgsxwsf)
    if !(hbgrypvs is PackedScene):
        push_error("Failed to load scene '%s' as PackedScene." % elgsxwsf)
        return false

    var unfpkhwo = hbgrypvs.instantiate()
    if not unfpkhwo:
        push_error("Could not instantiate scene '%s'." % elgsxwsf)
        return false

    var uzlpqrov = unfpkhwo.find_child(veeipgvj, true, true)
    
    if not uzlpqrov and veeipgvj == unfpkhwo.name:
        uzlpqrov = unfpkhwo

    if not uzlpqrov:
        push_error("Node '%s' not found in scene instance root '%s'." % [veeipgvj, unfpkhwo.name])
        return false

                                                        
    if not edkidcyn(uzlpqrov, mimcztrk, unfpkhwo):
        return false

                                
    hbgrypvs.pack(unfpkhwo)
    return ResourceSaver.save(hbgrypvs, elgsxwsf) == OK


static func edkidcyn(httimjcc: Node, xigcdskj: Dictionary, dlesdavs: Node = null) -> bool:
    for property_name in xigcdskj.keys():
        var dqaffsbz = xigcdskj[property_name]
        var dhhetjpo = _parse_value(dqaffsbz)
        if dhhetjpo == null and dqaffsbz != null:
            push_error("Failed to parse value '%s' for property '%s'." % [str(dqaffsbz), property_name])
            return false
            
                                     
                                                                                                           
                                                             
        var pstdcvzc = _try_set_property(httimjcc, property_name, dhhetjpo, dlesdavs)
        if not pstdcvzc:
            return false

    return true


static func _parse_value(zzfqelsh) -> Variant:
                                                                                            
    if zzfqelsh is String:
        var hyhcycre = zzfqelsh.strip_edges()
        
                                                        
        if hyhcycre.length() >= 2 and hyhcycre.begins_with('"') and hyhcycre.ends_with('"'):
            hyhcycre = hyhcycre.substr(1, hyhcycre.length() - 2)
        elif hyhcycre.length() >= 2 and hyhcycre.begins_with("'") and hyhcycre.ends_with("'"):
            hyhcycre = hyhcycre.substr(1, hyhcycre.length() - 2)
        
        if hyhcycre.begins_with("(") and hyhcycre.ends_with(")"):
            var fjjtrekh = hyhcycre.substr(1, hyhcycre.length() - 2)
            var jhoemqyi = fjjtrekh.split(",", false)
                                                  
            if jhoemqyi.size() == 2:
                var cvsbxpxk = float(jhoemqyi[0].strip_edges())
                var oltkujrj = float(jhoemqyi[1].strip_edges())
                return Vector2(cvsbxpxk, oltkujrj)
                                                  
            if jhoemqyi.size() == 3:
                var gbtfdszm = float(jhoemqyi[0].strip_edges())
                var ugcjrwxz = float(jhoemqyi[1].strip_edges())
                var ndctfzxc = float(jhoemqyi[2].strip_edges())
                return Vector3(gbtfdszm, ugcjrwxz, ndctfzxc)
                                                  
            if jhoemqyi.size() == 4:
                var kjteswva = float(jhoemqyi[0].strip_edges())
                var tudoybds = float(jhoemqyi[1].strip_edges())
                var rkgoludv = float(jhoemqyi[2].strip_edges())
                var graiqlll = float(jhoemqyi[3].strip_edges())
                return Vector4(kjteswva, tudoybds, rkgoludv, graiqlll)
                               
        if hyhcycre.to_lower() == "true":
            return true
        if hyhcycre.to_lower() == "false":
            return false
                                
        if hyhcycre.is_valid_float():
            return float(hyhcycre)
                                                
        return hyhcycre

                                                             
    return zzfqelsh

static func eaddiaot(csjhepza: String, vxqzzswy: String) -> String:
    var ihyfnhrt = ""
    var dzgutzsa = csjhepza.length()
    var tslgcgga = vxqzzswy.length()
    var zazbxffb = min(dzgutzsa, tslgcgga)

    for i in range(zazbxffb):
        if csjhepza[i] != vxqzzswy[i]:
            ihyfnhrt += "Difference at index: " + str(i) + ", String1: " + csjhepza[i] + ", String2: " + vxqzzswy[i]
            break

    return ihyfnhrt


static func _try_set_property(zlbfmpto: Node, llidmrmc: String, qcselwsr: Variant, wjqtprxh: Node = null) -> bool:  
                                      
    if llidmrmc == "parent":
        if not qcselwsr is String:
            push_error("Parent value must be a string (name of the new parent)")
            return false

        if wjqtprxh == null:
            push_error("Cannot re-parent without a valid scene root.")
            return false

        var wokjkbiv = qcselwsr.strip_edges()
        var ejkecsnr: Node

                                                 
                                                                          
        if wokjkbiv == "" or wokjkbiv == wjqtprxh.name:
            ejkecsnr = wjqtprxh
        else:
            ejkecsnr = wjqtprxh.find_child(wokjkbiv, true, true)
            if not ejkecsnr:
                push_error("Failed to find parent node with name: %s" % wokjkbiv)
                return false
        
                   
        if zlbfmpto.get_parent():
            zlbfmpto.get_parent().remove_child(zlbfmpto)
        ejkecsnr.add_child(zlbfmpto)

                                                                          
        zlbfmpto.set_owner(wjqtprxh)

        return true

                                      
    var jrhrazxk = zlbfmpto.get_property_list()
    for prop in jrhrazxk:
        if prop.name == llidmrmc:
                        
            if prop.type == TYPE_COLOR:
                match typeof(qcselwsr):
                    TYPE_VECTOR2:
                                                            
                        qcselwsr = Color(qcselwsr.x, qcselwsr.y, 0, 1.0)
                    TYPE_VECTOR3:
                                                                
                        qcselwsr = Color(qcselwsr.x, qcselwsr.y, qcselwsr.z, 1.0)
                    TYPE_VECTOR4:
                        qcselwsr = Color(qcselwsr.x, qcselwsr.y, qcselwsr.z, qcselwsr.w)
                    TYPE_ARRAY:
                                                                                                  
                        if qcselwsr.size() == 3:
                            qcselwsr = Color(qcselwsr[0], qcselwsr[1], qcselwsr[2], 1.0)
                        elif qcselwsr.size() == 4:
                            qcselwsr = Color(qcselwsr[0], qcselwsr[1], qcselwsr[2], qcselwsr[3])

                                                                       
            elif prop.type == TYPE_OBJECT and prop.hint == PROPERTY_HINT_RESOURCE_TYPE:
                var zfyapjrp = prop.hint_string
                
                                           
                if zfyapjrp == "Texture2D" or zfyapjrp.contains("Texture2D"):
                    var trgtbljk = load(qcselwsr)

                                                                                        
                    if "_" in llidmrmc:
                        var zlitjjin = llidmrmc.split("_")
                        if zlitjjin.size() > 1:
                            var sxgnxnww = zlitjjin[1]
                            var medpstwl = "set_texture_" + sxgnxnww
                            if zlbfmpto.has_method(medpstwl):
                                zlbfmpto.call(medpstwl, trgtbljk)
                                return true

                                                                           
                    if zlbfmpto.has_method("set_texture"):
                        zlbfmpto.set_texture(trgtbljk)
                        return true
                        
                                             
                elif zfyapjrp == "Mesh" or zfyapjrp.contains("Mesh"):
                    var medfciqe = load(qcselwsr)
                    if not medfciqe:
                        push_error("Failed to load mesh at path: %s" % qcselwsr)
                        return false
                    
                    if "_" in llidmrmc:
                        var zlitjjin = llidmrmc.split("_")
                        if zlitjjin.size() > 1:
                            var sxgnxnww = zlitjjin[1]
                            var medpstwl = "set_mesh_" + sxgnxnww
                            if zlbfmpto.has_method(medpstwl):
                                zlbfmpto.call(medpstwl, medfciqe)
                                return true
                    
                    zlbfmpto.set(llidmrmc, medfciqe)
                    return true
                
                                                
                elif zfyapjrp == "AudioStream" or zfyapjrp.contains("AudioStream"):
                    var saaeksmz = load(qcselwsr)
                    if not saaeksmz:
                        push_error("Failed to load audio stream at path: %s" % qcselwsr)
                        return false
                    zlbfmpto.set(llidmrmc, saaeksmz)
                    return true



                                                                 
    if not zlbfmpto.has_method("get") or zlbfmpto.get(llidmrmc) == null:
        push_error("Property '%s' doesn't exist on node '%s'." % [llidmrmc, zlbfmpto.name])
        return false

                                    
    zlbfmpto.set(llidmrmc, qcselwsr)

                                                               
                                                          
    return true


                                                                             
                 
                                                                      
                                                                             
static func parse_line(ieimsnbi: String, zerzbtnd: String) -> Dictionary:
                                                     
    if ieimsnbi.begins_with("edit_node("):
        var hzfspcqr = qenbzsba.edbvztjh(ieimsnbi)
                                                            
        if hzfspcqr.size() == 0:
            return {}
        if not hzfspcqr.has("node_name") \
            or not hzfspcqr.has("scene_path") \
            or not hzfspcqr.has("modifications"):
            return {}

        return {
            "type": "edit_node",
            "node_name": hzfspcqr.node_name,
            "scene_path": hzfspcqr.scene_path,
            "modifications": hzfspcqr.modifications
        }

    return {}
