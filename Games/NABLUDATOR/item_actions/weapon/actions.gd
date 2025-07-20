extends C_NabludatorItemActions
class_name C_NabludatorItemActionsWeapon

const ID_SHOOT: String = "mouse1"
const ID_ZOOM: String = "mouse2"

var _shooting: bool = false
var _zooming: bool = false

var weapon: R_NabludatorWeapon

var _cooldown: float = 0.0

signal on_local_shoot()

static func find_in(node: Node) -> C_NabludatorItemActionsWeapon:
	return super(node) as C_NabludatorItemActionsWeapon

func _ready() -> void:
	super()
	
	weapon = item as R_NabludatorWeapon
	
	SD_Network.register_function(local_shoot)
	
	if not SD_Network.is_server():
		set_process(false)
		set_physics_process(false)
		return
	


func _using_changed(value: bool, id: String) -> void:
	if id == ID_SHOOT:
		_shooting = value
	if id == ID_ZOOM:
		_zooming = value


#server
func _physics_process(delta: float) -> void:
	if _shooting and _cooldown <= 0.0:
		server_shoot()
	
	_cooldown = move_toward(_cooldown, 0.0, delta)

func server_shoot() -> void:
	_cooldown = weapon.cooldown
	
	SD_Network.call_func(local_shoot)

func local_shoot() -> void:
	NabludatorEvents.i.event_shoot.emit(self, entity_viewmodel.root)
	_on_local_shoot()
	on_local_shoot.emit()
	_on_client_shoot()

func _on_local_shoot() -> void:
	pass

func _on_client_shoot() -> void:
	pass
