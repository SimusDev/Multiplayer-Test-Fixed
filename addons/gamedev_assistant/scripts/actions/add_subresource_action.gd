                                                                     
@tool
extends Node

const fsizptvh = preload("action_parser_utils.gd")

static func execute(ezykpztm: String, xpociuhp: String, gjukhdmw: String, fioqbunn: Dictionary) -> bool:
    var ygsqvmhd = EditorPlugin.new().get_editor_interface()
    var kdgzyexz = ygsqvmhd.get_open_scenes()

                                   
    for scene in kdgzyexz:
        if scene == xpociuhp:
                                                                   
            ygsqvmhd.reload_scene_from_path(xpociuhp)
            return _add_to_open_scene(ezykpztm, ygsqvmhd.get_edited_scene_root(), gjukhdmw, fioqbunn)

                                           
                                                             
    return _add_to_closed_scene(ezykpztm, xpociuhp, gjukhdmw, fioqbunn)


static func _add_to_open_scene(xlldqhqx: String, arubhxix: Node, nxbpduqn: String, gopfrqlu: Dictionary) -> bool:
    var toqmwxjp = obzrbcdu(xlldqhqx, arubhxix)
    if not toqmwxjp:
        return false

    var segpdhyp = vngpzhdf(nxbpduqn, gopfrqlu)
    if not segpdhyp:
        return false

                                                                                                 
                                                                                                 
    if not gopfrqlu.has("assign_to_property"):
        push_error("No 'assign_to_property' field in gopfrqlu dictionary.")
        return false

    var tmnkzedk = String(gopfrqlu["assign_to_property"])
                                             
    if not vuhkkolu(toqmwxjp, tmnkzedk, segpdhyp):
        return false

                    
    return EditorInterface.save_scene() == OK

static func _add_to_closed_scene(gawuixkr: String, llpmwntj: String, eyxlugre: String, bxtygmmt: Dictionary) -> bool:
    var pglrexuy = load(llpmwntj)
    if !(pglrexuy is PackedScene):
        push_error("Failed to load scene '%s' as PackedScene." % llpmwntj)
        return false

    var yuxneuqv = pglrexuy.instantiate()
    if not yuxneuqv:
        push_error("Could not instantiate scene '%s'." % llpmwntj)
        return false

    var rqjptmps = obzrbcdu(gawuixkr, yuxneuqv)
    if not rqjptmps:
        return false

    var hunrfktz = vngpzhdf(eyxlugre, bxtygmmt)
    if not hunrfktz:
        return false

    if not bxtygmmt.has("assign_to_property"):
        push_error("No 'assign_to_property' field in bxtygmmt dictionary.")
        return false

    var jvhulzof = String(bxtygmmt["assign_to_property"])
    if not vuhkkolu(rqjptmps, jvhulzof, hunrfktz):
        return false

                                
    pglrexuy.pack(yuxneuqv)
    return ResourceSaver.save(pglrexuy, llpmwntj) == OK


                                                                             
         
                                                                             
static func obzrbcdu(lfrrzuss: String, ueomkaqt: Node) -> Node:
    var srkgefvs = ueomkaqt.find_child(lfrrzuss, true, true)
    if not srkgefvs and lfrrzuss == ueomkaqt.name:
        srkgefvs = ueomkaqt

    if not srkgefvs:
        push_error("Node '%s' not found in the scene." % lfrrzuss)
        return null

    return srkgefvs


static func vngpzhdf(ueyumjeu: String, jynqwsur: Dictionary) -> Resource:
    if not ClassDB.class_exists(ueyumjeu):
        push_error("Resource type '%s' does not exist." % ueyumjeu)
        return null

    var lcdhdbnm = ClassDB.instantiate(ueyumjeu)
    if not lcdhdbnm:
        push_error("Could not instantiate resource of type '%s'." % ueyumjeu)
        return null

                                                                  
    for property_name in jynqwsur.keys():
        if property_name == "assign_to_property":
            continue

        var llkkvuyo = jynqwsur[property_name]
        var bdaforla = _parse_value(llkkvuyo)
        if bdaforla == null and llkkvuyo != null:
            push_error("Failed to parse value '%s' for property '%s'." % [str(llkkvuyo), property_name])
            return null

        if not yspztkay(lcdhdbnm, property_name, bdaforla):
            return null

    return lcdhdbnm


static func _parse_value(ksaywopl) -> Variant:
                                                             
    if ksaywopl is String:
        var osxfylac = ksaywopl.strip_edges()
                                                 
        if osxfylac.begins_with("(") and osxfylac.ends_with(")"):
            var jraexvhz = osxfylac.substr(1, osxfylac.length() - 2)
            var vdernyje = jraexvhz.split(",", false)
            if vdernyje.size() == 2:
                return Vector2(float(vdernyje[0].strip_edges()), float(vdernyje[1].strip_edges()))
            elif vdernyje.size() == 3:
                return Vector3(float(vdernyje[0].strip_edges()), float(vdernyje[1].strip_edges()), float(vdernyje[2].strip_edges()))
            elif vdernyje.size() == 4:
                return Vector4(float(vdernyje[0].strip_edges()), float(vdernyje[1].strip_edges()), float(vdernyje[2].strip_edges()), float(vdernyje[3].strip_edges()))
        if osxfylac.to_lower() == "true":
            return true
        if osxfylac.to_lower() == "false":
            return false
        if osxfylac.is_valid_float():
            return float(osxfylac)
                                       
        return osxfylac

                                                                  
    return ksaywopl


static func vuhkkolu(kzcvtaur: Node, kzmhlgmb: String, ffgyydjd: Variant) -> bool:
    var puhxybsr = kzcvtaur.get(kzmhlgmb)
    var ykrjzwmu = true
                                                                                          
                                                                                                        
                                         
      
                                                                                                            
                                                                 

                    
    kzcvtaur.set(kzmhlgmb, ffgyydjd)
                                               
    if kzcvtaur.get(kzmhlgmb) != ffgyydjd:
        push_error("Failed to set property '%s' on node '%s' value: %s." % [kzmhlgmb, kzcvtaur.name, ffgyydjd])
        ykrjzwmu = false
                          
    return ykrjzwmu


static func yspztkay(nmsdrnkq: Resource, dxfntlal: String, qymqaaqy: Variant) -> bool:
                                                    
    var wadhwwcp = nmsdrnkq.get_property_list()
    var yrtznumf = null

                                           
    for prop_info in wadhwwcp:
        if prop_info.name == dxfntlal:
            yrtznumf = prop_info.type
            break

                                              
    if yrtznumf == null:
        push_error("Property '%s' doesn't exist on resource '%s'." % [dxfntlal, nmsdrnkq.get_class()])
        return true                                                              

                                                                                 
                                         
    if yrtznumf == TYPE_COLOR:
        match typeof(qymqaaqy):
            TYPE_VECTOR2:
                                                    
                qymqaaqy = Color(qymqaaqy.x, qymqaaqy.y, 0, 1.0)
            TYPE_VECTOR3:
                                                        
                qymqaaqy = Color(qymqaaqy.x, qymqaaqy.y, qymqaaqy.z, 1.0)
            TYPE_VECTOR4:
                                                        
                qymqaaqy = Color(qymqaaqy.x, qymqaaqy.y, qymqaaqy.z, qymqaaqy.w)
            TYPE_ARRAY:
                                                                                         
                if qymqaaqy.size() == 3:
                    qymqaaqy = Color(qymqaaqy[0], qymqaaqy[1], qymqaaqy[2], 1.0)
                elif qymqaaqy.size() == 4:
                    qymqaaqy = Color(qymqaaqy[0], qymqaaqy[1], qymqaaqy[2], qymqaaqy[3])
                                                                       
                                           
            
                                                                    
    elif yrtznumf == TYPE_VECTOR3 and typeof(qymqaaqy):
        qymqaaqy = Vector3(qymqaaqy.x, qymqaaqy.y, 0)

                    
    nmsdrnkq.set(dxfntlal, qymqaaqy)

                                                   
    var yvojejht = nmsdrnkq.get(dxfntlal)
    
    var tsllaqca : bool
    
    if typeof(qymqaaqy) in [TYPE_VECTOR2, TYPE_VECTOR3, TYPE_VECTOR4]:
        if typeof(yvojejht) == typeof(qymqaaqy):
            tsllaqca = yvojejht.is_equal_approx(qymqaaqy)
        else:
            push_error("Wrong data type for property %s" % [dxfntlal])
            tsllaqca = false
    elif typeof(qymqaaqy) == TYPE_FLOAT:
                             
                         
        tsllaqca = is_equal_approx(qymqaaqy, yvojejht)
    else:
        tsllaqca = yvojejht == qymqaaqy

                                                                              
    if typeof(yvojejht) == typeof(qymqaaqy) and not tsllaqca:
        push_error("Failed to set resource property '%s' on resource '%s' value: %s " % [dxfntlal, nmsdrnkq.get_class(), qymqaaqy])
        return false

    return true



                                                                             
            
                                                       
                                                               
                                                                             
                           
static func parse_line(mtmwegmw: String, zfnndhbz: String) -> Dictionary:
    if mtmwegmw.begins_with("add_subresource("):
        var nqyygupp = mtmwegmw.replace("add_subresource(", "")
        if nqyygupp.ends_with(")"):
            nqyygupp = nqyygupp.substr(0, nqyygupp.length() - 1)
        nqyygupp = nqyygupp.strip_edges()

        var rfmydffy = []
        var uufnrpdj = 0
        while true:
            var mtemibim = nqyygupp.find('"',uufnrpdj)
            if mtemibim == -1:
                break
            var uonmxenx = nqyygupp.find('"', mtemibim + 1)
            if uonmxenx == -1:
                break
            rfmydffy.append(nqyygupp.substr(mtemibim + 1, uonmxenx - (mtemibim + 1)))
            uufnrpdj = uonmxenx + 1

        var goxebolt = nqyygupp.find("{")
        var ermxzype = nqyygupp.rfind("}")
        if goxebolt == -1 or ermxzype == -1:
            return {}

        var rkpkzjut = nqyygupp.substr(goxebolt, ermxzype - goxebolt + 1)
        var lxqnwaab = fsizptvh.wikfdcty(rkpkzjut)

                                                                               
                                                                                
                                  
        for key in lxqnwaab.keys():
            var nxubzhes = lxqnwaab[key]
            if nxubzhes is String:
                var yhrstbol = nxubzhes.strip_edges()
                if yhrstbol.begins_with("\"") and yhrstbol.ends_with("\"") and yhrstbol.length() > 1:
                    yhrstbol = yhrstbol.substr(1, yhrstbol.length() - 2)
                lxqnwaab[key] = yhrstbol
                                                                               

        if rfmydffy.size() < 3:
            return {}

        return {
            "type": "add_subresource",
            "node_name": rfmydffy[0],
            "scene_path": rfmydffy[1],
            "subresource_type": rfmydffy[2],
            "properties": lxqnwaab
        }

    return {}
