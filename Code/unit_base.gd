extends CharacterBody2D
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

func ReplacePart(Part:GameObject)->void:
    print_debug("adad")
    pass