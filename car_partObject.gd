extends Node2D
class_name  car_part_obj

@export var part:CarPart
@export var icon: Sprite2D
@export var DropHitBox:Area2D
@export var PopConponet: PopOut
@export var CarScene:PackedScene
@export var ParticleEffect:PackedScene

func _ready():
	UpdateSprte()
	

func  UpdateSprte()->void:
	icon.texture = part.icon
	PopConponet.pop()

func PartChange()->void:
	var unitsAreas:Array= DropHitBox.get_overlapping_areas()
	if unitsAreas:
		if unitsAreas[0].get_parent().is_in_group("CarPart"):
			if unitsAreas[0].get_parent().part.TypeOfPart == "Body" and part.TypeOfPart == "Wheels" or unitsAreas[0].get_parent().part.TypeOfPart == "Wheels" and part.TypeOfPart == "Body":
				self.queue_free() 
				get_tree().get_first_node_in_group("FleetManger").AddNewCar(CreateNewCar(unitsAreas[0].get_parent().part, part))
				unitsAreas[0].get_parent().queue_free()
				self.queue_free() 
			return
		unitsAreas[0].get_parent().ReplacePart(part,self)
		var effect :GPUParticles2D= ParticleEffect.instantiate()
		get_tree().get_first_node_in_group("MainLevel").add_child(effect)
		effect.global_position = global_position
		unitsAreas[0].global_rotation = 0.0
		effect.emitting= true
		effect.finished.connect(effect.queue_free)
		print_debug("replace")
func CreateNewCar(Part: CarPart, OtherPart: CarPart , Weapon:CarPart = null) -> car:
	var body_part: CarPart
	var wheel_part: CarPart

	# Match Part
	match Part.TypeOfPart:
		"Body":
			body_part = Part
		"Wheels":
			wheel_part = Part
		_:
			push_warning("Unknown part type for Part: " + Part.TypeOfPart)

	# Match OtherPart
	match OtherPart.TypeOfPart:
		"Body":
			body_part = OtherPart
		"Wheels":
			wheel_part = OtherPart
		_:
			push_warning("Unknown part type for OtherPart: " + OtherPart.TypeOfPart)

	if body_part == null or wheel_part == null:
		push_warning("Missing required parts for car creation.")
		return null

	var new_car: car = CarScene.instantiate()
	new_car.BodyPart = body_part
	new_car.WheelPart = wheel_part
	if Weapon :
		new_car.WeaponPart = Weapon
	
	if(get_tree() != null):
		var effect :GPUParticles2D= ParticleEffect.instantiate()
		get_tree().get_first_node_in_group("MainLevel").add_child(effect)
		effect.global_position = global_position
		effect.emitting= true
		effect.finished.connect(effect.queue_free)
	
	return new_car
