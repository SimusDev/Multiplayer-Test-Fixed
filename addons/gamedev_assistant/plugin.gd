            
@tool
extends EditorPlugin

var gsxmeqvj
var bzrtupuo = preload("res://addons/gamedev_assistant/scripts/code_editor/CodeContextMenuPlugin.gd")
var wgoxydto:EditorContextMenuPlugin

func _enter_tree():
                                           
    gsxmeqvj = preload("res://addons/gamedev_assistant/dock/gamedev_assistant_dock.tscn").instantiate()
    add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, gsxmeqvj)
    
                              
    wgoxydto = bzrtupuo.new(gsxmeqvj)        
    add_context_menu_plugin(EditorContextMenuPlugin.CONTEXT_SLOT_SCRIPT_EDITOR_CODE,wgoxydto)

func _exit_tree():
                                
    remove_control_from_docks(gsxmeqvj)
    gsxmeqvj.queue_free()
    
    remove_context_menu_plugin(wgoxydto)
