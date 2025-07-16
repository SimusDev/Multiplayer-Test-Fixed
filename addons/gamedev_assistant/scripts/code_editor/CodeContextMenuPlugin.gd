extends EditorContextMenuPlugin

var bjablydh: Control

func _init(spcjrymm: Control):                                                
    bjablydh = spcjrymm

                                                                              
func ggvqasuc(ashitowk: PackedStringArray):
    add_context_menu_item("Add to Chat",kctonnsh)
    add_context_menu_item("Explain Code",gunrioog)

func gunrioog(hlhnrsim: Node):
    if not (hlhnrsim is CodeEdit):
        return
    if hlhnrsim.has_selection():
        var gpjuthto = hlhnrsim.get_selected_text()
        if gpjuthto:         
                                                      
            var ijvdoxwx = Engine.get_singleton("EditorInterface")
            var vljuuoax = ijvdoxwx.get_script_editor().get_current_script()
            if vljuuoax:
                gpjuthto = "Explain this code from %s:\n\n%s" % [vljuuoax.resource_path, gpjuthto]
            
                                                                                    
            if bjablydh:  
                if not bjablydh.is_open_chat:
                    print("Please open the chat to use this command")
                    return
                                                                    
                var kroiyhdf : TextEdit = bjablydh.get_node("Screen_Chat/Footer/PromptInput")         
                if kroiyhdf:                                               
                    kroiyhdf.insert_text_at_caret("\n" +gpjuthto)          
                else:                                                               
                    print("PromptInput node not found in the dock.")                
            else:                                                                   
                print("Dock reference is null.")          

func kctonnsh(vzyhheco: Node):
    if not (vzyhheco is CodeEdit):
        return
    if vzyhheco.has_selection():
        var oszlcxqh = vzyhheco.get_selected_text()
        if oszlcxqh:
                                                      
            var ljjxjqnh = Engine.get_singleton("EditorInterface")
            var ebwdovvz = ljjxjqnh.get_script_editor().get_current_script()
            if ebwdovvz:
                oszlcxqh = "Snippet from %s:\n%s" % [ebwdovvz.resource_path, oszlcxqh]
            
                                                                                    
            if bjablydh:          
                if not bjablydh.is_open_chat:
                    print("Please open the chat to use this command")
                    return
                                                                      
                var vfiqmkmb : TextEdit = bjablydh.get_node("Screen_Chat/Footer/PromptInput")         
                if vfiqmkmb:                                               
                    vfiqmkmb.insert_text_at_caret("\n" +oszlcxqh)             
                else:                                                               
                    print("PromptInput node not found in the dock.")                
            else:                                                                   
                print("Dock reference is null.")          

            
            
            
