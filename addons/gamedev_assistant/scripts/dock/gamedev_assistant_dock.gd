                                         
@tool
extends Control

@onready var wmxtpwoe = $Screen_Conversations
@onready var plfiyzzq = $Screen_Chat
@onready var lrlmdgwm = $Screen_Settings

@onready var damfetzs = $Header/HBoxContainer/ConversationsButton
@onready var sluizpyo = $Header/ChatButton
@onready var anddjebk = $Header/HBoxContainer/SettingsButton
@onready var rxjhknlm = $Header/ScreenText

@onready var vjeipgnn = $ConversationManager
@onready var pegbxzmr = $APIManager

                                          
var rbepeloh : bool = false

                                                    
var dmeckvgu : bool = false

func _ready():
    jrqichgu(false)
    
                                       
    pegbxzmr.hmqqywkp.connect(byqyxqwq)
    pegbxzmr.tbojgdpj.connect(byqyxqwq)
    
                                   
    sluizpyo.pressed.connect(bibkqmtg)
    anddjebk.pressed.connect(iohmbouj)
    damfetzs.pressed.connect(albimnsg)
    
    var jywftlac = EditorInterface.get_editor_settings()
    
                                        
    var zexoshmv = jywftlac.has_setting("gamedev_assistant/development_mode") and jywftlac.get_setting('gamedev_assistant/development_mode') == true    
    if zexoshmv:
        xziwbbzr()
    
    if jywftlac.has_setting("gamedev_assistant/validated"):
        if jywftlac.get_setting("gamedev_assistant/validated") == true:
            bibkqmtg()
            jrqichgu(true)
                        
                                                             
            pegbxzmr.ezuczicd(true)
            return
                                          
    elif !jywftlac.has_setting("gamedev_assistant/onboarding_shown"):
        xziwbbzr()
        jywftlac.set_setting("gamedev_assistant/onboarding_shown", true)
        
    bbbkjcfj(lrlmdgwm, "Settings")

func bbbkjcfj (hrnhhjom, ftxkkway):
    wmxtpwoe.visible = false
    plfiyzzq.visible = false
    lrlmdgwm.visible = false
    
                                                 
    hrnhhjom.visible = true
    hrnhhjom._on_open()
    
    rxjhknlm.text = ftxkkway
    
    dmeckvgu = hrnhhjom == plfiyzzq
    
                       
    pegbxzmr.hnsdgzcf.emit()
    
                                                                
                                                           
                                       

func albimnsg():
    bbbkjcfj(wmxtpwoe, "Conversations")

func bibkqmtg():
    vjeipgnn.tydauhrq()
    bbbkjcfj(plfiyzzq, "New Conversation")
    plfiyzzq.hahtuttl()
    pegbxzmr.hnsdgzcf.emit()

func iohmbouj():
    if lrlmdgwm.visible:
        return
    
    bbbkjcfj(lrlmdgwm, "Settings")

func bekfohhm (avwvssbd : Conversation):
    vjeipgnn.bxehkmun(avwvssbd.id)
    bbbkjcfj(plfiyzzq, "Chat")

func jrqichgu (nfmsxune : bool):
    rbepeloh = nfmsxune
    sluizpyo.disabled = !nfmsxune
    damfetzs.disabled = !nfmsxune
    
                                                               
func byqyxqwq(lnjdfdwd, param2 = ""):
                                                                                       
                                                            
    
    var qhxzlosl = AcceptDialog.new()
    qhxzlosl.get_ok_button().text = "Close"
    
                                                                                 
    if lnjdfdwd is bool:
                                                             
        var rcngqskg = lnjdfdwd
        var sudqncoa = param2
        
                                                   
        if rcngqskg:
            qhxzlosl.title = "GameDev Assistant Update"
            qhxzlosl.dialog_text = "An update is available! Latest version: " + sudqncoa + ". Go to https://app.gamedevassistant.com to download it."
            add_child(qhxzlosl)
            qhxzlosl.popup_centered()
    else:
                                                           
        var xfasmuti = lnjdfdwd
        qhxzlosl.title = "GameDev Assistant Update"
        qhxzlosl.dialog_text = xfasmuti
        add_child(qhxzlosl)
        qhxzlosl.popup_centered()

func xziwbbzr():
    var wtngehdb = AcceptDialog.new()
    wtngehdb.title = "Welcome Aboard! 🚀"
    wtngehdb.dialog_text = "Welcome to GameDev Assistant by Zenva!\n\n🌟 To get started:\n1. Find the Assistant tab (next to Inspector, Node, etc, use arrows < > to find it)\n2. Enter your token in Settings\n3. Start a chat with the + button\n4. Switch between Chat and Agent mode to find your perfect workflow\n\n\nHappy gamedev! 🎮"
    wtngehdb.ok_button_text = "Close"
    wtngehdb.dialog_hide_on_ok = true
    add_child(wtngehdb)
    wtngehdb.popup_centered()

func gsfckmhq():
    return vjeipgnn
