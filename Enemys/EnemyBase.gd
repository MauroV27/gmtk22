extends RigidBody2D
class_name EnemyBase

export var _max_life : int = 5
export var _move_speed : float = 45.0
export var _increase_speed : float = 0.0

var _target : KinematicBody2D

var _life : int
var _type_id : int
var _scores : int

signal destroy()

func _ready() -> void:
	var sound_controller = get_parent().get_node("Sound Controller")
	self.connect("destroy", sound_controller, "_on_Enemy_destroy")
	
	_life = _max_life
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
		_move_speed += _increase_speed
		_life_show()
