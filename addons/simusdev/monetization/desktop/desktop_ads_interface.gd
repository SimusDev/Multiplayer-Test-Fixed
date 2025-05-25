extends CanvasLayer
class_name desktop_ads_interface

@export var _back: CanvasLayer
@export var _front: CanvasLayer
@export var _fade: ColorRect
@export var _label_cooldown: Label

@export var interstitial_scene: PackedScene
@export var reward_scene: PackedScene

static var _instance: desktop_ads_interface

var _current_ad: Node = null
var _current_cooldown: float = 0.0

func _ready() -> void:
	_instance = self
	_fade.hide()
	update_cooldown_label()

func _process(delta: float) -> void:
	if _current_cooldown > 0.0:
		_current_cooldown -= delta
	update_cooldown_label()

static func instance() -> desktop_ads_interface:
	return _instance

static func get_instance() -> desktop_ads_interface:
	return _instance

func update_cooldown_label() -> void:
	_label_cooldown.text = str(round(_current_cooldown))
	_label_cooldown.visible = _current_cooldown > 0

func open_ad(scene: PackedScene, cooldown: float = 5) -> Node:
	if get_current_ad_node():
		return null
	
	set_cooldown(cooldown)
	_fade.show()
	var ad: Node = scene.instantiate()
	ad.tree_exited.connect(_on_ad_tree_exited.bind(ad))
	_back.add_child(ad)
	_current_ad = ad
	return ad

func _on_ad_tree_exited(ad: Node) -> void:
	set_cooldown(0)
	_fade.hide()
	_current_ad = null

func get_current_ad_node() -> Node:
	return _current_ad

func get_cooldown() -> float:
	return _current_cooldown

func set_cooldown(cd: float) -> void:
	_current_cooldown = cd
	
	update_cooldown_label()
	
