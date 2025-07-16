                                  
@tool
extends GDAScreenBase

var djqpptpu : Label
var mzcgqiks : LineEdit
var aqlljhlm : CheckButton
var iclntpcn : Button
var bkeqcklz : RichTextLabel
var lpexhiio : RichTextLabel
var yvviqyyg : RichTextLabel
var vuinekfq : Button
var pbuovorz : LineEdit
var kmyyhhbh : Button
var wkpiynue : Button
var xcrtiyux : String

const zwchacig : String = "gamedev_assistant/hide_token"
const dwkzmdgt : String = "gamedev_assistant/validated"
const pvyrednj : String = "gamedev_assistant/custom_instructions"

@onready var pftbgmwq = $".."
@onready var usfnslbv = $"../APIManager"
@onready var jdjuflmc = $"VBoxContainer/CustomInput"

var kyoaoeqv : bool

func _ready ():
    usfnslbv.lkzzpfme.connect(_on_validate_token_received)
    usfnslbv.hmqqywkp.connect(_on_check_updates_received)
    usfnslbv.tbojgdpj.connect(gytaawzi)
    
    hacqnxkl()
    
                                             
    aqlljhlm.toggled.connect(fmpqkute)
    iclntpcn.pressed.connect(wqstyhkx)
    kmyyhhbh.pressed.connect(onfjmcbj)
    wkpiynue.pressed.connect(owfulhzo)
    mzcgqiks.text_changed.connect(pbyscfvd)
    
    bkeqcklz.visible = false
    lpexhiio.visible = false
    yvviqyyg.visible = false
    
    var xjckspbb = EditorInterface.get_editor_settings()       
    
    xjckspbb.set_setting("gamedev_assistant/version_identifier", "UMD72JD9F")
    
    kyoaoeqv = xjckspbb.has_setting("gamedev_assistant/development_mode") and xjckspbb.get_setting('gamedev_assistant/development_mode') == true    
    if not kyoaoeqv:
        xjckspbb.set_setting("gamedev_assistant/endpoint", "https://app.gamedevassistant.com")
        xcrtiyux = "gamedev_assistant/token"
    else:
        xjckspbb.set_setting("gamedev_assistant/endpoint", "http://localhost:3000")
        xcrtiyux = "gamedev_assistant/token_dev"
        print("Development mode")
        
    usfnslbv.isxxvspv()
    
                                                                         
                                                  
func hacqnxkl ():
    djqpptpu = $VBoxContainer/EnterTokenPrompt
    mzcgqiks = $VBoxContainer/Token_Input
    aqlljhlm = $VBoxContainer/HideToken
    iclntpcn = $VBoxContainer/ValidateButton
    bkeqcklz = $VBoxContainer/TokenValidationSuccess
    lpexhiio = $VBoxContainer/TokenValidationError
    yvviqyyg = $VBoxContainer/TokenValidationProgress
    kmyyhhbh = $VBoxContainer/AccountButton
    wkpiynue = $VBoxContainer/UpdatesButton

func fmpqkute (ntqdwdxi):
    mzcgqiks.secret = ntqdwdxi
    
    var tpguobat = EditorInterface.get_editor_settings()
    tpguobat.set_setting(zwchacig, aqlljhlm.button_pressed)

func pbyscfvd (diymwykm):
    if len(mzcgqiks.text) == 0:
        djqpptpu.visible = true
    else:
        djqpptpu.visible = false
    
    pftbgmwq.jrqichgu(false)
    
    bkeqcklz.visible = false
    lpexhiio.visible = false
    yvviqyyg.visible = false
    
    var ogvmegoy = EditorInterface.get_editor_settings()
    ogvmegoy.set_setting(xcrtiyux, mzcgqiks.text)

func wqstyhkx ():
    iclntpcn.disabled = true
    bkeqcklz.visible = false
    lpexhiio.visible = false
    yvviqyyg.visible = true
    usfnslbv.phkuusbf()

                                                        
func _on_validate_token_received (nwztjrdr : bool, eabbwrbt : String):
    yvviqyyg.visible = false
    iclntpcn.disabled = false
    
    if nwztjrdr:
        bkeqcklz.visible = true
        bkeqcklz.text = "Token has been validated!"
        
        var tqhtswrn = EditorInterface.get_editor_settings()
        tqhtswrn.set_setting(dwkzmdgt, true)
        
        pftbgmwq.jrqichgu(true)
    else:
        lpexhiio.visible = true
        lpexhiio.text = eabbwrbt

                                                  
                                                  
func _on_open ():
    hacqnxkl()
    var mwmnbqat = EditorInterface.get_editor_settings()
    
    if mwmnbqat.has_setting(xcrtiyux):
        mzcgqiks.text = mwmnbqat.get_setting(xcrtiyux)
    
    if mwmnbqat.has_setting(zwchacig):
        aqlljhlm.button_pressed = mwmnbqat.get_setting(zwchacig)
    
    mzcgqiks.secret = aqlljhlm.button_pressed
    
    if len(mzcgqiks.text) == 0:
        djqpptpu.visible = true
    else:
        djqpptpu.visible = false
        
    if mwmnbqat.has_setting(pvyrednj):
        jdjuflmc.text = mwmnbqat.get_setting(pvyrednj)

func onfjmcbj():
    OS.shell_open("https://app.gamedevassistant.com/profile")
    
func owfulhzo():
    bkeqcklz.visible = false
    lpexhiio.visible = false
    yvviqyyg.visible = true
    
    usfnslbv.ezuczicd()

func _on_check_updates_received(yknkhole: bool, pkbzbcvg: String):
    yvviqyyg.visible = false
    
    if yknkhole:
        bkeqcklz.visible = true
        bkeqcklz.text = "An update is available! Latest version: " + pkbzbcvg + ". Click 'Manage Account' to download it."
    else:
        bkeqcklz.visible = true
        bkeqcklz.text = "You are already in the latest version"

func gytaawzi(ogfigwha: String):
    yvviqyyg.visible = false
    lpexhiio.visible = true
    lpexhiio.text = ogfigwha
    
