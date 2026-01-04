extends SimusNetSingletonChild
class_name SimusNetEvents

static var event_active_status_changed := SimusNetEvent.new()
static var event_connected := SimusNetEvent.new()
static var event_disconnected := SimusNetEvent.new()
static var event_peer_connected := SimusNetEvent.new()
static var event_peer_disconnected := SimusNetEvent.new()
static var event_identity_cached := SimusNetEventIdentityCached.new()
static var event_method_cached := SimusNetEventMethodCached.new()
static var event_method_uncached := SimusNetEventMethodUncached.new()
static var event_identity_rpc_fail := SimusNetIdentity.new()
