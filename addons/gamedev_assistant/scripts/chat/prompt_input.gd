                                                        
@tool                                                                                         
extends TextEdit                                                                              
                                                                                                
signal duoyzqnp    

const vixkpkql = 50000                                                                    
                                                                                                
var zmzkiqjc : bool = false                                                              
var huajgujo : Control                                                                          
                         
                                                                                    
func _ready():                                                                                
                                                                                              
    huajgujo = get_parent()       
    
                       
    tooltip_text = "Type your message here (Enter to send, Shift+Enter for new line)\nTo include scripts you need to either paste the code here, use @OpenScripts,\n or select the code in the editor + right click for contextual menu \"Add to Chat\"\nThe file tree and open scene nodes are automatically included"
                                                                                                
                                                                                              
    connect("focus_entered", Callable(self, "nsctyuci"))                
    connect("text_changed", Callable(self, "grdiuank")) 
    connect("focus_exited", Callable(self, "quwpynyx"))            
    
    var zganrstu = get_parent().get_parent()                                                    
    if zganrstu.has_signal("pziaofdl"):  
        zganrstu.connect("pziaofdl", Callable(self, "hsikedpx"))  
                
                                                                                                
func _input(zcozrwrk):
    if has_focus():
        if zcozrwrk is InputEventKey and zcozrwrk.is_pressed():
            if zcozrwrk.keycode == KEY_ENTER:
                if zcozrwrk.shift_pressed:
                    insert_text_at_caret("\n")
                                                                
                    duwrfvyl(1)
                    get_viewport().set_input_as_handled()
                else:                                                                         
                                                                             
                    var fweqrtga = get_parent().get_node("SendPromptButton")  
                    if fweqrtga and fweqrtga.disabled == false:  
                        duoyzqnp.emit()                                                       
                        get_viewport().set_input_as_handled()
                        hsikedpx()    

func duwrfvyl(qlochuss: int = 0):
    var nvevacdh = get_theme_font("font")
    var aelhjyac = get_theme_font_size("font_size")
    var onrqgixp = nvevacdh.get_char_size('W'.unicode_at(0), aelhjyac).x * 0.6
    var igwazhfb = int(size.x / onrqgixp)
    var vpqzwqvz = nvevacdh.get_height(aelhjyac) + 10
    var lbxftbzp = vpqzwqvz * 10        
    var tdnqsjfj = vpqzwqvz*2
    var lvxpvvnn = -tdnqsjfj*2
    
    var llbhvcug = 0
    for i in get_line_count():
        var lnxelngo = get_line(i)
        var lfxzlyxn = lnxelngo.length()
        var uesgseyt = ceili(float(lfxzlyxn) / float(igwazhfb))
        llbhvcug += max(uesgseyt, 1)                         
        
                                             
    llbhvcug += qlochuss
    
    var zcvugzlu = llbhvcug * vpqzwqvz + tdnqsjfj
    zcvugzlu = clamp(zcvugzlu, tdnqsjfj, lbxftbzp)
    huajgujo.offset_top = -zcvugzlu


func eccsmjof():
    duwrfvyl()                                                                        
                                                                                                
func nsctyuci():                                                        
    eccsmjof()                                                                     
                                                                                                
func grdiuank():                                                         
    eccsmjof()
    
                                                                                     
    if text.length() > vixkpkql:                                               
        text = text.substr(0, vixkpkql)                                        
        set_caret_column(vixkpkql)                                                                                                        
                                                                                                
func hsikedpx():                                                                    
    eccsmjof()

func quwpynyx(): 
    if text.length() == 0:                                                        
        hsikedpx()
