                                                            
@tool
extends Node

signal lzbrzabb(action_type: String, path: String, success: bool, button: Button)

                                     
const jsausqjm = preload("res://addons/gamedev_assistant/scripts/actions/action_parser_utils.gd")
const tfvyemyi = preload("res://addons/gamedev_assistant/scripts/actions/create_file_action.gd")
const ybhpddbc = preload("res://addons/gamedev_assistant/scripts/actions/create_scene_action.gd")
const xnxrnnqp = preload("res://addons/gamedev_assistant/scripts/actions/create_node_action.gd")
const tzvowgsw = preload("res://addons/gamedev_assistant/scripts/actions/edit_node_action.gd")
const xwgpedbi = preload("res://addons/gamedev_assistant/scripts/actions/add_subresource_action.gd")
const rffoqxtp = preload("res://addons/gamedev_assistant/scripts/actions/edit_subresource_action.gd")
const njirixqw = preload("res://addons/gamedev_assistant/scripts/actions/assign_script_action.gd")
const nlnxgrqv = preload("res://addons/gamedev_assistant/scripts/actions/add_existing_scene_action.gd")
const wofeomje = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ActionButton.tscn")
const nnzguzyb = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ApplyAllButton.tscn")
const rcsiugnp = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ActionsContainer.tscn")
const isbdevyz = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_Spacing.tscn")

var zfmnjayi: Control
var hbpotyub : VBoxContainer
var rglevqne: Array = []
var yfmmpwgm : Button
var kcjilohr : bool

func _ready():
    
    var vcggcnjp = EditorInterface.get_editor_settings()       
    kcjilohr = vcggcnjp.has_setting("gamedev_assistant/development_mode") and vcggcnjp.get_setting('gamedev_assistant/development_mode') == true    

                                                           
    lzbrzabb.connect(xdzjpxhk)


                            
func qbjvmbra(fwjusspj: String, viajiugi: int) -> Array:
    var sflrxrag = []

    var rjbssfay = "[gds_actions]"
    var vnfdmwcp = "[/gds_actions]"

    var lsbuhlys = fwjusspj.find(rjbssfay)
    var xlyrksiq = fwjusspj.find(vnfdmwcp)

    if lsbuhlys == -1 or xlyrksiq == -1:
        return sflrxrag                                       

                                                                
    var dscvlxqe = lsbuhlys + rjbssfay.length()
    var fgnorzib = xlyrksiq - dscvlxqe
    var nckobufm = fwjusspj.substr(dscvlxqe, fgnorzib).strip_edges()
    
    if kcjilohr:
        print(nckobufm)

                                        
    var yadqzkwp = nckobufm.split("\n")
    for line in yadqzkwp:
        line = line.strip_edges()
        if line == "":
            continue

        var ziahplhh = ggrugmaa(line, fwjusspj)
        if ziahplhh:
            ziahplhh["message_id"] = viajiugi
            sflrxrag.append(ziahplhh)

    return sflrxrag


                    
func zqgwshfx(tfggxdyc: String, pfocwggg: String, izpvqvey: Button) -> bool:
    var xrumwbke = tfvyemyi.execute(tfggxdyc, pfocwggg)
    lzbrzabb.emit("create_file", tfggxdyc, xrumwbke, izpvqvey)
    return xrumwbke


                     
func zzklgmky(vcvuqdeu: String, lmxcmclc: String, bostsqob: String, ujcvnker: Button) -> bool:
    var pvmqjfhy = ybhpddbc.execute(vcvuqdeu, lmxcmclc, bostsqob)
    lzbrzabb.emit("create_scene", vcvuqdeu, pvmqjfhy, ujcvnker)
    return pvmqjfhy


                    
func bmbfisaf(reelnizu: String, kaacucgp: String, fjcnmlnv: String, wajpeqfa: String, hblrcyiu: Dictionary, xljslqhl: Button) -> bool:
    var pjxrgpgh = xnxrnnqp.execute(reelnizu, kaacucgp, fjcnmlnv, wajpeqfa, hblrcyiu)
    lzbrzabb.emit("create_node", fjcnmlnv, pjxrgpgh, xljslqhl)
    return pjxrgpgh
    
                  
func ynzmeflq(iafstjvy: String, bmfubvzw: String, kuehpetr: Dictionary, npooagjf: Button) -> bool:
    var nqbygdxl = tzvowgsw.execute(iafstjvy, bmfubvzw, kuehpetr)
    lzbrzabb.emit("edit_node", bmfubvzw, nqbygdxl, npooagjf)
    return nqbygdxl
    
func odvjoefr(mmslwztc: String, ztjqbljc: String, mehckjce: String, fjugjqga: Dictionary, kgfjkato: Button) -> bool:
    var eewkgtxe = xwgpedbi.execute(mmslwztc, ztjqbljc, mehckjce, fjugjqga)
    lzbrzabb.emit("add_subresource", ztjqbljc, eewkgtxe, kgfjkato)
    return eewkgtxe

                         
func ffmjtnga(frdpgwqw: String, vaohdckc: String, xmwbprpi: String, fibsruom: Dictionary, gukwyamc: Button) -> bool:
    var fwywhxkp = rffoqxtp.execute(frdpgwqw, vaohdckc, xmwbprpi, fibsruom)
                                                                              
    lzbrzabb.emit("edit_subresource", vaohdckc, fwywhxkp, gukwyamc)
    return fwywhxkp

func nofdtzsy(vgwivirl: String, sdldvdea: String, wgbrvomv: String, tykzkboj: Button) -> bool:  
      var iqbdfzfc = njirixqw.execute(vgwivirl, sdldvdea, wgbrvomv)  
      lzbrzabb.emit("assign_script", sdldvdea, iqbdfzfc, tykzkboj)  
      return iqbdfzfc  

                                 
func mczzzfds(unxehtlx: Array, jpxptxrq: Control) -> void:
    
    zfmnjayi = jpxptxrq    
    qqrpuwbw()
    
    hbpotyub = rcsiugnp.instantiate()
    var jceauhqn = isbdevyz.instantiate()
    hbpotyub.add_child(jceauhqn)
    zfmnjayi.add_child(hbpotyub)
    
                                                        
    if unxehtlx.size() > 1:
        yfmmpwgm = nnzguzyb.instantiate()
        yfmmpwgm.text = "Apply All"
        yfmmpwgm.disabled = false
        yfmmpwgm.pressed.connect(knkdspep.bind(rglevqne))
        yfmmpwgm.tooltip_text = "Apply the actions listed below from top to bottom"
        hbpotyub.add_child(yfmmpwgm)

    for action in unxehtlx:
        var zxmwypsz = wofeomje.instantiate()

        var kkmlajot = ""
        var pxssdsjo = []
        
        match action.type:
            "create_file":
                kkmlajot = "Create {path}".format({"path": action.path})
                pxssdsjo.append("Create file")
            "create_scene":
                kkmlajot = "Create {path}".format({
                    "path": action.path,
                })
                pxssdsjo.append("Create scene")
            "create_node":
                var nlqcvyls = action.scene_path.get_file()
                var nhjgmiyt = action.parent_path if action.parent_path != "" else "root"
                kkmlajot = "Create {type} \"{node_name}\"".format({
                    "type": action.node_type,
                    "node_name": action.name
                })
                pxssdsjo.append("Create node")
                pxssdsjo.append("Scene: %s" % nlqcvyls)                
            "edit_node":
                var nlqcvyls = action.scene_path.get_file()
                kkmlajot = "Edit %s" % [action.node_name]
                
                pxssdsjo.append("Edit node")
                pxssdsjo.append("Scene: %s" % nlqcvyls)
            "add_subresource":
                var nlqcvyls = action.scene_path.get_file()
                kkmlajot = "Add %s to %s" % [
                    action.subresource_type,
                    action.node_name
                ]                
                pxssdsjo.append("Add subresource")
                pxssdsjo.append("Scene: %s" % nlqcvyls)
            "edit_subresource":
                var nlqcvyls = action.scene_path.get_file()
                kkmlajot = "Edit %s on %s" % [
                    action.subresource_property_name,                                       
                    action.node_name                                                
                ]
                pxssdsjo.append("Edit subresource")
                pxssdsjo.append("Scene: %s" % nlqcvyls)
                pxssdsjo.append("Property: %s" % action.subresource_property_name)                
            "assign_script":  
                var nlqcvyls = action.scene_path.get_file()  
                var jncewicr = action.script_path.get_file()
                kkmlajot = "Attach %s to %s" % [  
                    jncewicr,  
                    action.node_name  
                ]
                pxssdsjo.append("Attach script")
                pxssdsjo.append("File: %s" % jncewicr)
                pxssdsjo.append("Scene: %s" % nlqcvyls)                
            "add_existing_scene":
                var jpdhfeel = action.existing_scene_path.get_file()
                var juekhtvx = action.target_scene_path.get_file()
                kkmlajot = "Add %s to %s" % [jpdhfeel, juekhtvx]
                
                pxssdsjo.append("Add existing scene")
                pxssdsjo.append("Source: %s" % jpdhfeel)
                pxssdsjo.append("Target: %s" % juekhtvx)           
                                
                              
        if action.has("path"):
            pxssdsjo.append("Path: %s" % action.path)
        
        if action.has("scene_name"):
            pxssdsjo.append("Scene: %s" % action.scene_name)
        
        if action.has("node_type"):
            pxssdsjo.append("Node type: %s" % action.node_type)
        
        if action.has("root_type"):
            pxssdsjo.append("Root type: %s" % action.root_type)
            
        if action.has("subresource_type"):
            pxssdsjo.append("Subresource type: %s" % action.subresource_type)
        
        if action.has("name"):
            pxssdsjo.append("Name: %s" % action.name)
        
        if action.has("node_name"):
            pxssdsjo.append("Node name: %s" % action.node_name)
       
        if action.has("parent_path"):      
            pxssdsjo.append("Parent: %s" % (action.parent_path if action.parent_path else "root"))
            
        if action.has("modifications") or action.has("properties"):
            var cjsnmqcp = action.get("modifications", action.get("properties", {}))
            if cjsnmqcp.size() > 0:
                pxssdsjo.append("\nProperties to apply:")
                for key in cjsnmqcp:
                    pxssdsjo.append("• %s = %s" % [key, str(cjsnmqcp[key])])
                
        zxmwypsz.tooltip_text = "\n".join(pxssdsjo)

        zxmwypsz.text = kkmlajot
        zxmwypsz.set_meta("action", action)
        zxmwypsz.pressed.connect(ypeyrrsa.bind(zxmwypsz))

        hbpotyub.add_child(zxmwypsz)
        rglevqne.append(zxmwypsz)


                          
func qqrpuwbw() -> void:
    if zfmnjayi == null:
        return
        
                                                                     
    if is_instance_valid(hbpotyub) and hbpotyub.is_inside_tree():
                                                                     
        if zfmnjayi.has_node(hbpotyub.get_path()):
                                                                  
            zfmnjayi.remove_child(hbpotyub)
    
                                    
    rglevqne.clear()


                                                  
func ypeyrrsa(kmmtnrrz: Button) -> void:
    var oocnfhqz = kmmtnrrz.get_meta("action") if kmmtnrrz.has_meta("action") else {}

    match oocnfhqz.type:
        "create_file":
            zqgwshfx(oocnfhqz.path, oocnfhqz.content, kmmtnrrz)
        "create_scene":
            zzklgmky(oocnfhqz.path, oocnfhqz.root_name, oocnfhqz.root_type, kmmtnrrz)
        "create_node":
            var damrbyuw = oocnfhqz.modifications if oocnfhqz.has("modifications") else {}
            bmbfisaf(oocnfhqz.name, oocnfhqz.node_type, oocnfhqz.scene_path, oocnfhqz.parent_path, damrbyuw, kmmtnrrz)
        "edit_node":
            ynzmeflq(oocnfhqz.node_name, oocnfhqz.scene_path, oocnfhqz.modifications, kmmtnrrz)
        "add_subresource":
            odvjoefr(
                oocnfhqz.node_name,
                oocnfhqz.scene_path,
                oocnfhqz.subresource_type,
                oocnfhqz.properties,
                kmmtnrrz
            )
        "edit_subresource":
             ffmjtnga(
                oocnfhqz.node_name,
                oocnfhqz.scene_path,
                oocnfhqz.subresource_property_name,
                oocnfhqz.properties,                                                    
                kmmtnrrz
             )
        "assign_script":  
              nofdtzsy(oocnfhqz.node_name, oocnfhqz.scene_path, oocnfhqz.script_path, kmmtnrrz)  
        "add_existing_scene":
            dgzaessl(
                oocnfhqz.node_name,
                oocnfhqz.existing_scene_path,
                oocnfhqz.target_scene_path,
                oocnfhqz.parent_path,
                oocnfhqz.modifications,
                kmmtnrrz
            )
        _:
            push_warning("Unrecognized action type: %s" % oocnfhqz.type)


                                             
func xdzjpxhk(mwdbkdbc: String, bxbhtvik: String, lnkgwskt: bool, gbxwkvvb: Button) -> void:
    if not is_instance_valid(gbxwkvvb):
        return

                                                                         
    var hpcwalrt = gbxwkvvb.text
    var kaizomeu = gbxwkvvb.tooltip_text

    gbxwkvvb.disabled = true
                                                         
    if is_instance_valid(yfmmpwgm):
        yfmmpwgm.disabled = true

    var gcrldwlg = gbxwkvvb.get_meta("action")
    var xlijdstg = gcrldwlg.get("message_id", -1)

    if xlijdstg != -1:
        $"../APIManager".uzwyvavv(xlijdstg, lnkgwskt, mwdbkdbc)

                                                                             
    if mwdbkdbc == gcrldwlg.type:
        var livcnspc = "✓ " if lnkgwskt else "✗ "
        var jttarqur = "\n\nACTION COMPLETED" if lnkgwskt else "\n\nACTION FAILED"                              
        var jgpwuakw = ""                               

                                                                   
                                                                                  
        match mwdbkdbc:
            "create_file":
                jgpwuakw = ("Created file {path}" if lnkgwskt else "Failed: file creation {path}").format({"path": gcrldwlg.path})
            "create_scene":
                jgpwuakw = ("Created scene {path}, root: {root_type}" if lnkgwskt else "Failed: scene creation {path}, root: {root_type}").format({
                    "path": gcrldwlg.path,
                    "root_type": gcrldwlg.root_type
                })
            "create_node":
                var vuuynfyk = gcrldwlg.scene_path.get_file()
                var fqbbismh = gcrldwlg.parent_path if gcrldwlg.parent_path != "" else "root"
                var masaasij = ""
                if gcrldwlg.has("modifications") and gcrldwlg.modifications.size() > 0:
                    masaasij = " with %s props" % gcrldwlg.modifications.size()
                jgpwuakw = ("Created node {name}, type {type}, parent {parent} in scene {scene}{props}" if lnkgwskt
                                else "Failed: creating node {name}, type {type}, parent {parent} in scene {scene}{props}"
                                ).format({
                                    "name": gcrldwlg.name,
                                    "type": gcrldwlg.node_type,
                                    "scene": vuuynfyk,
                                    "parent": fqbbismh,
                                    "props": masaasij
                                })
            "edit_node":
                jgpwuakw = ("Edited node \"%s\" in scene %s" if lnkgwskt
                                else "Failed: editing node \"%s\", scene: %s"
                                ) % [gcrldwlg.node_name, gcrldwlg.scene_path.get_file()]

            "add_subresource":
                var vuuynfyk = gcrldwlg.scene_path.get_file()
                var ahsullzm = str(gcrldwlg.properties.size())
                jgpwuakw = ("Added subresource %s to node %s in scene %s (%s properties)" if lnkgwskt
                                else "Failed: adding subresource %s to node %s, scene: %s (%s properties)"
                                ) % [gcrldwlg.subresource_type, gcrldwlg.node_name, vuuynfyk, ahsullzm]
                                
            "edit_subresource":
                 var vuuynfyk = gcrldwlg.scene_path.get_file()
                 var ahsullzm = str(gcrldwlg.properties.size())
                 jgpwuakw = ("Edited subresource property '%s' on node '%s' in scene %s (%s properties changed)" if lnkgwskt
                                 else "Failed: editing subresource property '%s' on node '%s', scene: %s (%s properties attempted)"
                                 ) % [gcrldwlg.subresource_property_name, gcrldwlg.node_name, vuuynfyk, ahsullzm]

            "assign_script":
                jgpwuakw = ("Assigned script to node \"%s\" in scene %s" if lnkgwskt
                                else "Failed: assigning script to node \"%s\", scene: %s"
                                ) % [gcrldwlg.node_name, gcrldwlg.scene_path.get_file()]

            "add_existing_scene":
                var iogahjro = gcrldwlg.target_scene_path.get_file()
                var vuuynfyk = gcrldwlg.existing_scene_path.get_file()
                var ahsullzm = str(gcrldwlg.modifications.size())
                jgpwuakw = ("Added %s to %s" if lnkgwskt
                              else "Failed: adding %s to %s"
                              ) % [vuuynfyk, iogahjro]
                if gcrldwlg.modifications.size() > 0:
                    jgpwuakw += " (%s props)" % ahsullzm
                                                       

                                                         
        gbxwkvvb.text = livcnspc + hpcwalrt

                                                             
        gbxwkvvb.tooltip_text = kaizomeu + jttarqur

                                               
                                                             
        print('[GameDev Assistant] ' + livcnspc + jgpwuakw) 

        if not lnkgwskt:
            gbxwkvvb.self_modulate = Color(1, 0, 0)                               
        
                              
func ggrugmaa(axhypjhp: String, rmtmyntf: String) -> Dictionary:
    var hccesnyp = [tfvyemyi, ybhpddbc, xnxrnnqp, tzvowgsw, xwgpedbi, rffoqxtp, njirixqw, nlnxgrqv]
    for parser in hccesnyp:
        var hseyemtf = parser.parse_line(axhypjhp, rmtmyntf)
        if not hseyemtf.is_empty():
            return hseyemtf
    return {}
    
func knkdspep(gptnwtuc: Array) -> void:
    yfmmpwgm.disabled = true
    var kzyfejgs = 0
    rovvjyyx(kzyfejgs, gptnwtuc)                    

func rovvjyyx(thvosebb: int, klgleyxs: Array):
    if thvosebb >= klgleyxs.size():
        return                        

    var kjfbvxds = klgleyxs[thvosebb]
    if not is_instance_valid(kjfbvxds):
        thvosebb += 1
        rovvjyyx(thvosebb, klgleyxs)                       
        return

                                                                          
    var cyozvglh = func(_type, _path, _success, btn):
        if btn == kjfbvxds:
            thvosebb += 1                        
            await get_tree().create_timer(0.2).timeout
            rovvjyyx(thvosebb, klgleyxs)

                                      
    lzbrzabb.connect(cyozvglh, CONNECT_ONE_SHOT)
    await get_tree().process_frame                                           
    
                            
    ypeyrrsa(kjfbvxds)

func dgzaessl(qnvonfcn: String, uprrqdsw: String, ojmtypmh: String, olzqijua: String, uelrocxr: Dictionary, ccyuysgg: Button) -> bool:
    var vbjwrtjb = nlnxgrqv.execute(qnvonfcn, uprrqdsw, ojmtypmh, olzqijua, uelrocxr)
    lzbrzabb.emit("add_existing_scene", ojmtypmh, vbjwrtjb, ccyuysgg)
    return vbjwrtjb
