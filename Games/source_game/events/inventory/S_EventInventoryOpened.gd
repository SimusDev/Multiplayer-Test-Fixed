extends S_EventInventory
class_name S_EventInventoryOpened

static func as_event() -> S_EventInventoryOpened:
	return SourceEvents.get_by_script(S_EventInventoryOpened) as S_EventInventoryOpened
