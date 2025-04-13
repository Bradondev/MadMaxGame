extends Node

class_name FleetManager

@export var playerFleet: FleetManager
@export var cars: Array[car_controller] = []
@export var averaged_settings: VehicleSettings
@export var isPlayer: bool

@export var fleet_position_holder: Node2D
var fleet_positions: Array[Node2D] = []

@export var delay: float = 0.1
@export var prediction_offset: float = 0.5

var delay_timer: float = 0.0
var input_vector: Vector2 = Vector2.ZERO
var targetT: Node2D
var targetOffset: Vector2

func _ready() -> void:
	# Populate fleet_positions from children of fleet_position_holder
	for child in fleet_position_holder.get_children():
		if child is Node2D:
			fleet_positions.append(child)

	# Assign starting positions
	for i in range(min(cars.size(), fleet_positions.size())):
		cars[i].initalize()
		cars[i].get_parent().global_position = fleet_positions[i].global_position
	
	recalculate_fleet_information()

	# Set leader/follower info
	if cars.size() > 0:
		cars[0].set_info(isPlayer, isPlayer, averaged_settings)

	for i in range(1, cars.size()):
		cars[i].set_info(isPlayer, false, averaged_settings)
		
	align_fleet()

func get_random_car() -> car_controller:
	return cars[randi_range(0, cars.size() - 1)]

func recalculate_fleet_information() -> void:
	
	var settingsNew = averaged_settings.duplicate(true)
	
	settingsNew.engine_power = 0
	settingsNew.max_speed = 0
	settingsNew.steer_speed = 0

	for car in cars:
		settingsNew.engine_power += car.settings.engine_power
		settingsNew.max_speed += car.settings.max_speed
		settingsNew.steer_speed += car.settings.steer_speed

	if cars.size() > 0:
		settingsNew.engine_power /= cars.size()
		settingsNew.max_speed /= cars.size()
		settingsNew.steer_speed /= cars.size()
	
	averaged_settings = settingsNew.duplicate(true)
		

func SetTarget(target: Node2D) -> void:
	targetT = target
	var angle = randf() * TAU  # TAU is 2 * PI
	targetOffset =  Vector2(cos(angle), sin(angle)) * 30

func _process(delta: float) -> void:
	
	if(isPlayer):
		get_input()
		apply_input()
	else:
		if(targetT ==  null):
			cars[0].take_position(get_child(0).global_position, 0)
		#if(targetT !=  null):
			#cars[0].take_position(targetT.global_position + targetOffset, 0)
		
	delay_timer -= delta
	if delay_timer < 0:
		delay_timer = delay
		if(isPlayer):
			align_fleet()
		else:
			if(targetT !=  null):
				align_enemy_fleet()
			else:
				align_fleet()
			var angle = randf() * TAU  # TAU is 2 * PI
			targetOffset =  Vector2(cos(angle), sin(angle)) * 30


func get_input() -> void:
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Up") - Input.get_action_strength("Down")
	


func apply_input() -> void:
	if cars.size() > 0:
		cars[0].take_input(input_vector.y, input_vector.x)

func align_enemy_fleet() -> void:
	for i in range(cars.size()):
		var target_index = i % playerFleet.cars.size()
		cars[i].take_position(playerFleet.cars[target_index].get_parent().global_position, 0)

func align_fleet() -> void:
	if cars.size() == 0 or fleet_positions.size() == 0:
		return

	var leader = cars[0]
	fleet_position_holder.global_position = leader.get_future_position(prediction_offset)
	fleet_position_holder.rotation = leader.get_parent().rotation

	for i in range(1, cars.size()):
		if i < fleet_positions.size():
			cars[i].take_position(fleet_positions[i].global_position, leader.get_parent().rotation_degrees)
			
func  AddNewCar(NewCar:car)->void:
	if(isPlayer):
		NewCar.global_position = get_tree().get_first_node_in_group("MainLevel").get_global_mouse_position()
		get_tree().get_first_node_in_group("MainLevel").add_child(NewCar)
	cars.append(NewCar.carcontroller)
	NewCar.carcontroller.set_info(isPlayer, false, averaged_settings)
	NewCar.carcontroller.initalize()
	recalculate_fleet_information()
	pass
