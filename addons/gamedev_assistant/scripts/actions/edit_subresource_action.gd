                                                                      
@tool
extends Node

const nlxbbxbg = preload("action_parser_utils.gd")
                                                                            
                                                   
const cetulygl = preload("add_subresource_action.gd")

static func execute(iiuaaiev: String, pqcogclx: String, bhwlazra: String, fzxiuzcr: Dictionary) -> bool:
    var opkvtqyf = EditorPlugin.new().get_editor_interface()
    var meateftd = opkvtqyf.get_open_scenes()

                                   
    for scene in meateftd:
        if scene == pqcogclx:
                                                                    
            opkvtqyf.reload_scene_from_path(pqcogclx)
            return _edit_in_open_scene(iiuaaiev, opkvtqyf.get_edited_scene_root(), bhwlazra, fzxiuzcr)

                                           
                                                              
    return _edit_in_closed_scene(iiuaaiev, pqcogclx, bhwlazra, fzxiuzcr)


static func _edit_in_open_scene(yqeevubi: String, bbimchxe: Node, cuecgvhs: String, mltiijqc: Dictionary) -> bool:
    var qcqgzkuw = cetulygl.ehpfzfoh(yqeevubi, bbimchxe)               
    if not qcqgzkuw:
        return false

    var gbsknflq = qcqgzkuw.get(cuecgvhs)
    if not (gbsknflq is Resource):
        push_error("Property '%s' on node '%s' is not a Resource or doesn't exist." % [cuecgvhs, yqeevubi])
        return false

    if not gtuidwor(gbsknflq, mltiijqc):
        return false

                         
    EditorInterface.edit_resource(gbsknflq)                                 
    return EditorInterface.save_scene() == OK

static func _edit_in_closed_scene(xnrezoed: String, snemotvo: String, scoyttqa: String, fcgowxsn: Dictionary) -> bool:
    var wmkefdrz = load(snemotvo)
    if !(wmkefdrz is PackedScene):
        push_error("Failed to load scene '%s' as PackedScene." % snemotvo)             
        return false

    var ntitydhh = wmkefdrz.instantiate()
    if not ntitydhh:
        push_error("Could not instantiate scene '%s'." % snemotvo)             
        return false

    var rhasydac = cetulygl.ehpfzfoh(xnrezoed, ntitydhh)               
    if not rhasydac:
        return false

    var esmiqoux = rhasydac.get(scoyttqa)
    if not (esmiqoux is Resource):
        push_error("Property '%s' on node '%s' is not a Resource or doesn't exist." % [scoyttqa, xnrezoed])
                                                           
        ntitydhh.free()
        return false

    if not gtuidwor(esmiqoux, fcgowxsn):
                                                   
        ntitydhh.free()
        return false

                                
                                                                       
                                                                        
                                                                                  
                                                                      
    wmkefdrz.pack(ntitydhh)
    var wbtblton = ResourceSaver.save(wmkefdrz, snemotvo)

                                                                
    ntitydhh.free()

    return wbtblton == OK


                                                                             
         
                                                                             
static func gtuidwor(uamjmwtw: Resource, knhyftgn: Dictionary) -> bool:
                                  
    for property_name in knhyftgn.keys():
        var hhtvsgkb = knhyftgn[property_name]
                                                          
        var voewutiv = cetulygl._parse_value(hhtvsgkb)                         
        if voewutiv == null and hhtvsgkb != null:
            push_error("Failed to parse value '%s' for property '%s'." % [str(hhtvsgkb), property_name])             
                                                                          
            return false

                                                                             
        if not cetulygl.cgxxpngw(uamjmwtw, property_name, voewutiv):                                                     
                                                               
            return false

    return true


                                                                             
            
                                                       
                                                                
                                                                                                                     
                                                                             
static func parse_line(znouxbeb: String, qdugweue: String) -> Dictionary:
    if znouxbeb.begins_with("edit_subresource("):
        var vlcivudo = znouxbeb.replace("edit_subresource(", "")
        if vlcivudo.ends_with(")"):
            vlcivudo = vlcivudo.substr(0, vlcivudo.length() - 1)             
        vlcivudo = vlcivudo.strip_edges()

                                                                                                
        var fcljhops = []
        var mqmsrwvu = 0
        var qzaodjzc = 0
        while qzaodjzc < 3:                             
            var ssyndoye = vlcivudo.find('"',mqmsrwvu)
            if ssyndoye == -1:
                break                         
            var xespjfbo = vlcivudo.find('"', ssyndoye + 1)
            if xespjfbo == -1:
                break                       
            fcljhops.append(vlcivudo.substr(ssyndoye + 1, xespjfbo - (ssyndoye + 1)))             
            mqmsrwvu = xespjfbo + 1
            qzaodjzc += 1
                                                                         
            var okdbcpko = vlcivudo.find(",", mqmsrwvu)
            if okdbcpko != -1:
                mqmsrwvu = okdbcpko + 1
            else:
                                                                                                    
                if qzaodjzc < 3: break                                               

        if fcljhops.size() < 3:
            push_error("Edit Subresource: Failed to parse required string arguments (node_name, scene_path, subresource_property_name). Line: " + znouxbeb)
            return {}

                                                                        
        var ztyzwjuw = vlcivudo.find("{", mqmsrwvu)                                 
        var nmqxnnjh = vlcivudo.rfind("}")
        if ztyzwjuw == -1 or nmqxnnjh == -1 or nmqxnnjh < ztyzwjuw:
            push_error("Edit Subresource: Failed to find or parse properties dictionary. Line: " + znouxbeb)
            return {}

        var mhauimwe = vlcivudo.substr(ztyzwjuw, nmqxnnjh - ztyzwjuw + 1)             
                                                                           
        var wkfrpsmb = nlxbbxbg.wljdwntt(mhauimwe)                                 

                                                                           
                                                                                   

        return {
            "type": "edit_subresource",
            "node_name": fcljhops[0],
            "scene_path": fcljhops[1],
            "subresource_property_name": fcljhops[2],
            "properties": wkfrpsmb                                         
        }

    return {}
