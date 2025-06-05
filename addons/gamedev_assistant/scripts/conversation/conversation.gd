@tool
class_name Conversation
extends Node

                                                                             

var messages : Array[Message] = []
var title : String
var id : int = -1
var favorited : bool = false
var has_been_fetched : bool = false

class Message:
    var role : String
    var content : String

                                           
                                                                    
func rezbvrpf () -> String:
    if len(title) > 0:
        return title
    
    if len(messages) == 0:
        return "Empty chat..."
    
    return messages[0].content

func ffqrtwxl (nrpqwhzx : String):
    var aayyqivy = Message.new()
    aayyqivy.role = "user"
    aayyqivy.content = nrpqwhzx
    messages.append(aayyqivy)

func pzubutpy (ylrjzcft : String):
    var tidksdyh = Message.new()
    tidksdyh.role = "assistant"
    tidksdyh.content = ylrjzcft
    messages.append(tidksdyh)
