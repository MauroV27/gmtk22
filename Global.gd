extends Node

var _total_scores : int = 0

var object_types = [
	["type1", Color(255, 0, 0)],
	["type2", Color(0, 255, 0)],
	["type3", Color(0, 0, 255)],
	["type4", Color(255, 255, 0)],
]


func set_total_scores(ts:int) -> void:
	_total_scores = ts


func get_total_scores() -> int:
	return _total_scores
