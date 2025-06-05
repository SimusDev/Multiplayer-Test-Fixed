                                                                     
@tool
extends Node

const vjxuvlhm = preload("action_parser_utils.gd")

static func execute(bprzfqkb: String, ckoegsow: String, wijwnbfo: String, bhxozkik: Dictionary) -> bool:
    var tsbblzzj = EditorPlugin.new().get_editor_interface()
    var gfxsamae = tsbblzzj.get_open_scenes()

                                   
    for scene in gfxsamae:
        if scene == ckoegsow:
                                                                   
            tsbblzzj.reload_scene_from_path(ckoegsow)
            return _add_to_open_scene(bprzfqkb, tsbblzzj.get_edited_scene_root(), wijwnbfo, bhxozkik)

                                           
                                                             
    return _add_to_closed_scene(bprzfqkb, ckoegsow, wijwnbfo, bhxozkik)


static func _add_to_open_scene(tbbusxsg: String, diepvdkl: Node, qqxbvhvb: String, pqcwessp: Dictionary) -> bool:
    var rlwfqsry = ehpfzfoh(tbbusxsg, diepvdkl)
    if not rlwfqsry:
        return false

    var fuuuevwc = zdoxpkxz(qqxbvhvb, pqcwessp)
    if not fuuuevwc:
        return false

                                                                                                 
                                                                                                 
    if not pqcwessp.has("assign_to_property"):
        push_error("No 'assign_to_property' field in pqcwessp dictionary.")
        return false

    var cnjmjwwv = String(pqcwessp["assign_to_property"])
                                             
    if not dlgpgugy(rlwfqsry, cnjmjwwv, fuuuevwc):
        return false

                    
    return EditorInterface.save_scene() == OK

static func _add_to_closed_scene(uxyuyram: String, xgmflbal: String, znyvrpcx: String, rkkulshc: Dictionary) -> bool:
    var kmiceljk = load(xgmflbal)
    if !(kmiceljk is PackedScene):
        push_error("Failed to load scene '%s' as PackedScene." % xgmflbal)
        return false

    var shmsxxfl = kmiceljk.instantiate()
    if not shmsxxfl:
        push_error("Could not instantiate scene '%s'." % xgmflbal)
        return false

    var tbhpbuzs = ehpfzfoh(uxyuyram, shmsxxfl)
    if not tbhpbuzs:
        return false

    var yvjjpoot = zdoxpkxz(znyvrpcx, rkkulshc)
    if not yvjjpoot:
        return false

    if not rkkulshc.has("assign_to_property"):
        push_error("No 'assign_to_property' field in rkkulshc dictionary.")
        return false

    var uobtfgdg = String(rkkulshc["assign_to_property"])
    if not dlgpgugy(tbhpbuzs, uobtfgdg, yvjjpoot):
        return false

                                
    kmiceljk.pack(shmsxxfl)
    return ResourceSaver.save(kmiceljk, xgmflbal) == OK


                                                                             
         
                                                                             
static func ehpfzfoh(pvhkfxjx: String, yxoqmqfk: Node) -> Node:
    var pxlghbhu = yxoqmqfk.find_child(pvhkfxjx, true, true)
    if not pxlghbhu and pvhkfxjx == yxoqmqfk.name:
        pxlghbhu = yxoqmqfk

    if not pxlghbhu:
        push_error("Node '%s' not found in the scene." % pvhkfxjx)
        return null

    return pxlghbhu


static func zdoxpkxz(dklusxvq: String, vrqcaoek: Dictionary) -> Resource:
    if not ClassDB.class_exists(dklusxvq):
        push_error("Resource type '%s' does not exist." % dklusxvq)
        return null

    var oizlzcos = ClassDB.instantiate(dklusxvq)
    if not oizlzcos:
        push_error("Could not instantiate resource of type '%s'." % dklusxvq)
        return null

                                                                  
    for property_name in vrqcaoek.keys():
        if property_name == "assign_to_property":
            continue

        var dkkiifao = vrqcaoek[property_name]
        var trinkoey = _parse_value(dkkiifao)
        if trinkoey == null and dkkiifao != null:
            push_error("Failed to parse value '%s' for property '%s'." % [str(dkkiifao), property_name])
            return null

        if not cgxxpngw(oizlzcos, property_name, trinkoey):
            return null

    return oizlzcos


static func _parse_value(tdjfhhga) -> Variant:
                                                             
    if tdjfhhga is String:
        var xidffccn = tdjfhhga.strip_edges()
                                                 
        if xidffccn.begins_with("(") and xidffccn.ends_with(")"):
            var yrvcmiyo = xidffccn.substr(1, xidffccn.length() - 2)
            var xttkvzrt = yrvcmiyo.split(",", false)
            if xttkvzrt.size() == 2:
                return Vector2(float(xttkvzrt[0].strip_edges()), float(xttkvzrt[1].strip_edges()))
            elif xttkvzrt.size() == 3:
                return Vector3(float(xttkvzrt[0].strip_edges()), float(xttkvzrt[1].strip_edges()), float(xttkvzrt[2].strip_edges()))
            elif xttkvzrt.size() == 4:
                return Vector4(float(xttkvzrt[0].strip_edges()), float(xttkvzrt[1].strip_edges()), float(xttkvzrt[2].strip_edges()), float(xttkvzrt[3].strip_edges()))
        if xidffccn.to_lower() == "true":
            return true
        if xidffccn.to_lower() == "false":
            return false
        if xidffccn.is_valid_float():
            return float(xidffccn)
                                       
        return xidffccn

                                                                  
    return tdjfhhga


static func dlgpgugy(secpvvcm: Node, oqrxvtvu: String, wndklrmk: Variant) -> bool:
    var dehblnfk = secpvvcm.get(oqrxvtvu)
    var vvbukpuw = true
                                                                                          
                                                                                                        
                                         
      
                                                                                                            
                                                                 

                    
    secpvvcm.set(oqrxvtvu, wndklrmk)
                                               
    if secpvvcm.get(oqrxvtvu) != wndklrmk:
        push_error("Failed to set property '%s' on node '%s' value: %s." % [oqrxvtvu, secpvvcm.name, wndklrmk])
        vvbukpuw = false
                          
    return vvbukpuw


static func cgxxpngw(kjkbmwcl: Resource, ggxdvjso: String, vtjediqs: Variant) -> bool:
                                                    
    var nvxfqldj = kjkbmwcl.get_property_list()
    var kmopecoz = null

                                           
    for prop_info in nvxfqldj:
        if prop_info.name == ggxdvjso:
            kmopecoz = prop_info.type
            break

                                              
    if kmopecoz == null:
        push_error("Property '%s' doesn't exist on resource '%s'." % [ggxdvjso, kjkbmwcl.get_class()])
        return true                                                              

                                                                                 
                                         
    if kmopecoz == TYPE_COLOR:
        match typeof(vtjediqs):
            TYPE_VECTOR2:
                                                    
                vtjediqs = Color(vtjediqs.x, vtjediqs.y, 0, 1.0)
            TYPE_VECTOR3:
                                                        
                vtjediqs = Color(vtjediqs.x, vtjediqs.y, vtjediqs.z, 1.0)
            TYPE_VECTOR4:
                                                        
                vtjediqs = Color(vtjediqs.x, vtjediqs.y, vtjediqs.z, vtjediqs.w)
            TYPE_ARRAY:
                                                                                         
                if vtjediqs.size() == 3:
                    vtjediqs = Color(vtjediqs[0], vtjediqs[1], vtjediqs[2], 1.0)
                elif vtjediqs.size() == 4:
                    vtjediqs = Color(vtjediqs[0], vtjediqs[1], vtjediqs[2], vtjediqs[3])
                                                                       
                                           
            
                                                                    
    elif kmopecoz == TYPE_VECTOR3 and typeof(vtjediqs):
        vtjediqs = Vector3(vtjediqs.x, vtjediqs.y, 0)

                    
    kjkbmwcl.set(ggxdvjso, vtjediqs)

                                                   
    var cyqhfnvo = kjkbmwcl.get(ggxdvjso)
    
    var ufrhksln : bool
    
    if typeof(vtjediqs) in [TYPE_VECTOR2, TYPE_VECTOR3, TYPE_VECTOR4]:
        if typeof(cyqhfnvo) == typeof(vtjediqs):
            ufrhksln = cyqhfnvo.is_equal_approx(vtjediqs)
        else:
            push_error("Wrong data type for property %s" % [ggxdvjso])
            ufrhksln = false
    elif typeof(vtjediqs) == TYPE_FLOAT:
                             
                         
        ufrhksln = is_equal_approx(vtjediqs, cyqhfnvo)
    else:
        ufrhksln = cyqhfnvo == vtjediqs

                                                                              
    if typeof(cyqhfnvo) == typeof(vtjediqs) and not ufrhksln:
        push_error("Failed to set resource property '%s' on resource '%s' value: %s " % [ggxdvjso, kjkbmwcl.get_class(), vtjediqs])
        return false

    return true



                                                                             
            
                                                       
                                                               
                                                                             
                           
static func parse_line(kigfunpv: String, jtchwolz: String) -> Dictionary:
    if kigfunpv.begins_with("add_subresource("):
        var renqgvfa = kigfunpv.replace("add_subresource(", "")
        if renqgvfa.ends_with(")"):
            renqgvfa = renqgvfa.substr(0, renqgvfa.length() - 1)
        renqgvfa = renqgvfa.strip_edges()

        var xvjgpzgt = []
        var hkbcmksz = 0
        while true:
            var ieyuljez = renqgvfa.find('"',hkbcmksz)
            if ieyuljez == -1:
                break
            var rkeyzsqy = renqgvfa.find('"', ieyuljez + 1)
            if rkeyzsqy == -1:
                break
            xvjgpzgt.append(renqgvfa.substr(ieyuljez + 1, rkeyzsqy - (ieyuljez + 1)))
            hkbcmksz = rkeyzsqy + 1

        var dofjvuwa = renqgvfa.find("{")
        var pbbbokbl = renqgvfa.rfind("}")
        if dofjvuwa == -1 or pbbbokbl == -1:
            return {}

        var dulhgnys = renqgvfa.substr(dofjvuwa, pbbbokbl - dofjvuwa + 1)
        var vxcpmcwr = vjxuvlhm.wljdwntt(dulhgnys)

                                                                               
                                                                                
                                  
        for key in vxcpmcwr.keys():
            var eqvbwtko = vxcpmcwr[key]
            if eqvbwtko is String:
                var wcrpavkp = eqvbwtko.strip_edges()
                if wcrpavkp.begins_with("\"") and wcrpavkp.ends_with("\"") and wcrpavkp.length() > 1:
                    wcrpavkp = wcrpavkp.substr(1, wcrpavkp.length() - 2)
                vxcpmcwr[key] = wcrpavkp
                                                                               

        if xvjgpzgt.size() < 3:
            return {}

        return {
            "type": "add_subresource",
            "node_name": xvjgpzgt[0],
            "scene_path": xvjgpzgt[1],
            "subresource_type": xvjgpzgt[2],
            "properties": vxcpmcwr
        }

    return {}
