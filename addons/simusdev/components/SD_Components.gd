@static_unload
extends SD_Object
class_name SD_Components

static func get_list_from(node: Node) -> Array[Node]:
	if !is_instance_valid(node):
		return [] as Array[Node]
	
	if node.has_meta("sd_components"):
		return node.get_meta("sd_components") as Array[Node]
	
	var components: Array[Node] = []
	node.set_meta("sd_components", components)
	return components

static func append_to(node: Node, component: Variant) -> void:
	if not is_instance_valid(node):
		return
	
	var list: Array[Node] = get_list_from(node)
	
	var script: Script
	
	if component is Node:
		script = component.get_script() as Script
		if component in list:
			return
			
	
	var c_instance: Node
	
	if component is Node:
		c_instance = component
	
	elif component is Script:
		if component.has_method("new"):
			c_instance = component.new()
	
	if c_instance:
		list.append(c_instance)

static func find_first(node: Node, component: Script) -> Node:
	var array: Array[Node] = find_all(node, component)
	if array.is_empty():
		return null
	
	return array.get(0)

static func find_random(node: Node, component: Script) -> Node:
	return SD_Array.get_random_value_from_array(find_all(node, component))

static func find_all(node: Node, component: Script) -> Array[Node]:
	if not is_instance_valid(node):
		return [] as Array[Node]
	
	var result: Array[Node] = []
	for c in get_list_from(node):
		if get_base_script_from_node(c) == component or c.get_script() == component:
			SD_Array.append_to_array_no_repeat(result, c)
	
	for i in node.get_children():
		if get_base_script_from_node(i) == component:
			SD_Array.append_to_array_no_repeat(result, i)
	
	return result

static func get_base_script_from(script: Script) -> Script:
	if not script:
		return null
	return _get_base_script_from(script)

static func _get_base_script_from(script: Script) -> Script:
	var base: Script = script.get_base_script()
	if base == null:
		return script
	return _get_base_script_from(base)

static func get_base_script_from_node(node: Object) -> Script:
	if not node.get_script():
		return null
	return get_base_script_from(node.get_script())

static func node_find_above_by_script(from: Node, script: Script) -> Node:
	if get_base_script_from_node(from) == script:
		return from
	
	if from == SimusDev.get_tree().root:
		return null
	
	return node_find_above_by_script(from.get_parent(), script)

static func node_find_above_by_component(from: Node, component: Script) -> Node:
	var founded = find_first(from, component)
	if founded:
		return founded
	
	if from == SimusDev.get_tree().root:
		return null
	
	return node_find_above_by_component(from.get_parent(), component)
