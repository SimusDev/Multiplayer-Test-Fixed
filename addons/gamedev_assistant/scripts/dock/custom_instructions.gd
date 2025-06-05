                                                                    
@tool
extends TextEdit

@export var max_length = 1000                                        
const vvipubch = "gamedev_assistant/custom_instructions"

func _ready():
    text_changed.connect(hokvruts)

func hokvruts():
                             
    if text.length() > max_length:
        var zyfrgsdn = get_caret_column()
        text = text.substr(0, max_length)
        set_caret_column(min(zyfrgsdn, max_length))
    
                        
    var nwmanzia = EditorInterface.get_editor_settings()
    nwmanzia.set_setting(vvipubch, text)
