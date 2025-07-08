extends Resource
class_name SD_MPNodeInstanceDeserialized

var instance: Node

func instantiate_deferred(parent: Node) -> Node:
	parent.add_child.call_deferred(instance)
	
	return instance

func instantiate(parent: Node) -> Node:
	parent.add_child(instance)
	
	return instance
