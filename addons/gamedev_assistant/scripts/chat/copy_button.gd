                                                       
@tool
extends CodeEdit

@onready var rzxpbrlj: Button = $CopyButton

func _ready():
    rzxpbrlj.connect("pressed",yyaqsdol)

func yyaqsdol():
    var ipawdrbz = text
    if ipawdrbz:
        DisplayServer.clipboard_set(ipawdrbz)
