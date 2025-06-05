                                                       
@tool
extends GDAScreenBase

signal pziaofdl

var vokflrrh : RichTextLabel = null

@onready var ybwakrdp : TextEdit = $Footer/PromptInput
@onready var mhuvddox : Button = $Footer/SendPromptButton
@onready var frqrdbjh : Control = $Footer
@onready var iuqfmugb : Control = $Body

@onready var puedohxc = $"../APIManager"
@onready var bwlomwos = $"../ActionManager"

var uotmmfwz = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_UserPrompt.tscn")
var tixlfpxn = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ServerResponse.tscn")
var vprmmolh = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ErrorMessage.tscn")
const vvarenol = preload("res://addons/gamedev_assistant/scripts/chat/markdown_to_bbcode.gd")
var fykxmbrz = preload("res://addons/gamedev_assistant/scripts/chat/message_tagger.gd").new()
var wfsttqta = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_CodeBlockResponse.tscn")
var bisfbecj = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_CodeBlockUser.tscn")
var royzjtwb = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_Spacing.tscn")

var jfnpmhsu := false
var htpmaksb: String = ""

var lpdhziky : String = ""
var xbqhsrza : String = ""
var urppfktq : int = -1

@onready var lxtustpo = $Body/MessagesContainer
@onready var yoxxytpp = $Body/MessagesContainer/ThinkingLabel
@onready var jqgktpxf = $Bottom/AddContext
@onready var vxnhdsgu : CheckButton = $Bottom/ReasoningToggle
@onready var ucqbrwhy = $Body/MessagesContainer/RatingContainer
@onready var gcwmkben = $Bottom/Mode

@onready var qhpgkogf = preload("res://addons/gamedev_assistant/dock/icons/stop.png")  
@onready var erlvsjnx = preload("res://addons/gamedev_assistant/dock/icons/arrowUp.png")  

var xtfvuneh = [
    "",
    " @OpenScripts ",
    " @Output ",
    " @Docs ",
    " @GitDiff ",
    " @ProjectSettings"
]

@onready var vlyxketr = $"../ConversationManager"

var waiting_nonthinking = "Thinking ⚡"
var waiting_thinking = "Reasoning ⌛ This could take multiple minutes"

var notice_actions_nonthinking = "Generating one-click actions ⌛ To skip, press ■"
var notice_actions_thinking = "Generating one-click actions ⌛ To skip, press ■"


func _ready ():
    puedohxc.oyedrfpg.connect(otdxesjl)
    puedohxc.eqpgenrs.connect(dgsnhzyz)
    
    vlyxketr.kriazboy.connect(rzktyrjt)
    ybwakrdp.duoyzqnp.connect(jkpcvmcl)
    
                       
    puedohxc.ftrthtjf.connect(eedptumi)
    puedohxc.pkzlifbx.connect(gkkqhehm)
    puedohxc.wcnybufe.connect(nkydlysx)
    puedohxc.dninyqmi.connect(eydktiqf)

    jqgktpxf.item_selected.connect(llzfzajr)    
    mhuvddox.pressed.connect(jrbjhagr)   
    
    ucqbrwhy.get_node("UpButton").pressed.connect(itbbmpmb)
    ucqbrwhy.get_node("DownButton").pressed.connect(ssuhjzug)
    ucqbrwhy.visible = false 

func _on_open ():
    ybwakrdp.text = ""
    yoxxytpp.visible = false
    ucqbrwhy.visible = false 
    pgwwwmhq(false)
    xwqirzou()
    jqgktpxf.selected = 0
    htpmaksb = ''
    

                                                            
func osrlnken ():
    jfnpmhsu = true
    pgwwwmhq(true)
    urppfktq = -1
    ucqbrwhy.visible = false

func eedptumi(exzrabwz: String, xakkkjuh: int, owdhdmbf: int) -> void:
    if vokflrrh == null:
        vokflrrh = tixlfpxn.instantiate()
        vokflrrh.bbcode_enabled = true
        lxtustpo.add_child(vokflrrh)
        var bgoqstgw = royzjtwb.instantiate()
        lxtustpo.add_child(bgoqstgw)
        yoxxytpp.visible = false
        htpmaksb = exzrabwz
        
        if owdhdmbf != -1:
            urppfktq = owdhdmbf
    else:
        htpmaksb += exzrabwz
        
                                                  
    vokflrrh.text = vvarenol.uzzbwgfu(htpmaksb)
    
                                                                     
    if not vokflrrh.meta_clicked.is_connected(futrhqwm):  
        vokflrrh.meta_clicked.connect(futrhqwm)  
    
    if xakkkjuh > 0:
        vlyxketr.xvdrbrfl(xakkkjuh)

func nkydlysx(yrqjkamu: int, svjmlnej: int) -> void:
    if vokflrrh:
        vokflrrh.visible = false

                                                                
    qcvoehji(htpmaksb, tixlfpxn, lxtustpo, wfsttqta)
    
                              
    lxtustpo.move_child(yoxxytpp, lxtustpo.get_child_count() - 1)
    yoxxytpp.visible = true
    yoxxytpp.text = notice_actions_nonthinking

func gkkqhehm(guyslsfv: int, gpvlximj: int) -> void:
                                         
    if vokflrrh:
        vokflrrh.queue_free()
        vokflrrh = null
        
    yoxxytpp.visible = false
    
                                                    
    lxtustpo.move_child(ucqbrwhy, lxtustpo.get_child_count() - 1)
    ucqbrwhy.visible = gpvlximj > 0
    
                          
    var hqeppzwl = bwlomwos.qbjvmbra(htpmaksb, gpvlximj)
    bwlomwos.mczzzfds(hqeppzwl, lxtustpo)

    htpmaksb = ""
    pgwwwmhq(true)
    yoxxytpp.visible = false
    mhuvddox.icon = erlvsjnx

func eydktiqf(ivlkxpmc: String):
    xmiizsak(ivlkxpmc)
    pgwwwmhq(true)
    yoxxytpp.visible = false
    vokflrrh = null
    mhuvddox.icon = erlvsjnx

func jrbjhagr():  
    if puedohxc.xipzctnj():  
                                         
        puedohxc.mtqlfuui.emit()  
        
                                             
        if vokflrrh:
            vokflrrh.queue_free()
            vokflrrh = null
        
        pgwwwmhq(true)  
        mhuvddox.icon = erlvsjnx  
        
        if not yoxxytpp.visible:
                                                                        
            qcvoehji(htpmaksb, tixlfpxn, lxtustpo, wfsttqta)
        
        yoxxytpp.visible = false  
        
                                                   
        lxtustpo.move_child(ucqbrwhy, lxtustpo.get_child_count() - 1)
        ucqbrwhy.visible = urppfktq > 0

    else:  
                                             
        lwkljnvj()  

func lwkljnvj():
                                                        
    bwlomwos.qqrpuwbw()
    
    ucqbrwhy.visible = false
    
    urppfktq = -1
    
    if len(ybwakrdp.text) < 1:
        return
    
    var pwnsvlhh = ybwakrdp.text

                                                        
    if tmshydun() or jfnpmhsu:
        pwnsvlhh += xbqhsrza
        lpdhziky = xbqhsrza
    
    jfnpmhsu = false

    if Engine.is_editor_hint():
        var gkyvrcek = Engine.get_singleton("EditorInterface")
        pwnsvlhh = fykxmbrz.ogqmymeh(pwnsvlhh, gkyvrcek)
    
    var ewabhidc = vxnhdsgu.button_pressed
    var hdxvotog : int = gcwmkben.selected
    var kyrpaptg : String
    
    if hdxvotog == 0:
        kyrpaptg = "CHAT"
    else:
        kyrpaptg = "AGENT"        
    
    puedohxc.pmlqzimx(pwnsvlhh, ewabhidc, kyrpaptg)
    bhhhjfzh(ybwakrdp.text)                               
    pgwwwmhq(false)
    ybwakrdp.text = ""
    
    if ewabhidc:
        yoxxytpp.text = waiting_thinking
    else:
        yoxxytpp.text = waiting_nonthinking
        
    yoxxytpp.visible = true
    lxtustpo.move_child(yoxxytpp, lxtustpo.get_child_count() - 1)
    
                                               
    pziaofdl.emit()
    
func pgwwwmhq (jdmajoev : bool):
    if jdmajoev:  
        mhuvddox.icon = erlvsjnx  
    else:  
        mhuvddox.icon = qhpgkogf  

func otdxesjl (looczrfc : String, bzfgpvlt : int):
    znacilgr(looczrfc)
    pgwwwmhq(true)
    yoxxytpp.visible = false

func dgsnhzyz (dtxbicft : String):
    xmiizsak(dtxbicft)
    pgwwwmhq(true)
    yoxxytpp.visible = false

func bhhhjfzh(yuwzcbvs: String):
                                                                               
    qcvoehji(yuwzcbvs, uotmmfwz, lxtustpo, bisfbecj)
    
    var xldzlvlo = royzjtwb.instantiate()
    lxtustpo.add_child(xldzlvlo)


func znacilgr(cwytltca: String):
                                                                                
    qcvoehji(cwytltca, tixlfpxn, lxtustpo, wfsttqta)
    
    var ptfcdakc = royzjtwb.instantiate()
    lxtustpo.add_child(ptfcdakc)

func xmiizsak (eyqcsjkv : String):
    var pbdoyqev = vprmmolh.instantiate()
    lxtustpo.add_child(pbdoyqev)
    pbdoyqev.text = eyqcsjkv

func xwqirzou ():
    for node in lxtustpo.get_children():
        if node == yoxxytpp or node == ucqbrwhy:
            continue
        node.queue_free()
    lxtustpo.custom_minimum_size = Vector2.ZERO
    
    pziaofdl.emit()

func rzktyrjt ():
    var xhofeikm = vlyxketr.pirnmejx()
    xwqirzou()
    
    for msg in xhofeikm.messages:
        if msg.role == "user":
            bhhhjfzh(msg.content)
        elif msg.role == "assistant":
            znacilgr(msg.content)
    
    pgwwwmhq(true)

func llzfzajr(tjgzaxzb: int):
    if tjgzaxzb >= 0 and tjgzaxzb < xtfvuneh.size():
        ybwakrdp.text += " " + xtfvuneh[tjgzaxzb]
        jqgktpxf.select(0)

func futrhqwm(npiidfis):
    OS.shell_open(str(npiidfis))

                                                
func xzlptjcl(lpdnfxiz: String) -> String:
    
    var ytvfyjwd = RegEx.new()
                                 
    ytvfyjwd.compile("\\[gds_context\\](.|\\n)*?\\[/gds_context\\]")
    lpdnfxiz = ytvfyjwd.sub(lpdnfxiz, "", true)
    
                                       
    ytvfyjwd.compile("<internal_tool_use>(.|\\n)*?</internal_tool_use>")
    return ytvfyjwd.sub(lpdnfxiz, "", true)
    
                                                
func qkhkeqrx(okbnpcfu: String) -> String:
        
    var rmtovtrf = RegEx.new()
    rmtovtrf.compile("\\[gds_actions\\](.|\\n)*?\\[/gds_actions\\]")
    return rmtovtrf.sub(okbnpcfu, "", true)

func zcitxjws(wlqermrv: String):
    wlqermrv = wlqermrv.replace(notice_actions_nonthinking, '').replace(notice_actions_thinking, '').strip_edges()
    return wlqermrv
    
func qcvoehji(vfddawhg: String, jeuvsykk: PackedScene, zzmdozcr: Node, xopspfkw: PackedScene) -> void:
    
    vfddawhg = vfddawhg.strip_edges()
    vfddawhg = xzlptjcl(vfddawhg)
    
                       
    var tbgtvxnl = vvarenol.xkrwhgvx(vfddawhg)

    for block in tbgtvxnl:
        if block["type"] == "text":
            var phdevhah = jeuvsykk.instantiate()
            phdevhah.bbcode_enabled = true
            zzmdozcr.add_child(phdevhah)
            
            var kjuzufws = block["content"]
            
                                                      
            kjuzufws = vvarenol.mwqxpujh(kjuzufws)
            kjuzufws = vvarenol.goaqikeh(kjuzufws)
            kjuzufws = kjuzufws.strip_edges()
            
            phdevhah.text = kjuzufws

                                 
            if not phdevhah.meta_clicked.is_connected(futrhqwm):
                phdevhah.meta_clicked.connect(futrhqwm)

        elif block["type"] == "code":
            var fyrgqafk = xopspfkw.instantiate()
            zzmdozcr.add_child(fyrgqafk)
            fyrgqafk.text = block["content"]

                           
func tmshydun() -> bool:
                                                           
    var usqxyeze = Engine.get_singleton("EditorInterface") if Engine.is_editor_hint() else null
    var dmsvzcma = fykxmbrz.wxcnmyxj("", usqxyeze)
    var hikffkmw = fykxmbrz.tzjhcems("", usqxyeze)
        
                                            
    xbqhsrza = "[gds_context]Current project context:[/gds_context]\n" + dmsvzcma + "\n" + hikffkmw
    
                                        
    return xbqhsrza != lpdhziky

                               
func jkpcvmcl() -> void:
    var crifcdsh = not puedohxc.xipzctnj()
    if crifcdsh:
        lwkljnvj()
        
func itbbmpmb():
    if urppfktq > 0:
        puedohxc.zghjdkyc(urppfktq, 5)
        ucqbrwhy.visible = false                     

func ssuhjzug():
    if urppfktq > 0:
        puedohxc.zghjdkyc(urppfktq, 1)
        ucqbrwhy.visible = false
