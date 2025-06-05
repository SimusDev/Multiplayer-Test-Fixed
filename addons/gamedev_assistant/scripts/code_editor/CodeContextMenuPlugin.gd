extends EditorContextMenuPlugin

var khxrvsvu: Control

func _init(qpqyxygu: Control):                                                
    khxrvsvu = qpqyxygu

                                                                              
func mdwiduwi(hhqnhfxd: PackedStringArray):
    add_context_menu_item("Add to Chat",qtyycdfs)
    add_context_menu_item("Explain Code",ugqcssao)

func ugqcssao(ridsnjxp: Node):
    if not (ridsnjxp is CodeEdit):
        return
    if ridsnjxp.has_selection():
        var psymnuls = ridsnjxp.get_selected_text()
        if psymnuls:         
                                                      
            var oleldjyx = Engine.get_singleton("EditorInterface")
            var ivwcxgvm = oleldjyx.get_script_editor().get_current_script()
            if ivwcxgvm:
                psymnuls = "Explain this code from %s:\n\n%s" % [ivwcxgvm.resource_path, psymnuls]
            
                                                                                    
            if khxrvsvu:  
                if not khxrvsvu.is_open_chat:
                    print("Please open the chat to use this command")
                    return
                                                                    
                var smrshicr : TextEdit = khxrvsvu.get_node("Screen_Chat/Footer/PromptInput")         
                if smrshicr:                                               
                    smrshicr.insert_text_at_caret("\n" +psymnuls)          
                else:                                                               
                    print("PromptInput node not found in the dock.")                
            else:                                                                   
                print("Dock reference is null.")          

func qtyycdfs(xbdogyoy: Node):
    if not (xbdogyoy is CodeEdit):
        return
    if xbdogyoy.has_selection():
        var sgsgltlm = xbdogyoy.get_selected_text()
        if sgsgltlm:
                                                      
            var lcbdosmm = Engine.get_singleton("EditorInterface")
            var maslhjic = lcbdosmm.get_script_editor().get_current_script()
            if maslhjic:
                sgsgltlm = "Snippet from %s:\n%s" % [maslhjic.resource_path, sgsgltlm]
            
                                                                                    
            if khxrvsvu:          
                if not khxrvsvu.is_open_chat:
                    print("Please open the chat to use this command")
                    return
                                                                      
                var luxyluxk : TextEdit = khxrvsvu.get_node("Screen_Chat/Footer/PromptInput")         
                if luxyluxk:                                               
                    luxyluxk.insert_text_at_caret("\n" +sgsgltlm)             
                else:                                                               
                    print("PromptInput node not found in the dock.")                
            else:                                                                   
                print("Dock reference is null.")          

            
            
            
