extends Resource
class_name SD_MPNodeInstanceDeserialized

var instance: Node

var name: String

func instantiate_deferred(parent: Node) -> Node:
	instance.tree_entered.connect(
		func():
			instance.name = name
	)
	
	parent.add_child.call_deferred(instance)
	
	return instance

func instantiate(parent: Node) -> Node:
	instance.tree_entered.connect(
		func():
			instance.name = name
	)
	
	parent.add_child(instance)
	
	return instance
