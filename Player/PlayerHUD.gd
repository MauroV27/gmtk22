extends CanvasLayer

onready var label_life = $Control/Life
onready var label_scores = $Control/Scores
onready var label_bullets = $Control/Bullets

func update_life(life:int) -> void:
	label_life.text = "life: " + str(life)


func update_scores(scores:int) -> void:
	label_scores.text = str(scores)


func update_bullets(bullets:int) -> void:
	label_bullets.text = str(bullets)
