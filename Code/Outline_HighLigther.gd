
extends Node
class_name OutlineHighlighter

signal  OutlineOff
signal  OutlineOn
@export var visuals: Array[CanvasItem]
@export var outline_color: Color
@export_range(1, 10) var outline_thickness: int = 1


func _ready() -> void:
	for visual in visuals:
		visual.material.set_shader_parameter("color", outline_color)


func clear_highlight() -> void:
	for visual in visuals:
		
		visual.material.set_shader_parameter("width", 0)
		emit_signal("OutlineOff")

func highlight() -> void:
	for visual in visuals:

		visual.material.set_shader_parameter("width", outline_thickness)
		emit_signal("OutlineOn")
