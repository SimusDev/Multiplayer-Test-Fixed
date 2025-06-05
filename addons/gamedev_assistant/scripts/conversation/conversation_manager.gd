@tool
extends Node

                                        
                             
                               

signal hrcuwxci (conversation : Conversation)

                                                                    
signal eazkpywg
signal kriazboy

var earzjhit : Array[Conversation]
var zkhbypel : Conversation

@onready var hxbunmit = $"../APIManager"
@onready var vcusbtxr = $".."
@onready var xtimsqpb = $"../Screen_Conversations"

func _ready ():
    hxbunmit.yznamlrk.connect(slmqoiep)
    hxbunmit.oyedrfpg.connect(_on_send_message_received)
    
    hxbunmit.sixksrlf.connect(rbpksikn)
    hxbunmit.gqtjftgc.connect(zugextoh)

func dwefjxnf () -> Conversation:
    hesusofv()                                            

    var afyokgmz = Conversation.new()
    afyokgmz.id = -1                                       
    earzjhit.append(afyokgmz)
    zkhbypel = afyokgmz
    return afyokgmz

func hesusofv ():
    if zkhbypel != null:
        if zkhbypel.id == -1:                                    
            earzjhit.erase(zkhbypel)
    
    zkhbypel = null

func zdgnftfv (pzrgdhoq : Conversation):
    zkhbypel = pzrgdhoq
    kriazboy.emit()

                                                                    
                                                                              
func rbpksikn (uqeszfbp):
    earzjhit.clear()
    
    for conv_data in uqeszfbp:
        var pimawpnp = Conversation.new()
        pimawpnp.id = int(conv_data["id"])
        pimawpnp.title = conv_data["title"]
        pimawpnp.favorited = conv_data["isFavorite"]
        earzjhit.append(pimawpnp)
    
    eazkpywg.emit()

                                   
func slmqoiep(xljretam: String):
    if zkhbypel == null:
                                           
        dwefjxnf()
    
                                                     
                                                    
                           
       
    zkhbypel.ffqrtwxl(xljretam)

func _on_send_message_received(slpbkraz: String, caewqpib: int):
    print("Received assistant message: ", {
        "conversation_id": caewqpib,
        "current_conv_id": zkhbypel.id if zkhbypel else "none",
        "content": slpbkraz
    })
    if zkhbypel:
        if zkhbypel.id == -1:
                                                                    
            zkhbypel.id = caewqpib
        zkhbypel.pzubutpy(slpbkraz)

                                                                                      
                                                                     
func kwdxqevp (pjajmkoo : int):
    hxbunmit.get_conversation(pjajmkoo)

                                                            
                                                 
func zugextoh (igjmgozs):
    var vpsviotg : Conversation
    var twvrbgng = igjmgozs["id"]
    twvrbgng = int(twvrbgng)
    
                                                
    for c in earzjhit:
        if c.id == twvrbgng:
            vpsviotg = c
            break
    
                                              
    if vpsviotg == null:
        vpsviotg = Conversation.new()
        vpsviotg.id = twvrbgng
        vpsviotg.title = igjmgozs["title"]
        earzjhit.append(vpsviotg)
    
    vpsviotg.messages.clear()
    
                                                    
    for message in igjmgozs["messages"]:
        if message["role"] == "user":
            vpsviotg.ffqrtwxl(message["content"])
        elif message["role"] == "assistant":
            vpsviotg.pzubutpy(message["content"])
    
    vpsviotg.has_been_fetched = true
    zdgnftfv(vpsviotg)

func clbatkce (gjlwsjtz : Conversation, mobjgoyu : bool):
    hxbunmit.mfjexrur(gjlwsjtz.id)
    
    if mobjgoyu:
        xtimsqpb.oqnlogsf("Adding favorite...")
    else:
        xtimsqpb.oqnlogsf("Removing favorite...")

func uakjxwly():
    return earzjhit
    
func pirnmejx():
    return zkhbypel
    
func xvdrbrfl(stxzwkam: int):
    zkhbypel.id = stxzwkam
