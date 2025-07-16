                                                               
@tool
extends Node

const uedkyhkq = preload("action_parser_utils.gd")

static func execute(tmyzowem: String, sqmcanmy: String, couwjvbu: Dictionary) -> bool:
    var hspnlepb = EditorPlugin.new().get_editor_interface()
    var kfuiwrda = hspnlepb.get_open_scenes()

                                   
    for scene in kfuiwrda:
        if scene == sqmcanmy:
                                                     
            hspnlepb.reload_scene_from_path(sqmcanmy)
                                                             
            return gymgmakx(tmyzowem, hspnlepb.get_edited_scene_root(), couwjvbu)

                                                        
                                               
    return khbtdoja(tmyzowem, sqmcanmy, couwjvbu)


static func gymgmakx(iyrsdbzf: String, vlybfwfz: Node, hcrcjypk: Dictionary) -> bool:
    var ctyrknyc = vlybfwfz.find_child(iyrsdbzf, true, true)
    
    if not ctyrknyc and iyrsdbzf == vlybfwfz.name:
        ctyrknyc = vlybfwfz

    if not ctyrknyc:
        push_error("Node '%s' not found in open scene root '%s'." % [iyrsdbzf, vlybfwfz.name])
        return false

                                                 
    if not htiyjkdn(ctyrknyc, hcrcjypk, vlybfwfz):
        return false
        
                                                    
    return EditorInterface.save_scene() == OK


static func khbtdoja(dyeocimg: String, rpuooepa: String, zertqukq: Dictionary) -> bool:
    var rpvbeqtx = load(rpuooepa)
    if !(rpvbeqtx is PackedScene):
        push_error("Failed to load scene '%s' as PackedScene." % rpuooepa)
        return false

    var gsgkfdsh = rpvbeqtx.instantiate()
    if not gsgkfdsh:
        push_error("Could not instantiate scene '%s'." % rpuooepa)
        return false

    var xtogsfgj = gsgkfdsh.find_child(dyeocimg, true, true)
    
    if not xtogsfgj and dyeocimg == gsgkfdsh.name:
        xtogsfgj = gsgkfdsh

    if not xtogsfgj:
        push_error("Node '%s' not found in scene instance root '%s'." % [dyeocimg, gsgkfdsh.name])
        return false

                                                        
    if not htiyjkdn(xtogsfgj, zertqukq, gsgkfdsh):
        return false

                                
    rpvbeqtx.pack(gsgkfdsh)
    return ResourceSaver.save(rpvbeqtx, rpuooepa) == OK


static func htiyjkdn(lljwigou: Node, pglqawxv: Dictionary, apfvaoix: Node = null) -> bool:
    for property_name in pglqawxv.keys():
        var epoxvkls = pglqawxv[property_name]
        var cuwgnuve = _parse_value(epoxvkls)
        if cuwgnuve == null and epoxvkls != null:
            push_error("Failed to parse value '%s' for property '%s'." % [str(epoxvkls), property_name])
            return false
            
                                     
                                                                                                           
                                                             
        var kkwljoqn = _try_set_property(lljwigou, property_name, cuwgnuve, apfvaoix)
        if not kkwljoqn:
            return false

    return true


static func _parse_value(neqjqlma) -> Variant:
                                                                                            
    if neqjqlma is String:
        var losohdbo = neqjqlma.strip_edges()
        
                                                        
        if losohdbo.length() >= 2 and losohdbo.begins_with('"') and losohdbo.ends_with('"'):
            losohdbo = losohdbo.substr(1, losohdbo.length() - 2)
        elif losohdbo.length() >= 2 and losohdbo.begins_with("'") and losohdbo.ends_with("'"):
            losohdbo = losohdbo.substr(1, losohdbo.length() - 2)
        
        if losohdbo.begins_with("(") and losohdbo.ends_with(")"):
            var cfemysdo = losohdbo.substr(1, losohdbo.length() - 2)
            var vaynjghc = cfemysdo.split(",", false)
                                                  
            if vaynjghc.size() == 2:
                var vddqfzid = float(vaynjghc[0].strip_edges())
                var iedvfzbz = float(vaynjghc[1].strip_edges())
                return Vector2(vddqfzid, iedvfzbz)
                                                  
            if vaynjghc.size() == 3:
                var aloshcla = float(vaynjghc[0].strip_edges())
                var zzieeevt = float(vaynjghc[1].strip_edges())
                var ptowuvql = float(vaynjghc[2].strip_edges())
                return Vector3(aloshcla, zzieeevt, ptowuvql)
                                                  
            if vaynjghc.size() == 4:
                var otmdzeft = float(vaynjghc[0].strip_edges())
                var qvcwhlct = float(vaynjghc[1].strip_edges())
                var jxyfvtdn = float(vaynjghc[2].strip_edges())
                var eilqqriy = float(vaynjghc[3].strip_edges())
                return Vector4(otmdzeft, qvcwhlct, jxyfvtdn, eilqqriy)
                               
        if losohdbo.to_lower() == "true":
            return true
        if losohdbo.to_lower() == "false":
            return false
                                
        if losohdbo.is_valid_float():
            return float(losohdbo)
                                                
        return losohdbo

                                                             
    return neqjqlma

static func vjwbpzcv(sngmlqpl: String, mmeufcwl: String) -> String:
    var nmkhafov = ""
    var ebdxddmu = sngmlqpl.length()
    var wqswdseu = mmeufcwl.length()
    var mtgrpfuh = min(ebdxddmu, wqswdseu)

    for i in range(mtgrpfuh):
        if sngmlqpl[i] != mmeufcwl[i]:
            nmkhafov += "Difference at index: " + str(i) + ", String1: " + sngmlqpl[i] + ", String2: " + mmeufcwl[i]
            break

    return nmkhafov


static func _try_set_property(lgvhdsds: Node, wsdlhbdf: String, mlphidpi: Variant, htejyqeg: Node = null) -> bool:  
                                      
    if wsdlhbdf == "parent":
        if not mlphidpi is String:
            push_error("Parent value must be a string (name of the new parent)")
            return false

        if htejyqeg == null:
            push_error("Cannot re-parent without a valid scene root.")
            return false

        var mkwklfia = mlphidpi.strip_edges()
        var akpgrhai: Node

                                                 
                                                                          
        if mkwklfia == "" or mkwklfia == htejyqeg.name:
            akpgrhai = htejyqeg
        else:
            akpgrhai = htejyqeg.find_child(mkwklfia, true, true)
            if not akpgrhai:
                push_error("Failed to find parent node with name: %s" % mkwklfia)
                return false
        
                   
        if lgvhdsds.get_parent():
            lgvhdsds.get_parent().remove_child(lgvhdsds)
        akpgrhai.add_child(lgvhdsds)

                                                                          
        lgvhdsds.set_owner(htejyqeg)

        return true

                                      
    var rwgxnhrj = lgvhdsds.get_property_list()
    for prop in rwgxnhrj:
        if prop.name == wsdlhbdf:
                        
            if prop.type == TYPE_COLOR:
                match typeof(mlphidpi):
                    TYPE_VECTOR2:
                                                            
                        mlphidpi = Color(mlphidpi.x, mlphidpi.y, 0, 1.0)
                    TYPE_VECTOR3:
                                                                
                        mlphidpi = Color(mlphidpi.x, mlphidpi.y, mlphidpi.z, 1.0)
                    TYPE_VECTOR4:
                        mlphidpi = Color(mlphidpi.x, mlphidpi.y, mlphidpi.z, mlphidpi.w)
                    TYPE_ARRAY:
                                                                                                  
                        if mlphidpi.size() == 3:
                            mlphidpi = Color(mlphidpi[0], mlphidpi[1], mlphidpi[2], 1.0)
                        elif mlphidpi.size() == 4:
                            mlphidpi = Color(mlphidpi[0], mlphidpi[1], mlphidpi[2], mlphidpi[3])

                                                                       
            elif prop.type == TYPE_OBJECT and prop.hint == PROPERTY_HINT_RESOURCE_TYPE:
                var irkgnmsq = prop.hint_string
                
                                           
                if irkgnmsq == "Texture2D" or irkgnmsq.contains("Texture2D"):
                    var sguxxzra = load(mlphidpi)

                                                                                        
                    if "_" in wsdlhbdf:
                        var nvkalydo = wsdlhbdf.split("_")
                        if nvkalydo.size() > 1:
                            var qsruqipt = nvkalydo[1]
                            var addkoeuh = "set_texture_" + qsruqipt
                            if lgvhdsds.has_method(addkoeuh):
                                lgvhdsds.call(addkoeuh, sguxxzra)
                                return true

                                                                           
                    if lgvhdsds.has_method("set_texture"):
                        lgvhdsds.set_texture(sguxxzra)
                        return true
                        
                                             
                elif irkgnmsq == "Mesh" or irkgnmsq.contains("Mesh"):
                    var glzhrpcg = load(mlphidpi)
                    if not glzhrpcg:
                        push_error("Failed to load mesh at path: %s" % mlphidpi)
                        return false
                    
                    if "_" in wsdlhbdf:
                        var nvkalydo = wsdlhbdf.split("_")
                        if nvkalydo.size() > 1:
                            var qsruqipt = nvkalydo[1]
                            var addkoeuh = "set_mesh_" + qsruqipt
                            if lgvhdsds.has_method(addkoeuh):
                                lgvhdsds.call(addkoeuh, glzhrpcg)
                                return true
                    
                    lgvhdsds.set(wsdlhbdf, glzhrpcg)
                    return true
                
                                                
                elif irkgnmsq == "AudioStream" or irkgnmsq.contains("AudioStream"):
                    var qqsrafma = load(mlphidpi)
                    if not qqsrafma:
                        push_error("Failed to load audio stream at path: %s" % mlphidpi)
                        return false
                    lgvhdsds.set(wsdlhbdf, qqsrafma)
                    return true



                                                                 
    if not lgvhdsds.has_method("get") or lgvhdsds.get(wsdlhbdf) == null:
        push_error("Property '%s' doesn't exist on node '%s'." % [wsdlhbdf, lgvhdsds.name])
        return false

                                    
    lgvhdsds.set(wsdlhbdf, mlphidpi)

                                                               
                                                          
    return true


                                                                             
                 
                                                                      
                                                                             
static func parse_line(skrzuchc: String, luoqktkh: String) -> Dictionary:
                                                     
    if skrzuchc.begins_with("edit_node("):
        var qepymjfa = uedkyhkq.uohklyyu(skrzuchc)
                                                            
        if qepymjfa.size() == 0:
            return {}
        if not qepymjfa.has("node_name") \
            or not qepymjfa.has("scene_path") \
            or not qepymjfa.has("modifications"):
            return {}

        return {
            "type": "edit_node",
            "node_name": qepymjfa.node_name,
            "scene_path": qepymjfa.scene_path,
            "modifications": qepymjfa.modifications
        }

    return {}
