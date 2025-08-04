extends Resource
class_name R_SourceCraftQueue

var time: float = 0.0
var recipe: R_SourceRecipe
var inventory: SourceInventory

var peer: int = 1

static func create(inventory: SourceInventory, recipe: R_SourceRecipe, peer: int) -> R_SourceCraftQueue:
	var queue := R_SourceCraftQueue.new()
	queue.inventory = inventory
	queue.time = recipe.time
	queue.recipe = recipe
	inventory._craft_queue.append(queue)
	inventory.craft_queue_add.emit(queue)
	
	return queue

func get_id() -> int:
	return inventory._craft_queue.find(self)

func delete() -> void:
	SourceCrafting.as_node()._invoke_queue_delete(self)
