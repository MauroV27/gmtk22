extends Node2D

const BULLET = preload("res://Player/Bullet.tscn")

onready var _player : KinematicBody2D = get_node("Player")


func _ready() -> void:
	Global.set_total_scores(0) # reset scores
	randomize()
	
	get_node("Enemys").set_target(_player)
	get_node("Enemys").start_spawn()


func _on_Player_create_bullet(_angle:float, _type:int) -> void:
	var _bullet = BULLET.instance()
	_bullet.set_type(_type)
	_bullet.set_direction(_angle, _player.get_node("Sprite2").get_node("Tip").global_position)
	
	add_child(_bullet)
