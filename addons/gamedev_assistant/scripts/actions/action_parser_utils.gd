                                                                  
@tool
extends Node

static func arsaclkr(ndkziugr: String) -> String:
    var wtbrphlx = ndkziugr.find('"')
    if wtbrphlx == -1:
        return ""
    var abdwletf = ndkziugr.find('"', wtbrphlx + 1)
    if abdwletf == -1:
        return ""
    return ndkziugr.substr(wtbrphlx + 1, abdwletf - (wtbrphlx + 1))


static func fgakxepz(kxlqnqlj: String, ejhmsqsn: String) -> String:
    var kajmpjhj = RegEx.new()
    kajmpjhj.compile("```.*\\n# New file: " + kxlqnqlj + "\\n([\\s\\S]*?)```")
    var ywhniits = kajmpjhj.search(ejhmsqsn)
    return ywhniits.get_string(1).strip_edges() if ywhniits else ""


static func yoxlteic(uhgtwziu: String) -> Array:
    var wguijeyo = uhgtwziu.replace("create_scene(", "").replace(")", "").strip_edges()
    var itkijlgo = []
    var dueeiegs = 0
    while true:
        var gyhmuflm = wguijeyo.find('"',dueeiegs)
        if gyhmuflm == -1:
            break
        var epzjpcsc = wguijeyo.find('"', gyhmuflm + 1)
        if epzjpcsc == -1:
            break
        itkijlgo.append(wguijeyo.substr(gyhmuflm + 1, epzjpcsc - gyhmuflm - 1))
        dueeiegs = epzjpcsc + 1
    return itkijlgo


                                                     
static func ezzqlaxc(dgpvxuyl: String) -> Array:
    var vbftqgwz = dgpvxuyl.replace("create_node(", "")
    
                                                                                                    
    var ropkibvs = vbftqgwz.rfind(")")
    if ropkibvs != -1:
        vbftqgwz = vbftqgwz.substr(0, ropkibvs)
    
    vbftqgwz = vbftqgwz.strip_edges()
    
                                                   
    var zbbqnrqz = vbftqgwz.find("{")
    if zbbqnrqz != -1:
        vbftqgwz = vbftqgwz.substr(0, zbbqnrqz).strip_edges()
    
    var ukhouaev = []
    var asfrmyfd = 0
    while true:
        var yepzgtwr = vbftqgwz.find('"',asfrmyfd)
        if yepzgtwr == -1:
            break
        var fbknwtyc = vbftqgwz.find('"', yepzgtwr + 1)
        if fbknwtyc == -1:
            break
        ukhouaev.append(vbftqgwz.substr(yepzgtwr + 1, fbknwtyc - yepzgtwr - 1))
        asfrmyfd = fbknwtyc + 1
    return ukhouaev


                                                                             
                   
                                                                             
static func edbvztjh(nwbfpipv: String) -> Dictionary:
                                 
    var datgdaee = nwbfpipv.replace("edit_node(", "")

                                    
    if datgdaee.ends_with(")"):
        datgdaee = datgdaee.substr(0, datgdaee.length() - 1)

                     
    datgdaee = datgdaee.strip_edges()

                                                                  
    var axistxvz = []
    var sxlfrrye = 0
    while true:
        var ghvilzyt = datgdaee.find('"',sxlfrrye)
        if ghvilzyt == -1:
            break
        var bakonneh = datgdaee.find('"', ghvilzyt + 1)
        if bakonneh == -1:
            break

        axistxvz.append(datgdaee.substr(ghvilzyt + 1, bakonneh - ghvilzyt - 1))
        sxlfrrye = bakonneh + 1

                              
    var mideoxja = datgdaee.find("{")
    var tamiqbqu = datgdaee.rfind("}")
    if mideoxja == -1 or tamiqbqu == -1:
                                           
        return {}

    var yfinickc = datgdaee.substr(mideoxja, tamiqbqu - mideoxja + 1)

                                             
    var ashdyliz = ""
    if axistxvz.size() > 0:
        ashdyliz = axistxvz[0]

    var voeexbie = ""
    if axistxvz.size() > 1:
        voeexbie = axistxvz[1]

    return {
        "node_name": ashdyliz,
        "scene_path": voeexbie,
        "modifications": wljdwntt(yfinickc)
    }


static func wljdwntt(ltzrehsc: String) -> Dictionary:
                                                          
    var stuziguh = ltzrehsc.strip_edges()

                                    
    if stuziguh.begins_with("{"):
        stuziguh = stuziguh.substr(1, stuziguh.length() - 1)
                                     
    if stuziguh.ends_with("}"):
        stuziguh = stuziguh.substr(0, stuziguh.length() - 1)

                                      
    stuziguh = stuziguh.strip_edges()

                                                              
    var dwvlwowx = []
    var ngqkrigw = ""
    var karhitum = 0

    for i in range(stuziguh.length()):
        var rcwkryjx = stuziguh[i]
        if rcwkryjx == "(":
            karhitum += 1
        elif rcwkryjx == ")":
            karhitum -= 1

        if rcwkryjx == "," and karhitum == 0:
            dwvlwowx.append(ngqkrigw.strip_edges())
            ngqkrigw = ""
        else:
            ngqkrigw += rcwkryjx

    if ngqkrigw != "":
        dwvlwowx.append(ngqkrigw.strip_edges())

                                 
    var hskniozs = {}
    for entry in dwvlwowx:
        var kmptkoqx = entry.find(":")
        if kmptkoqx == -1:
            continue

        var rmfknnfz = entry.substr(0, kmptkoqx).strip_edges()
        var yxltosrv = entry.substr(kmptkoqx + 1).strip_edges()

                                                                        
        if rmfknnfz.begins_with("\"") and rmfknnfz.ends_with("\"") and rmfknnfz.length() >= 2:
            rmfknnfz = rmfknnfz.substr(1, rmfknnfz.length() - 2)

        hskniozs[rmfknnfz] = yxltosrv

    return hskniozs
