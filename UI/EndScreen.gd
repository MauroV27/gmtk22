extends Control

onready var scores = $TotalScores
onready var btn_menu = $ButtonMenu
onready var btn_game = $ButtonRestart

var total_points : int = 0
var count_increase : float = 5.0
var count : float = 0

func _ready() -> void:
	total_points = Global.get_total_scores()
	count_increase = total_points/30
	count = 0
	
	btn_menu.visible = false
	btn_game.visible = false


func _process(delta: float) -> void:
	count += count_increase 
	count = min(count, total_points)
	
	scores.text = str(int(count))
	
	if count >= total_points:
		scores.get_font("font").size = 48
		
		btn_menu.visible = true
		btn_game.visible = true
		
		set_process(false)


func _on_ButtonMenu_pressed() -> void:
	get_tree().change_scene("res://UI/Menu.tscn")


func _on_ButtonRestart_pressed() -> void:
	get_tree().change_scene("res://Game.tscn")
