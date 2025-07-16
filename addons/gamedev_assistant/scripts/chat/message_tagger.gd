                                                          
@tool
extends RefCounted

const vqyiotvl = "@OpenScripts"
const vstkbpbx = "@SceneTree"
const jrjohrlg = "@FileTree"
const rhjbwoeg = "@Output"
const xfogqvxc = "@GitDiff"
const eeucvjjx = "@Docs"
const mwycohmf = "@ProjectSettings"
const gjoismyv = 10000
const vkatfvrc = 5000
const euqdgscu = 75000

var dyatapzj = {}                                      
var hiietcir = []                                     

                              
func yhdpphxg() -> void:
    dyatapzj.clear()
    hiietcir.clear()

func xfdwfunp(lfzfcqjx: String, ewckmjqc: EditorInterface) -> String:
                                                         
    if not fdslyiud(lfzfcqjx):
        return lfzfcqjx
        
                            
    var bserhabg = lfzfcqjx
    
    if vqyiotvl in lfzfcqjx:
                                      
        bserhabg = fgcyfmnw(bserhabg, ewckmjqc)
        
    if vstkbpbx in lfzfcqjx:
                                     
        bserhabg = anynpniy(bserhabg, ewckmjqc)

    if jrjohrlg in lfzfcqjx:
                                     
        bserhabg = oxlhfsoz(bserhabg, ewckmjqc)

    if rhjbwoeg in lfzfcqjx:
                                        
        bserhabg = xsdnmdlh(bserhabg, ewckmjqc)
    
    if xfogqvxc in lfzfcqjx:                                                             
        bserhabg = ardgltub(bserhabg, ewckmjqc)      
    
    if mwycohmf in bserhabg:
        bserhabg = gxawvcpo(bserhabg)
    
    return bserhabg

func fdslyiud(wofhfjda: String) -> bool:
                                  
    return vqyiotvl in wofhfjda or vstkbpbx in wofhfjda or jrjohrlg in wofhfjda or rhjbwoeg in wofhfjda or mwycohmf in wofhfjda

func fgcyfmnw(hwwfnmei: String, fkesdske: EditorInterface) -> String:
    var ufrkberp = hwwfnmei.replace(vqyiotvl, vqyiotvl.substr(1)).strip_edges()
    
    var kkovvsew = xinwxcek(fkesdske)
    hiietcir.clear()
    
                         
    var ezeciwca = "\n[gds_context]\nScripts for context:\n"
    
    for file_path in kkovvsew:
        var uieepztm = kkovvsew[file_path]
        var afegzmxu = uieepztm.md5_text()

        if dyatapzj.has(file_path):
            if dyatapzj[file_path] == afegzmxu:
                hiietcir.append(file_path)
                continue                        
                
                                
        dyatapzj[file_path] = afegzmxu
        
        ezeciwca += "File: %s\nContent:\n```%s\n```\n" % [file_path, uieepztm]
    
                               
    if hiietcir.size() > 0:
        ezeciwca += "The following scripts remain the same: %s\n" % [hiietcir]
    
                                
    if ezeciwca.length() > euqdgscu:
        ezeciwca = ezeciwca.substr(0, euqdgscu) + "..."
    
    return ufrkberp + ezeciwca + "\n[/gds_context]"

func xinwxcek(cwhbcnbb: EditorInterface) -> Dictionary:
    var rznallub = cwhbcnbb.get_script_editor()
    var oasicjhn: Array = rznallub.get_open_scripts()
    
    var zbsccqzh: Dictionary = {}
    
    for script in oasicjhn:
        var xbzzsizq: String = script.get_source_code()
        var fubttkbj: String = script.get_path()
                                            
        zbsccqzh[fubttkbj] = xbzzsizq
        
    return zbsccqzh

func anynpniy(bizeqhyo: String, onqfbeum: EditorInterface) -> String:
                                                                                                                          
    var zfolzrag = bizeqhyo.replace(vstkbpbx, vstkbpbx.substr(1)).strip_edges()
    
                               
    var qwinqzbd = onqfbeum.get_edited_scene_root()
    if not qwinqzbd:
        return zfolzrag + "\n[gds_context]Node tree: No scene is currently being edited.[/gds_context]"
    
                                
    var qeaccmeu = "\n[gds_context]Node tree:\n"
    qeaccmeu += qzhlzttk(qwinqzbd)
    qeaccmeu += "--\n"

    if qeaccmeu.length() > gjoismyv:                                                            
        qeaccmeu = qeaccmeu.substr(0, gjoismyv) + "..."
        
    qeaccmeu += "\n[/gds_context]"
        
    return zfolzrag + qeaccmeu

func qzhlzttk(chjlcxow: Node, dwuviuzs: String = "") -> String:
    var iejifdma = dwuviuzs + "- " + chjlcxow.name
    iejifdma += " (" + chjlcxow.get_class() + ")"
    
                                                 
    if chjlcxow is Node2D:
        iejifdma += " position " + str(chjlcxow.position)
    elif chjlcxow is Control:                      
        iejifdma += " position " + str(chjlcxow.position)
    elif chjlcxow is Node3D:
        iejifdma += " position " + str(chjlcxow.transform.origin)
    
    
                                                                              
    if chjlcxow.owner and chjlcxow.owner != chjlcxow:
        iejifdma += " [owner: " + chjlcxow.owner.name + "]"
    
    iejifdma += "\n"
    var nqxanxlc = dwuviuzs + "  "
    
                                                  
    if chjlcxow is CollisionObject2D or chjlcxow is CollisionObject3D:
        var lviaipim = []
        var wpejezdy = []
        
                            
        for i in range(1, 33):                                
            if chjlcxow.get_collision_layer_value(i):
                lviaipim.append(str(i))
            if chjlcxow.get_collision_mask_value(i):
                wpejezdy.append(str(i))
        
        if lviaipim.size() > 0 or wpejezdy.size() > 0:
            iejifdma += nqxanxlc + "Collision: layer: " + ",".join(lviaipim)
            iejifdma += " mask: " + ",".join(wpejezdy) + "\n"
    
                            
    var ztnkdrtj = []
    for prop in chjlcxow.get_property_list():
        var tujnrqgk = prop["name"]
        var njbarxwi = chjlcxow.get(tujnrqgk)
        if njbarxwi is Resource and njbarxwi != null:
            var jzwarnmu = njbarxwi.get_class()
            if njbarxwi.resource_name != "":
                jzwarnmu = njbarxwi.resource_name
            ztnkdrtj.append("%s (%s)" % [tujnrqgk, jzwarnmu])
        
    if not ztnkdrtj.is_empty():
        iejifdma += nqxanxlc + "Assigned subresources: " + ", ".join(ztnkdrtj) + "\n"
    
                                       
    if chjlcxow.get_script():
        iejifdma += nqxanxlc + "Script: " + chjlcxow.get_script().resource_path + "\n"
    
                            
    if chjlcxow.unique_name_in_owner:
        iejifdma += nqxanxlc + "Unique name: %" + chjlcxow.name + "\n"
    
                
    var mvwactfz = chjlcxow.get_groups()
    if not mvwactfz.is_empty():
                                                              
        mvwactfz = mvwactfz.filter(func(group): return not group.begins_with("_"))
        if not mvwactfz.is_empty():
            iejifdma += nqxanxlc + "Groups: " + ", ".join(mvwactfz) + "\n"
    
                                           
    if chjlcxow.scene_file_path:
        iejifdma += nqxanxlc + "Instanced from: " + chjlcxow.scene_file_path + "\n"
    
                      
    for child in chjlcxow.get_children():
        iejifdma += qzhlzttk(child, nqxanxlc)
    return iejifdma

func oxlhfsoz(cpnppiiq: String, zzpwvrhg: EditorInterface) -> String:
                                                                                                                          
    var vqatsalf = cpnppiiq.replace(jrjohrlg, jrjohrlg.substr(1)).strip_edges()

    var evfmmnkp = zzpwvrhg.get_resource_filesystem()
    var gpgbwsye = "res://"
    
                                
    var ucgkojct = "\n[gds_context]\nFile Tree:\n"
    ucgkojct += xshssmvw(evfmmnkp.get_filesystem_path(gpgbwsye))
    ucgkojct += "--\n"
    
    if ucgkojct.length() > gjoismyv:                                                            
        ucgkojct = ucgkojct.substr(0, gjoismyv) + "..."
            
    ucgkojct += "\n[/gds_context]"
    
    return vqatsalf + ucgkojct

func xshssmvw(bjkexbnj: EditorFileSystemDirectory, hpcclgtd: String = "") -> String:
    var adyexzef = ""
    
                                                          
    var ehvjcksr = bjkexbnj.get_path()
    if ehvjcksr == "res://addons/gamedev_assistant/":
                                
        var qgnnfhkk = EditorInterface.get_editor_settings()
        var bhatkqjb = qgnnfhkk.has_setting("gamedev_assistant/development_mode") and qgnnfhkk.get_setting("gamedev_assistant/development_mode") == true
        if not bhatkqjb:
            return hpcclgtd + "+ gamedev_assistant/\n"                                            
    
                                                   
    if bjkexbnj.get_path() != "res://":
        adyexzef += hpcclgtd + "+ " + bjkexbnj.get_name() + "/\n"
        hpcclgtd += "  "
    
                                      
    for i in bjkexbnj.get_subdir_count():
        var onsujyll = bjkexbnj.get_subdir(i)
        adyexzef += xshssmvw(onsujyll, hpcclgtd)
    
    for i in bjkexbnj.get_file_count():
        var psruwcni = bjkexbnj.get_file(i)
        adyexzef += hpcclgtd + "- " + psruwcni + "\n"
    
    return adyexzef

func xsdnmdlh(yowjvejt: String, gwoenaey: EditorInterface) -> String:
                                                                                                                          
    var dwanjvcg = yowjvejt.replace(rhjbwoeg, rhjbwoeg.substr(1)).strip_edges()

                                                                                                       
    var pnzvxzcu: Node = gwoenaey.get_base_control()
    var uznggyie: RichTextLabel = sdnxavqq(pnzvxzcu)

    if uznggyie:
        var rguksswe = uznggyie.get_parsed_text()
        
        if rguksswe.length() > vkatfvrc:                     
                                                                                            
            rguksswe = rguksswe.substr(-vkatfvrc) + "..."
        
        if rguksswe.length() > 0:
            return dwanjvcg + "\n[gds_context]\nOutput Panel:\n" + rguksswe + "\n[/gds_context]"
        else:
            return dwanjvcg + "\n[gds_context]No contents in the Output Panel.[/gds_context]"
    else:
        print("No RichTextLabel under @EditorLog was found.")
        return dwanjvcg + "\n--\nOutput Panel: Could not find the label.\n--\n"


func sdnxavqq(iwibzqdi: Node) -> RichTextLabel:
                                              
    if iwibzqdi is RichTextLabel:
        var lkitlyty: Node = iwibzqdi.get_parent()
        if lkitlyty:
            var xwslxefi: Node = lkitlyty.get_parent()
                                                           
            if xwslxefi and xwslxefi.name.begins_with("@EditorLog"):
                return iwibzqdi

                              
    for child in iwibzqdi.get_children():
        var fydajjgp: RichTextLabel = sdnxavqq(child)
        if fydajjgp:
            return fydajjgp

    return null

func ardgltub(tyyvgldq: String, fozozcuz: EditorInterface) -> String:         
                                                                                                                          
    var qpxdxjuy = tyyvgldq.replace(xfogqvxc, xfogqvxc.substr(1)).strip_edges()
                                                                                                    
                                                                                                  
    var lzhjevej = []                                                                              
    var okgrjuhv = OS.execute("git", ["diff"], lzhjevej, true)                                    
                                                                                                    
    if okgrjuhv == 0:                                                                            
        var alusmdan = "\n[gds_context]\nGit Diff:\n" + "\n".join(lzhjevej) + "\n"  
        
        if alusmdan.length() > gjoismyv:                                                            
            alusmdan = alusmdan.substr(0, gjoismyv) + "..."
        
        alusmdan += "[/gds_context]"
        
        return qpxdxjuy + alusmdan                                                
    else:                                                                                         
        return qpxdxjuy + "\n--\nGit Diff: Failed to execute git diff command.\n--\n"

func yvhzvqtr(kxiudhfv: String, ieonsiam: EditorInterface) -> String:
                                                                                                                          
    var qeptygzy = kxiudhfv.replace(eeucvjjx, eeucvjjx.substr(1)).strip_edges()
    return qeptygzy

                                             
func gxawvcpo(cavolqtv: String) -> String:
    var guytibvc = cavolqtv.replace(mwycohmf, mwycohmf.substr(1)).strip_edges()
    
    var typzoinu = []
    var mcavsnsq = ProjectSettings.get_property_list()
    
    for prop in mcavsnsq:
        var qjtsahqu: String = prop["name"]
        var ddbqrkql = ProjectSettings.get(qjtsahqu)
        
                                             
        if qjtsahqu.begins_with("input/"):
            if ddbqrkql is Dictionary or ddbqrkql is Array:
                typzoinu.append("%s = %s" % [qjtsahqu, str(ddbqrkql)])
            elif ddbqrkql == null or (ddbqrkql is String and ddbqrkql.is_empty()):
                continue
            else:
                typzoinu.append("%s = %s" % [qjtsahqu, ddbqrkql])
            continue
        
                                         
        if ddbqrkql is Dictionary or ddbqrkql is Array:
            continue
            
                                                      
        if ddbqrkql == null or (ddbqrkql is String and ddbqrkql.is_empty()):
            continue
            
        typzoinu.append("%s = %s" % [qjtsahqu, ddbqrkql])
    
    typzoinu.sort()
    var svhidbmt = "Unassigned project settings have been omitted from this list:\n" + "\n".join(typzoinu)
    
    guytibvc = guytibvc + "\n" + svhidbmt
    return guytibvc
