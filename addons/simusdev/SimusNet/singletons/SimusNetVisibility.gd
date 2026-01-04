extends SimusNetSingletonChild
class_name SimusNetVisibility

static var _queue_create: Array[SimusNetIdentity] = []
static var _queue_delete: Array[SimusNetIdentity] = []

static var _instance: SimusNetVisibility

const _META_PUBLIC: StringName = &"simusnet.public.visible"
const _META_VISIBLES: StringName = &"simusnet.visibles"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

static func _local_identity_create(identity: SimusNetIdentity) -> void:
	_queue_create.append(identity)

static func _local_identity_delete(identity: SimusNetIdentity) -> void:
	_queue_delete.append(identity)

static func _serialize_array(array: Array[SimusNetIdentity]) -> void:
	pass

static func _deserialize_array(array: Array[PackedByteArray]) -> void:
	pass

static func set_public_visibility(object: Object, visibility: bool) -> void:
	object.set_meta(_META_PUBLIC, visibility)

static func set_visible_for(peer: int, object: Object, visible: bool) -> void:
	var visibles: PackedInt32Array = get_visibles_for(object)
	if visible and !visibles.has(peer):
		visibles.append(peer)
		return
	visibles.erase(peer)

static func is_public_visible(object: Object) -> bool:
	if object.has_meta(_META_PUBLIC):
		return object.get_meta(_META_PUBLIC)
	return true

static func get_visibles_for(object: Object) -> PackedInt32Array:
	if object.has_meta(_META_VISIBLES):
		return object.get_meta(_META_VISIBLES)
	var result: PackedInt32Array = []
	object.set_meta(_META_VISIBLES, result)
	return result

static func is_visible_for(peer: int, object: Object) -> bool:
	if is_public_visible(object):
		return true
	return get_visibles_for(object).has(peer)
