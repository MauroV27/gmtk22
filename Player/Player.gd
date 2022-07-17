extends KinematicBody2D

onready var timer = $TimerToShoot
onready var vunerable_time = $TimerInvunerable
onready var hud = $PlayerHUD

const SPEED: int = 80

var _motion : Vector2 = Vector2.ZERO
var _can_shoot : bool = true
var _bullets : int = 0
var _bullet_type : int 
var _is_vunerable : bool = true

# Implement a stack estructury for control bullets 
# id of objetcts
var _bullet_stack = [
	0, 1, 2
]

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
			$Shooting.play()
			_bullets -= 1
			hud.update_bullets(_bullets, _bullet_type, _bullet_stack)
			
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
	var hor_input = Input.get_action_strength("right")-Input.get_action_strength("left")
	var ver_input = Input.get_action_strength("down")-Input.get_action_strength("up")
	var _dir = Vector2(
		hor_input,
		ver_input
	)
	
	if _dir.x == -1:
		get_node("AnimationPlayer").current_animation = "left"
	elif _dir.x == 1:
		get_node("AnimationPlayer").current_animation = "right"
	elif _dir.y == -1:
		get_node("AnimationPlayer").current_animation = "up"
	elif _dir.y == 1:
		get_node("AnimationPlayer").current_animation = "down"
	else:
		get_node("AnimationPlayer").current_animation = "idle"
	return _dir.normalized()


func _rotate_player() -> void:
	var _mouse_angle : float = global_position.direction_to(get_global_mouse_position()).angle()
	
	get_node("Sprite2").rotation =_mouse_angle+2.2


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
	_bullets = randi() % 6 + 4
	
	_bullet_type = _bullet_stack[0]
	_change_bullet_stack()
	get_node("BulletTypePreview").modulate = Global.object_types[_bullet_type][1]
	
	hud.update_bullets(_bullets, _bullet_type, _bullet_stack)


func _change_bullet_stack() -> void:
	var _temp_stack = [0, 1, 2]
	
	_temp_stack[0] = _bullet_stack[1]
	_temp_stack[1] = _bullet_stack[2]
	
	_temp_stack[2] = randi() % Global.object_types.size() 
	
	_bullet_stack = _temp_stack


func create_bullet() -> void:
	emit_signal("create_bullet", get_node("Sprite2").rotation+4, _bullet_type)


func _on_TimerToShoot_timeout() -> void:
	timer.stop()
	_can_shoot = true


func _on_HitBox_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy") and _is_vunerable:
		_update_life(-1)
		
		_is_vunerable = false
		vunerable_time.start()

func _on_TimerInvunerable_timeout() -> void:
	_is_vunerable = true
	vunerable_time.stop()
