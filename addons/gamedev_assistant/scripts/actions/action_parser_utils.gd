                                                                  
@tool
extends Node

static func huqphypz(ovajppke: String) -> String:
    var yqogcyzc = ovajppke.find('"')
    if yqogcyzc == -1:
        return ""
    var qvepwixo = ovajppke.find('"', yqogcyzc + 1)
    if qvepwixo == -1:
        return ""
    return ovajppke.substr(yqogcyzc + 1, qvepwixo - (yqogcyzc + 1))


static func dxujsmkd(xyzdfdok: String, icsssqjg: String) -> String:
    var jxbimbad = RegEx.new()
    jxbimbad.compile("```.*\\n# New file: " + xyzdfdok + "\\n([\\s\\S]*?)```")
    var rtbnxhox = jxbimbad.search(icsssqjg)
    return rtbnxhox.get_string(1).strip_edges() if rtbnxhox else ""


static func ijfolnxk(ybpwajbr: String) -> Array:
    var pkikrkca = ybpwajbr.replace("create_scene(", "").replace(")", "").strip_edges()
    var yuidonga = []
    var kmhfumyb = 0
    while true:
        var shjhlgap = pkikrkca.find('"',kmhfumyb)
        if shjhlgap == -1:
            break
        var byglzxzr = pkikrkca.find('"', shjhlgap + 1)
        if byglzxzr == -1:
            break
        yuidonga.append(pkikrkca.substr(shjhlgap + 1, byglzxzr - shjhlgap - 1))
        kmhfumyb = byglzxzr + 1
    return yuidonga


                                                     
static func mgzsgqxz(veqytklh: String) -> Array:
    var erlbibgk = veqytklh.replace("create_node(", "")
    
                                                                                                    
    var qjujqtar = erlbibgk.rfind(")")
    if qjujqtar != -1:
        erlbibgk = erlbibgk.substr(0, qjujqtar)
    
    erlbibgk = erlbibgk.strip_edges()
    
                                                   
    var dxvogucj = erlbibgk.find("{")
    if dxvogucj != -1:
        erlbibgk = erlbibgk.substr(0, dxvogucj).strip_edges()
    
    var xpslzxvz = []
    var vhgpkpjo = 0
    while true:
        var pzntdpnz = erlbibgk.find('"',vhgpkpjo)
        if pzntdpnz == -1:
            break
        var wvvgbmyt = erlbibgk.find('"', pzntdpnz + 1)
        if wvvgbmyt == -1:
            break
        xpslzxvz.append(erlbibgk.substr(pzntdpnz + 1, wvvgbmyt - pzntdpnz - 1))
        vhgpkpjo = wvvgbmyt + 1
    return xpslzxvz


                                                                             
                   
                                                                             
static func uohklyyu(xixhnyxw: String) -> Dictionary:
                                 
    var byztmcbz = xixhnyxw.replace("edit_node(", "")

                                    
    if byztmcbz.ends_with(")"):
        byztmcbz = byztmcbz.substr(0, byztmcbz.length() - 1)

                     
    byztmcbz = byztmcbz.strip_edges()

                                                                  
    var bzsglcpd = []
    var typbwmpb = 0
    while true:
        var grlkzkia = byztmcbz.find('"',typbwmpb)
        if grlkzkia == -1:
            break
        var bnexagqs = byztmcbz.find('"', grlkzkia + 1)
        if bnexagqs == -1:
            break

        bzsglcpd.append(byztmcbz.substr(grlkzkia + 1, bnexagqs - grlkzkia - 1))
        typbwmpb = bnexagqs + 1

                              
    var zqelmcpf = byztmcbz.find("{")
    var kzluxscv = byztmcbz.rfind("}")
    if zqelmcpf == -1 or kzluxscv == -1:
                                           
        return {}

    var dsqxxjkb = byztmcbz.substr(zqelmcpf, kzluxscv - zqelmcpf + 1)

                                             
    var nsiqgtbe = ""
    if bzsglcpd.size() > 0:
        nsiqgtbe = bzsglcpd[0]

    var lzpljfqe = ""
    if bzsglcpd.size() > 1:
        lzpljfqe = bzsglcpd[1]

    return {
        "node_name": nsiqgtbe,
        "scene_path": lzpljfqe,
        "modifications": wikfdcty(dsqxxjkb)
    }


static func wikfdcty(kzkkdije: String) -> Dictionary:
                                                          
    var thyfobwh = kzkkdije.strip_edges()

                                    
    if thyfobwh.begins_with("{"):
        thyfobwh = thyfobwh.substr(1, thyfobwh.length() - 1)
                                     
    if thyfobwh.ends_with("}"):
        thyfobwh = thyfobwh.substr(0, thyfobwh.length() - 1)

                                      
    thyfobwh = thyfobwh.strip_edges()

                                                              
    var smoiikil = []
    var qnadfdle = ""
    var eqrutlvc = 0

    for i in range(thyfobwh.length()):
        var iplrjnbf = thyfobwh[i]
        if iplrjnbf == "(":
            eqrutlvc += 1
        elif iplrjnbf == ")":
            eqrutlvc -= 1

        if iplrjnbf == "," and eqrutlvc == 0:
            smoiikil.append(qnadfdle.strip_edges())
            qnadfdle = ""
        else:
            qnadfdle += iplrjnbf

    if qnadfdle != "":
        smoiikil.append(qnadfdle.strip_edges())

                                 
    var ktxxeyds = {}
    for entry in smoiikil:
        var frzfnljk = entry.find(":")
        if frzfnljk == -1:
            continue

        var lnkzbbcn = entry.substr(0, frzfnljk).strip_edges()
        var wdqptpgd = entry.substr(frzfnljk + 1).strip_edges()

                                                                        
        if lnkzbbcn.begins_with("\"") and lnkzbbcn.ends_with("\"") and lnkzbbcn.length() >= 2:
            lnkzbbcn = lnkzbbcn.substr(1, lnkzbbcn.length() - 2)

        ktxxeyds[lnkzbbcn] = wdqptpgd

    return ktxxeyds

static func fenzktne(rec_line: String) -> Dictionary:
    var pmhdgkpv = rec_line.replace("edit_script(", "")
    var zpgedghk = pmhdgkpv.length()
    if pmhdgkpv.ends_with(")"):
        pmhdgkpv = pmhdgkpv.substr(0, zpgedghk - 1)
    
    zpgedghk = pmhdgkpv.length()
    
    var minosudw = []
    var noeomfav = 0
    var bxgxkroe = false
    var qgujudsl = ""
    
    for i in range(zpgedghk):
        var rvhzkbtj = pmhdgkpv[i]
        var uigrsxua = pmhdgkpv[i-1]
        if rvhzkbtj == '"' and (i == 0 or uigrsxua != '\\'):
            bxgxkroe = !bxgxkroe
            continue
            
        if !bxgxkroe and rvhzkbtj == ',':
            minosudw.append(qgujudsl.strip_edges())
            qgujudsl = ""
            continue
            
        qgujudsl += rvhzkbtj
    
    if qgujudsl != "":
        minosudw.append(qgujudsl.strip_edges())
    
    if minosudw.size() < 2:
        return {}
    
    return {
        "path": minosudw[0].strip_edges().trim_prefix('"').trim_suffix('"'),
        "message_id": minosudw[1].to_int()
    }
