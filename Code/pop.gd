extends Node
class_name PopOut

@export var scale_amount := 1.2
@export var move_distance := 10.0
@export var duration := 0.2
@export var pop_back := true
@export var back_duration := 0.1

var tween: Tween

func _ready():
	tween = create_tween()

func pop():
	if !tween: return
	if tween.is_running():
		tween.kill()

	tween = create_tween()

	var parent_node = get_parent()
	var original_scale = parent_node.scale
	var original_pos = parent_node.position

	# Random direction (left, right, up)
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP]
	var random_dir = directions[randi() % directions.size()]
	var move_offset = random_dir * move_distance

	# Pop out (scale + move randomly)
	tween.tween_property(parent_node, "scale", original_scale * scale_amount, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(parent_node, "position", original_pos + move_offset, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(parent_node, "scale", original_scale, back_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	if pop_back:
		tween.parallel().tween_property(parent_node, "position", original_pos, back_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
