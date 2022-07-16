extends KinematicBody2D

onready var timer = $TimerToShoot
onready var hud = $PlayerHUD

const SPEED: int = 80

var _motion : Vector2 = Vector2.ZERO
var _can_shoot : bool = true
var _bullets : int = 0
var _bullet_type : int 

var scores : int = 0
var _life : int = 12

signal create_bullet()

func _ready() -> void:
	hud.update_life(_life)
	hud.update_scores(scores)
	
	_reload_gun()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and _can_shoot :
		if _bullets > 0:
			create_bullet()
			_bullets -= 1
			hud.update_bullets(_bullets)
			
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


func _update_life(value:int) -> void:
	_life += value
	if _life <= 0 :
		Global.set_total_scores(scores)
		get_tree().change_scene("res://UI/EndScreen.tscn")
	else :
		hud.update_life(_life)


func update_scores(value:int) -> void:
	scores += value
	hud.update_scores(scores)


func _reload_gun() -> void:
	_bullets = randi() % 4 + 4
	
	_bullet_type = randi() % Global.object_types.size()
	get_node("BulletTypePreview").modulate = Global.object_types[_bullet_type][1]
	
	hud.update_bullets(_bullets)

func create_bullet() -> void:
	emit_signal("create_bullet", rotation, _bullet_type)


func _on_TimerToShoot_timeout() -> void:
	timer.stop()
	_can_shoot = true


func _on_HitBox_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy") :
		_update_life(-1)
