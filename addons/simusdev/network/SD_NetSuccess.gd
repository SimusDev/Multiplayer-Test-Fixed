extends Resource
class_name SD_NetSuccess

static func create(message: String) -> SD_NetSuccess:
	var i := SD_NetSuccess.new()
	i.message = message
	return i


var message: String
