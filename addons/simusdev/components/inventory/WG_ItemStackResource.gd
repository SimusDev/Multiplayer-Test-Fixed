extends Resource
class_name WG_ItemStackResource

@export var icon: Texture
@export var name: String
@export_multiline var description: String

func create_itemstack() -> WG_ItemStack:
	var stack: WG_ItemStack = WG_ItemStack.new()
	stack.resource = self
	return stack
