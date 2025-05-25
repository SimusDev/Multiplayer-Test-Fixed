extends SD_ShopEvent
class_name SD_ShopEventPurchased

var _item: SD_ShopNodeItem

func set_item(i: SD_ShopNodeItem) -> SD_ShopEventPurchased:
	_item = i
	return self

func get_item() -> SD_ShopNodeItem:
	return _item
