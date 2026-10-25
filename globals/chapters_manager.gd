extends Node

var current_chapter: int = 1

func _ready() -> void:
	SaveManager.save_loaded.connect(
		func(): current_chapter = SaveManager.get_save_data("current_chapter")
	)

func get_chapter_map_file_path() -> String:
	return "res://chapters/chapter%s/chapter%s_map.tscn" % [
		current_chapter, current_chapter
	]
