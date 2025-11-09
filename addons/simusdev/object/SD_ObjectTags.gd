extends SD_NetworkedResource
class_name SD_ObjectTags

var net_node: SD_NetRegisteredNode

func register() -> void:
	super()

func unregister() -> void:
	super()

func _initialize(net_node: SD_NetRegisteredNode) -> void:
	if net_node.last_path.is_empty() or registered:
		SD_Network.singleton.debug_print("cant initialize object tags, last_path is empty %s or is already registered" % [net_node])
		return
	
	self.net_node = net_node
	
	net_node.uncached.connect(_on_uncached)
	
	SD_Components.append_to(net_node.reference, self)
	net_id = str(net_node.last_path)
	register()

func _on_uncached() -> void:
	unregister()

static func get_or_create(object: Object) -> SD_ObjectTags:
	var founded: Array = SD_Components.find_all(object, SD_ObjectTags)
	if founded.is_empty():
		var tags := SD_ObjectTags.new()
		tags._initialize(SD_NetRegisteredNode.create(object))
		return tags
	return founded.get(0)
