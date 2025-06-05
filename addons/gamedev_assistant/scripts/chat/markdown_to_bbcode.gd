                                                              
@tool
class_name MarkdownToBBCode
extends RefCounted

const zanxboau = [
    "b", "i", "u", "s", "code", "char", "p", "center", "left", "right", "fill",
    "indent", "url", "hint", "img", "font", "font_size", "dropcap",
    "opentype_features", "lang", "color", "bgcolor", "fgcolor", "outline_size",
    "outline_color", "table", "cell", "ul", "ol", "lb", "rb", "lrm", "rlm",
    "lre", "rle", "lro", "rlo", "pdf", "alm", "lri", "rli", "fsi", "pdi",
    "zwj", "zwnj", "wj", "shy"
]


                                                                    
                              
                                                                
                                                                    
static func szhcsvag(eehbixee: Array, kdelhfcf: String) -> String:
    var fcpbdyhp = ""
    for i in range(eehbixee.size()):
        if i > 0:
            fcpbdyhp += kdelhfcf
        fcpbdyhp += str(eehbixee[i])
    return fcpbdyhp


                                                                    
                                     
 
                                
                                                              
                                                                         
                                                                    
static func uzzbwgfu(dcexiwxs: String) -> String:
    var egytqyme = dcexiwxs.split("\n")
    var kuvzubpi = []
    var ukcostjw = false
    var ozldrafe = []
    var hevttejz = []

    for line in egytqyme:
        var mqpwhijh = line.strip_edges(true, false)                       

        if mqpwhijh.begins_with("```"):
            if ukcostjw:
                                
                var ncnlkhzp = szhcsvag(ozldrafe, "\n")
                ncnlkhzp = mwqxpujh(ncnlkhzp)

                                                       
                if hevttejz.size() > 0:
                    var inlsynkp = szhcsvag(hevttejz, "\n")
                    inlsynkp = mwqxpujh(inlsynkp)
                    inlsynkp = goaqikeh(inlsynkp)
                    kuvzubpi.append(inlsynkp)
                    hevttejz.clear()

                kuvzubpi.append("\n[table=1]\n[cell bg=#000000]\n[code]" + ncnlkhzp + "[/code]\n[/cell]\n[/table]\n")
                ozldrafe.clear()
                ukcostjw = false
            else:
                                  
                if hevttejz.size() > 0:
                    var boyqkuoh = szhcsvag(hevttejz, "\n")
                    boyqkuoh = mwqxpujh(boyqkuoh)
                    boyqkuoh = goaqikeh(boyqkuoh)
                    kuvzubpi.append(boyqkuoh)
                    hevttejz.clear()
                ukcostjw = true
        elif ukcostjw:
            ozldrafe.append(line)
        else:
            hevttejz.append(line)

                                 
    if ukcostjw and ozldrafe.size() > 0:
                             
        var lnpqiwja = szhcsvag(ozldrafe, "\n")
        lnpqiwja = mwqxpujh(lnpqiwja)
        var zepnzfxe = ekksfbws(lnpqiwja)
        kuvzubpi.append("[p][/p][table=1]\n[cell bg=#000000]\n[code]" + zepnzfxe + "[/code]\n[/cell]\n[/table]")
    elif hevttejz.size() > 0:
        var vvyiefwu = szhcsvag(hevttejz, "\n")
        vvyiefwu = mwqxpujh(vvyiefwu)
        vvyiefwu = goaqikeh(vvyiefwu)
        kuvzubpi.append(vvyiefwu)

    return szhcsvag(kuvzubpi, "\n")


                                                                    
                                         
 
                                                    
                                                                                  
                                                                            
                                                                    
static func xkrwhgvx(ctqelpee: String) -> Array:
    var rdcvarqp = []
    var ecrljhps = ctqelpee.split("\n")

    var graqrlws = false
    var nkyknhfj = []
    var shpjzgyd = []

    for line in ecrljhps:
        var mntgvbnu = line.strip_edges()

        if mntgvbnu.begins_with("```"):
            if graqrlws:
                                    
                var cjgyitrc = szhcsvag(shpjzgyd, "\n")
                rdcvarqp.append({ "type": "code", "content": cjgyitrc })
                shpjzgyd.clear()
                graqrlws = false
            else:
                                    
                if nkyknhfj.size() > 0:
                    var vryaaatk = szhcsvag(nkyknhfj, "\n")
                    rdcvarqp.append({ "type": "text", "content": vryaaatk })
                    nkyknhfj.clear()
                graqrlws = true
        elif graqrlws:
            shpjzgyd.append(line)
        else:
            nkyknhfj.append(line)

                                      
    if nkyknhfj.size() > 0:
        var hvpazqnf = szhcsvag(nkyknhfj, "\n")
        rdcvarqp.append({ "type": "text", "content": hvpazqnf })
    elif graqrlws and shpjzgyd.size() > 0:
        var mlwsirdl = szhcsvag(shpjzgyd, "\n")
        rdcvarqp.append({ "type": "code", "content": mlwsirdl })

    return rdcvarqp


                             
                           
                             

static func ekksfbws(iixghlkd: String) -> String:
    var inccdjxc = iixghlkd.split("\n")
    var lpnypwfm = 0
    
                           
    for line in inccdjxc:
        lpnypwfm = max(lpnypwfm, line.length())
    
                                    
    for i in range(inccdjxc.size()):
        var oehigyql = "  "
        var dqchxzcm = "  "
        inccdjxc[i] = oehigyql + inccdjxc[i] + dqchxzcm
    
    return szhcsvag(inccdjxc, "\n") + "\n"


static func goaqikeh(jrkrhksa: String) -> String:
    var hebppvye = jrkrhksa
    var csdvyzol = hebppvye.split("\n")
    var ehhgowit = []

    for line in csdvyzol:
                        
        if line.begins_with("## "):
            line = "[font_size=22][b]" + line.substr(3) + "[/b][/font_size]"
        elif line.begins_with("### "):
            line = "[font_size=18][b]" + line.substr(4) + "[/b][/font_size]"
        elif line.begins_with("#### "):
            line = "[font_size=16][b]" + line.substr(4) + "[/b][/font_size]"
        
               
        line = lehzahjw(line)
        ehhgowit.append(line)

    hebppvye = szhcsvag(ehhgowit, "\n")

                               
    var dlwowcbg = hebppvye.split("***")
    hebppvye = ""
    for i in range(dlwowcbg.size()):
        hebppvye += dlwowcbg[i]
        if i < dlwowcbg.size() - 1:
            if i % 2 == 0:
                hebppvye += "[b][i]"
            else:
                hebppvye += "[/i][/b]"

                           
    var doxgofcc = hebppvye.split("**")
    var gscpfejn = ""
    for i in range(doxgofcc.size()):
        gscpfejn += doxgofcc[i]
        if i < doxgofcc.size() - 1:
            if i % 2 == 0:
                gscpfejn += "[b]"
            else:
                gscpfejn += "[/b]"
    hebppvye = gscpfejn

                           
    var readruyc = RegEx.new()
    readruyc.compile("(?<![\\s])(\\*)(?![\\s])([^\\*]+?)(?<![\\s])\\*(?![\\s])")
    hebppvye = readruyc.sub(hebppvye, "[i]$2[/i]", true)
    
    return hebppvye

static func xhmwmmkc(sbfzeanf: String, aroiootn: String, dhrkczei: int) -> bool:
    var plguyrco = dhrkczei + sbfzeanf.length()
    while plguyrco < aroiootn.length():
        var zeophgss = aroiootn[plguyrco]
        if zeophgss == "(":
            return true
        elif zeophgss == " " or zeophgss == "\t":
            plguyrco += 1
        else:
            return false
    return false


static func fwcnqjra(qopaolet: String, mzehnvrm: Color) -> String:
    return "[mzehnvrm =#" + mzehnvrm.to_html(false) + "]" + qopaolet + "[/color]"


static func mwqxpujh(cwsrntqh: String) -> String:
    var htqmojgo = cwsrntqh
    var ivaefpmb = RegEx.new()
    ivaefpmb.compile("\\[(/?)(\\w+)((?:[= ])[^\\]]*)?\\]")

    var atoyfpot = ivaefpmb.search_all(htqmojgo)
    atoyfpot.reverse()
    for match in atoyfpot:
        var ohfqoown = match.get_string()
        var pkalpwgr = match.get_string(2).to_lower()
        if pkalpwgr in zanxboau:
            var nreworbp = match.get_start()
            var ucerdbih = match.get_end()
            var outsxthj = ""
            for c in ohfqoown:
                if c == "[":
                    outsxthj += "[lb]"
                elif c == "]":
                    outsxthj += "[rb]"
                else:
                    outsxthj += c
            htqmojgo = htqmojgo.substr(0, nreworbp) + outsxthj + htqmojgo.substr(ucerdbih)

    return htqmojgo


static func lehzahjw(vhkwsrga: String) -> String:
    var jfrsojlb = RegEx.new()
                                      
    jfrsojlb.compile("\\[(.+?)\\]\\((.+?)\\)")
    var ldkrczhs = vhkwsrga
    var wmkygqci = jfrsojlb.search_all(vhkwsrga)
    wmkygqci.reverse()
    for match in wmkygqci:
        var shdxxilh = match.get_string()
        var pwwngkfm = match.get_string(1)
        var pxcaundr = match.get_string(2)
                             
        var zdlpqodg = "[url=%s]%s[/url]" % [pxcaundr, pwwngkfm]
        ldkrczhs = ldkrczhs.substr(0, match.get_start()) + zdlpqodg + ldkrczhs.substr(match.get_end())
    return ldkrczhs
