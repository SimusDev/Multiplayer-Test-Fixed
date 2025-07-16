                                                                      
@tool
extends Node

const asgiuzyf = preload("action_parser_utils.gd")
                                                                            
                                                   
const etyevslc = preload("add_subresource_action.gd")

static func execute(yprbnavp: String, xsxzzxwq: String, thpogeww: String, clddnein: Dictionary) -> bool:
    var szccehxs = EditorPlugin.new().get_editor_interface()
    var mgtrszxe = szccehxs.get_open_scenes()

                                   
    for scene in mgtrszxe:
        if scene == xsxzzxwq:
                                                                    
            szccehxs.reload_scene_from_path(xsxzzxwq)
            return _edit_in_open_scene(yprbnavp, szccehxs.get_edited_scene_root(), thpogeww, clddnein)

                                           
                                                              
    return _edit_in_closed_scene(yprbnavp, xsxzzxwq, thpogeww, clddnein)


static func _edit_in_open_scene(adhpmxxw: String, rvueytkd: Node, yvpdqfko: String, gsuqncqs: Dictionary) -> bool:
    var kgkpsctx = etyevslc.obzrbcdu(adhpmxxw, rvueytkd)               
    if not kgkpsctx:
        return false

    var gejcqfkb = kgkpsctx.get(yvpdqfko)
    if not (gejcqfkb is Resource):
        push_error("Property '%s' on node '%s' is not a Resource or doesn't exist." % [yvpdqfko, adhpmxxw])
        return false

    if not ddmrrril(gejcqfkb, gsuqncqs):
        return false

                         
    EditorInterface.edit_resource(gejcqfkb)                                 
    return EditorInterface.save_scene() == OK

static func _edit_in_closed_scene(hhqcxrcg: String, wcbpbzwn: String, ejlkioxz: String, puemldde: Dictionary) -> bool:
    var bwcmefjz = load(wcbpbzwn)
    if !(bwcmefjz is PackedScene):
        push_error("Failed to load scene '%s' as PackedScene." % wcbpbzwn)             
        return false

    var nlwqqlhy = bwcmefjz.instantiate()
    if not nlwqqlhy:
        push_error("Could not instantiate scene '%s'." % wcbpbzwn)             
        return false

    var asvektkd = etyevslc.obzrbcdu(hhqcxrcg, nlwqqlhy)               
    if not asvektkd:
        return false

    var yoooxsxe = asvektkd.get(ejlkioxz)
    if not (yoooxsxe is Resource):
        push_error("Property '%s' on node '%s' is not a Resource or doesn't exist." % [ejlkioxz, hhqcxrcg])
                                                           
        nlwqqlhy.free()
        return false

    if not ddmrrril(yoooxsxe, puemldde):
                                                   
        nlwqqlhy.free()
        return false

                                
                                                                       
                                                                        
                                                                                  
                                                                      
    bwcmefjz.pack(nlwqqlhy)
    var mtjuwwtf = ResourceSaver.save(bwcmefjz, wcbpbzwn)

                                                                
    nlwqqlhy.free()

    return mtjuwwtf == OK


                                                                             
         
                                                                             
static func ddmrrril(fhijwgku: Resource, qpldupot: Dictionary) -> bool:
                                  
    for property_name in qpldupot.keys():
        var xjfsfuob = qpldupot[property_name]
                                                          
        var igypselm = etyevslc._parse_value(xjfsfuob)                         
        if igypselm == null and xjfsfuob != null:
            push_error("Failed to parse value '%s' for property '%s'." % [str(xjfsfuob), property_name])             
                                                                          
            return false

                                                                             
        if not etyevslc.yspztkay(fhijwgku, property_name, igypselm):                                                     
                                                               
            return false

    return true


                                                                             
            
                                                       
                                                                
                                                                                                                     
                                                                             
static func parse_line(osjfzwcy: String, nqmxpaou: String) -> Dictionary:
    if osjfzwcy.begins_with("edit_subresource("):
        var obspfbps = osjfzwcy.replace("edit_subresource(", "")
        if obspfbps.ends_with(")"):
            obspfbps = obspfbps.substr(0, obspfbps.length() - 1)             
        obspfbps = obspfbps.strip_edges()

                                                                                                
        var usbrzpyu = []
        var hkkyjvwe = 0
        var kojfpuqg = 0
        while kojfpuqg < 3:                             
            var jhhzvfmh = obspfbps.find('"',hkkyjvwe)
            if jhhzvfmh == -1:
                break                         
            var neorawna = obspfbps.find('"', jhhzvfmh + 1)
            if neorawna == -1:
                break                       
            usbrzpyu.append(obspfbps.substr(jhhzvfmh + 1, neorawna - (jhhzvfmh + 1)))             
            hkkyjvwe = neorawna + 1
            kojfpuqg += 1
                                                                         
            var vvdhjvuf = obspfbps.find(",", hkkyjvwe)
            if vvdhjvuf != -1:
                hkkyjvwe = vvdhjvuf + 1
            else:
                                                                                                    
                if kojfpuqg < 3: break                                               

        if usbrzpyu.size() < 3:
            push_error("Edit Subresource: Failed to parse required string arguments (node_name, scene_path, subresource_property_name). Line: " + osjfzwcy)
            return {}

                                                                        
        var ewnwsgsl = obspfbps.find("{", hkkyjvwe)                                 
        var sozacaqe = obspfbps.rfind("}")
        if ewnwsgsl == -1 or sozacaqe == -1 or sozacaqe < ewnwsgsl:
            push_error("Edit Subresource: Failed to find or parse properties dictionary. Line: " + osjfzwcy)
            return {}

        var anpwpcut = obspfbps.substr(ewnwsgsl, sozacaqe - ewnwsgsl + 1)             
                                                                           
        var ilgzsmte = asgiuzyf.wikfdcty(anpwpcut)                                 

                                                                           
                                                                                   

        return {
            "type": "edit_subresource",
            "node_name": usbrzpyu[0],
            "scene_path": usbrzpyu[1],
            "subresource_property_name": usbrzpyu[2],
            "properties": ilgzsmte                                         
        }

    return {}
