                                                        
@tool                                                                                         
extends TextEdit                                                                              
                                                                                                
signal ssobifaj    

const svlkdtty = 50000                                                                    
                                                                                                
var dpizowaa : bool = false                                                              
var cwcfnxve : Control                                                                          
                         
                                                                                    
func _ready():                                                                                
                                                                                              
    cwcfnxve = get_parent()       
    
                       
    tooltip_text = "Type your message here (Enter to send, Shift+Enter for new line)\nTo include scripts you need to either paste the code here, use @OpenScripts,\n or select the code in the editor + right click for contextual menu \"Add to Chat\"\nThe file tree and open scene nodes are automatically included"
                                                                                                
                                                                                              
    connect("focus_entered", Callable(self, "tgefzjli"))                
    connect("text_changed", Callable(self, "diahxume")) 
    connect("focus_exited", Callable(self, "mhozbqdo"))            
    
    var vfhweybz = get_parent().get_parent()                                                    
    if vfhweybz.has_signal("fkmoxfvn"):  
        vfhweybz.connect("fkmoxfvn", Callable(self, "gnekarrz"))  
                
                                                                                                
func _input(toiwyysz):
    if has_focus():
        if toiwyysz is InputEventKey and toiwyysz.is_pressed():
            if toiwyysz.keycode == KEY_ENTER:
                if toiwyysz.shift_pressed:
                    insert_text_at_caret("\n")
                                                                
                    ywiowisk(1)
                    get_viewport().set_input_as_handled()
                else:                                                                         
                                                                             
                    var ifqaqvof = get_parent().get_node("SendPromptButton")  
                    if ifqaqvof and ifqaqvof.disabled == false:  
                        ssobifaj.emit()                                                       
                        get_viewport().set_input_as_handled()
                        gnekarrz()    

func ywiowisk(oicvqmre: int = 0):
    var gpfouope = get_theme_font("font")
    var nwldqhwo = get_theme_font_size("font_size")
    var twxndgvs = gpfouope.get_char_size('W'.unicode_at(0), nwldqhwo).x * 0.6
    var zccbvcmp = int(size.x / twxndgvs)
    var zryabdsd = gpfouope.get_height(nwldqhwo) + 10
    var tlhkqwor = zryabdsd * 10        
    var jvsuluuh = zryabdsd*2
    var qbfuqtpt = -jvsuluuh*2
    
    var jfhibxlw = 0
    for i in get_line_count():
        var kfbsdikz = get_line(i)
        var nbmeifhx = kfbsdikz.length()
        var mrsmkybo = ceili(float(nbmeifhx) / float(zccbvcmp))
        jfhibxlw += max(mrsmkybo, 1)                         
        
                                             
    jfhibxlw += oicvqmre
    
    var jletjhjf = jfhibxlw * zryabdsd + jvsuluuh
    jletjhjf = clamp(jletjhjf, jvsuluuh, tlhkqwor)
    cwcfnxve.offset_top = -jletjhjf


func owlxugsp():
    ywiowisk()                                                                        
                                                                                                
func tgefzjli():                                                        
    owlxugsp()                                                                     
                                                                                                
func diahxume():                                                         
    owlxugsp()
    
                                                                                     
    if text.length() > svlkdtty:                                               
        text = text.substr(0, svlkdtty)                                        
        set_caret_column(svlkdtty)                                                                                                        
                                                                                                
func gnekarrz():                                                                    
    owlxugsp()

func mhozbqdo(): 
    if text.length() == 0:                                                        
        gnekarrz()
