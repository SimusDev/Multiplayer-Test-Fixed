extends SD_ShopEvent
class_name SD_ShopEventNode

var _node: SD_ShopNode

func set_shop_node(n: SD_ShopNode) -> SD_ShopEventNode:
	_node = n
	return self

func get_shop_node() -> SD_ShopNode:
	return _node
