extends RigidBody2D
class_name car
@export var BodyPart:Body
@export var WeaponPart:Weapon
@export var WheelPart:Wheel

@export var  BodyIcon: Sprite2D
@export var  WheelIcon: Sprite2D
@export var  WeaponIcon: Sprite2D
@export var carcontroller:car_controller
@export var Cam:Camera2D
@export var PartScene:PackedScene = load("res://Scene/car_part.tscn")
@export var soundeffect:Array[AudioStream]
var accel_input: float = 0.0
var steer_input: float = 0.0

var current_steer: float = 0.0

var target_position: Vector2
var target_angle: float = 0.0
var CurrentHealth: float = 0.0
var MaxHealth: float = 0.0
var is_leader: bool = false


func UpdateSprites() -> void:
	if BodyPart != null and BodyIcon != null:
		BodyIcon.texture = BodyPart.icon
	if WheelPart != null and WheelIcon != null:
		WheelIcon.texture = WheelPart.icon
	if WeaponPart != null and WeaponIcon != null:
		WeaponIcon.texture = WeaponPart.icon
	
func ReplacePart(Part: CarPart, GameObjectPart:car_part_obj) -> void:

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

func  TakeDamage(amount:float)->void:
	CurrentHealth -= amount
	if CurrentHealth <= 0:
		CurrentHealth = 0
		carcontroller.FleetManagerNode.RemoveCar(carcontroller)
		call_deferred("SpawnPartOnDeath")
		call_deferred("queue_free")
		if amount >5:
			SodaAudioManager.play_sfx(soundeffect.pick_random().resource_path,.5)

	pass

func _spawn_part(part: CarPart) -> void:
	var dropped_part = PartScene.instantiate()
	if dropped_part is car_part_obj:
		dropped_part.part = part
		dropped_part.UpdateSprte()
		dropped_part.global_position = global_position
		get_tree().get_first_node_in_group("MainLevel").add_child(dropped_part)
		
func SpawnPartOnDeath() -> void:
	if PartScene == null:
		return

	# Make a list of existing parts
	var available_parts: Array[CarPart] = []
	if BodyPart != null:
		available_parts.append(BodyPart)
	if WheelPart != null:
		available_parts.append(WheelPart)
	if WeaponPart != null:
		available_parts.append(WeaponPart)

	if available_parts.is_empty():
		return

	# Pick one random part to drop
	var random_part: CarPart = available_parts.pick_random()
	_spawn_part(random_part)
func _ready():
	UpdateSprites()
	MaxHealth = BodyPart.Health
	CurrentHealth = MaxHealth
