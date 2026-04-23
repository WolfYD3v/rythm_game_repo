extends Node

signal look_at_map_changed

var look_at_map: bool = false:
	set(value):
		look_at_map = value
		look_at_map_changed.emit()
