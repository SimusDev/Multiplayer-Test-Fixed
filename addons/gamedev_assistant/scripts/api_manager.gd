                         
@tool
extends Node

                                                 
                                      
                                   

signal gsjjvznk (validated : bool, error : String)

signal twuqtije(update_available: bool, latest_version: String)
signal sfbkqhmh(error: String)

signal oyedrfpg (message : String, conv_id : int)
signal eqpgenrs (error : String)
signal yznamlrk (message : String)

signal sixksrlf (data)
signal zurkrjmo (error : String)

signal gqtjftgc (data)
signal qpqhuvxu (error : String)

signal ohqtpiyu ()
signal iuitsarb (error : String)

signal fgvjnoap ()
signal iqtmgbcv (error : String)

signal mtqlfuui

const xcjwcawf = 30

              
signal ftrthtjf(content: String, conv_id: int, message_id: int)
signal pkzlifbx(conv_id: int, message_id: int)
signal wcnybufe(conv_id: int, message_id: int)
signal dninyqmi(error: String)
var xcszqvoy : HTTPClient
var bypbulgi = false
var qogqbzbl = ""

var hguxqgob : String
var epcgajou : String
var eivvbnis : String
var nvktmvjn : String
var wrbglfat : String
var xssmyxvi : String
var soytbxhc : String
var phdbuquv : String

var ocditntr : String:
    get:
        var kunewgnd = EditorInterface.get_editor_settings()
        var zhclxeah = "null"
        var xrblfpmz : bool = kunewgnd.has_setting("gamedev_assistant/development_mode") and kunewgnd.get_setting('gamedev_assistant/development_mode') == true
        
        if not xrblfpmz and kunewgnd.has_setting("gamedev_assistant/token"):
            return kunewgnd.get_setting("gamedev_assistant/token")
        elif xrblfpmz and kunewgnd.has_setting("gamedev_assistant/token_dev"):        
            return kunewgnd.get_setting("gamedev_assistant/token_dev")
                    
        return zhclxeah

var ywcxfxyu = ["Content-type: application/json", "Authorization: Bearer " + ocditntr]

@onready var guikyami = $"../ConversationManager"

@onready var lnepfizc : HTTPRequest = $ValidateToken
@onready var nlkfencl : HTTPRequest = $SendMessage
@onready var nwlophsk : HTTPRequest = $GetConversationsList
@onready var wgqhrgtr : HTTPRequest = $GetConversation
@onready var fnahuziq : HTTPRequest = $DeleteConversation
@onready var vlllvkgm : HTTPRequest = $ToggleFavorite
@onready var jkbnpofk : HTTPRequest = $CheckUpdates
@onready var zlzmivaw : HTTPRequest = $TrackAction
@onready var aysxneoc : HTTPRequest = $RatingAction


var qwrvgcjk = []

func _ready ():
                                      
    xcszqvoy = HTTPClient.new()
    
    lnepfizc.timeout = xcjwcawf                                         
    nlkfencl.timeout = xcjwcawf                                           
    nwlophsk.timeout = xcjwcawf                                 
    wgqhrgtr.timeout = xcjwcawf                                       
    fnahuziq.timeout = xcjwcawf                                    
    vlllvkgm.timeout = xcjwcawf
    jkbnpofk.timeout = xcjwcawf
    
    lnepfizc.request_completed.connect(xbfwdbce)
    nlkfencl.request_completed.connect(ilgwryil)
    nwlophsk.request_completed.connect(ncqfejcy)
    wgqhrgtr.request_completed.connect(spnuffmr)
    fnahuziq.request_completed.connect(bhxrbnbi)
    vlllvkgm.request_completed.connect(vukjnkjr)
    jkbnpofk.request_completed.connect(ilxhqpeg)
    
    mtqlfuui.connect(jakthliy)  
    
    chutmtuw ()
    

func chutmtuw ():
    var oswcwacy = EditorInterface.get_editor_settings()            
    if oswcwacy.has_setting("gamedev_assistant/endpoint"):          
        hguxqgob = oswcwacy.get_setting("gamedev_assistant/endpoint")    
        epcgajou = hguxqgob + "/token/validate"                
        eivvbnis = hguxqgob + "/chat/message"                         
        nvktmvjn = hguxqgob + "/chat/conversations"        
        wrbglfat = hguxqgob + "/chat/conversation/"
        xssmyxvi = hguxqgob + "/chat/checkForUpdates"
        soytbxhc = hguxqgob + "/chat/track-action"
        phdbuquv = hguxqgob + "/chat/track-rating"

func ncgbyzqp ():
    return ["Content-type: application/json", "Authorization: Bearer " + ocditntr]

func jgknhlht ():
    var raqoazvf = lnepfizc.request(epcgajou, ncgbyzqp(), HTTPClient.METHOD_GET)

func pmlqzimx(jpmrfyhk: String, lyittfik: bool, cmovnycn: String) -> void:
    
    nlkfencl.timeout = xcjwcawf
    
                           
    bypbulgi = false
    qogqbzbl = ""
    
                                
    var kxmeeant = hguxqgob.begins_with("https://")
    var tzoeoxtn = hguxqgob.replace("http://", "").replace("https://", "")
    
                                       
    var ogbiczrq = -1
    if tzoeoxtn.begins_with("localhost:"):
        var fttigxcm = tzoeoxtn.split(":")
        tzoeoxtn = fttigxcm[0]
        ogbiczrq = int(fttigxcm[1])
    
                                                                            
    
    var ssxmdedq: Error
    if kxmeeant:
        ssxmdedq = xcszqvoy.connect_to_host(tzoeoxtn, ogbiczrq, TLSOptions.client())
    else:
        ssxmdedq = xcszqvoy.connect_to_host(tzoeoxtn, ogbiczrq)
        
    if ssxmdedq != OK:
        dninyqmi.emit("Failed to connect: " + str(ssxmdedq))
        return

    bypbulgi = true
    
                             
    var bogpiidl = EditorInterface.get_editor_settings()
    var iyvjstip = bogpiidl.get_setting("gamedev_assistant/version_identifier")
    
    var klbijvei = Engine.get_version_info()
    var spzsoptp = "%d.%d" % [klbijvei.major, klbijvei.minor]
    
                                           
    var dzkframs = ""
    if bogpiidl.has_setting("gamedev_assistant/custom_instructions"):
        dzkframs = bogpiidl.get_setting("gamedev_assistant/custom_instructions")
    
    
                              
    var dqndkred = { 
        "content": jpmrfyhk, 
        "useThinking": lyittfik,
        "releaseUniqueIdentifier": iyvjstip,
        "godotVersion": spzsoptp,
        "mode": cmovnycn,
        "customInstructions": dzkframs
    }
    
    var agebnrlv = guikyami.pirnmejx()
    
    if agebnrlv and agebnrlv.id > 0:
        dqndkred["conversationId"] = agebnrlv.id
        
                                                            
    
                                                
    teqiwutx(dqndkred)
    
    yznamlrk.emit(jpmrfyhk)

func rehxusbr ():
    var ujauqfsg = nwlophsk.request(nvktmvjn, ncgbyzqp(), HTTPClient.METHOD_GET)

func get_conversation (qvvhjiye : int):
    var rzwrgclz = wrbglfat + str(qvvhjiye)
    var gtnxzijz = wgqhrgtr.request(rzwrgclz, ncgbyzqp(), HTTPClient.METHOD_GET)

func spgkyzfi (ehodfbgt : int):
    var ifcwrwms = wrbglfat + str(ehodfbgt)
    var rnffdyth = fnahuziq.request(ifcwrwms, ncgbyzqp(), HTTPClient.METHOD_DELETE)

func mfjexrur (zsqsxeqt : int):
    var mifjvbln = wrbglfat + str(zsqsxeqt) + "/toggle-favorite"
    var lulkymdt = vlllvkgm.request(mifjvbln, ncgbyzqp(), HTTPClient.METHOD_POST)

func xbfwdbce(qkzeehbr: int, lmnndebl: int, bjcvbozc: PackedStringArray, sktumcrv: PackedByteArray):
                                
    if qkzeehbr != HTTPRequest.RESULT_SUCCESS:
        gsjjvznk.emit(false, "Network error (Code: " + str(qkzeehbr) + ")")
        return
        
    var papinacr = srqdgqll(sktumcrv)
    if not papinacr is Dictionary:
        gsjjvznk.emit(false, "Response error (Code: " + str(lmnndebl) + ")")
        return
        
    var vsnzyhje = papinacr.get("success", false)
    var rlmgyqdr = papinacr.get("error", "Response code: " + str(lmnndebl))
    
    gsjjvznk.emit(vsnzyhje, rlmgyqdr)

                                                     
func ilgwryil(evafgzto, guarolcw, tjkkqwbe, tyfuavmi):
    
    if evafgzto != HTTPRequest.RESULT_SUCCESS:
        eqpgenrs.emit("Network error (Code: " + str(evafgzto) + ")")
        return
        
    var zmvvbkfq = srqdgqll(tyfuavmi)
    if not zmvvbkfq is Dictionary:
        eqpgenrs.emit("Response error (Code: " + str(guarolcw) + ")")
        return
    
    if guarolcw == 201:
        var hnibmdsw = zmvvbkfq.get("content", "")
        var pqtzvonh = int(zmvvbkfq.get("conversationId", -1))
        oyedrfpg.emit(hnibmdsw, pqtzvonh)
    else:
        eqpgenrs.emit(zmvvbkfq.get("error", "Response code: " + str(guarolcw)))

                                                                    
func ncqfejcy(puopecbt, vmrfebbg, brqaukie, icoycrmt):
    if puopecbt != HTTPRequest.RESULT_SUCCESS:
        zurkrjmo.emit("Network error (Code: " + str(puopecbt) + ")")
        return
        
    var tpdavxfz = srqdgqll(icoycrmt)
    
    if vmrfebbg == 200:
        sixksrlf.emit(tpdavxfz)
    else:
        if tpdavxfz is Dictionary:
            zurkrjmo.emit(tpdavxfz.get("error", "Response code: " + str(vmrfebbg)))
        else:
            zurkrjmo.emit("Response error (Code: " + str(vmrfebbg) + ")")

                                                                
func spnuffmr(mbxsinik, hbqixevb, cmorhnrj, qodddjvx):
    if mbxsinik != HTTPRequest.RESULT_SUCCESS:
                                                              
        printerr("[GameDev Assistant] Get conversation network error (Code: " + str(mbxsinik) + ")")
        return
        
    var rfjrggul = srqdgqll(qodddjvx)
    if not rfjrggul is Dictionary:
        printerr("[GameDev Assistant] Get conversation response error (Code: " + str(hbqixevb) + ")")
        return
        
    gqtjftgc.emit(rfjrggul)

                                                                                         
func bhxrbnbi(olonwubx, xasiwvwc, zzyketqh, okgnefyh):
    if olonwubx != HTTPRequest.RESULT_SUCCESS:
                                                                          
        printerr("[GameDev Assistant] Delete conversation network error (Code: " + str(olonwubx) + ")")
        return
        
    if xasiwvwc == 204:
        ohqtpiyu.emit()
    else:
        var urcifdfi = srqdgqll(okgnefyh)
        var oqjhhwpc = "[GameDev Assistant] Response code: " + str(xasiwvwc)
        if urcifdfi is Dictionary:
            oqjhhwpc = urcifdfi.get("error", oqjhhwpc)
        iuitsarb.emit(oqjhhwpc)

                                                                                                       
func vukjnkjr(sshsrsyv, clixxocm, efzhogda, vbxmncse):
    if sshsrsyv != HTTPRequest.RESULT_SUCCESS:
                                                                      
        printerr("[GameDev Assistant] Toggle favorite network error (Code: " + str(sshsrsyv) + ")")
        return
        
    if clixxocm == 200:
        fgvjnoap.emit()
    else:
        var hnsxuubk = srqdgqll(vbxmncse)
        var nxifttnu = "[GameDev Assistant] Response code: " + str(clixxocm)
        if hnsxuubk is Dictionary:
            nxifttnu = hnsxuubk.get("error", nxifttnu)
        iqtmgbcv.emit(nxifttnu)

func srqdgqll (bxvebhva):
    var goagaswu = JSON.new()
    var ghhydjeu = goagaswu.parse(bxvebhva.get_string_from_utf8())
    if ghhydjeu != OK:
        return null
    return goagaswu.get_data()

func teqiwutx(eyajuzyz: Dictionary) -> void:
    while bypbulgi:
        xcszqvoy.poll()
        
        match xcszqvoy.get_status():
            HTTPClient.STATUS_CONNECTION_ERROR:
                dninyqmi.emit("Connection error")
                jakthliy()
                return
            HTTPClient.STATUS_DISCONNECTED:
                dninyqmi.emit("Disconnected")
                jakthliy()
                return
            
            HTTPClient.STATUS_CONNECTED:
                tkptaqkd(eyajuzyz)
                
            HTTPClient.STATUS_BODY:
                isyvcgnc()
        
        await get_tree().process_frame

func tkptaqkd(qbrdbjju: Dictionary) -> void:
    var juhtlwye = JSON.new()
    var wfuyafki = juhtlwye.stringify(qbrdbjju)
    var atnayeux = PackedStringArray([
        "Content-Type: application/json",
        "Authorization: Bearer " + ocditntr
    ])
    
    var ujrlhavq = xcszqvoy.request(
        HTTPClient.METHOD_POST,
        eivvbnis.replace(hguxqgob, ""),                                        
        atnayeux,
        wfuyafki
    )
    
    if ujrlhavq != OK:
        dninyqmi.emit("Failed to send request: " + str(ujrlhavq))
        bypbulgi = false

func isyvcgnc() -> void:
    while xcszqvoy.get_status() == HTTPClient.STATUS_BODY:
        var pdvkului = xcszqvoy.read_response_body_chunk()
        if pdvkului.size() == 0:
            break
            
        qogqbzbl += pdvkului.get_string_from_utf8()
        
        celblwgt()

func celblwgt() -> void:
    
    var shvzhzos
    var yhpngekn
    var tezbpgot
    
    if xcszqvoy.get_response_code() != 200:
        bypbulgi = false
        
        shvzhzos = JSON.new()
        yhpngekn = shvzhzos.parse(qogqbzbl)
        
        if yhpngekn == OK:
            tezbpgot = shvzhzos.get_data()
            if tezbpgot.has("error"):                
                dninyqmi.emit(tezbpgot["error"])
            elif tezbpgot.has("message"):                
                dninyqmi.emit(tezbpgot["message"])
            else:
                dninyqmi.emit("Unknown server error, please try again later")
        else: 
            dninyqmi.emit("Unknown server error")
    
    var hjzeobho = qogqbzbl.split("\n\n")
    
                                                                                 
    for i in range(hjzeobho.size() - 1):
        var wyrzifnz: String = hjzeobho[i]
        if wyrzifnz.find("data:") != -1:
            var srzcbphy = wyrzifnz.split("\n")
            for line in srzcbphy:
                if line.begins_with("data:"):
                    var wutjiaxw = line.substr(5).strip_edges()
                                                               
                    
                    shvzhzos = JSON.new()
                    yhpngekn = shvzhzos.parse(wutjiaxw)
                    
                    if yhpngekn == OK:
                        tezbpgot = shvzhzos.get_data()
                        
                        if tezbpgot is Dictionary:
                            if tezbpgot.has("error"):
                                printerr("Server error: ", tezbpgot["error"])
                                dninyqmi.emit(tezbpgot["error"])
                                jakthliy()
                                return
                            
                            if tezbpgot.has("done") and tezbpgot["done"] == true:
                                bypbulgi = false
                                                                
                                pkzlifbx.emit(
                                    int(tezbpgot.get("conversationId", -1)),
                                    int(tezbpgot.get("messageId", -1))
                                )
                                jakthliy()
                                
                            elif tezbpgot.has("beforeActions"):
                                wcnybufe.emit(
                                    int(tezbpgot.get("conversationId", -1)),
                                    int(tezbpgot.get("messageId", -1))
                                )
                                
                            elif tezbpgot.has("content"):
                                
                                if (typeof(tezbpgot.get("messageId")) != TYPE_INT and typeof(tezbpgot.get("messageId")) != TYPE_FLOAT) or (typeof(tezbpgot.get("conversationId")) != TYPE_INT and typeof(tezbpgot.get("conversationId")) != TYPE_FLOAT):
                                    print(tezbpgot.get("messageId"))
                                    print(tezbpgot.get("conversationId"))
                                    
                                    dninyqmi.emit("Invalid data coming from the server")
                                    jakthliy()
                                    return                                   
                            
                                ftrthtjf.emit(
                                    str(tezbpgot["content"]),
                                    int(tezbpgot.get("conversationId", -1)),
                                    int(tezbpgot.get("messageId", -1))
                                )
                        
                                               
    qogqbzbl = hjzeobho[hjzeobho.size() - 1]
    
func jakthliy():  
    bypbulgi = false  
    xcszqvoy.close()            

                                                                  
func jdlbsgeg(hmoapcqs: bool = false):
    var ryqnffql = EditorInterface.get_editor_settings()       
    var harycjyp = ryqnffql.get_setting("gamedev_assistant/version_identifier")
    
    var vgwxucaw = {
        "releaseUniqueIdentifier": harycjyp,
        "isInit": hmoapcqs
    }
    var rnucgrqo = JSON.new()
    var xczlzmwc = rnucgrqo.stringify(vgwxucaw)
    var vrctramw = jkbnpofk.request(xssmyxvi, ncgbyzqp(), HTTPClient.METHOD_POST, xczlzmwc)

                                            
func ilxhqpeg(zxvozkuh, izccrjkv, qboxprjj, pmbfdcsi):
    if zxvozkuh != HTTPRequest.RESULT_SUCCESS:
        sfbkqhmh.emit("[GameDev Assistant] Network error when checking for updates (Code: " + str(zxvozkuh) + ")")
        return
        
    var eoryrvhk = srqdgqll(pmbfdcsi)
    if not eoryrvhk is Dictionary:
        sfbkqhmh.emit("[GameDev Assistant] Response error when checking for updates (Code: " + str(izccrjkv) + ")")
        return
    
    if izccrjkv == 200:
        var avoczuuf = eoryrvhk.get("updateAvailable", false)
        var xenvvvwf = eoryrvhk.get("latestVersion", "")
        
        twuqtije.emit(avoczuuf, xenvvvwf)
    else:
        sfbkqhmh.emit(eoryrvhk.get("error", "Response code: " + str(izccrjkv)))

func uzwyvavv(tuiynzai: int, ncpzlqfp: bool, azxlrjeg: String):
    var gscekwuy = {
        "messageId": tuiynzai,
        "success": ncpzlqfp,
        "action_type": azxlrjeg
    }
    qwrvgcjk.append(gscekwuy)
    xtfjalsx()

                             
func xtfjalsx():
    var client_status = zlzmivaw.get_http_client_status()
                                                                                      
    if (client_status == HTTPClient.STATUS_DISCONNECTED or 
        client_status == HTTPClient.STATUS_CANT_RESOLVE or 
        client_status == HTTPClient.STATUS_CANT_CONNECT or 
        client_status == HTTPClient.STATUS_CONNECTION_ERROR or 
        client_status == HTTPClient.STATUS_TLS_HANDSHAKE_ERROR) and qwrvgcjk.size() > 0:
        
        var aftamagh = qwrvgcjk.pop_front()
        var tbtuvutw = JSON.new()
        var afefaftx = tbtuvutw.stringify(aftamagh)
        var zryhixsj = ncgbyzqp()
        var goxrxvaj = zlzmivaw.request(soytbxhc, zryhixsj, HTTPClient.METHOD_POST, afefaftx)
        if goxrxvaj != OK:
            printerr("Failed to start track action request:", goxrxvaj)
            xtfjalsx()                                  

func pjiflleu(txucggbj, mczdqiru, owfehveq, ldhngega):
    xtfjalsx()                                      
    if txucggbj != HTTPRequest.RESULT_SUCCESS:
        printerr("[GameDev Assistant] Track action failed:", txucggbj)
        return
        
    var tlauiwol = srqdgqll(ldhngega)
    if not tlauiwol is Dictionary:
        printerr("[GameDev Assistant] Invalid track action response")

func zghjdkyc(brzzsgfi: int, numoabsu: int) -> void:
    var ogbbfqxh = {
        "messageId": brzzsgfi,
        "rating": numoabsu
    }
    var frgsswld = JSON.new()
    var uhavjajc = frgsswld.stringify(ogbbfqxh)
    var xeqysdef = ncgbyzqp()
    var ggabpgdo = aysxneoc.request(phdbuquv, xeqysdef, HTTPClient.METHOD_POST, uhavjajc)
    if ggabpgdo != OK:
        printerr("[GameDev Assistant] Failed to track rating:", ggabpgdo)

                                          
func jmdcypds(tiemuttm, ovkjuirp, fqsntpss, qmjlgnob):
    if tiemuttm != HTTPRequest.RESULT_SUCCESS:
        printerr("[GameDev Assistant] Rating action failed:", tiemuttm)
        return
        
    var ktlblrae = srqdgqll(qmjlgnob)
    if not ktlblrae is Dictionary:
        printerr("[GameDev Assistant] Invalid rating response")
        return

func xipzctnj():
    return bypbulgi
