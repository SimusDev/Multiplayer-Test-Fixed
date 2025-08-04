@static_unload
extends SD_Object
class_name SD_Components

static func get_list_from(node: Node) -> Array[Node]:
	if node.has_meta("sd_components"):
		return node.get_meta("sd_components") as Array[Node]
	
	var components: Array[Node] = []
	node.set_meta("sd_components", components)
	return components

static func append_to(node: Node, component: Variant) -> void:
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
	return SD_Array.get_value_from_array(find_all(node, component), 0)

static func find_random(node: Node, component: Script) -> Node:
	return SD_Array.get_random_value_from_array(find_all(node, component))

static func find_all(node: Node, component: Script) -> Array[Node]:
	var result: Array[Node] = []
	for c in get_list_from(node):
		if get_base_script_from_node(c) == component:
			SD_Array.append_to_array_no_repeat(result, c)
	
	for i in node.get_children():
		if get_base_script_from_node(i) == component:
			SD_Array.append_to_array_no_repeat(result, i)
	
	return result

static func get_base_script(script: Script) -> Script:
	var result: Script = script
	if result.get_base_script():
		return get_base_script(script.get_base_script())
	return result

static func get_base_script_from_node(node: Node) -> Script:
	if not node.get_script():
		return null
	return get_base_script(node.get_script())

static func node_find_above_by_script(from: Node, script: Script) -> Node:
	if from.get_script() == script:
		return from
	
	if from == SimusDev.get_tree().root:
		return null
	
	return node_find_above_by_script(from.get_parent(), script)
