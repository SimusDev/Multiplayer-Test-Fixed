                                                            
@tool
extends OptionButton

func _ready():
    setup_context_items()
    
func setup_context_items():   
    set_item_tooltip(0, "Chat mode: generalist assistant for developing, debugging and learning. 1-click actions are provided when needed.")
    set_item_tooltip(1, "Agent mode: action-oriented agent to get things done. 1-click actions are provided when needed. Buckle up!")
