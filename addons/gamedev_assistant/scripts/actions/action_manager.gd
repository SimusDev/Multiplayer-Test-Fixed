                                                                  
@tool
extends Node

signal bunseryn(action_type: String, path: String, success: bool, button: Button)
signal epsfsspq(action_type: String, disable: bool)

                                     
const xklkiixj = preload("res://addons/gamedev_assistant/scripts/actions/action_parser_utils.gd")
const crqrzlhy = preload("res://addons/gamedev_assistant/scripts/actions/create_file_action.gd")
const epvtbnam = preload("res://addons/gamedev_assistant/scripts/actions/create_scene_action.gd")
const ffgwtoog = preload("res://addons/gamedev_assistant/scripts/actions/create_node_action.gd")
const igyfitkh = preload("res://addons/gamedev_assistant/scripts/actions/edit_node_action.gd")
const sbskvyrv = preload("res://addons/gamedev_assistant/scripts/actions/add_subresource_action.gd")
const qwqovoqq = preload("res://addons/gamedev_assistant/scripts/actions/edit_subresource_action.gd")
const rrsatyif = preload("res://addons/gamedev_assistant/scripts/actions/assign_script_action.gd")
const zwykvrog = preload("res://addons/gamedev_assistant/scripts/actions/add_existing_scene_action.gd")
const evmyyicq = preload("res://addons/gamedev_assistant/scripts/actions/edit_script_action.gd")

const rurzkfsx = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ActionButton.tscn")
const znqibkld = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ApplyAllButton.tscn")
const fstohmbt = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ActionsContainer.tscn")
const uzpuzkha = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_Spacing.tscn")

var fmgzbmvo: Control
var fdexgahs : VBoxContainer
var czoguxzg: Array = []
var cbgeomvp : Button
var kyjvryzw : bool
var ephqnmmo : bool

                             
var oeqhahsh: Timer

func _ready():
    
    var uyjciizs = EditorInterface.get_editor_settings()       
    ephqnmmo = uyjciizs.has_setting("gamedev_assistant/development_mode") and uyjciizs.get_setting('gamedev_assistant/development_mode') == true    

                                                           
    bunseryn.connect(mdychrjp)
    epsfsspq.connect(psftrsqx)

                                    
    oeqhahsh = Timer.new()
    oeqhahsh.wait_time = 0.2
    oeqhahsh.one_shot = true
    add_child(oeqhahsh)

                            
func myydjctb(rudfrcxf: String, gmhphmru: int) -> Array:
    var rbcbbdmx = []

    var dvxlswua = "[gds_actions]"
    var nfeuyxvk = "[/gds_actions]"

    var sloxqnpw = rudfrcxf.find(dvxlswua)
    var yzhsdgly = rudfrcxf.find(nfeuyxvk)

    if sloxqnpw == -1 or yzhsdgly == -1:
        return rbcbbdmx                                       

                                                                
    var zgiqcjyr = sloxqnpw + dvxlswua.length()
    var zbxrtnsj = yzhsdgly - zgiqcjyr
    var dtiivfqk = rudfrcxf.substr(zgiqcjyr, zbxrtnsj).strip_edges()
    
    if ephqnmmo:
        print(dtiivfqk)

                                        
    var yckxshsj = dtiivfqk.split("\n")
    for line in yckxshsj:
        line = line.strip_edges()
        if line == "":
            continue

        var bvqysbsf = gnprgksx(line, rudfrcxf)
        if bvqysbsf:
            bvqysbsf["message_id"] = gmhphmru
            rbcbbdmx.append(bvqysbsf)

    return rbcbbdmx


                    
func wtkejpih(ralkpspt: String, eslttjir: String, rcyxziuj: Button) -> bool:
    var dajuhtmn = crqrzlhy.execute(ralkpspt, eslttjir)
    bunseryn.emit("create_file", ralkpspt, dajuhtmn, rcyxziuj)
    return dajuhtmn


                     
func uqdmfwah(pswhwqgn: String, znqrmjgu: String, ksgjnwez: String, xgofckhe: Button) -> bool:
    var fzcnshgb = epvtbnam.execute(pswhwqgn, znqrmjgu, ksgjnwez)
    bunseryn.emit("create_scene", pswhwqgn, fzcnshgb, xgofckhe)
    return fzcnshgb


                    
func jdmryjdq(aimjbvbx: String, upwishwz: String, svvervgf: String, xpwxucjp: String, iastuarj: Dictionary, sryklmxh: Button) -> bool:
    var amxqfsay = ffgwtoog.execute(aimjbvbx, upwishwz, svvervgf, xpwxucjp, iastuarj)
    bunseryn.emit("create_node", svvervgf, amxqfsay, sryklmxh)
    return amxqfsay
    
                  
func jkxgjoza(rgnnrlwh: String, mdaurpzr: String, zgmfqmbc: Dictionary, khevzeei: Button) -> bool:
    var ouywfhzv = igyfitkh.execute(rgnnrlwh, mdaurpzr, zgmfqmbc)
    bunseryn.emit("edit_node", mdaurpzr, ouywfhzv, khevzeei)
    return ouywfhzv
    
func gczultmy(otkezipm: String, kijfuqqz: String, kgkdjyom: String, hsuatyku: Dictionary, hxgngved: Button) -> bool:
    var qwouylrh = sbskvyrv.execute(otkezipm, kijfuqqz, kgkdjyom, hsuatyku)
    bunseryn.emit("add_subresource", kijfuqqz, qwouylrh, hxgngved)
    return qwouylrh

                         
func vzmeiefy(qsebqjzk: String, bytsafdf: String, zuizzwwo: String, kbsryaad: Dictionary, pfdfjokc: Button) -> bool:
    var rtxzfzdm = qwqovoqq.execute(qsebqjzk, bytsafdf, zuizzwwo, kbsryaad)
                                                                              
    bunseryn.emit("edit_subresource", bytsafdf, rtxzfzdm, pfdfjokc)
    return rtxzfzdm

func iaagcvye(rprqaxky: String, mjplhnyg: String, bwcufssx: String, hqoujibr: Button) -> bool:  
      var uzsuzjjp = rrsatyif.execute(rprqaxky, mjplhnyg, bwcufssx)  
      bunseryn.emit("assign_script", mjplhnyg, uzsuzjjp, hqoujibr)  
      return uzsuzjjp  

                                 
func qycsmath(knafuyur: Array, bdiwfzvp: Control) -> void:
    
    fmgzbmvo = bdiwfzvp    
    ykwmhucf()
    
    fdexgahs = fstohmbt.instantiate()
    var dmaioiwz = uzpuzkha.instantiate()
    fdexgahs.add_child(dmaioiwz)
    fmgzbmvo.add_child(fdexgahs)
    
                                                        
    if knafuyur.size() > 1:
        cbgeomvp = znqibkld.instantiate()
        cbgeomvp.text = "Apply All"
        cbgeomvp.disabled = false
        cbgeomvp.pressed.connect(yptzarxw.bind(czoguxzg))
        cbgeomvp.tooltip_text = "Apply the actions listed below from top to bottom"
        fdexgahs.add_child(cbgeomvp)

    for action in knafuyur:
        var uttbujbu = rurzkfsx.instantiate()

        var zdbinpms = ""
        var dmwnmyzz = []
        
        match action.type:
            "create_file":
                zdbinpms = "Create {path}".format({"path": action.path})
                dmwnmyzz.append("Create file")
            "create_scene":
                zdbinpms = "Create {path}".format({
                    "path": action.path,
                })
                dmwnmyzz.append("Create scene")
            "create_node":
                var czggcjgf = action.scene_path.get_file()
                var csstndft = action.parent_path if action.parent_path != "" else "root"
                zdbinpms = "Create {type} \"{node_name}\"".format({
                    "type": action.node_type,
                    "node_name": action.name
                })
                dmwnmyzz.append("Create node")
                dmwnmyzz.append("Scene: %s" % czggcjgf)                
            "edit_node":
                var czggcjgf = action.scene_path.get_file()
                zdbinpms = "Edit %s" % [action.node_name]
                
                dmwnmyzz.append("Edit node")
                dmwnmyzz.append("Scene: %s" % czggcjgf)
            "add_subresource":
                var czggcjgf = action.scene_path.get_file()
                zdbinpms = "Add %s to %s" % [
                    action.subresource_type,
                    action.node_name
                ]                
                dmwnmyzz.append("Add subresource")
                dmwnmyzz.append("Scene: %s" % czggcjgf)
            "edit_subresource":
                var czggcjgf = action.scene_path.get_file()
                zdbinpms = "Edit %s on %s" % [
                    action.subresource_property_name,                                       
                    action.node_name                                                
                ]
                dmwnmyzz.append("Edit subresource")
                dmwnmyzz.append("Scene: %s" % czggcjgf)
                dmwnmyzz.append("Property: %s" % action.subresource_property_name)                
            "assign_script":  
                var czggcjgf = action.scene_path.get_file()  
                var oradnzhs = action.script_path.get_file()
                zdbinpms = "Attach %s to %s" % [  
                    oradnzhs,  
                    action.node_name  
                ]
                dmwnmyzz.append("Attach script")
                dmwnmyzz.append("File: %s" % oradnzhs)
                dmwnmyzz.append("Scene: %s" % czggcjgf)                
            "add_existing_scene":
                var usgxvqoz = action.existing_scene_path.get_file()
                var zshukgln = action.target_scene_path.get_file()
                zdbinpms = "Add %s to %s" % [usgxvqoz, zshukgln]
                
                dmwnmyzz.append("Add existing scene")
                dmwnmyzz.append("Source: %s" % usgxvqoz)
                dmwnmyzz.append("Target: %s" % zshukgln)  
            "edit_script":
                zdbinpms = "Edit {path}".format({"path": action.path})
                dmwnmyzz.append("Edit script")
                dmwnmyzz.append("Path: %s" % action.path)
                                
                              
        if action.has("path"):
            dmwnmyzz.append("Path: %s" % action.path)
        
        if action.has("scene_name"):
            dmwnmyzz.append("Scene: %s" % action.scene_name)
        
        if action.has("node_type"):
            dmwnmyzz.append("Node type: %s" % action.node_type)
        
        if action.has("root_type"):
            dmwnmyzz.append("Root type: %s" % action.root_type)
            
        if action.has("subresource_type"):
            dmwnmyzz.append("Subresource type: %s" % action.subresource_type)
        
        if action.has("name"):
            dmwnmyzz.append("Name: %s" % action.name)
        
        if action.has("node_name"):
            dmwnmyzz.append("Node name: %s" % action.node_name)
       
        if action.has("parent_path"):      
            dmwnmyzz.append("Parent: %s" % (action.parent_path if action.parent_path else "root"))
            
        if action.has("modifications") or action.has("properties"):
            var aqruxlnf = action.get("modifications", action.get("properties", {}))
            if aqruxlnf.size() > 0:
                dmwnmyzz.append("\nProperties to apply:")
                for key in aqruxlnf:
                    dmwnmyzz.append("• %s = %s" % [key, str(aqruxlnf[key])])
                
        uttbujbu.tooltip_text = "\n".join(dmwnmyzz)

        uttbujbu.text = zdbinpms
        uttbujbu.set_meta("action", action)
        uttbujbu.pressed.connect(getarcfz.bind(uttbujbu))

        fdexgahs.add_child(uttbujbu)
        czoguxzg.append(uttbujbu)


                          
func ykwmhucf() -> void:
    if fmgzbmvo == null:
        return
        
                                                                     
    if is_instance_valid(fdexgahs) and fdexgahs.is_inside_tree():
                                                                     
        if fmgzbmvo.has_node(fdexgahs.get_path()):
                                                                  
            fmgzbmvo.remove_child(fdexgahs)
    
                                    
    czoguxzg.clear()

                                                  
func getarcfz(jmqgjkes: Button) -> void:
        kyjvryzw = false
        edazokwu(jmqgjkes)

                                                  
func edazokwu(skrrpcxb: Button) -> void:
    var vhzngxbi = skrrpcxb.get_meta("action") if skrrpcxb.has_meta("action") else {}
    
    skrrpcxb.disabled = true

    match vhzngxbi.type:
        "create_file":
            wtkejpih(vhzngxbi.path, vhzngxbi.content, skrrpcxb)
        "create_scene":
            uqdmfwah(vhzngxbi.path, vhzngxbi.root_name, vhzngxbi.root_type, skrrpcxb)
        "create_node":
            var txortzdc = vhzngxbi.modifications if vhzngxbi.has("modifications") else {}
            jdmryjdq(vhzngxbi.name, vhzngxbi.node_type, vhzngxbi.scene_path, vhzngxbi.parent_path, txortzdc, skrrpcxb)
        "edit_node":
            jkxgjoza(vhzngxbi.node_name, vhzngxbi.scene_path, vhzngxbi.modifications, skrrpcxb)
        "add_subresource":
            gczultmy(
                vhzngxbi.node_name,
                vhzngxbi.scene_path,
                vhzngxbi.subresource_type,
                vhzngxbi.properties,
                skrrpcxb
            )
        "edit_subresource":
             vzmeiefy(
                vhzngxbi.node_name,
                vhzngxbi.scene_path,
                vhzngxbi.subresource_property_name,
                vhzngxbi.properties,                                                    
                skrrpcxb
             )
        "assign_script":  
              iaagcvye(vhzngxbi.node_name, vhzngxbi.scene_path, vhzngxbi.script_path, skrrpcxb)  
        "add_existing_scene":
            ktxwombg(
                vhzngxbi.node_name,
                vhzngxbi.existing_scene_path,
                vhzngxbi.target_scene_path,
                vhzngxbi.parent_path,
                vhzngxbi.modifications,
                skrrpcxb
            )
        "edit_script":
            scujckjt(vhzngxbi.path, vhzngxbi.message_id, skrrpcxb)
        _:
            push_warning("Unrecognized action type: %s" % vhzngxbi.type)


                                             
func mdychrjp(wvzeybwz: String, iocproxq: String, kircbbcd: bool, vbpyxnkk: Button) -> void:
    if not is_instance_valid(vbpyxnkk):
        return

                                                                         
    var alzvgflx = vbpyxnkk.text
    var chiqoasn = vbpyxnkk.tooltip_text
    
                                                         
    if is_instance_valid(cbgeomvp):
        cbgeomvp.disabled = true

    var sivnyyav = vbpyxnkk.get_meta("action")
    var omctclnz = sivnyyav.get("message_id", -1)

    if omctclnz != -1:
        $"../APIManager".mbqadahd(omctclnz, kircbbcd, wvzeybwz)

                                                                             
    if wvzeybwz == sivnyyav.type:
        var jbtyfoms = "✓ " if kircbbcd else "✗ "
        var zkwjuaep = "\n\nACTION COMPLETED" if kircbbcd else "\n\nACTION FAILED:\nCheck Output panel for error message.\nClick to retry."
        var tlucvsfj = ""                               

                                                                   
        match wvzeybwz:
            "create_file":
                tlucvsfj = ("Created file {path}" if kircbbcd else "Failed: file creation {path}").format({"path": sivnyyav.path})
            "create_scene":
                tlucvsfj = ("Created scene {path}, root: {root_type}" if kircbbcd else "Failed: scene creation {path}, root: {root_type}").format({
                    "path": sivnyyav.path,
                    "root_type": sivnyyav.root_type
                })
            "create_node":
                var mattswfe = sivnyyav.scene_path.get_file()
                var pjccggve = sivnyyav.parent_path if sivnyyav.parent_path != "" else "root"
                var ldeklrnf = ""
                if sivnyyav.has("modifications") and sivnyyav.modifications.size() > 0:
                    ldeklrnf = " with %s props" % sivnyyav.modifications.size()
                tlucvsfj = ("Created node {name}, type {type}, parent {parent} in scene {scene}{props}" if kircbbcd
                                else "Failed: creating node {name}, type {type}, parent {parent} in scene {scene}{props}"
                                ).format({
                                    "name": sivnyyav.name,
                                    "type": sivnyyav.node_type,
                                    "scene": mattswfe,
                                    "parent": pjccggve,
                                    "props": ldeklrnf
                                })
            "edit_node":
                tlucvsfj = ("Edited node \"%s\" in scene %s" if kircbbcd
                                else "Failed: editing node \"%s\", scene: %s"
                                ) % [sivnyyav.node_name, sivnyyav.scene_path.get_file()]

            "add_subresource":
                var mattswfe = sivnyyav.scene_path.get_file()
                var awnapgmp = str(sivnyyav.properties.size())
                tlucvsfj = ("Added subresource %s to node %s in scene %s (%s properties)" if kircbbcd
                                else "Failed: adding subresource %s to node %s, scene: %s (%s properties)"
                                ) % [sivnyyav.subresource_type, sivnyyav.node_name, mattswfe, awnapgmp]
                                
            "edit_subresource":
                 var mattswfe = sivnyyav.scene_path.get_file()
                 var awnapgmp = str(sivnyyav.properties.size())
                 tlucvsfj = ("Edited subresource property '%s' on node '%s' in scene %s (%s properties changed)" if kircbbcd
                                 else "Failed: editing subresource property '%s' on node '%s', scene: %s (%s properties attempted)"
                                 ) % [sivnyyav.subresource_property_name, sivnyyav.node_name, mattswfe, awnapgmp]

            "assign_script":
                tlucvsfj = ("Assigned script to node \"%s\" in scene %s" if kircbbcd
                                else "Failed: assigning script to node \"%s\", scene: %s"
                                ) % [sivnyyav.node_name, sivnyyav.scene_path.get_file()]

            "add_existing_scene":
                var knogifog = sivnyyav.target_scene_path.get_file()
                var mattswfe = sivnyyav.existing_scene_path.get_file()
                var awnapgmp = str(sivnyyav.modifications.size())
                tlucvsfj = ("Added %s to %s" if kircbbcd
                              else "Failed: adding %s to %s"
                              ) % [mattswfe, knogifog]
                if sivnyyav.modifications.size() > 0:
                    tlucvsfj += " (%s props)" % awnapgmp
            "edit_script":
                tlucvsfj = ("Edited script %s" if kircbbcd
                                else "Failed: editing script %s"
                                ) % [iocproxq]

                                                         
        vbpyxnkk.text = jbtyfoms + alzvgflx

                                                             
        vbpyxnkk.tooltip_text = chiqoasn + zkwjuaep

                                               
                                                             
        print('[GameDev Assistant] ' + jbtyfoms + tlucvsfj) 

        if not kircbbcd:
            vbpyxnkk.self_modulate = Color(1, 0, 0)                               
            
                                  
        vbpyxnkk.set_meta("completed", true)
        
                               
        if wvzeybwz == "edit_script":
            psftrsqx(wvzeybwz, false)
            
                                          
        if kircbbcd:
            vbpyxnkk.disabled = true
        
                              
func gnprgksx(nhxohfhk: String, gdpnkmqk: String) -> Dictionary:
    var utywifwk = [crqrzlhy, epvtbnam, ffgwtoog, igyfitkh, sbskvyrv, qwqovoqq, rrsatyif, zwykvrog, evmyyicq]
    for parser in utywifwk:
        var jsrqitjd = parser.parse_line(nhxohfhk, gdpnkmqk)
        if not jsrqitjd.is_empty():
            return jsrqitjd
    return {}
    
func yptzarxw(nttlpahd: Array) -> void:
    kyjvryzw = true
    cbgeomvp.disabled = true
    var jhakpygh = 0
    
                                       
    for button in czoguxzg:
        button.disabled = true
    
    nduvopxl(jhakpygh, nttlpahd)                    

func nduvopxl(jnsdaycx: int, czgvfuzw: Array):
    if jnsdaycx >= czgvfuzw.size():
        return                        

    var nbnjgukw = czgvfuzw[jnsdaycx]
    if not is_instance_valid(nbnjgukw):
        jnsdaycx += 1
        nduvopxl(jnsdaycx, czgvfuzw)                       
        return

                                                                          
    var tmoifkpr = func(_type, _path, _success, btn):
        if btn == nbnjgukw:
            jnsdaycx += 1                        
            oeqhahsh.start()
            await oeqhahsh.timeout
            nduvopxl(jnsdaycx, czgvfuzw)

                                      
    bunseryn.connect(tmoifkpr, CONNECT_ONE_SHOT)
    await get_tree().process_frame                                           
    
                            
    edazokwu(nbnjgukw)

func ktxwombg(snlbxkje: String, eeqidfwf: String, dsisgihh: String, oywsnuyl: String, qjvvdjhv: Dictionary, vaplimfp: Button) -> bool:
    var mvtlhfwh = zwykvrog.execute(snlbxkje, eeqidfwf, dsisgihh, oywsnuyl, qjvvdjhv)
    bunseryn.emit("add_existing_scene", dsisgihh, mvtlhfwh, vaplimfp)
    return mvtlhfwh
    
func scujckjt(edaetwjh: String, olzbxooz: int, eubceqkd: Button) -> bool:
    var fnaysgyv = $"../APIManager"
    var vzfuduxw = evmyyicq.execute(edaetwjh, olzbxooz, eubceqkd, fnaysgyv)
    return vzfuduxw
    
func psftrsqx(sfteqadi: String, hzswzokj: bool) -> void:

    if kyjvryzw:
        return
    
    for button in czoguxzg:
        var knafjzpo = button.get_meta("action") if button.has_meta("action") else {}
        if knafjzpo.get("type", "") == sfteqadi:
                                                
            if not button.get_meta("completed", false):
                button.disabled = hzswzokj
