extends SD_MPPropertySynchronizer
class_name SB_Synchronizer

var _network: SBR_Network = SB_GameSingleton.instance.network

func init_property(mp_property: SD_MPPSSyncedBase) -> void:
	if mp_property is SD_MPPSSyncedProperty:
		mp_property.tickrate = _network.tickrate
		mp_property.tickrate_mode = _network.tickrate_mode
		mp_property.sync_mode = _network.sync_mode
		mp_property.interpolation_enabled = _network.interpolation_enabled
		mp_property.interpolation_speed = _network.interpolation_speed
	
	super(mp_property)
