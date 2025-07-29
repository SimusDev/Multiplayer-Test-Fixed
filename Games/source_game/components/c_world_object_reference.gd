extends RefCounted
class_name C_SourceWorldObjectReference

var source: Node
var object: R_SourceWorldObject

func instantiate() -> C_SourceWorldObjectReference:
	SourceGame.instance.instantiate_object_on_server(source)
	return self
