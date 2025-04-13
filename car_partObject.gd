extends Node2D
class_name  GameObject

@export var part:CarPart
@export var icon: Sprite2D
@export var DropHitBox:Area2D
@export var PopConponet: PopOut
@export var CarScene:PackedScene
func _ready():
	UpdateSprte()
	

func  UpdateSprte()->void:
	icon.texture = part.icon
	PopConponet.pop()

func PartChange()->void:
	var unitsAreas:Array= DropHitBox.get_overlapping_areas()
	if unitsAreas:
		if unitsAreas[0].get_parent().is_in_group("CarPart"):
			if unitsAreas[0].get_parent().part.TypeOfPart == "Body" and part.TypeOfPart == "Wheels" or unitsAreas[0].get_parent().part.TypeOfPart == "Wheel" and part.TypeOfPart == "Body":
				CreateNewCar(unitsAreas[0].get_parent().part.TypeOfPart, part)
			pass
		unitsAreas[0].get_parent().ReplacePart(part,self)
		print_debug("replace")
func  CreateNewCar(BodyPart:CarPart,OtherPart:CarPart)->car:
	var NewCar:car = CarScene.instantiate()
	NewCar.BodyPart = BodyPart
	NewCar.WheelPart = OtherPart
	return NewCar
