extends CanvasLayer

onready var label_life = $Control/Life
onready var label_scores = $Control/Scores
onready var label_bullets = $Control/BulletManager/Square1/Bullets

func update_life(life:int) -> void:
	label_life.text = "life: " + str(life)


func update_scores(scores:int) -> void:
	label_scores.text = str(scores)


func update_bullets(bullets:int, currently_bullet_id:int, stack:Array) -> void:
	label_bullets.text = str(bullets)
	
	get_node("Control/BulletManager/Square1").color = Global.object_types[currently_bullet_id][1]
	get_node("Control/BulletManager/Square2").color = Global.object_types[stack[0]][1]
	get_node("Control/BulletManager/Square3").color = Global.object_types[stack[1]][1]
	get_node("Control/BulletManager/Square4").color = Global.object_types[stack[2]][1]
