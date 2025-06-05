                                                          
@tool
extends RefCounted

const sqkdeeyo = "@OpenScripts"
const rqvifwna = "@SceneTree"
const atjjkryq = "@FileTree"
const uqdzkanq = "@Output"
const pyfabqhx = "@GitDiff"
const kvfpbwrm = "@Docs"
const xzkqonsx = "@ProjectSettings"
const cwiwoncr = 10000
const iiodzbxn = 5000
const itvkijql = 50000

var wlyaszjs = {}                                      
var pgwvmofk = []                                     

                              
func zjulxceo() -> void:
    wlyaszjs.clear()
    pgwvmofk.clear()

func ogqmymeh(hikrvzzn: String, ntkdoazm: EditorInterface) -> String:
                                                         
    if not tpkyelyq(hikrvzzn):
        return hikrvzzn
        
                            
    var diamjfic = hikrvzzn
    
    if sqkdeeyo in hikrvzzn:
                                      
        diamjfic = yryqqkfe(diamjfic, ntkdoazm)
        
    if rqvifwna in hikrvzzn:
                                     
        diamjfic = wxcnmyxj(diamjfic, ntkdoazm)

    if atjjkryq in hikrvzzn:
                                     
        diamjfic = tzjhcems(diamjfic, ntkdoazm)

    if uqdzkanq in hikrvzzn:
                                        
        diamjfic = ccqvfxcu(diamjfic, ntkdoazm)
    
    if pyfabqhx in hikrvzzn:                                                             
        diamjfic = wkhsyojv(diamjfic, ntkdoazm)      
    
    if xzkqonsx in diamjfic:
        diamjfic = vofjbzjw(diamjfic)
    
    return diamjfic

func tpkyelyq(dwewzcvh: String) -> bool:
                                  
    return sqkdeeyo in dwewzcvh or rqvifwna in dwewzcvh or atjjkryq in dwewzcvh or uqdzkanq in dwewzcvh or xzkqonsx in dwewzcvh

func yryqqkfe(dtbwlurl: String, iulybcrw: EditorInterface) -> String:
    var vyumdhmg = dtbwlurl.replace(sqkdeeyo, sqkdeeyo.substr(1)).strip_edges()
    
    var ipppxzia = qunevnhm(iulybcrw)
    pgwvmofk.clear()
    
                         
    var qywvzuxv = "\n[gds_context]\nScripts for context:\n"
    
    for file_path in ipppxzia:
        var zeybykkd = ipppxzia[file_path]
        var gdsxyxpb = zeybykkd.md5_text()
        
        if wlyaszjs.has(file_path):
            if wlyaszjs[file_path] == gdsxyxpb:
                pgwvmofk.append(file_path)
                continue                        
                
                                
        wlyaszjs[file_path] = gdsxyxpb
        
        qywvzuxv += "File: %s\nContent:\n```%s\n```\n" % [file_path, zeybykkd]
    
                               
    if pgwvmofk.size() > 0:
        qywvzuxv += "The following scripts remain the same: %s\n" % [pgwvmofk]
    
                                
    if qywvzuxv.length() > itvkijql:
        qywvzuxv = qywvzuxv.substr(0, itvkijql) + "..."
    
    return vyumdhmg + qywvzuxv + "\n[/gds_context]"

func qunevnhm(jzustags: EditorInterface) -> Dictionary:
    var aqhanyjk = jzustags.get_script_editor()
    var tsmsbjnb: Array = aqhanyjk.get_open_scripts()
    
    var fdzpgcwu: Dictionary = {}
    
    for script in tsmsbjnb:
        var wudmxqgg: String = script.get_source_code()
        var vyzxgfkh: String = script.get_path()
                                            
        fdzpgcwu[vyzxgfkh] = wudmxqgg
        
    return fdzpgcwu

func wxcnmyxj(jhwfgzhg: String, sogichms: EditorInterface) -> String:
                                                                                                                          
    var erynpwjl = jhwfgzhg.replace(rqvifwna, rqvifwna.substr(1)).strip_edges()
    
                               
    var kvczlnft = sogichms.get_edited_scene_root()
    if not kvczlnft:
        return erynpwjl + "\n[gds_context]Node tree: No scene is currently being edited.[/gds_context]"
    
                                
    var macdrhxy = "\n[gds_context]Node tree:\n"
    macdrhxy += rxkighrv(kvczlnft)
    macdrhxy += "--\n"

    if macdrhxy.length() > cwiwoncr:                                                            
        macdrhxy = macdrhxy.substr(0, cwiwoncr) + "..."
        
    macdrhxy += "\n[/gds_context]"
        
    return erynpwjl + macdrhxy

func rxkighrv(qgccnjua: Node, dnugmptx: String = "") -> String:
    var oqgunllo = dnugmptx + "- " + qgccnjua.name
    oqgunllo += " (" + qgccnjua.get_class() + ")"
    
                                                 
    if qgccnjua is Node2D:
        oqgunllo += " position " + str(qgccnjua.position)
    elif qgccnjua is Control:                      
        oqgunllo += " position " + str(qgccnjua.position)
    elif qgccnjua is Node3D:
        oqgunllo += " position " + str(qgccnjua.transform.origin)
    
    
                                                                              
    if qgccnjua.owner and qgccnjua.owner != qgccnjua:
        oqgunllo += " [owner: " + qgccnjua.owner.name + "]"
    
    oqgunllo += "\n"
    var clpiozji = dnugmptx + "  "
    
                                                  
    if qgccnjua is CollisionObject2D or qgccnjua is CollisionObject3D:
        var psiyrzhk = []
        var biaxzcam = []
        
                            
        for i in range(1, 33):                                
            if qgccnjua.get_collision_layer_value(i):
                psiyrzhk.append(str(i))
            if qgccnjua.get_collision_mask_value(i):
                biaxzcam.append(str(i))
        
        if psiyrzhk.size() > 0 or biaxzcam.size() > 0:
            oqgunllo += clpiozji + "Collision: layer: " + ",".join(psiyrzhk)
            oqgunllo += " mask: " + ",".join(biaxzcam) + "\n"
    
                            
    var foegqxjt = []
    for prop in qgccnjua.get_property_list():
        var jkkdizso = prop["name"]
        var mffbgtkh = qgccnjua.get(jkkdizso)
        if mffbgtkh is Resource and mffbgtkh != null:
            var eiyisnvv = mffbgtkh.get_class()
            if mffbgtkh.resource_name != "":
                eiyisnvv = mffbgtkh.resource_name
            foegqxjt.append("%s (%s)" % [jkkdizso, eiyisnvv])
        
    if not foegqxjt.is_empty():
        oqgunllo += clpiozji + "Assigned subresources: " + ", ".join(foegqxjt) + "\n"
    
                                       
    if qgccnjua.get_script():
        oqgunllo += clpiozji + "Script: " + qgccnjua.get_script().resource_path + "\n"
    
                            
    if qgccnjua.unique_name_in_owner:
        oqgunllo += clpiozji + "Unique name: %" + qgccnjua.name + "\n"
    
                
    var mikzxotl = qgccnjua.get_groups()
    if not mikzxotl.is_empty():
                                                              
        mikzxotl = mikzxotl.filter(func(group): return not group.begins_with("_"))
        if not mikzxotl.is_empty():
            oqgunllo += clpiozji + "Groups: " + ", ".join(mikzxotl) + "\n"
    
                                           
    if qgccnjua.scene_file_path:
        oqgunllo += clpiozji + "Instanced from: " + qgccnjua.scene_file_path + "\n"
    
                      
    for child in qgccnjua.get_children():
        oqgunllo += rxkighrv(child, clpiozji)
    return oqgunllo

func tzjhcems(fiyxolru: String, wnpzmamy: EditorInterface) -> String:
                                                                                                                          
    var atsoulwv = fiyxolru.replace(atjjkryq, atjjkryq.substr(1)).strip_edges()

    var lrgxbjtl = wnpzmamy.get_resource_filesystem()
    var sgkgkqqr = "res://"
    
                                
    var uggfmiiy = "\n[gds_context]\nFile Tree:\n"
    uggfmiiy += hekhmvje(lrgxbjtl.get_filesystem_path(sgkgkqqr))
    uggfmiiy += "--\n"
    
    if uggfmiiy.length() > cwiwoncr:                                                            
        uggfmiiy = uggfmiiy.substr(0, cwiwoncr) + "..."
            
    uggfmiiy += "\n[/gds_context]"
    
    return atsoulwv + uggfmiiy

func hekhmvje(kzxfdpgr: EditorFileSystemDirectory, jaxgbopv: String = "") -> String:
    var hlnxhqub = ""
    
                                                          
    var zkpclijk = kzxfdpgr.get_path()
    if zkpclijk == "res://addons/gamedev_assistant/":
                                
        var skzhknpm = EditorInterface.get_editor_settings()
        var yuvqkjys = skzhknpm.has_setting("gamedev_assistant/development_mode") and skzhknpm.get_setting("gamedev_assistant/development_mode") == true
        if not yuvqkjys:
            return jaxgbopv + "+ gamedev_assistant/\n"                                            
    
                                                   
    if kzxfdpgr.get_path() != "res://":
        hlnxhqub += jaxgbopv + "+ " + kzxfdpgr.get_name() + "/\n"
        jaxgbopv += "  "
    
                                      
    for i in kzxfdpgr.get_subdir_count():
        var jskgpozz = kzxfdpgr.get_subdir(i)
        hlnxhqub += hekhmvje(jskgpozz, jaxgbopv)
    
    for i in kzxfdpgr.get_file_count():
        var aboyvpiu = kzxfdpgr.get_file(i)
        hlnxhqub += jaxgbopv + "- " + aboyvpiu + "\n"
    
    return hlnxhqub

func ccqvfxcu(lyycrdap: String, ncrwosob: EditorInterface) -> String:
                                                                                                                          
    var qqrkqlwc = lyycrdap.replace(uqdzkanq, uqdzkanq.substr(1)).strip_edges()

                                                                                                       
    var adyqblan: Node = ncrwosob.get_base_control()
    var tablgake: RichTextLabel = qnergrja(adyqblan)

    if tablgake:
        var ifeiikrw = tablgake.get_parsed_text()
        
        if ifeiikrw.length() > iiodzbxn:                     
                                                                                            
            ifeiikrw = ifeiikrw.substr(-iiodzbxn) + "..."
        
        if ifeiikrw.length() > 0:
            return qqrkqlwc + "\n[gds_context]\nOutput Panel:\n" + ifeiikrw + "\n[/gds_context]"
        else:
            return qqrkqlwc + "\n[gds_context]No contents in the Output Panel.[/gds_context]"
    else:
        print("No RichTextLabel under @EditorLog was found.")
        return qqrkqlwc + "\n--\nOutput Panel: Could not find the label.\n--\n"


func qnergrja(ctmnhhcl: Node) -> RichTextLabel:
                                              
    if ctmnhhcl is RichTextLabel:
        var epxpkaiz: Node = ctmnhhcl.get_parent()
        if epxpkaiz:
            var huoypmdi: Node = epxpkaiz.get_parent()
                                                           
            if huoypmdi and huoypmdi.name.begins_with("@EditorLog"):
                return ctmnhhcl

                              
    for child in ctmnhhcl.get_children():
        var acmlipjc: RichTextLabel = qnergrja(child)
        if acmlipjc:
            return acmlipjc

    return null

func wkhsyojv(zqysypei: String, lnmhtcpb: EditorInterface) -> String:         
                                                                                                                          
    var zclddkjk = zqysypei.replace(pyfabqhx, pyfabqhx.substr(1)).strip_edges()
                                                                                                    
                                                                                                  
    var yqnjzsqq = []                                                                              
    var jupbhult = OS.execute("git", ["diff"], yqnjzsqq, true)                                    
                                                                                                    
    if jupbhult == 0:                                                                            
        var yknykuor = "\n[gds_context]\nGit Diff:\n" + "\n".join(yqnjzsqq) + "\n"  
        
        if yknykuor.length() > cwiwoncr:                                                            
            yknykuor = yknykuor.substr(0, cwiwoncr) + "..."
        
        yknykuor += "[/gds_context]"
        
        return zclddkjk + yknykuor                                                
    else:                                                                                         
        return zclddkjk + "\n--\nGit Diff: Failed to execute git diff command.\n--\n"

func hcinkzbh(cgbgbzyz: String, yorqsryt: EditorInterface) -> String:
                                                                                                                          
    var mxlukkva = cgbgbzyz.replace(kvfpbwrm, kvfpbwrm.substr(1)).strip_edges()
    return mxlukkva

                                             
func vofjbzjw(bxqkauvq: String) -> String:
    var fratsycd = bxqkauvq.replace(xzkqonsx, xzkqonsx.substr(1)).strip_edges()
    
    var sulpvmnv = []
    var bhtyhpjc = ProjectSettings.get_property_list()
    
    for prop in bhtyhpjc:
        var mqajndxa: String = prop["name"]
        var suhtgjdt = ProjectSettings.get(mqajndxa)
        
                                             
        if mqajndxa.begins_with("input/"):
            if suhtgjdt is Dictionary or suhtgjdt is Array:
                sulpvmnv.append("%s = %s" % [mqajndxa, str(suhtgjdt)])
            elif suhtgjdt == null or (suhtgjdt is String and suhtgjdt.is_empty()):
                continue
            else:
                sulpvmnv.append("%s = %s" % [mqajndxa, suhtgjdt])
            continue
        
                                         
        if suhtgjdt is Dictionary or suhtgjdt is Array:
            continue
            
                                                      
        if suhtgjdt == null or (suhtgjdt is String and suhtgjdt.is_empty()):
            continue
            
        sulpvmnv.append("%s = %s" % [mqajndxa, suhtgjdt])
    
    sulpvmnv.sort()
    var ckwbxgml = "Unassigned project settings have been omitted from this list:\n" + "\n".join(sulpvmnv)
    
    fratsycd = fratsycd + "\n" + ckwbxgml
    return fratsycd
