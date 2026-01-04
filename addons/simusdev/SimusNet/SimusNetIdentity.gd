extends Resource
class_name SimusNetIdentity

var owner: Object
var settings: SimusNetIdentitySettings

signal on_ready()

var is_ready: bool = false

var _bytes_unique_id: PackedByteArray = PackedByteArray()

var is_initialized: bool = false

var _generated_unique_id: Variant
var _unique_id: int = -1

var _net_settings: SimusNetSettings

signal _on_awaited_and_cached()

static var _list_by_id: Dictionary[int, SimusNetIdentity] = {}
static var _list_by_generated_id: Dictionary[Variant, SimusNetIdentity] = {}

const BYTE_SIZE: int = 2

var _invisible_for_peers: PackedInt32Array = []

func is_visible_for_peer(id: int) -> bool:
	return !_invisible_for_peers.has(id)

func is_invisible_for_peer(id: int) -> bool:
	return _invisible_for_peers.has(id)

static func register(object: Object, settings: SimusNetIdentitySettings = null, from: SimusNetIdentity = null) -> SimusNetIdentity:
	if object.has_meta("SimusNetIdentity"):
		return object.get_meta("SimusNetIdentity")
	
	var identity: SimusNetIdentity = from
	if !identity:
		identity = SimusNetIdentity.new()
	
	object.set_meta("SimusNetIdentity", identity)
	
	identity.owner = object
	identity.settings = settings
	
	if !is_instance_valid(settings):
		identity.settings = SimusNetIdentitySettings.new()
	
	identity._initialize()
	return identity

func _initialize() -> void:
	_net_settings = SimusNetSettings.get_or_create()
	SimusNetEvents.event_disconnected.listen(_deinitialize_dynamic)
	
	if owner is Node:
		if !owner.is_inside_tree():
			await owner.tree_entered
		
		owner.tree_entered.connect(_tree_entered)
		owner.tree_exited.connect(_tree_exited)
	
	_initialize_dynamic()
	

func _initialize_dynamic() -> void:
	if !SimusNetConnection.is_active():
		await SimusNetEvents.event_connected.published
	
	if is_initialized:
		return
	
	is_initialized = true
	
	if SimusNetConnection.is_server():
		_unique_id = SimusNetIdentitySettings._generate_instance_int()
		_tree_entered()
	else:
		_tree_entered()
		
		_unique_id = get_cached_unique_ids_values().get(_generated_unique_id, -1)
		if _unique_id < 0:
			if _net_settings.debug_enable:
				print_debug("(%s) unique id not found, awaiting for cache..." % str(_generated_unique_id))
				_await_for_cache()
				await _on_awaited_and_cached
				print_debug("(%s) cached!" % str(_generated_unique_id))
		
		get_cached_unique_ids_values().erase(_generated_unique_id)
		get_cached_unique_ids().erase(_unique_id)
		
		_set_ready()

func _deinitialize_dynamic() -> void:
	if !is_initialized:
		return
	
	SimusNetIdentitySettings._delete_instance_int()
	
	is_initialized = false
	
	_initialize_dynamic()
	

func _await_for_cache() -> void:
	SimusNetEvents.event_identity_cached.listen(_listen_cache)

func _listen_cache() -> void:
	var event: SimusNetEventIdentityCached = SimusNetEvents.event_identity_cached
	if event.generated_unique_id == _generated_unique_id:
		_on_awaited_and_cached.emit()
		event.unlisten(_listen_cache)

func _tree_entered() -> void:
	if settings.get_unique_id() == null:
		if owner is Node:
			_generated_unique_id = owner.get_path()
	else:
		_generated_unique_id = settings.get_unique_id()
	
	_list_by_generated_id[_generated_unique_id] = self
	
	SimusNetCache._cache_identity(self)
	
	if SimusNetConnection.is_server():
		_set_ready()
	

func _set_ready() -> void:
	if is_ready:
		return
	
	_bytes_unique_id.clear()
	_bytes_unique_id.resize(BYTE_SIZE)
	
	_bytes_unique_id.encode_u16(0, get_unique_id())
	
	_list_by_id[get_unique_id()] = self
	
	is_ready = true
	on_ready.emit()
	
	SimusNetVisibility._local_identity_create(self)

func _tree_exited() -> void:
	_list_by_generated_id.erase(get_generated_unique_id())
	
	if !is_ready:
		await is_ready
	
	if owner.has_method("is_queued_for_deletion"):
		if owner.is_queued_for_deletion():
			_destroy()


func _destroy() -> void:
	_deinitialize_dynamic()
	SimusNetVisibility._local_identity_delete(self)
	SimusNetCache._uncache_identity(self)
	
	_list_by_id.erase(get_unique_id())

func get_generated_unique_id() -> Variant:
	return _generated_unique_id

func get_unique_id() -> int:
	return _unique_id

func serialize_unique_id() -> PackedByteArray:
	return _bytes_unique_id

func try_serialize_into_variant() -> Variant:
	if get_unique_id() >= 0:
		return get_unique_id()
	return get_generated_unique_id()

static func try_deserialize_from_variant(variant: Variant) -> SimusNetIdentity:
	if variant is int:
		return _list_by_id.get(variant)
	return _list_by_generated_id.get(variant)

static func deserialize_unique_id(bytes: PackedByteArray) -> SimusNetIdentity:
	return _list_by_id.get(deserialize_unique_id_into_int(bytes))

static func deserialize_unique_id_into_int(bytes: PackedByteArray) -> int:
	return bytes.decode_u16(0)

static func get_cached_unique_ids() -> Dictionary[int, Variant]:
	return SimusNetCache.data_get_or_add("i.uid", {} as Dictionary[int, Variant])

static func get_cached_unique_ids_values() -> Dictionary[Variant, int]:
	return SimusNetCache.data_get_or_add("i.uidv", {} as Dictionary[Variant, int])

static func try_find_in(object: Object) -> SimusNetIdentity:
	if object.has_meta("SimusNetIdentity"):
		return object.get_meta("SimusNetIdentity")
	return null
