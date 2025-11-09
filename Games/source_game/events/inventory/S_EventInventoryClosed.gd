extends S_EventInventory
class_name S_EventInventoryClosed

static func as_event() -> S_EventInventoryClosed:
	return SourceEvents.get_by_script(S_EventInventoryClosed) as S_EventInventoryClosed
