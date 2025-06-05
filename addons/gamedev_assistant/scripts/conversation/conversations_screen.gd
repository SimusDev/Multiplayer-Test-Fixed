@tool
extends GDAScreenBase

@onready var uysqlgay : ConfirmationDialog = $DeleteConfirmation
@onready var ynlpaaoe = $ScrollContainer/VBoxContainer
@onready var bzvwubot = $"../ConversationManager"

@onready var wocwxvvn = $ScrollContainer/VBoxContainer/ErrorMessage
@onready var visysfwt = $ScrollContainer/VBoxContainer/ProcessMessage
@onready var ibioxdgj = $ScrollContainer/VBoxContainer/AllConversationsHeader
@onready var krqnqzcf = $ScrollContainer/VBoxContainer/FavouritesHeader

var kqtdbigc = preload("res://addons/gamedev_assistant/dock/scenes/ConversationSlot.tscn")

var aoyuyuyg
@onready var tlsngvja = $".."

@onready var nuthnjgg = $"../APIManager"

var hxxukvgx : bool = false

func _ready ():
    bzvwubot.eazkpywg.connect(rbkbcghf)
    nuthnjgg.zurkrjmo.connect(jigzzwlc)
    nuthnjgg.ohqtpiyu.connect(_on_delete_conversation_received)
    nuthnjgg.iuitsarb.connect(jigzzwlc)
    nuthnjgg.iqtmgbcv.connect(jigzzwlc)
    nuthnjgg.fgvjnoap.connect(_on_toggle_favorite_received)
    uysqlgay.confirmed.connect(vgbacqnd)
    
func _on_open ():
    wacjbiev()
    nuthnjgg.rehxusbr()
    
                               
    
                                      
                                         
                                     

func wacjbiev ():
    for node in ynlpaaoe.get_children():
        if node is RichTextLabel:
            continue
        
        node.queue_free()
    
    wocwxvvn.visible = false
    visysfwt.visible = false

func rbkbcghf ():
    wacjbiev()
    
    var klivuopn = bzvwubot.uakjxwly()
    
    var nxqplbit : Array[Conversation] = []
    var fwzqutgn : Array[Conversation] = []
    
    for conv in klivuopn:
        if conv.favorited:
            nxqplbit.append(conv)
        else:
            fwzqutgn.append(conv)
    
    var dgejglqe = 2
    ynlpaaoe.move_child(krqnqzcf, 1)
    
    for fav in nxqplbit:
        var qttsjrzv = rfpqusac(fav, tlsngvja)
        ynlpaaoe.move_child(qttsjrzv, dgejglqe)
        dgejglqe += 1
    
    ynlpaaoe.move_child(ibioxdgj, dgejglqe)
    dgejglqe += 1
    
    for other in fwzqutgn:
        var qttsjrzv = rfpqusac(other, tlsngvja)
        ynlpaaoe.move_child(qttsjrzv, dgejglqe)
        dgejglqe += 1

func rfpqusac (bxfynuwe, xgourmuu) -> Control:
    var nfrqipzb = kqtdbigc.instantiate()
    ynlpaaoe.add_child(nfrqipzb)
    nfrqipzb.ynuysgnr(bxfynuwe, xgourmuu)
    return nfrqipzb

                                            
                                        
func wttkcasu (ywzigxyg):
    aoyuyuyg = ywzigxyg
    uysqlgay.popup()

                                                        
func vgbacqnd():
    if aoyuyuyg == null or aoyuyuyg.get_conversation() == null:
        return
    
    var dgubwclw = aoyuyuyg.get_conversation()
    nuthnjgg.spgkyzfi(dgubwclw.id)
    
    oqnlogsf("Deleting conversation...")

func _on_toggle_favorite_received ():
    nuthnjgg.rehxusbr()

func _on_delete_conversation_received ():
    nuthnjgg.rehxusbr()

func oqnlogsf (tiywmhvp : String):
    return
    
    ynlpaaoe.move_child(visysfwt, 1)
    wocwxvvn.visible = false
    visysfwt.visible = true
    visysfwt.text = tiywmhvp

func jigzzwlc (qxuxqoid : String):
    ynlpaaoe.move_child(wocwxvvn, 0)
    visysfwt.visible = false
    wocwxvvn.visible = true
    wocwxvvn.text = qxuxqoid
