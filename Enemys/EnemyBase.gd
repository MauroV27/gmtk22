extends RigidBody2D
class_name EnemyBase

var _target : KinematicBody2D

var _move_speed : float = 45.0
var _life : int
var _type_id : int
var _scores : int

signal destroy()

#var _animate_time : float = 0
#var _animate_dir : int = 1
#var _animate_speed : int = 8


func _ready() -> void:
	var sound_controller = get_parent().get_node("Sound Controller")
	self.connect("destroy", sound_controller, "_on_Enemy_destroy")
	_life = (randi() % 4 + 1)
	_scores = (_life * (_life+1)/2)
	_life_show()

func set_target(target: KinematicBody2D) -> void:
	_target = target

func set_enemy(_pos: Vector2, _id : int, _color: Color ) -> void:
	position = _pos
	_type_id = _id
	get_node("EnemyBackground").modulate = _color

func get_enemy_type_id() -> int:
	return _type_id

func _physics_process(delta: float) -> void:
	var _direction = global_position.direction_to(_target.global_position)
	rotation = (PI + _direction.angle()) 
	position += _direction * _move_speed * delta

func _life_show() -> void:
	get_node("Sprite").region_rect = Rect2((_life-1) * 16, 0, 16, 16)

func receive_damage(damage_value:int) -> void:
	_life -= damage_value
	if _life <= 0:
		emit_signal("destroy")
		if _target.has_method("update_scores"):
			_target.update_scores(_scores)
		queue_free()
	else:
		_move_speed += 5
		_life_show()

#func _process(delta: float) -> void:
#	if _animate_time >= 2:
#		_animate_time = 0
#		_animate_dir *= -1
#
#	_animate_time += delta * _animate_speed;
#	var _triangle = 1 - (abs(_animate_time % 2 - 1))
#	var value = 1 - (1 - _triangle) * (1 - _triangle)
#	position = Vector2(0, value * 12)
#	rotation = deg2rad(value * (8 * dir))
#	scale.x = 1 + (value * 2) * -1
#	scale.y = 1 + (value * 2)
