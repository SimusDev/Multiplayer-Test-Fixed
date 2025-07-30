extends Label

func initialize(prop_res:R_SourceWorldObject) -> void:
	var format = "%s \n%s" % [prop_res.name, prop_res.description]
	text = format
