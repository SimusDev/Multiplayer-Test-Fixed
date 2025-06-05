@tool
extends Button

@onready var apubcnjc : Label = $PromptLabel
@onready var fmqkbalk : TextureButton = $FavouriteButton
@onready var shaqhxhh : Button = $DeleteButton

@export var non_favourite_color : Color
@export var favourite_color : Color

var accmkskc : Conversation
var rbsgerkq

func _ready():
    fmqkbalk.modulate = non_favourite_color
    
                                
    pressed.connect(zkqczjad)
    shaqhxhh.pressed.connect(wlsvifhq)
    fmqkbalk.pressed.connect(afcririw)

                                                 
func ynuysgnr (ulktsuwx : Conversation, xxhmmntc):
    accmkskc = ulktsuwx
    rbsgerkq = xxhmmntc
    apubcnjc.text = accmkskc.rezbvrpf().replace("\n", "")                    
    ngchuxxo()

                                                
func zkqczjad():
    rbsgerkq.fzvzkjay(accmkskc)

                              
                                    
func wlsvifhq():
    $"../../..".wttkcasu(self)

func afcririw():
                                                          
    var zgcishzz = rbsgerkq.xycvtxxl()
    zgcishzz.clbatkce(accmkskc, not accmkskc.favorited)
    ngchuxxo()

func ngchuxxo ():
    if accmkskc.favorited:
        fmqkbalk.modulate = favourite_color
    else:
        fmqkbalk.modulate = non_favourite_color

func get_conversation():
    return accmkskc
