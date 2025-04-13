extends Node2D
class_name  GameObject

@export var part:CarPart
@export var icon: Sprite2D
@export var DropHitBox:Area2D


func _ready():
	UpdateSprte()
	pass

func  UpdateSprte()->void:
	icon.texture = part.icon
	pass
func PartChange()->void:
	var unitsAreas:Array= DropHitBox.get_overlapping_areas()
	if unitsAreas:
		unitsAreas[0].get_parent().ReplacePart(self)
