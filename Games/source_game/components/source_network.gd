extends Node
class_name SourceNetwork

@export var channels: PackedStringArray = [
	CHANNEL_ENTITY_POSITION,
	CHANNEL_PLAYER,
	"transform1",
	"transform2",
	"transform3",
	"transform4",
	CHANNEL_SPAWN,
	CHANNEL_ITEMS,
	CHANNEL_INVENTORY,
	CHANNEL_INTERACTABLES
]

const CHANNEL_ENTITY_POSITION: String = "entity_position"
const CHANNEL_PLAYER: String = "player"
const CHANNEL_SPAWN: String = "spawn"
const CHANNEL_ITEMS: String = "items"
const CHANNEL_INVENTORY: String = "inventory"
const CHANNEL_INTERACTABLES: String = "interactables"

func _ready() -> void:
	for channel in channels:
		SD_Network.register_channel(channel)

static func serialize_resource(resource: Resource) -> Variant:
	if resource.resource_path.is_empty():
		return {1: var_to_str(resource)}
	return resource.resource_path.replacen(SourceGame.GAME_PATH, "")

static func deserialize_resource(resource: Variant) -> Resource:
	if resource is Dictionary:
		return str_to_var(resource.get(1, ""))
	return load(SourceGame.GAME_PATH.path_join(resource))
