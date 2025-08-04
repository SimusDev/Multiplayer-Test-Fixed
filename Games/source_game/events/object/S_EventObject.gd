extends S_Event
class_name S_EventObject

var object: R_SourceWorldObject
var source: Node

var server: bool = true

func setup(object: R_SourceWorldObject, source: Node) -> S_EventObject:
	server = SD_Network.is_server()
	self.object = object
	self.source = source
	return self
