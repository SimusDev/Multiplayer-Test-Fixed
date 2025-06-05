                                  
@tool
extends GDAScreenBase

var hlixzvoo : Label
var nxhjqypr : LineEdit
var frrvjksj : CheckButton
var twfoobgf : Button
var kwsdeixg : RichTextLabel
var ybyrkqvv : RichTextLabel
var okaqvhgj : RichTextLabel
var kttfvboz : Button
var pnagguij : LineEdit
var ejatvgrj : Button
var ojvchimn : Button
var nfroutrm : String

const olbpwale : String = "gamedev_assistant/hide_token"
const qybrthav : String = "gamedev_assistant/validated"
const ykpqbqxd : String = "gamedev_assistant/custom_instructions"

@onready var isldyfse = $".."
@onready var rhqxsgze = $"../APIManager"
@onready var zdeguswc = $"VBoxContainer/CustomInput"

var icbztfwn : bool

func _ready ():
    rhqxsgze.gsjjvznk.connect(_on_validate_token_received)
    rhqxsgze.twuqtije.connect(_on_check_updates_received)
    rhqxsgze.sfbkqhmh.connect(xtfcceon)
    
    pxobkehl()
    
                                             
    frrvjksj.toggled.connect(vmczujxc)
    twfoobgf.pressed.connect(awwcywlx)
    ejatvgrj.pressed.connect(xohkirhh)
    ojvchimn.pressed.connect(jqpwpbfo)
    nxhjqypr.text_changed.connect(hlvprcdt)
    
    kwsdeixg.visible = false
    ybyrkqvv.visible = false
    okaqvhgj.visible = false
    
    var jjagwexe = EditorInterface.get_editor_settings()       
    
    jjagwexe.set_setting("gamedev_assistant/version_identifier", "94KDH6BN1D")
    
    icbztfwn = jjagwexe.has_setting("gamedev_assistant/development_mode") and jjagwexe.get_setting('gamedev_assistant/development_mode') == true    
    if not icbztfwn:
        jjagwexe.set_setting("gamedev_assistant/endpoint", "https://app.gamedevassistant.com")
        nfroutrm = "gamedev_assistant/token"
    else:
        jjagwexe.set_setting("gamedev_assistant/endpoint", "http://localhost:3000")
        nfroutrm = "gamedev_assistant/token_dev"
        print("Development mode")
        
    rhqxsgze.chutmtuw()
    
                                                                         
                                                  
func pxobkehl ():
    hlixzvoo = $VBoxContainer/EnterTokenPrompt
    nxhjqypr = $VBoxContainer/Token_Input
    frrvjksj = $VBoxContainer/HideToken
    twfoobgf = $VBoxContainer/ValidateButton
    kwsdeixg = $VBoxContainer/TokenValidationSuccess
    ybyrkqvv = $VBoxContainer/TokenValidationError
    okaqvhgj = $VBoxContainer/TokenValidationProgress
    ejatvgrj = $VBoxContainer/AccountButton
    ojvchimn = $VBoxContainer/UpdatesButton

func vmczujxc (irryglsd):
    nxhjqypr.secret = irryglsd
    
    var orzgxeym = EditorInterface.get_editor_settings()
    orzgxeym.set_setting(olbpwale, frrvjksj.button_pressed)

func hlvprcdt (vdypymyn):
    if len(nxhjqypr.text) == 0:
        hlixzvoo.visible = true
    else:
        hlixzvoo.visible = false
    
    isldyfse.bytpyagv(false)
    
    kwsdeixg.visible = false
    ybyrkqvv.visible = false
    okaqvhgj.visible = false
    
    var txatrhbg = EditorInterface.get_editor_settings()
    txatrhbg.set_setting(nfroutrm, nxhjqypr.text)

func awwcywlx ():
    twfoobgf.disabled = true
    kwsdeixg.visible = false
    ybyrkqvv.visible = false
    okaqvhgj.visible = true
    rhqxsgze.jgknhlht()

                                                        
func _on_validate_token_received (rqmmtrcq : bool, mrlvddhe : String):
    okaqvhgj.visible = false
    twfoobgf.disabled = false
    
    if rqmmtrcq:
        kwsdeixg.visible = true
        kwsdeixg.text = "Token has been validated!"
        
        var qihhrbjx = EditorInterface.get_editor_settings()
        qihhrbjx.set_setting(qybrthav, true)
        
        isldyfse.bytpyagv(true)
    else:
        ybyrkqvv.visible = true
        ybyrkqvv.text = mrlvddhe

                                                  
                                                  
func _on_open ():
    pxobkehl()
    var ggolidlg = EditorInterface.get_editor_settings()
    
    if ggolidlg.has_setting(nfroutrm):
        nxhjqypr.text = ggolidlg.get_setting(nfroutrm)
    
    if ggolidlg.has_setting(olbpwale):
        frrvjksj.button_pressed = ggolidlg.get_setting(olbpwale)
    
    nxhjqypr.secret = frrvjksj.button_pressed
    
    if len(nxhjqypr.text) == 0:
        hlixzvoo.visible = true
    else:
        hlixzvoo.visible = false
        
    if ggolidlg.has_setting(ykpqbqxd):
        zdeguswc.text = ggolidlg.get_setting(ykpqbqxd)

func xohkirhh():
    OS.shell_open("https://app.gamedevassistant.com/profile")
    
func jqpwpbfo():
    kwsdeixg.visible = false
    ybyrkqvv.visible = false
    okaqvhgj.visible = true
    
    rhqxsgze.jdlbsgeg()

func _on_check_updates_received(kgcrwvzd: bool, wycpclmu: String):
    okaqvhgj.visible = false
    
    if kgcrwvzd:
        kwsdeixg.visible = true
        kwsdeixg.text = "An update is available! Latest version: " + wycpclmu + ". Click 'Manage Account' to download it."
    else:
        kwsdeixg.visible = true
        kwsdeixg.text = "You are already in the latest version"

func xtfcceon(zubsusia: String):
    okaqvhgj.visible = false
    ybyrkqvv.visible = true
    ybyrkqvv.text = zubsusia
    
