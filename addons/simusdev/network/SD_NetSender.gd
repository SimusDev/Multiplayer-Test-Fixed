extends SD_Object
class_name SD_NetSender

var player: SD_NetworkPlayer
var id: int = SD_Network.SERVER_ID
var callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE
var channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT
var channel_id: int = 0
