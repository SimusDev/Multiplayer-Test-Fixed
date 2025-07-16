                                                       
@tool
extends Node

                                                 
                                      
                                   

signal lkzzpfme (validated : bool, error : String)

signal hmqqywkp(update_available: bool, latest_version: String)
signal tbojgdpj(error: String)

signal hzirqcnv (message : String, conv_id : int)
signal llomxgxn (error : String)
signal ljieruqp (message : String)

signal hxqheqrf (data)
signal qbaskjzz (error : String)

signal vyzdnovp (data)
signal xdqmweba (error : String)

signal hfapgvfx ()
signal zdjzwuvm (error : String)

signal klnapnvo ()
signal yryhzmex (error : String)

signal hnsdgzcf

const wvjftlog = 30
const pnjdkfxx = 60

var rpwsndpe : bool 

              
signal wwtvhcet(content: String, conv_id: int, message_id: int)
signal yppgawpt(conv_id: int, message_id: int)
signal vpxrehwk(conv_id: int, message_id: int)
signal xfnerllx(error: String)
var eymfrflf : HTTPClient
var iogagath = false
var olkytncm = ""

var ijryosgy : String
var anplapat : String
var wnihqrve : String
var hbbpfmap : String
var catruxel : String
var jbjxqrmn : String
var randmirj : String
var ykrhaodn : String

var odtdzqzo : String:
    get:
        var rzfjjydu = EditorInterface.get_editor_settings()
        var naqxvfio = "null"
        rpwsndpe = rzfjjydu.has_setting("gamedev_assistant/development_mode") and rzfjjydu.get_setting('gamedev_assistant/development_mode') == true
        
        if not rpwsndpe and rzfjjydu.has_setting("gamedev_assistant/token"):
            return rzfjjydu.get_setting("gamedev_assistant/token")
        elif rpwsndpe and rzfjjydu.has_setting("gamedev_assistant/token_dev"):        
            return rzfjjydu.get_setting("gamedev_assistant/token_dev")
                    
        return naqxvfio

var erejevym = ["Content-type: application/json", "Authorization: Bearer " + odtdzqzo]

@onready var kidjyzzo = $"../ConversationManager"

@onready var hsjykylt : HTTPRequest = $ValidateToken
@onready var fjkkmrpq : HTTPRequest = $SendMessage
@onready var bdskngjm : HTTPRequest = $GetConversationsList
@onready var zpalahao : HTTPRequest = $GetConversation
@onready var nomhwtzo : HTTPRequest = $DeleteConversation
@onready var wzzkqwia : HTTPRequest = $ToggleFavorite
@onready var pygycomo : HTTPRequest = $CheckUpdates
@onready var kmujkakc : HTTPRequest = $TrackAction
@onready var nguoasvv : HTTPRequest = $RatingAction
@onready var heggeeuo : HTTPRequest = $EditScript

var bhjyctiw = []

var qipcfyvh : Button = null

func _ready ():
                                      
    eymfrflf = HTTPClient.new()
    
    hsjykylt.timeout = wvjftlog                                         
    fjkkmrpq.timeout = wvjftlog                                           
    bdskngjm.timeout = wvjftlog                                 
    zpalahao.timeout = wvjftlog                                       
    nomhwtzo.timeout = wvjftlog                                    
    wzzkqwia.timeout = wvjftlog
    pygycomo.timeout = wvjftlog
    heggeeuo.timeout = pnjdkfxx
    
    hsjykylt.request_completed.connect(xmvdzjbv)
    fjkkmrpq.request_completed.connect(wssrtxgg)
    bdskngjm.request_completed.connect(kcjirpgf)
    zpalahao.request_completed.connect(fjlqfsiq)
    nomhwtzo.request_completed.connect(fuiaoxop)
    wzzkqwia.request_completed.connect(doajdohp)
    pygycomo.request_completed.connect(fcmxyllv)
    heggeeuo.request_completed.connect(onfjjqdw)
    
    hnsdgzcf.connect(pspdqxqz)  
    
    isxxvspv ()
    

func isxxvspv ():
    var tdvwtioe = EditorInterface.get_editor_settings()            
    if tdvwtioe.has_setting("gamedev_assistant/endpoint"):          
        ijryosgy = tdvwtioe.get_setting("gamedev_assistant/endpoint")    
        anplapat = ijryosgy + "/token/validate"                
        wnihqrve = ijryosgy + "/chat/message"                         
        hbbpfmap = ijryosgy + "/chat/conversations"        
        catruxel = ijryosgy + "/chat/conversation/"
        jbjxqrmn = ijryosgy + "/chat/checkForUpdates"
        randmirj = ijryosgy + "/chat/track-action"
        ykrhaodn = ijryosgy + "/chat/track-rating"

func layklcta ():
    return ["Content-type: application/json", "Authorization: Bearer " + odtdzqzo]

func phkuusbf ():
    var gqhwadao = hsjykylt.request(anplapat, layklcta(), HTTPClient.METHOD_GET)

func tnfxwjoj(hkqmdzzx: String, hjuofxha: bool, izjixmib: String) -> void:
    
    fjkkmrpq.timeout = wvjftlog
    
                           
    iogagath = false
    olkytncm = ""
    
                                
    var fxqjmmxu = ijryosgy.begins_with("https://")
    var rmudjeas = ijryosgy.replace("http://", "").replace("https://", "")
    
                                       
    var fzvjtcdz = -1
    if rmudjeas.begins_with("localhost:"):
        var zlctqlqp = rmudjeas.split(":")
        rmudjeas = zlctqlqp[0]
        fzvjtcdz = int(zlctqlqp[1])
    
                                                                            
    
    var axfuimpy: Error
    if fxqjmmxu:
        axfuimpy = eymfrflf.connect_to_host(rmudjeas, fzvjtcdz, TLSOptions.client())
    else:
        axfuimpy = eymfrflf.connect_to_host(rmudjeas, fzvjtcdz)
        
    if axfuimpy != OK:
        xfnerllx.emit("Failed to connect: " + str(axfuimpy))
        return

    iogagath = true
    
                             
    var gbhocaui = EditorInterface.get_editor_settings()
    var oaeasham = gbhocaui.get_setting("gamedev_assistant/version_identifier")
    
    var tvirikpy = Engine.get_version_info()
    var vpzdxiyi = "%d.%d" % [tvirikpy.major, tvirikpy.minor]
    
                                           
    var mtmlsirr = ""
    if gbhocaui.has_setting("gamedev_assistant/custom_instructions"):
        mtmlsirr = gbhocaui.get_setting("gamedev_assistant/custom_instructions")
    
    
                              
    var fgnpbofo = { 
        "content": hkqmdzzx, 
        "useThinking": hjuofxha,
        "releaseUniqueIdentifier": oaeasham,
        "godotVersion": vpzdxiyi,
        "mode": izjixmib,
        "customInstructions": mtmlsirr
    }
    
    var qvrgqkod = kidjyzzo.nlkrcvov()
    
    if qvrgqkod and qvrgqkod.id > 0:
        fgnpbofo["conversationId"] = qvrgqkod.id
        
                                                            
    
                                                
    matonvnq(fgnpbofo)
    
    ljieruqp.emit(hkqmdzzx)

func fnjkrlfw ():
    var fyzzytuf = bdskngjm.request(hbbpfmap, layklcta(), HTTPClient.METHOD_GET)

func get_conversation (fevdpgqo : int):
    var ekmafbzy = catruxel + str(fevdpgqo)
    var nwebvzuq = zpalahao.request(ekmafbzy, layklcta(), HTTPClient.METHOD_GET)

func tzspyrxj (buluegrc : int):
    var nxceowwx = catruxel + str(buluegrc)
    var wvrmdoop = nomhwtzo.request(nxceowwx, layklcta(), HTTPClient.METHOD_DELETE)

func yjvdfmme (rwsiqzwr : int):
    var afdwjwci = catruxel + str(rwsiqzwr) + "/toggle-favorite"
    var znbewuty = wzzkqwia.request(afdwjwci, layklcta(), HTTPClient.METHOD_POST)

func xmvdzjbv(dmnlprmc: int, mktzkccg: int, sfkffvjs: PackedStringArray, zbsezzmp: PackedByteArray):
                                
    if dmnlprmc != HTTPRequest.RESULT_SUCCESS:
        lkzzpfme.emit(false, "Network error (Code: " + str(dmnlprmc) + ")")
        return
        
    var pjqcbriq = iubiqwrr(zbsezzmp)
    if not pjqcbriq is Dictionary:
        lkzzpfme.emit(false, "Response error (Code: " + str(mktzkccg) + ")")
        return
        
    var pygtooqc = pjqcbriq.get("success", false)
    var msppifsa = pjqcbriq.get("error", "Response code: " + str(mktzkccg))
    
    lkzzpfme.emit(pygtooqc, msppifsa)

                                                     
func wssrtxgg(lhkkpofz, vlsjijmz, muaryexl, fxglvjrn):
    
    if lhkkpofz != HTTPRequest.RESULT_SUCCESS:
        llomxgxn.emit("Network error (Code: " + str(lhkkpofz) + ")")
        return
        
    var cfqxopbj = iubiqwrr(fxglvjrn)
    if not cfqxopbj is Dictionary:
        llomxgxn.emit("Response error (Code: " + str(vlsjijmz) + ")")
        return
    
    if vlsjijmz == 201:
        var txflvitq = cfqxopbj.get("content", "")
        var unvliemv = int(cfqxopbj.get("conversationId", -1))
        hzirqcnv.emit(txflvitq, unvliemv)
    else:
        llomxgxn.emit(cfqxopbj.get("error", "Response code: " + str(vlsjijmz)))

                                                                    
func kcjirpgf(dwycyocf, tjuekcky, jgdgtrkb, fjdgnczj):
    if dwycyocf != HTTPRequest.RESULT_SUCCESS:
        qbaskjzz.emit("Network error (Code: " + str(dwycyocf) + ")")
        return
        
    var hawojdun = iubiqwrr(fjdgnczj)
    
    if tjuekcky == 200:
        hxqheqrf.emit(hawojdun)
    else:
        if hawojdun is Dictionary:
            qbaskjzz.emit(hawojdun.get("error", "Response code: " + str(tjuekcky)))
        else:
            qbaskjzz.emit("Response error (Code: " + str(tjuekcky) + ")")

                                                                
func fjlqfsiq(doehpvvt, ezxisorm, abdycqcq, rlcvsqja):
    if doehpvvt != HTTPRequest.RESULT_SUCCESS:
                                                              
        printerr("[GameDev Assistant] Get conversation network error (Code: " + str(doehpvvt) + ")")
        return
        
    var upyzxdfw = iubiqwrr(rlcvsqja)
    if not upyzxdfw is Dictionary:
        printerr("[GameDev Assistant] Get conversation response error (Code: " + str(ezxisorm) + ")")
        return
        
    vyzdnovp.emit(upyzxdfw)

                                                                                         
func fuiaoxop(kganhbws, rlyqexur, apivmhke, pejguwix):
    if kganhbws != HTTPRequest.RESULT_SUCCESS:
                                                                          
        printerr("[GameDev Assistant] Delete conversation network error (Code: " + str(kganhbws) + ")")
        return
        
    if rlyqexur == 204:
        hfapgvfx.emit()
    else:
        var ueicowyx = iubiqwrr(pejguwix)
        var gjrhidlw = "[GameDev Assistant] Response code: " + str(rlyqexur)
        if ueicowyx is Dictionary:
            gjrhidlw = ueicowyx.get("error", gjrhidlw)
        zdjzwuvm.emit(gjrhidlw)

                                                                                                       
func doajdohp(tusfmmmx, fdynsmql, nwkxrgwl, gxphgkrp):
    if tusfmmmx != HTTPRequest.RESULT_SUCCESS:
                                                                      
        printerr("[GameDev Assistant] Toggle favorite network error (Code: " + str(tusfmmmx) + ")")
        return
        
    if fdynsmql == 200:
        klnapnvo.emit()
    else:
        var gthipcco = iubiqwrr(gxphgkrp)
        var tntlaylh = "[GameDev Assistant] Response code: " + str(fdynsmql)
        if gthipcco is Dictionary:
            tntlaylh = gthipcco.get("error", tntlaylh)
        yryhzmex.emit(tntlaylh)

func iubiqwrr (zncudlid):
    var arckuind = JSON.new()
    var hdtfutcv = arckuind.parse(zncudlid.get_string_from_utf8())
    if hdtfutcv != OK:
        return null
    return arckuind.get_data()

func matonvnq(fjpknpet: Dictionary) -> void:
    while iogagath:
        eymfrflf.poll()
        
        match eymfrflf.get_status():
            HTTPClient.STATUS_CONNECTION_ERROR:
                xfnerllx.emit("Connection error")
                pspdqxqz()
                return
            HTTPClient.STATUS_DISCONNECTED:
                xfnerllx.emit("Disconnected")
                pspdqxqz()
                return
            
            HTTPClient.STATUS_CONNECTED:
                nwbhbprl(fjpknpet)
                
            HTTPClient.STATUS_BODY:
                eeopsbmc()
        
        await get_tree().process_frame

func nwbhbprl(jjtylhwg: Dictionary) -> void:
    var pmbhxzpb = JSON.new()
    var onpvigvz = pmbhxzpb.stringify(jjtylhwg)
    var obazkbyr = PackedStringArray([
        "Content-Type: application/json",
        "Authorization: Bearer " + odtdzqzo
    ])
    
    var lytfxesq = eymfrflf.request(
        HTTPClient.METHOD_POST,
        wnihqrve.replace(ijryosgy, ""),                                        
        obazkbyr,
        onpvigvz
    )
    
    if lytfxesq != OK:
        xfnerllx.emit("Failed to send request: " + str(lytfxesq))
        iogagath = false

func eeopsbmc() -> void:
    while eymfrflf.get_status() == HTTPClient.STATUS_BODY:
        var hunpfzvd = eymfrflf.read_response_body_chunk()
        if hunpfzvd.size() == 0:
            break
            
        olkytncm += hunpfzvd.get_string_from_utf8()
        
        wgchcyrc()

func wgchcyrc() -> void:
    
    var jrsntlor
    var kbtddmwf
    var fpmbbrcc
    
    if eymfrflf.get_response_code() != 200:
        iogagath = false
        
        jrsntlor = JSON.new()
        kbtddmwf = jrsntlor.parse(olkytncm)
        
        if kbtddmwf == OK:
            fpmbbrcc = jrsntlor.get_data()
            if fpmbbrcc.has("error"):                
                xfnerllx.emit(fpmbbrcc["error"])
            elif fpmbbrcc.has("message"):                
                xfnerllx.emit(fpmbbrcc["message"])
            else:
                xfnerllx.emit("Unknown server error, please try again later")
        else: 
            xfnerllx.emit("Unknown server error")
    
    var wmuvauav = olkytncm.split("\n\n")
    
                                                                                 
    for i in range(wmuvauav.size() - 1):
        var gfqkhfzw: String = wmuvauav[i]
        if gfqkhfzw.find("data:") != -1:
            var fugmewls = gfqkhfzw.split("\n")
            for line in fugmewls:
                if line.begins_with("data:"):
                    var zjmspcqk = line.substr(5).strip_edges()
                                                               
                    
                    jrsntlor = JSON.new()
                    kbtddmwf = jrsntlor.parse(zjmspcqk)
                    
                    if kbtddmwf == OK:
                        fpmbbrcc = jrsntlor.get_data()
                        
                        if fpmbbrcc is Dictionary:
                            if fpmbbrcc.has("error"):
                                printerr("Server error: ", fpmbbrcc["error"])
                                xfnerllx.emit(fpmbbrcc["error"])
                                pspdqxqz()
                                return
                            
                            if fpmbbrcc.has("done") and fpmbbrcc["done"] == true:
                                iogagath = false
                                                                
                                yppgawpt.emit(
                                    int(fpmbbrcc.get("conversationId", -1)),
                                    int(fpmbbrcc.get("messageId", -1))
                                )
                                pspdqxqz()
                                
                            elif fpmbbrcc.has("beforeActions"):
                                vpxrehwk.emit(
                                    int(fpmbbrcc.get("conversationId", -1)),
                                    int(fpmbbrcc.get("messageId", -1))
                                )
                                
                            elif fpmbbrcc.has("content"):
                                
                                if (typeof(fpmbbrcc.get("messageId")) != TYPE_INT and typeof(fpmbbrcc.get("messageId")) != TYPE_FLOAT) or (typeof(fpmbbrcc.get("messageId")) != TYPE_INT and typeof(fpmbbrcc.get("conversationId")) != TYPE_FLOAT):
                                    print(fpmbbrcc.get("messageId"))
                                    print(fpmbbrcc.get("conversationId"))
                                    
                                    xfnerllx.emit("Invalid data coming from the server")
                                    pspdqxqz()
                                    return                                   
                            
                                wwtvhcet.emit(
                                    str(fpmbbrcc["content"]),
                                    int(fpmbbrcc.get("conversationId", -1)),
                                    int(fpmbbrcc.get("messageId", -1))
                                )
                        
                                               
    olkytncm = wmuvauav[wmuvauav.size() - 1]
    
func pspdqxqz():  
    iogagath = false  
    eymfrflf.close()            

                                                                  
func ezuczicd(weligbxl: bool = false):
    var osrbgoux = EditorInterface.get_editor_settings()       
    var zocygulk = osrbgoux.get_setting("gamedev_assistant/version_identifier")
    
    var xbvsvgui = {
        "releaseUniqueIdentifier": zocygulk,
        "isInit": weligbxl
    }
    var xrxmqezb = JSON.new()
    var yborjqco = xrxmqezb.stringify(xbvsvgui)
    var gmcmarep = pygycomo.request(jbjxqrmn, layklcta(), HTTPClient.METHOD_POST, yborjqco)

                                            
func fcmxyllv(dbctwjin, isnvsfwu, gbgniogp, ddzwpljp):
    if dbctwjin != HTTPRequest.RESULT_SUCCESS:
        tbojgdpj.emit("[GameDev Assistant] Network error when checking for updates (Code: " + str(dbctwjin) + ")")
        return
        
    var ccriboaw = iubiqwrr(ddzwpljp)
    if not ccriboaw is Dictionary:
        tbojgdpj.emit("[GameDev Assistant] Response error when checking for updates (Code: " + str(isnvsfwu) + ")")
        return
    
    if isnvsfwu == 200:
        var ebkpicei = ccriboaw.get("updateAvailable", false)
        var xntijjmm = ccriboaw.get("latestVersion", "")
        
        hmqqywkp.emit(ebkpicei, xntijjmm)
    else:
        tbojgdpj.emit(ccriboaw.get("error", "Response code: " + str(isnvsfwu)))

func mbqadahd(auxgjrgc: int, mghrrbyu: bool, uvabzevi: String):
    var fmjjnqxk = {
        "messageId": auxgjrgc,
        "success": mghrrbyu,
        "action_type": uvabzevi
    }
    bhjyctiw.append(fmjjnqxk)
    yhustfgs()

                             
func yhustfgs():
    var client_status = kmujkakc.get_http_client_status()
                                                                                      
    if (client_status == HTTPClient.STATUS_DISCONNECTED or 
        client_status == HTTPClient.STATUS_CANT_RESOLVE or 
        client_status == HTTPClient.STATUS_CANT_CONNECT or 
        client_status == HTTPClient.STATUS_CONNECTION_ERROR or 
        client_status == HTTPClient.STATUS_TLS_HANDSHAKE_ERROR) and bhjyctiw.size() > 0:
        
        var wcklkpxp = bhjyctiw.pop_front()
        var dyebsdig = JSON.new()
        var ycfgvxrw = dyebsdig.stringify(wcklkpxp)
        var xhqvdspu = layklcta()
        var esdmidrt = kmujkakc.request(randmirj, xhqvdspu, HTTPClient.METHOD_POST, ycfgvxrw)
        if esdmidrt != OK:
            printerr("Failed to start track action request:", esdmidrt)
            yhustfgs()                                  

func rhpnxqqh(gvuxmiik, cuvfvtvr, owziahmr, gxxypumv):
    yhustfgs()                                      
    if gvuxmiik != HTTPRequest.RESULT_SUCCESS:
        printerr("[GameDev Assistant] Track action failed:", gvuxmiik)
        return
        
    var rkxurdzo = iubiqwrr(gxxypumv)
    if not rkxurdzo is Dictionary:
        printerr("[GameDev Assistant] Invalid track action response")

func ulkedylb(wiokfguf: int, clnsqbba: int) -> void:
    var meaigefp = {
        "messageId": wiokfguf,
        "rating": clnsqbba
    }
    var asnsboyc = JSON.new()
    var jtazougr = asnsboyc.stringify(meaigefp)
    var rlkydvur = layklcta()
    var wwxcuqdv = nguoasvv.request(ykrhaodn, rlkydvur, HTTPClient.METHOD_POST, jtazougr)
    if wwxcuqdv != OK:
        printerr("[GameDev Assistant] Failed to track rating:", wwxcuqdv)

                                          
func ttizuvta(gsabkdbf, gctdjmay, ymjvuhai, twxhslhd):
    if gsabkdbf != HTTPRequest.RESULT_SUCCESS:
        printerr("[GameDev Assistant] Rating action failed:", gsabkdbf)
        return
        
    var gxelkrxg = iubiqwrr(twxhslhd)
    if not gxelkrxg is Dictionary:
        printerr("[GameDev Assistant] Invalid rating response")
        return

func gofbguxw():
    return iogagath
func hykpwzaa(psxppxzx: Object) -> void:
    print("=== Methods ===")
    for method in psxppxzx.get_method_list():
        print(method["name"])
    
    print("\n=== Properties ===")
    for property in psxppxzx.get_property_list():
        print(property["name"])
    
    print("\n=== Signals ===")
    for signal_info in psxppxzx.get_signal_list():
        print(signal_info["name"])
        
func rljxqqys(njhubdxw: String, ycelbbzp: int, nrovoxvn: String, bdyqgkcs: Button) -> void:
                                         
    qipcfyvh = bdyqgkcs
    
                                                                  
    var tznprihy = $"../ActionManager"
    tznprihy.epsfsspq.emit("edit_script", true)
    bdyqgkcs.text = "⌛Editing file %s" % njhubdxw

    var pzfatcdw = {
        "path": njhubdxw,
        "message_id": ycelbbzp,
        "content": nrovoxvn
    }
    
    var gvlpgivp = JSON.new()
    var ephmviqi = gvlpgivp.stringify(pzfatcdw)
    var bacqchkv = layklcta()
                                                     
    
    var omoevgjd = ijryosgy + "/editScript"
    var oklsmyrm = heggeeuo.request(omoevgjd, bacqchkv, HTTPClient.METHOD_POST, ephmviqi)
    
    if oklsmyrm != OK:
        push_error("Failed to start edit_script request: " + str(oklsmyrm))
                                   
                                                      
        tznprihy.bunseryn.emit("edit_script", njhubdxw, false, bdyqgkcs)
        
func onfjjqdw(ihargpzd: int, zmanlpcj: int, jaepuank: PackedStringArray, bdegepog: PackedByteArray) -> void:
                                                      
    var eajryhbk = $"../ActionManager"
    var rfaphbvi = qipcfyvh
    
    if ihargpzd != HTTPRequest.RESULT_SUCCESS:
        push_error("EditScript request failed: " + str(ihargpzd))
        return
        
    var ailcctbb = iubiqwrr(bdegepog)
    if not ailcctbb is Dictionary:
        push_error("Invalid response for EditScript")
        return
    
                                           
    var kahlyaop = ailcctbb.get("path", "")
    var mwwvyrfg = ailcctbb.get("content", "")
    
    if rpwsndpe:
        print(kahlyaop)
        print(mwwvyrfg)
    
    if kahlyaop == "" or mwwvyrfg == "":
        push_error("Missing data in EditScript response")
        return
    
                                            
    var pnznennt = Engine.get_singleton("EditorInterface")
    var aeslfpyh = pnznennt.get_script_editor()
    var xpyylvme: Array = aeslfpyh.get_open_scripts()
    var kvasqhfl: Array = aeslfpyh.get_open_script_editors()
    
                                        
    var sfnlolfn = FileAccess.open(kahlyaop, FileAccess.WRITE)
    if sfnlolfn:
        sfnlolfn.store_string(mwwvyrfg)
        sfnlolfn.close()
        
                                          
        var lsqowiet = ResourceLoader.load(kahlyaop, "Script", ResourceLoader.CACHE_MODE_IGNORE)
        
                                                            
        await get_tree().process_frame
        
        var sigvxpwc = 0
        var cxrddchp : bool = true
        for open_script in xpyylvme:
            if open_script.resource_path == kahlyaop:
                kvasqhfl[sigvxpwc].get_base_editor().set_text(mwwvyrfg)  
                push_warning("[GameDev Assistant] File updated: " + kahlyaop + " (due to a Godot API limitation, it will appear as not saved in the editor, but rest assured it has already been saved to disk!)")
                cxrddchp = false
                break
            sigvxpwc = sigvxpwc + 1
            
        if cxrddchp:
            print("[GameDev Assistant] File updated: " + kahlyaop)
        
        pnznennt.get_resource_filesystem().scan()
        await get_tree().process_frame
        pnznennt.edit_script(lsqowiet)
        rfaphbvi.text = "Edited sfnlolfn %s" % kahlyaop
        eajryhbk.bunseryn.emit("edit_script", kahlyaop, true, rfaphbvi)
    else:
        push_error("[GameDev Assistant] Failed to write updated script: " + kahlyaop)
        eajryhbk.bunseryn.emit("edit_script", kahlyaop, false, rfaphbvi)
