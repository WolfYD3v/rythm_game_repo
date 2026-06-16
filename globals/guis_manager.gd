extends Node

var _guis: Dictionary[String, Node] = {}

func _ready() -> void:
	pass

func scan_for_guis_from(scanning_start_point: Node) -> void:
	for gui: Node in scanning_start_point.get_children():
		if not _guis.has(gui.name): _guis.set(gui.name, gui)
	
	print(_guis)

func gui_call_method(gui_name: String, method_to_call: String, args: Array = []) -> void:
	if gui_exists(gui_name):
		var gui: Node = _guis.get(gui_name)
		if gui.has_method(method_to_call):
			if args.is_empty(): gui.call_deferred(method_to_call)
			else: gui.callv(method_to_call, args)

func gui_exists(gui_name: String) -> bool:
	return _guis.has(gui_name)

func hide_gui(gui_name: String) -> void:
	gui_call_method(gui_name, "hide")

func show_gui(gui_name: String) -> void:
	gui_call_method(gui_name, "show")

func hide_all_guis() -> void:
	for gui_name: String in _guis.keys(): hide_gui(gui_name)

func show_all_guis() -> void:
	for gui_name: String in _guis.keys(): show_gui(gui_name)
