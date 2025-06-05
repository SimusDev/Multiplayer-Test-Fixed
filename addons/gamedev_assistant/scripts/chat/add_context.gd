                                                                       
@tool
extends OptionButton

func _ready():
    iekgazug()
    
func iekgazug():   
    tooltip_text = "Add extra content to the chat. Your open scene nodes and file tree are automatically included"
    set_item_tooltip(0, "Add extra content to the chat. Your open scene nodes and file tree are automatically included")
    set_item_tooltip(1, "Include the contents of all scripts that are currently open in the Godot code editor. Clipped at 50k characters")
    set_item_tooltip(2, "Add the contents of the Output panel. Note this does NOT include the Debugger panel")
    set_item_tooltip(3, "Docs are already included automatically, but you can force it to look at a certain topic")
    set_item_tooltip(4, "If you are using git, this will pass the contents of the `git diff` command")
    set_item_tooltip(5, "Add the list of Project Settings and Input Map to the context. Unassigned settings are omitted.")
