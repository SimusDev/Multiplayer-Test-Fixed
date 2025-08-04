extends R_SourceWorldObject
class_name R_SourceRecipe

@export var time: float = 0.0
@export var input: Array[R_SourceRecipeInput] = []
@export var output: R_SourceRecipeOutput

static var _list: Array[R_SourceRecipe] = []

static func get_list() -> Array[R_SourceRecipe]:
	return _list

func _begin_register() -> void:
	custom_section = "recipe"

func _registered() -> void:
	if not prefab:
		prefab = load("res://Games/source_game/components/crafting/recipe_object.tscn")
	
	_list.append(self)

func _unregistered() -> void:
	_list.erase(self)

func can_craft(inventory: SourceInventory) -> Array[SourceItemStack]:
	var status: int = 0
	var result: Array[SourceItemStack] = []
	for i in input:
		var items: Array[SourceItemStack] = inventory.get_items_by_object(i.source)
		var quantity: int = 0
		for item in items:
			quantity += item.get_quantity()
		
		if quantity >= i.quantity:
			status += 1
			result.append_array(items)
		
	
	return result
