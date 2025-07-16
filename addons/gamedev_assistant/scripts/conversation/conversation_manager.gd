@tool
extends Node

                                        
                             
                               

signal lfxqolsb (conversation : Conversation)

                                                                    
signal unpumqat
signal hkneviuc

var sdsvwfas : Array[Conversation]
var xuhskhcv : Conversation

@onready var ddrthjvm = $"../APIManager"
@onready var eveahqhh = $".."
@onready var pzehwzal = $"../Screen_Conversations"

func _ready ():
    ddrthjvm.ljieruqp.connect(zyfklquj)
    ddrthjvm.hzirqcnv.connect(_on_send_message_received)
    
    ddrthjvm.hxqheqrf.connect(dpmqysuf)
    ddrthjvm.vyzdnovp.connect(oxxopyxv)

func tvluauqo () -> Conversation:
    tydauhrq()                                            

    var nabqhjjv = Conversation.new()
    nabqhjjv.id = -1                                       
    sdsvwfas.append(nabqhjjv)
    xuhskhcv = nabqhjjv
    return nabqhjjv

func tydauhrq ():
    if xuhskhcv != null:
        if xuhskhcv.id == -1:                                    
            sdsvwfas.erase(xuhskhcv)
    
    xuhskhcv = null

func rkzrczau (jqwuwsrn : Conversation):
    xuhskhcv = jqwuwsrn
    hkneviuc.emit()

                                                                    
                                                                              
func dpmqysuf (nylbvsrm):
    sdsvwfas.clear()
    
    for conv_data in nylbvsrm:
        var vtobuzuj = Conversation.new()
        vtobuzuj.id = int(conv_data["id"])
        vtobuzuj.title = conv_data["title"]
        vtobuzuj.favorited = conv_data["isFavorite"]
        sdsvwfas.append(vtobuzuj)
    
    unpumqat.emit()

                                   
func zyfklquj(gvhptwoj: String):
    if xuhskhcv == null:
                                           
        tvluauqo()
    
                                                     
                                                    
                           
       
    xuhskhcv.ummyohqb(gvhptwoj)

func _on_send_message_received(uoetfixa: String, ipwzyucr: int):
    print("Received assistant message: ", {
        "conversation_id": ipwzyucr,
        "current_conv_id": xuhskhcv.id if xuhskhcv else "none",
        "content": uoetfixa
    })
    if xuhskhcv:
        if xuhskhcv.id == -1:
                                                                    
            xuhskhcv.id = ipwzyucr
        xuhskhcv.muovzobj(uoetfixa)

                                                                                      
                                                                     
func bxehkmun (ilsgrnwm : int):
    ddrthjvm.get_conversation(ilsgrnwm)

                                                            
                                                 
func oxxopyxv (buhzixxn):
    var lyrrnydb : Conversation
    var xdlifwzo = buhzixxn["id"]
    xdlifwzo = int(xdlifwzo)
    
                                                
    for c in sdsvwfas:
        if c.id == xdlifwzo:
            lyrrnydb = c
            break
    
                                              
    if lyrrnydb == null:
        lyrrnydb = Conversation.new()
        lyrrnydb.id = xdlifwzo
        lyrrnydb.title = buhzixxn["title"]
        sdsvwfas.append(lyrrnydb)
    
    lyrrnydb.messages.clear()
    
                                                    
    for message in buhzixxn["messages"]:
        if message["role"] == "user":
            lyrrnydb.ummyohqb(message["content"])
        elif message["role"] == "assistant":
            lyrrnydb.muovzobj(message["content"])
    
    lyrrnydb.has_been_fetched = true
    rkzrczau(lyrrnydb)

func hxdqjupk (qkuouply : Conversation, nsppwkgt : bool):
    ddrthjvm.yjvdfmme(qkuouply.id)
    
    if nsppwkgt:
        pzehwzal.arbthbns("Adding favorite...")
    else:
        pzehwzal.arbthbns("Removing favorite...")

func tgarxifp():
    return sdsvwfas
    
func nlkrcvov():
    return xuhskhcv
    
func munwvrah(evkgehsz: int):
    xuhskhcv.id = evkgehsz
