# This code comes from a collaborative Godot Project, where Healleu
# added this autoload to the project.
# I have modified the code to match his code with my coding style and my needs.
# But all the credits for this code goes to him :)
# https://github.com/WolfYD3v/Godot-Wild-Jam-91---Game-Project-Repository/blob/main/autoloads/SceneManager.gd

extends Node

signal replacing_scene

var _scenes : Dictionary = {}
var _current_scene : Node = null
var _current_scene_name : String = ""

func add_scene(scene_name: String, scene: PackedScene) -> void :
	_scenes.set(scene_name, scene)

func remove_scene(scene_name: String) -> void :
	if _scenes.has(scene_name): _scenes.erase(scene_name)

func replace_scene(scene_name: String) -> void :
	if _scenes.has(scene_name):
		replacing_scene.emit()
		if _current_scene != null:
			_current_scene.queue_free()
			_current_scene = null
		var new_packed_scene : PackedScene = _scenes[scene_name]
		var new_scene = new_packed_scene.instantiate()
		get_tree().root.call_deferred("add_child", new_scene)
		_current_scene = new_scene
		_current_scene_name = scene_name

func get_scene(scene_name: String) -> PackedScene:
	if _scenes.has(scene_name): return _scenes.get(scene_name)
	return null

func get_current_scene() -> String:
	return _current_scene_name

func get_scenes(with_values: bool = false) -> Variant:
	if with_values: return _scenes
	return _scenes.keys()
