                                                       
@tool
extends GDAScreenBase

signal fkmoxfvn

var czeyzffj : RichTextLabel = null

@onready var erjrtscn : TextEdit = $Footer/PromptInput
@onready var exuvqjlx : Button = $Footer/SendPromptButton
@onready var pdzsrwpv : Control = $Footer
@onready var smpgxmqm : Control = $Body

@onready var wzlddwzm = $"../APIManager"
@onready var ocxvgkpe = $"../ActionManager"

var fvckuwot = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_UserPrompt.tscn")
var fjtzpwfk = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ServerResponse.tscn")
var wemcuswr = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ErrorMessage.tscn")
const sricjaop = preload("res://addons/gamedev_assistant/scripts/chat/markdown_to_bbcode.gd")
var kgjgtebq = preload("res://addons/gamedev_assistant/scripts/chat/message_tagger.gd").new()
var hajsllxx = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_CodeBlockResponse.tscn")
var lupyjkdd = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_CodeBlockUser.tscn")
var fudrrwhl = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_Spacing.tscn")

var pyudptdw := false
var yajfrxrf: String = ""

var amdabamb : String = ""
var yaamljsk : String = ""
var bfktmuei : int = -1

@onready var hjlpqakv = $Body/MessagesContainer
@onready var oobbxzgr = $Body/MessagesContainer/ThinkingLabel
@onready var faxirstk = $Bottom/AddContext
@onready var vlanixhz : CheckButton = $Bottom/ReasoningToggle
@onready var hujscpaq = $Body/MessagesContainer/RatingContainer
@onready var ovzieyqi = $Bottom/Mode

@onready var jjoloqhg = preload("res://addons/gamedev_assistant/dock/icons/stop.png")  
@onready var qwcpvnik = preload("res://addons/gamedev_assistant/dock/icons/arrowUp.png")  

var swnpgahg = [
    "",
    " @OpenScripts ",
    " @Output ",
    " @Docs ",
    " @GitDiff ",
    " @ProjectSettings"
]

@onready var ebwglefh = $"../ConversationManager"

var waiting_nonthinking = "Thinking ⚡"
var waiting_thinking = "Reasoning ⌛ This could take multiple minutes"

var notice_actions_nonthinking = "Generating one-click actions ⌛ To skip, press ■"
var notice_actions_thinking = "Generating one-click actions ⌛ To skip, press ■"


func _ready ():
    wzlddwzm.hzirqcnv.connect(ypyadrin)
    wzlddwzm.llomxgxn.connect(llrvvudo)
    
    ebwglefh.hkneviuc.connect(qbkbspgc)
    erjrtscn.ssobifaj.connect(mdyswjax)
    
                       
    wzlddwzm.wwtvhcet.connect(eggoaiaf)
    wzlddwzm.yppgawpt.connect(dzxzffxx)
    wzlddwzm.vpxrehwk.connect(turwatrw)
    wzlddwzm.xfnerllx.connect(polfpjub)

    faxirstk.item_selected.connect(rthirehe)    
    exuvqjlx.pressed.connect(ktyvcdrm)   
    
    hujscpaq.get_node("UpButton").pressed.connect(ybfmhvpd)
    hujscpaq.get_node("DownButton").pressed.connect(jiptkprp)
    hujscpaq.visible = false 

func _on_open ():
    erjrtscn.text = ""
    oobbxzgr.visible = false
    hujscpaq.visible = false 
    hjcyyhcf(false)
    pzdasgfy()
    faxirstk.selected = 0
    yajfrxrf = ''
    

                                                            
func hahtuttl ():
    pyudptdw = true
    hjcyyhcf(true)
    bfktmuei = -1
    hujscpaq.visible = false

func eggoaiaf(apvqzcum: String, vfaobovf: int, kybznuqd: int) -> void:
    if czeyzffj == null:
        czeyzffj = fjtzpwfk.instantiate()
        czeyzffj.bbcode_enabled = true
        hjlpqakv.add_child(czeyzffj)
        var hhxlaels = fudrrwhl.instantiate()
        hjlpqakv.add_child(hhxlaels)
        oobbxzgr.visible = false
        yajfrxrf = apvqzcum
        
        if kybznuqd != -1:
            bfktmuei = kybznuqd
    else:
        yajfrxrf += apvqzcum
        
                                                  
    czeyzffj.text = sricjaop.qnpuilvf(yajfrxrf)
    
                                                                     
    if not czeyzffj.meta_clicked.is_connected(gamdacjx):  
        czeyzffj.meta_clicked.connect(gamdacjx)  
    
    if vfaobovf > 0:
        ebwglefh.munwvrah(vfaobovf)

func turwatrw(avhijtcy: int, vlfixdyx: int) -> void:
    if czeyzffj:
        czeyzffj.visible = false

                                                                
    exxkptst(yajfrxrf, fjtzpwfk, hjlpqakv, hajsllxx)
    
                              
    hjlpqakv.move_child(oobbxzgr, hjlpqakv.get_child_count() - 1)
    oobbxzgr.visible = true
    oobbxzgr.text = notice_actions_nonthinking

func dzxzffxx(lysggbds: int, wedcbxjo: int) -> void:
                                         
    if czeyzffj:
        czeyzffj.queue_free()
        czeyzffj = null
        
    oobbxzgr.visible = false
    
                                                    
    hjlpqakv.move_child(hujscpaq, hjlpqakv.get_child_count() - 1)
    hujscpaq.visible = wedcbxjo > 0
    
                          
    var sfesydvz = ocxvgkpe.myydjctb(yajfrxrf, wedcbxjo)
    ocxvgkpe.qycsmath(sfesydvz, hjlpqakv)

    yajfrxrf = ""
    hjcyyhcf(true)
    oobbxzgr.visible = false
    exuvqjlx.icon = qwcpvnik

func polfpjub(bbcbxcym: String):
    rdlkblug(bbcbxcym)
    hjcyyhcf(true)
    oobbxzgr.visible = false
    czeyzffj = null
    exuvqjlx.icon = qwcpvnik

func ktyvcdrm():  
    if wzlddwzm.gofbguxw():  
                                         
        wzlddwzm.hnsdgzcf.emit()  
        
                                             
        if czeyzffj:
            czeyzffj.queue_free()
            czeyzffj = null
        
        hjcyyhcf(true)  
        exuvqjlx.icon = qwcpvnik  
        
        if not oobbxzgr.visible:
                                                                        
            exxkptst(yajfrxrf, fjtzpwfk, hjlpqakv, hajsllxx)
        
        oobbxzgr.visible = false  
        
                                                   
        hjlpqakv.move_child(hujscpaq, hjlpqakv.get_child_count() - 1)
        hujscpaq.visible = bfktmuei > 0

    else:  
                                             
        kdfhixuo()  

func kdfhixuo():
                                                        
    ocxvgkpe.ykwmhucf()
    
    hujscpaq.visible = false
    
    bfktmuei = -1
    
    if len(erjrtscn.text) < 1:
        return
    
    var aodnwpwu = erjrtscn.text

                                                        
    if ujluevud() or pyudptdw:
        aodnwpwu += yaamljsk
        amdabamb = yaamljsk
    
    pyudptdw = false

    if Engine.is_editor_hint():
        var bdpdghie = Engine.get_singleton("EditorInterface")
        aodnwpwu = kgjgtebq.xfdwfunp(aodnwpwu, bdpdghie)
    
    var tfioxtti = vlanixhz.button_pressed
    var sforcjoj : int = ovzieyqi.selected
    var lllkivhc : String
    
    if sforcjoj == 0:
        lllkivhc = "CHAT"
    else:
        lllkivhc = "AGENT"        
    
    wzlddwzm.tnfxwjoj(aodnwpwu, tfioxtti, lllkivhc)
    zovndkjj(erjrtscn.text)                               
    hjcyyhcf(false)
    erjrtscn.text = ""
    
    if tfioxtti:
        oobbxzgr.text = waiting_thinking
    else:
        oobbxzgr.text = waiting_nonthinking
        
    oobbxzgr.visible = true
    hjlpqakv.move_child(oobbxzgr, hjlpqakv.get_child_count() - 1)
    
                                               
    fkmoxfvn.emit()
    
func hjcyyhcf (nvbhvgmj : bool):
    if nvbhvgmj:  
        exuvqjlx.icon = qwcpvnik  
    else:  
        exuvqjlx.icon = jjoloqhg  

func ypyadrin (wyaxzlyy : String, mlnwsjaj : int):
    uqxczahv(wyaxzlyy)
    hjcyyhcf(true)
    oobbxzgr.visible = false

func llrvvudo (rhmihstq : String):
    rdlkblug(rhmihstq)
    hjcyyhcf(true)
    oobbxzgr.visible = false

func zovndkjj(dtikcxli: String):
                                                                               
    exxkptst(dtikcxli, fvckuwot, hjlpqakv, lupyjkdd)
    
    var zirausqx = fudrrwhl.instantiate()
    hjlpqakv.add_child(zirausqx)


func uqxczahv(tvlrmmpt: String):
                                                                                
    exxkptst(tvlrmmpt, fjtzpwfk, hjlpqakv, hajsllxx)
    
    var bcvvpolj = fudrrwhl.instantiate()
    hjlpqakv.add_child(bcvvpolj)

func rdlkblug (hoixxzpf : String):
    var sxxsxwwh = wemcuswr.instantiate()
    hjlpqakv.add_child(sxxsxwwh)
    sxxsxwwh.text = hoixxzpf

func pzdasgfy ():
    for node in hjlpqakv.get_children():
        if node == oobbxzgr or node == hujscpaq:
            continue
        node.queue_free()
    hjlpqakv.custom_minimum_size = Vector2.ZERO
    
    fkmoxfvn.emit()
    
                  
    kgjgtebq.yhdpphxg()

func qbkbspgc ():
    var tvzjtvep = ebwglefh.nlkrcvov()
    pzdasgfy()
    
    for msg in tvzjtvep.messages:
        if msg.role == "user":
            zovndkjj(msg.content)
        elif msg.role == "assistant":
            uqxczahv(msg.content)
    
    hjcyyhcf(true)

func rthirehe(tcnhzkps: int):
    if tcnhzkps >= 0 and tcnhzkps < swnpgahg.size():
        erjrtscn.text += " " + swnpgahg[tcnhzkps]
        faxirstk.select(0)

func gamdacjx(uevyuzht):
    OS.shell_open(str(uevyuzht))

                                                
func lywqnvev(idcdgiam: String) -> String:
    
    var uyreucqs = RegEx.new()
                                 
    uyreucqs.compile("\\[gds_context\\](.|\\n)*?\\[/gds_context\\]")
    idcdgiam = uyreucqs.sub(idcdgiam, "", true)
    
                                       
    uyreucqs.compile("<internal_tool_use>(.|\\n)*?</internal_tool_use>")
    return uyreucqs.sub(idcdgiam, "", true)
    
                                                
func wjtwoqcp(gnnbtthr: String) -> String:
        
    var kuiobqud = RegEx.new()
    kuiobqud.compile("\\[gds_actions\\](.|\\n)*?\\[/gds_actions\\]")
    return kuiobqud.sub(gnnbtthr, "", true)

func rlzpkveq(izrmgkro: String):
    izrmgkro = izrmgkro.replace(notice_actions_nonthinking, '').replace(notice_actions_thinking, '').strip_edges()
    return izrmgkro
    
func exxkptst(jrwcfgbe: String, xafrezsk: PackedScene, akquzsns: Node, rnmeeuuz: PackedScene) -> void:
    
    jrwcfgbe = jrwcfgbe.strip_edges()
    jrwcfgbe = lywqnvev(jrwcfgbe)
    
                       
    var snrumnoq = sricjaop.axxubega(jrwcfgbe)

    for block in snrumnoq:
        if block["type"] == "text":
            var rfqyfdrr = xafrezsk.instantiate()
            rfqyfdrr.bbcode_enabled = true
            akquzsns.add_child(rfqyfdrr)
            
            var bbdcnnvf = block["content"]
            
                                                      
            bbdcnnvf = sricjaop.ygcavxvl(bbdcnnvf)
            bbdcnnvf = sricjaop.qhmdrvae(bbdcnnvf)
            bbdcnnvf = bbdcnnvf.strip_edges()
            
            rfqyfdrr.text = bbdcnnvf

                                 
            if not rfqyfdrr.meta_clicked.is_connected(gamdacjx):
                rfqyfdrr.meta_clicked.connect(gamdacjx)

        elif block["type"] == "code":
            var luuqlgif = rnmeeuuz.instantiate()
            akquzsns.add_child(luuqlgif)
            luuqlgif.text = block["content"]

                           
func ujluevud() -> bool:
                                                           
    var qukfjrwb = Engine.get_singleton("EditorInterface") if Engine.is_editor_hint() else null
    var wobfktjy = kgjgtebq.anynpniy("", qukfjrwb)
    var wqtbqkul = kgjgtebq.oxlhfsoz("", qukfjrwb)
        
                                            
    yaamljsk = "[gds_context]Current project context:[/gds_context]\n" + wobfktjy + "\n" + wqtbqkul
    
                                        
    return yaamljsk != amdabamb

                               
func mdyswjax() -> void:
    var viflhbbg = not wzlddwzm.gofbguxw()
    if viflhbbg:
        kdfhixuo()
        
func ybfmhvpd():
    if bfktmuei > 0:
        wzlddwzm.ulkedylb(bfktmuei, 5)
        hujscpaq.visible = false                     

func jiptkprp():
    if bfktmuei > 0:
        wzlddwzm.ulkedylb(bfktmuei, 1)
        hujscpaq.visible = false
