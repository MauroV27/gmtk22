extends Node2D

const ENEMY_1 = preload("res://Enemys/Types/EnemyType1.tscn")
const ENEMY_2 = preload("res://Enemys/Types/EnemyType2.tscn")
const ENEMY_3 = preload("res://Enemys/Types/EnemyType3.tscn")
const ENEMY_4 = preload("res://Enemys/Types/EnemyType4.tscn")

onready var timer : Timer = $Timer

export var wait_time : float = 3.0

var _spanw_positions : Array
var _target : KinematicBody2D

func set_target(target:KinematicBody2D)-> void:
	_target = target

func _ready() -> void:
	
	for spawn in $SpawnPoints.get_children():
		_spanw_positions.append(spawn.position)
		
	timer.start()

func _create_enemy() -> void:
	
	var _enemy
	var _chance = (randi() % 15) + 1 
	var _id # GAMBIARRA
	
	if _chance <= 6 :
		_enemy = ENEMY_1.instance()
		_id = 0
	elif _chance <= 10 and _chance > 6 :
		_enemy = ENEMY_2.instance()
		_id = 1
	elif _chance <= 13 and _chance > 6 :
		_enemy = ENEMY_3.instance()
		_id = 2
	else:
		_enemy = ENEMY_4.instance()
		_id = 3
	
	var _pos_spawn = _spanw_positions[randi() % _spanw_positions.size() ]
	
	_enemy.set_target(_target)
	_enemy.set_enemy(_pos_spawn, _id) 
	get_node("Enemys").add_child(_enemy)
	
	timer.start()
	timer.wait_time = wait_time

func _on_Timer_timeout() -> void:
	timer.stop()
	_create_enemy()
