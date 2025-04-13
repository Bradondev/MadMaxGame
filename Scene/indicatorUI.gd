extends Control

@export var indicator_scene: PackedScene  # Scene that contains one arrow/indicator
@export var camera: Camera2D
@export var targets: Array[Node2D] = []
var active_indicators: Dictionary = {}  # key = Node2D, value = indicator node

func _process(_delta):
	if camera == null:
		print_debug("Camera not found")
		return
	
	# Update target list
	var current_targets = get_tree().get_nodes_in_group("EnemyFleet")

	# Add indicators for new targets
	for target in current_targets:
		if target not in active_indicators:
			var indicator = indicator_scene.instantiate()
			add_child(indicator)
			active_indicators[target] = indicator

	# Remove indicators for invalid/destroyed targets
	for target in active_indicators.keys():
		if !is_instance_valid(target) or target not in current_targets:
			active_indicators[target].queue_free()
			active_indicators.erase(target)

	var screen_size = get_viewport_rect().size
	var center = screen_size * 0.5
	var margin = 50

	# Update indicator positions
	for target in active_indicators.keys():
		if !is_instance_valid(target):
			continue

		var indicator = active_indicators[target]
		var world_pos: Vector2 = target.global_position
		var screen_pos = camera.get_screen_center_position()

		var is_onscreen = screen_pos.x >= margin and screen_pos.x <= screen_size.x - margin and \
						  screen_pos.y >= margin and screen_pos.y <= screen_size.y - margin

		indicator.visible = not is_onscreen

		if !is_onscreen:
			var dir = (screen_pos - center).normalized()
			var edge_pos = center + dir * ((screen_size.length() * 0.5) - margin)
			indicator.position = edge_pos
			indicator.rotation = dir.angle()
