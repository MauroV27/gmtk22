extends Node

export (float) var stage_interval = 10

var current_stage := 0
var wave_ended := false

onready var stages = $Stages.get_children() as Array
onready var points = $SpawnPoints.get_children() as Array


func _ready() -> void:
	for i in stages:
		for j in i.get_children():
			j.global_position = points[randi() % points.size()].global_position
	start_stage()


func _process(_delta: float) -> void:
	if wave_ended:
		var stage = stages[current_stage] as Node
		if stage.get_child_count() == 0:
			queue_free()


func start_stage():
	var stage = stages[current_stage] as Node
	for i in stage.get_children():
		i.activate()
	var time = get_tree().create_timer(stage_interval)
	time.connect("timeout", self, "on_timeout")


func _on_timeout():
	if current_stage == stages.size() - 1:
		wave_ended = true
	else:
		current_stage += 1
		start_stage()
