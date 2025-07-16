                                                       
@tool
extends CodeEdit

@onready var efgxbygv: Button = $CopyButton

func _ready():
    efgxbygv.connect("pressed",afoxngbv)

func afoxngbv():
    var eaxxjafj = text
    if eaxxjafj:
        DisplayServer.clipboard_set(eaxxjafj)
