extends Resource
class_name SD_NetTag

var _data: Dictionary = {}

var _net_id: int = -1

var owner: Node : get = get_owner

func get_owner() -> Node:
	if is_instance_valid(owner):
		return owner
	
	owner = SD_Network.singleton.cache.get_cached_nodes_by_id().get(_net_id)
	
	if !is_instance_valid(owner):
		SimusDev.console.write_error("cant find tag owner by id: %s" % str(_net_id))
	
	return owner

func serialize() -> Dictionary:
	var data: Dictionary = {}
	data.d = _data
	data.i = _net_id
	data.c = get_script().get_global_name()
	_serialize_custom(data)
	return data

func _serialize_custom(data: Dictionary) -> void:
	pass

static func deserialize(data: Dictionary) -> SD_NetTag:
	var tag: SD_NetTag = SD_Variables.instantiate_class(data.c)
	tag._data = data.d
	tag._net_id = data.i
	_deserialize_custom(tag, data)
	return tag

static func _deserialize_custom(tag: SD_NetTag, data: Dictionary) -> void:
	pass

static func get_from(node: Node, script: GDScript = SD_NetTag) -> SD_NetTag:
	if SD_Network.is_object_registered(node):
		SD_Network.singleton.debug_print("cant get tag from node: %s, object is not registered." % str(node), SD_ConsoleCategories.ERROR)
		return script.new()
	
	var list: Array[SD_NetTag] = find_all_in(node)
	for i in list:
		if i.get_script() == script:
			return i
	
	if SD_Network.is_server():
		var tag: SD_NetTag = script.new()
		tag._net_id = SD_Network.singleton.cache.get_cached_id_by_path(node.get_path())
		list.append(tag)
		return tag
	
	SD_Network.singleton.debug_print("[client] cant find server tag on node: %s" % str(node), SD_ConsoleCategories.ERROR)
	return script.new()

static func find_all_in(node: Node) -> Array[SD_NetTag]:
	if node.has_meta("net.tags"):
		return node.get_meta("net.tags")
	var tags: Array[SD_NetTag] = []
	node.set_meta("net.tags", tags)
	return tags

static func has_tags(node: Node) -> bool:
	return node.has_meta("net.tags")

static func serialize_tags(node: Node) -> Array:
	var result: Array = []
	var list: Array[SD_NetTag] = find_all_in(node)
	for i in list:
		result.append(i.serialize())
	return result

static func deserialize_tags(to: Node, tags: Array) -> Array[SD_NetTag]:
	var list: Array[SD_NetTag] = find_all_in(to)
	for i: Dictionary in tags:
		list.append(deserialize(i))
	return list
