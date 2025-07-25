extends SD_ShopEvent
class_name SD_ShopEventSell

var _item: SD_ShopNodeItem

func set_item(i: SD_ShopNodeItem) -> SD_ShopEventSell:
	_item = i
	return self

func get_item() -> SD_ShopNodeItem:
	return _item
