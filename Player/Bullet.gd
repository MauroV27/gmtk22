extends Area2D

const SPEED : int = 192
var _direction : Vector2 = Vector2.ZERO
var _type_id : int 

func set_type(id:int) -> void:
	_type_id = id
	get_node("Sprite").modulate = Global.object_types[_type_id][1]

func set_direction(_angle:float, _pos:Vector2) -> void:
	rotation = (_angle + PI/2)
	position = _pos
	_direction = Vector2(cos(_angle), sin(_angle))

func _physics_process(delta: float) -> void:
	position += _direction * delta * SPEED

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _on_Bullet_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		if area.get_enemy_type_id() == _type_id:
			area.receive_damage(1)
		queue_free()
