extends SD_Event
class_name SD_ShopEvent

var _shop: SD_GlobalShop

func _init(shop: SD_GlobalShop) -> void:
	_shop = shop

func get_shop() -> SD_GlobalShop:
	return _shop
