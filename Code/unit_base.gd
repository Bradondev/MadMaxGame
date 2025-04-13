extends RigidBody2D
class_name car
@export var BodyPart:Body
@export var WeaponPart:Weapon
@export var WheelPart:Wheel

@export var  BodyIcon: Sprite2D
@export var  WheelIcon: Sprite2D
@export var  WeaponIcon: Sprite2D
@export var settings: VehicleSettings = VehicleSettings.new()
var averaged_settings: VehicleSettings

var accel_input: float = 0.0
var steer_input: float = 0.0

var current_steer: float = 0.0

var target_position: Vector2
var target_angle: float = 0.0

var is_leader: bool = false


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




func _ready():
	UpdateSprites()
