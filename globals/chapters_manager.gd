extends Node

var current_chapter: int = 1

func _ready() -> void:
	pass

func build_chapter_map_file_path() -> String:
	return "res://chapters/chapter%s/chapter%s_map.tscn" % [
		current_chapter, current_chapter
	]
