            
@tool
extends EditorPlugin

var pduwctgv
var ppqjiapp = preload("res://addons/gamedev_assistant/scripts/code_editor/CodeContextMenuPlugin.gd")
var kzlzcted:EditorContextMenuPlugin

func _enter_tree():
                                           
    pduwctgv = preload("res://addons/gamedev_assistant/dock/gamedev_assistant_dock.tscn").instantiate()
    add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, pduwctgv)
    
                              
    kzlzcted = ppqjiapp.new(pduwctgv)        
    add_context_menu_plugin(EditorContextMenuPlugin.CONTEXT_SLOT_SCRIPT_EDITOR_CODE,kzlzcted)

func _exit_tree():
                                
    remove_control_from_docks(pduwctgv)
    pduwctgv.queue_free()
    
    remove_context_menu_plugin(kzlzcted)
