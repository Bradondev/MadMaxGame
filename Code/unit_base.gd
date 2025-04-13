extends CharacterBody2D
class_name  Car
@export var BodyPart:Body
@export var WeaponPart:Weapon
@export var WheelPart:Wheel

@export var  BodyIcon: Sprite2D
@export var  WheelIcon: Sprite2D
@export var  WeaponIcon: Sprite2D


func _ready():
	UpdateSprites()
func UpdateSprites() -> void:
	if BodyPart != null and BodyIcon != null:
		BodyIcon.texture = BodyPart.icon
	if WheelPart != null and WheelIcon != null:
		WheelIcon.texture = WheelPart.icon
	if WeaponPart != null and WeaponIcon != null:
		WeaponIcon.texture = WeaponPart.icon
func ReplacePart(Part: CarPart, GameObjectPart:GameObject) -> void:

	match Part.TypeOfPart:
		"Body":
			GameObjectPart.part = BodyPart
			BodyPart = Part as Body
		"Wheels":
			GameObjectPart.part = WheelPart
			WheelPart = Part as Wheel
		"Weapon":
			GameObjectPart.part = WeaponPart
			WeaponPart = Part as Weapon
			WeaponIcon.weapon = Part as Weapon
		_:
			push_warning("Unknown part type: " + Part.TypeOfPart)
	GameObjectPart.UpdateSprte()
	print_debug("aaaaaaaaaaa")
	UpdateSprites()
