extends KinematicBody2D

onready var timer = $TimerToShoot

const SPEED: int = 80

var _motion : Vector2 = Vector2.ZERO
var _can_shoot : bool = true
var _bullets : int = 0
var _bullet_type : int 

signal create_bullet()

func _ready() -> void:
	_reload_gun()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and _can_shoot :
		if _bullets > 0:
			create_bullet()
			_can_shoot = false
			timer.start()
		else:
			_reload_gun()
	
	if event.is_action_pressed("click_right"):
		_reload_gun()

func _physics_process(delta: float) -> void:
	_rotate_player()
	_motion = _move()
	_motion = move_and_slide(_motion * SPEED)


func _move() -> Vector2:
	var _dir = Vector2(
		Input.get_action_strength("right")-Input.get_action_strength("left"),
		Input.get_action_strength("down")-Input.get_action_strength("up")
	)
		
	return _dir.normalized()


func _rotate_player() -> void:
	var _mouse_angle : float = global_position.direction_to(get_global_mouse_position()).angle()
	rotation =_mouse_angle


func _reload_gun() -> void:
	_bullets = randi() % 4 + 4
	
	_bullet_type = randi() % Global.object_types.size()
	get_node("BulletTypePreview").modulate = Global.object_types[_bullet_type][1]

func create_bullet() -> void:
	emit_signal("create_bullet", rotation, _bullet_type)


func _on_TimerToShoot_timeout() -> void:
	timer.stop()
	_can_shoot = true
