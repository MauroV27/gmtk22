extends Node

const ENEMY = preload("res://Enemys/Types/EnemyType1.tscn")
const ENEMY_2 = preload("res://Enemys/Types/EnemyType2.tscn")
const ENEMY_3 = preload("res://Enemys/Types/EnemyType3.tscn")
const ENEMY_4 = preload("res://Enemys/Types/EnemyType4.tscn")

onready var timer : Timer = $Timer
var _player_target_ref : KinematicBody2D

func set_target(target: KinematicBody2D) -> void:
	_player_target_ref = target

func start_spawn() -> void:
	timer.stop()
	timer.start()

func create_enemy() -> void:
	var _enemy 
	var _color
	
	var _type : int = randi() % Global.object_types.size()
	
	match _type:
		0:
			_enemy = ENEMY.instance()
		1:
			_enemy = ENEMY_2.instance()
		2:
			_enemy = ENEMY_3.instance()
		3:
			_enemy = ENEMY_4.instance()
	
	var _pos : Vector2 = Vector2( rand_range(-400, 400), rand_range(-200, 200) )
	
	_enemy.set_target(_player_target_ref)
	_enemy.set_enemy(_pos, _type)
	
	add_child(_enemy)

func _on_Timer_timeout() -> void:
	create_enemy()
