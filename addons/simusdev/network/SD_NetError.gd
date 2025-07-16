extends Resource
class_name SD_NetError

static func create(message: String) -> SD_NetError:
	var i := SD_NetError.new()
	i.message = message
	return i

var message: String
