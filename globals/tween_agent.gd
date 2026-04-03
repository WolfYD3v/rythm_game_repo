extends Node

signal tween_finished

func _are_all_tween_arguments_right(tween_arguments : Array[Array]) -> bool :
	# Check if there is no arguments (Array) in 'tween_arguments' :
	if tween_arguments.size() < 1 :
		return false
	# Check if all arguments have some problems :
	for argument : Array in tween_arguments :
		# The argument do not have 5 elements :
		if argument.size() != 5 :
			return false
		# The first element of the argument is not a Node :
		if not argument[0] is Node :
			return false
		# The second element of the argument is not a String :
		if not argument[1] is String :
			return false
		# The second element of the argument is a property of the Node :
		if argument[0].get(argument[1]) == null :
			return false
		# The third element of the argument is not equal or lesser than 0.0 :
		if argument[3] <= 0.0 :
			return false
		# The last element of the argument is not a easing type for tweening , also written as an element of the enum 'Tween.EaseType' :
		if not argument[4] is Tween.EaseType :
			return false
	# If all the checks are good , the tweening can occured . If one problem has been found the tweening does not occured .
	return true

func tween(tween_arguments : Array[Array]) -> void :
	assert(_are_all_tween_arguments_right(tween_arguments))
	var _tween = get_tree().create_tween()
	for argument : Array in tween_arguments :
		# argument[0] is a Node
		# argument[1] is a property of the Node
		# argument[2] is the new value attributed to the Node property
		# argument[3] is the time for the tweening to process , as a float
		# argument[4] is the tweening easing
		_tween.set_parallel().tween_property(argument[0] , argument[1] , argument[2] , argument[3]).set_ease(argument[4])
	await _tween.finished
	tween_finished.emit()
