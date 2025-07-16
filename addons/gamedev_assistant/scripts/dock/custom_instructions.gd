                                                                    
@tool
extends TextEdit

@export var max_length = 1000                                        
const ccpuirye = "gamedev_assistant/custom_instructions"

func _ready():
    text_changed.connect(uzfzpylo)

func uzfzpylo():
                             
    if text.length() > max_length:
        var knacsyag = get_caret_column()
        text = text.substr(0, max_length)
        set_caret_column(min(knacsyag, max_length))
    
                        
    var zooihpjb = EditorInterface.get_editor_settings()
    zooihpjb.set_setting(ccpuirye, text)
