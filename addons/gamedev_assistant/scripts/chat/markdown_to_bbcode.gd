                                                              
@tool
class_name MarkdownToBBCode
extends RefCounted

const dcgudjuj = [
    "b", "i", "u", "s", "code", "char", "p", "center", "left", "right", "fill",
    "indent", "url", "hint", "img", "font", "font_size", "dropcap",
    "opentype_features", "lang", "color", "bgcolor", "fgcolor", "outline_size",
    "outline_color", "table", "cell", "ul", "ol", "lb", "rb", "lrm", "rlm",
    "lre", "rle", "lro", "rlo", "pdf", "alm", "lri", "rli", "fsi", "pdi",
    "zwj", "zwnj", "wj", "shy"
]


                                                                    
                              
                                                                
                                                                    
static func abfqezgq(ovcfvdqd: Array, hgpjmtxa: String) -> String:
    var pqyizich = ""
    for i in range(ovcfvdqd.size()):
        if i > 0:
            pqyizich += hgpjmtxa
        pqyizich += str(ovcfvdqd[i])
    return pqyizich


                                                                    
                                     
 
                                
                                                              
                                                                         
                                                                    
static func qnpuilvf(prlmnznr: String) -> String:
    var whrgqdnf = prlmnznr.split("\n")
    var izitqppk = []
    var ytolgsxz = false
    var zsysahvd = []
    var lxblnigh = []

    for line in whrgqdnf:
        var tjixaetp = line.strip_edges(true, false)                       

        if tjixaetp.begins_with("```"):
            if ytolgsxz:
                                
                var jzlwizml = abfqezgq(zsysahvd, "\n")
                jzlwizml = ygcavxvl(jzlwizml)

                                                       
                if lxblnigh.size() > 0:
                    var mpuiaiad = abfqezgq(lxblnigh, "\n")
                    mpuiaiad = ygcavxvl(mpuiaiad)
                    mpuiaiad = qhmdrvae(mpuiaiad)
                    izitqppk.append(mpuiaiad)
                    lxblnigh.clear()

                izitqppk.append("\n[table=1]\n[cell bg=#000000]\n[code]" + jzlwizml + "[/code]\n[/cell]\n[/table]\n")
                zsysahvd.clear()
                ytolgsxz = false
            else:
                                  
                if lxblnigh.size() > 0:
                    var aqtpirkh = abfqezgq(lxblnigh, "\n")
                    aqtpirkh = ygcavxvl(aqtpirkh)
                    aqtpirkh = qhmdrvae(aqtpirkh)
                    izitqppk.append(aqtpirkh)
                    lxblnigh.clear()
                ytolgsxz = true
        elif ytolgsxz:
            zsysahvd.append(line)
        else:
            lxblnigh.append(line)

                                 
    if ytolgsxz and zsysahvd.size() > 0:
                             
        var jebkvtfd = abfqezgq(zsysahvd, "\n")
        jebkvtfd = ygcavxvl(jebkvtfd)
        var kpsdjlaf = ztjeqoxt(jebkvtfd)
        izitqppk.append("[p][/p][table=1]\n[cell bg=#000000]\n[code]" + kpsdjlaf + "[/code]\n[/cell]\n[/table]")
    elif lxblnigh.size() > 0:
        var fpbvxatt = abfqezgq(lxblnigh, "\n")
        fpbvxatt = ygcavxvl(fpbvxatt)
        fpbvxatt = qhmdrvae(fpbvxatt)
        izitqppk.append(fpbvxatt)

    return abfqezgq(izitqppk, "\n")


                                                                    
                                         
 
                                                    
                                                                                  
                                                                            
                                                                    
static func axxubega(mijvfbef: String) -> Array:
    var zgddymly = []
    var xbdsnhbh = mijvfbef.split("\n")

    var twqwpcpx = false
    var gbzkleve = []
    var jmtiupyg = []

    for line in xbdsnhbh:
        var lrrfztgg = line.strip_edges()

        if lrrfztgg.begins_with("```"):
            if twqwpcpx:
                                    
                var zbdetxft = abfqezgq(jmtiupyg, "\n")
                zgddymly.append({ "type": "code", "content": zbdetxft })
                jmtiupyg.clear()
                twqwpcpx = false
            else:
                                    
                if gbzkleve.size() > 0:
                    var fckzatpp = abfqezgq(gbzkleve, "\n")
                    zgddymly.append({ "type": "text", "content": fckzatpp })
                    gbzkleve.clear()
                twqwpcpx = true
        elif twqwpcpx:
            jmtiupyg.append(line)
        else:
            gbzkleve.append(line)

                                      
    if gbzkleve.size() > 0:
        var lixwdifj = abfqezgq(gbzkleve, "\n")
        zgddymly.append({ "type": "text", "content": lixwdifj })
    elif twqwpcpx and jmtiupyg.size() > 0:
        var tgcamoel = abfqezgq(jmtiupyg, "\n")
        zgddymly.append({ "type": "code", "content": tgcamoel })

    return zgddymly


                             
                           
                             

static func ztjeqoxt(whfxwxho: String) -> String:
    var prxiutrz = whfxwxho.split("\n")
    var sslavifh = 0
    
                           
    for line in prxiutrz:
        sslavifh = max(sslavifh, line.length())
    
                                    
    for i in range(prxiutrz.size()):
        var rnskipvh = "  "
        var cinroxgz = "  "
        prxiutrz[i] = rnskipvh + prxiutrz[i] + cinroxgz
    
    return abfqezgq(prxiutrz, "\n") + "\n"


static func qhmdrvae(cikzfqfy: String) -> String:
    var gvkwsqoz = cikzfqfy
    var tukycjkh = gvkwsqoz.split("\n")
    var mrgnzdoj = []

    for line in tukycjkh:
                        
        if line.begins_with("## "):
            line = "[font_size=22][b]" + line.substr(3) + "[/b][/font_size]"
        elif line.begins_with("### "):
            line = "[font_size=18][b]" + line.substr(4) + "[/b][/font_size]"
        elif line.begins_with("#### "):
            line = "[font_size=16][b]" + line.substr(4) + "[/b][/font_size]"
        
               
        line = xpajylqv(line)
        mrgnzdoj.append(line)

    gvkwsqoz = abfqezgq(mrgnzdoj, "\n")

                               
    var dhyvnalu = gvkwsqoz.split("***")
    gvkwsqoz = ""
    for i in range(dhyvnalu.size()):
        gvkwsqoz += dhyvnalu[i]
        if i < dhyvnalu.size() - 1:
            if i % 2 == 0:
                gvkwsqoz += "[b][i]"
            else:
                gvkwsqoz += "[/i][/b]"

                           
    var uezzlizv = gvkwsqoz.split("**")
    var yrqkjpjk = ""
    for i in range(uezzlizv.size()):
        yrqkjpjk += uezzlizv[i]
        if i < uezzlizv.size() - 1:
            if i % 2 == 0:
                yrqkjpjk += "[b]"
            else:
                yrqkjpjk += "[/b]"
    gvkwsqoz = yrqkjpjk

                           
    var pqkaifzc = RegEx.new()
    pqkaifzc.compile("(?<![\\s])(\\*)(?![\\s])([^\\*]+?)(?<![\\s])\\*(?![\\s])")
    gvkwsqoz = pqkaifzc.sub(gvkwsqoz, "[i]$2[/i]", true)
    
    return gvkwsqoz

static func vluvtsis(pukshnmc: String, yjblrtdj: String, mxkhbimd: int) -> bool:
    var scponugj = mxkhbimd + pukshnmc.length()
    while scponugj < yjblrtdj.length():
        var fuoiczio = yjblrtdj[scponugj]
        if fuoiczio == "(":
            return true
        elif fuoiczio == " " or fuoiczio == "\t":
            scponugj += 1
        else:
            return false
    return false


static func oobpwsef(hjegbnss: String, dxwlnjev: Color) -> String:
    return "[dxwlnjev =#" + dxwlnjev.to_html(false) + "]" + hjegbnss + "[/color]"


static func ygcavxvl(uqddggtv: String) -> String:
    var kvxyhfha = uqddggtv
    var pslyzcqv = RegEx.new()
    pslyzcqv.compile("\\[(/?)(\\w+)((?:[= ])[^\\]]*)?\\]")

    var ajhaqjww = pslyzcqv.search_all(kvxyhfha)
    ajhaqjww.reverse()
    for match in ajhaqjww:
        var kxlpundb = match.get_string()
        var lpbxyhiz = match.get_string(2).to_lower()
        if lpbxyhiz in dcgudjuj:
            var cidcqmty = match.get_start()
            var uwvohekn = match.get_end()
            var uqnuaupk = ""
            for c in kxlpundb:
                if c == "[":
                    uqnuaupk += "[lb]"
                elif c == "]":
                    uqnuaupk += "[rb]"
                else:
                    uqnuaupk += c
            kvxyhfha = kvxyhfha.substr(0, cidcqmty) + uqnuaupk + kvxyhfha.substr(uwvohekn)

    return kvxyhfha


static func xpajylqv(dyxsxprb: String) -> String:
    var myfagtit = RegEx.new()
                                      
    myfagtit.compile("\\[(.+?)\\]\\((.+?)\\)")
    var jpnfisuo = dyxsxprb
    var bbottcds = myfagtit.search_all(dyxsxprb)
    bbottcds.reverse()
    for match in bbottcds:
        var vqtmbyjy = match.get_string()
        var fydozgdi = match.get_string(1)
        var icfzhflj = match.get_string(2)
                             
        var yltxqskh = "[url=%s]%s[/url]" % [icfzhflj, fydozgdi]
        jpnfisuo = jpnfisuo.substr(0, match.get_start()) + yltxqskh + jpnfisuo.substr(match.get_end())
    return jpnfisuo
