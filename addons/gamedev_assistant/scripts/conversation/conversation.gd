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

                                           
                                                                    
func suqyobce () -> String:
    if len(title) > 0:
        return title
    
    if len(messages) == 0:
        return "Empty chat..."
    
    return messages[0].content

func ummyohqb (ooihhotf : String):
    var bpzmadzi = Message.new()
    bpzmadzi.role = "user"
    bpzmadzi.content = ooihhotf
    messages.append(bpzmadzi)

func muovzobj (hshnvcsw : String):
    var chcvjujg = Message.new()
    chcvjujg.role = "assistant"
    chcvjujg.content = hshnvcsw
    messages.append(chcvjujg)
