extends SD_ShopEvent
class_name SD_ShopEventFailedToPurchase 

var _item: SD_ShopNodeItem
var _reason: REASON = -1

enum REASON {
	NOT_ENOUGH_CURRENCY,
	ALREADY_PURCHASED,
}

func set_reason(id: REASON) -> SD_ShopEventFailedToPurchase:
	_reason = id
	return self

func get_reason() -> REASON:
	return _reason

func set_item(i: SD_ShopNodeItem) -> SD_ShopEventFailedToPurchase:
	_item = i
	return self

func get_item() -> SD_ShopNodeItem:
	return _item
