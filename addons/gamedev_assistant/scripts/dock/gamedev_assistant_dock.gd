                                         
@tool
extends Control

@onready var czvrmeki = $Screen_Conversations
@onready var kgiubxbz = $Screen_Chat
@onready var chrymfpa = $Screen_Settings

@onready var aviihypd = $Header/HBoxContainer/ConversationsButton
@onready var piadpopr = $Header/ChatButton
@onready var qijjbwrw = $Header/HBoxContainer/SettingsButton
@onready var eqsybxmr = $Header/ScreenText

@onready var jxwfrrbl = $ConversationManager
@onready var bbstowdm = $APIManager

                                          
var kjdeyuar : bool = false

                                                    
var jqkegowu : bool = false

func _ready():
    bytpyagv(false)
    
                                       
    bbstowdm.twuqtije.connect(xfqxtfhe)
    bbstowdm.sfbkqhmh.connect(xfqxtfhe)
    
                                   
    piadpopr.pressed.connect(xhiydicj)
    qijjbwrw.pressed.connect(aqbyotoi)
    aviihypd.pressed.connect(unqilsui)
    
    var lnsmkwcc = EditorInterface.get_editor_settings()
    
                                        
    var vefutlvf = lnsmkwcc.has_setting("gamedev_assistant/development_mode") and lnsmkwcc.get_setting('gamedev_assistant/development_mode') == true    
    if vefutlvf:
        qhdpwqkg()
    
    if lnsmkwcc.has_setting("gamedev_assistant/validated"):
        if lnsmkwcc.get_setting("gamedev_assistant/validated") == true:
            xhiydicj()
            bytpyagv(true)
                        
                                                             
            bbstowdm.jdlbsgeg(true)
            return
                                          
    elif !lnsmkwcc.has_setting("gamedev_assistant/onboarding_shown"):
        qhdpwqkg()
        lnsmkwcc.set_setting("gamedev_assistant/onboarding_shown", true)
        
    ggyfzpsq(chrymfpa, "Settings")

func ggyfzpsq (jznzjzya, sfmqpara):
    czvrmeki.visible = false
    kgiubxbz.visible = false
    chrymfpa.visible = false
    
                                                 
    jznzjzya.visible = true
    jznzjzya._on_open()
    
    eqsybxmr.text = sfmqpara
    
    jqkegowu = jznzjzya == kgiubxbz
    
                       
    bbstowdm.mtqlfuui.emit()
    
                                                                
                                                           
                                       

func unqilsui():
    ggyfzpsq(czvrmeki, "Conversations")

func xhiydicj():
    jxwfrrbl.hesusofv()
    ggyfzpsq(kgiubxbz, "New Conversation")
    kgiubxbz.osrlnken()
    bbstowdm.mtqlfuui.emit()

func aqbyotoi():
    if chrymfpa.visible:
        return
    
    ggyfzpsq(chrymfpa, "Settings")

func fzvzkjay (iiwqnqvr : Conversation):
    jxwfrrbl.kwdxqevp(iiwqnqvr.id)
    ggyfzpsq(kgiubxbz, "Chat")

func bytpyagv (ioppanwu : bool):
    kjdeyuar = ioppanwu
    piadpopr.disabled = !ioppanwu
    aviihypd.disabled = !ioppanwu
    
                                                               
func xfqxtfhe(nqfrmxqh, param2 = ""):
                                                                                       
                                                            
    
    var qjwcqlwr = AcceptDialog.new()
    qjwcqlwr.get_ok_button().text = "Close"
    
                                                                                 
    if nqfrmxqh is bool:
                                                             
        var kxujdawg = nqfrmxqh
        var uhcxtnhk = param2
        
                                                   
        if kxujdawg:
            qjwcqlwr.title = "GameDev Assistant Update"
            qjwcqlwr.dialog_text = "An update is available! Latest version: " + uhcxtnhk + ". Go to https://app.gamedevassistant.com to download it."
            add_child(qjwcqlwr)
            qjwcqlwr.popup_centered()
    else:
                                                           
        var lrkhzlsb = nqfrmxqh
        qjwcqlwr.title = "GameDev Assistant Update"
        qjwcqlwr.dialog_text = lrkhzlsb
        add_child(qjwcqlwr)
        qjwcqlwr.popup_centered()

func qhdpwqkg():
    var vktywbtv = AcceptDialog.new()
    vktywbtv.title = "Welcome Aboard! 🚀"
    vktywbtv.dialog_text = "Welcome to GameDev Assistant by Zenva!\n\n🌟 To get started:\n1. Find the Assistant tab (next to Inspector, Node, etc, use arrows < > to find it)\n2. Enter your token in Settings\n3. Start a chat with the + button\n4. Switch between Chat and Agent mode to find your perfect workflow\n\n\nHappy gamedev! 🎮"
    vktywbtv.ok_button_text = "Close"
    vktywbtv.dialog_hide_on_ok = true
    add_child(vktywbtv)
    vktywbtv.popup_centered()

func xycvtxxl():
    return jxwfrrbl
