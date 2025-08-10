extends Node
class_name SourceCrafting

@export var object_handler: C_SourceObjectHandler

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_request_,
		])
	if !object_handler.is_node_ready():
		await object_handler.ready

static var _instance: SourceCrafting

func _enter_tree() -> void:
	_instance = self

static func as_node() -> SourceCrafting:
	return _instance

func request(inventory: SourceInventory, recipe: R_SourceRecipe) -> void:
	SD_Network.call_func_on_server(_request_, [inventory, recipe.id])

func _request_(inventory: SourceInventory, recipe_id: String) -> void:
	var recipe: R_SourceRecipe = R_SourceRecipe.get_by_id(recipe_id) as R_SourceRecipe
	if not recipe:
		SimusDev.console.write_error("recipe not found!: %s, %s" % [str(inventory.root), recipe_id])
		return
	
	if recipe.can_craft(inventory).is_empty():
		SimusDev.console.write_info("cant craft!: %s, %s" % [str(inventory.root), recipe_id])
		return
	
	for input in recipe.input:
		input
	
	_create_item(recipe, inventory)
	
	return
	if recipe.time == 0.0:
		_create_item(recipe, inventory)
	else:
		if SD_Network.get_remote_sender_id() != SD_Network.SERVER_ID:
			SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _queue_create, [inventory, recipe_id, SD_Network.get_remote_sender_id()])
		_queue_create(inventory, recipe_id, SD_Network.get_remote_sender_id())

func _take_craft_items(_recipe:R_SourceRecipe, _inventory:SourceInventory):
	pass
	#for input_item in _recipe.input:
		#for x in input_item.quantity:
			#SD_Nodes.fast_queue_free(input_item)

func _create_item(recipe: R_SourceRecipe, inventory: SourceInventory) -> void:
	var itemstack := SourceItemStack.create_from_object(recipe.output.source)
	itemstack.set_quantity(recipe.output.quantity)
	inventory.add_item(itemstack)
	_take_craft_items(recipe, inventory)

func _queue_create(inventory: SourceInventory, recipe_id: String, peer: int) -> void:
	var recipe: R_SourceRecipe = R_SourceRecipe.get_by_id(recipe_id) as R_SourceRecipe
	var queue := R_SourceCraftQueue.create(inventory, recipe, peer) as R_SourceCraftQueue
	
	if SD_Network.is_server():
		await SimusDev.get_tree().create_timer(recipe.time).timeout
		queue.delete()
	
func _invoke_queue_delete(queue: R_SourceCraftQueue) -> void:
	SD_Network.call_func_on(queue.peer, _queue_delete, [queue.get_id()])

func _queue_delete(inventory: SourceInventory, queue_id: int) -> void:
	var queue: R_SourceCraftQueue = inventory._craft_queue.get(queue_id) as R_SourceCraftQueue
	inventory._craft_queue.erase(queue)
	inventory.craft_queue_remove.emit(queue)
	_create_item(queue.recipe, inventory)
