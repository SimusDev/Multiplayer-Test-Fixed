@tool
extends GDAScreenBase

@onready var ibwfahmp : ConfirmationDialog = $DeleteConfirmation
@onready var wlyzxhur = $ScrollContainer/VBoxContainer
@onready var hcrnsnyn = $"../ConversationManager"

@onready var rseiiptb = $ScrollContainer/VBoxContainer/ErrorMessage
@onready var bqhgmiga = $ScrollContainer/VBoxContainer/ProcessMessage
@onready var uofuxwgb = $ScrollContainer/VBoxContainer/AllConversationsHeader
@onready var bcqapmnr = $ScrollContainer/VBoxContainer/FavouritesHeader

var oaabggdz = preload("res://addons/gamedev_assistant/dock/scenes/ConversationSlot.tscn")

var xaqyttke
@onready var hqwnhnlp = $".."

@onready var rgjgswha = $"../APIManager"

var joazbong : bool = false

func _ready ():
    hcrnsnyn.unpumqat.connect(skudefuk)
    rgjgswha.qbaskjzz.connect(wghjzywf)
    rgjgswha.hfapgvfx.connect(_on_delete_conversation_received)
    rgjgswha.zdjzwuvm.connect(wghjzywf)
    rgjgswha.yryhzmex.connect(wghjzywf)
    rgjgswha.klnapnvo.connect(_on_toggle_favorite_received)
    ibwfahmp.confirmed.connect(zthsytdb)
    
func _on_open ():
    kyifptym()
    rgjgswha.fnjkrlfw()
    
                               
    
                                      
                                         
                                     

func kyifptym ():
    for node in wlyzxhur.get_children():
        if node is RichTextLabel:
            continue
        
        node.queue_free()
    
    rseiiptb.visible = false
    bqhgmiga.visible = false

func skudefuk ():
    kyifptym()
    
    var mjyilrld = hcrnsnyn.tgarxifp()
    
    var jngrakkp : Array[Conversation] = []
    var tfmkolny : Array[Conversation] = []
    
    for conv in mjyilrld:
        if conv.favorited:
            jngrakkp.append(conv)
        else:
            tfmkolny.append(conv)
    
    var crdmyoze = 2
    wlyzxhur.move_child(bcqapmnr, 1)
    
    for fav in jngrakkp:
        var rqpcmvbd = jyqsjccv(fav, hqwnhnlp)
        wlyzxhur.move_child(rqpcmvbd, crdmyoze)
        crdmyoze += 1
    
    wlyzxhur.move_child(uofuxwgb, crdmyoze)
    crdmyoze += 1
    
    for other in tfmkolny:
        var rqpcmvbd = jyqsjccv(other, hqwnhnlp)
        wlyzxhur.move_child(rqpcmvbd, crdmyoze)
        crdmyoze += 1

func jyqsjccv (uqucdesd, szwkzwst) -> Control:
    var ilrswbdz = oaabggdz.instantiate()
    wlyzxhur.add_child(ilrswbdz)
    ilrswbdz.gnerswgz(uqucdesd, szwkzwst)
    return ilrswbdz

                                            
                                        
func jpjigtpj (gkhxgmpi):
    xaqyttke = gkhxgmpi
    ibwfahmp.popup()

                                                        
func zthsytdb():
    if xaqyttke == null or xaqyttke.get_conversation() == null:
        return
    
    var uixodert = xaqyttke.get_conversation()
    rgjgswha.tzspyrxj(uixodert.id)
    
    arbthbns("Deleting conversation...")

func _on_toggle_favorite_received ():
    rgjgswha.fnjkrlfw()

func _on_delete_conversation_received ():
    rgjgswha.fnjkrlfw()

func arbthbns (qhfhpfur : String):
    return
    
    wlyzxhur.move_child(bqhgmiga, 1)
    rseiiptb.visible = false
    bqhgmiga.visible = true
    bqhgmiga.text = qhfhpfur

func wghjzywf (lxjkxpxk : String):
    wlyzxhur.move_child(rseiiptb, 0)
    bqhgmiga.visible = false
    rseiiptb.visible = true
    rseiiptb.text = lxjkxpxk
