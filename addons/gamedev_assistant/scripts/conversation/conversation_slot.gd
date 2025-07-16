@tool
extends Button

@onready var bjolbqvb : Label = $PromptLabel
@onready var zghjwnsz : TextureButton = $FavouriteButton
@onready var beprghnw : Button = $DeleteButton

@export var non_favourite_color : Color
@export var favourite_color : Color

var pwllsbqe : Conversation
var chzjmkxn

func _ready():
    zghjwnsz.modulate = non_favourite_color
    
                                
    pressed.connect(vofwvxnc)
    beprghnw.pressed.connect(symrvppp)
    zghjwnsz.pressed.connect(eifvegsl)

                                                 
func gnerswgz (jpickvbl : Conversation, yqdvuajn):
    pwllsbqe = jpickvbl
    chzjmkxn = yqdvuajn
    bjolbqvb.text = pwllsbqe.suqyobce().replace("\n", "")                    
    aubhbdaa()

                                                
func vofwvxnc():
    chzjmkxn.bekfohhm(pwllsbqe)

                              
                                    
func symrvppp():
    $"../../..".jpjigtpj(self)

func eifvegsl():
                                                          
    var hjsntovx = chzjmkxn.gsfckmhq()
    hjsntovx.hxdqjupk(pwllsbqe, not pwllsbqe.favorited)
    aubhbdaa()

func aubhbdaa ():
    if pwllsbqe.favorited:
        zghjwnsz.modulate = favourite_color
    else:
        zghjwnsz.modulate = non_favourite_color

func get_conversation():
    return pwllsbqe
