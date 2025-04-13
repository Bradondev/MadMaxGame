extends Node

@export var cars: Array[car_controller] = []
@export var averaged_settings: VehicleSettings = VehicleSettings.new()

@export var fleet_position_holder: Node2D
var fleet_positions: Array[Node2D] = []

@export var delay: float = 0.1
@export var prediction_offset: float = 0.5

var delay_timer: float = 0.0
var input_vector: Vector2 = Vector2.ZERO


func _ready() -> void:
	# Populate fleet_positions from children of fleet_position_holder
	for child in fleet_position_holder.get_children():
		if child is Node2D:
			fleet_positions.append(child)

	# Assign starting positions
	for i in range(min(cars.size(), fleet_positions.size())):
		cars[i].get_parent().global_position = fleet_positions[i].global_position

	recalculate_fleet_information()

	# Set leader/follower info
	if cars.size() > 0:
		cars[0].set_info(true, averaged_settings)

	for i in range(1, cars.size()):
		cars[i].set_info(false, averaged_settings)


func recalculate_fleet_information() -> void:
	averaged_settings.engine_power = 0
	averaged_settings.max_speed = 0
	averaged_settings.steer_speed = 0

	for car in cars:
		averaged_settings.engine_power += car.settings.engine_power
		averaged_settings.max_speed += car.settings.max_speed
		averaged_settings.steer_speed += car.settings.steer_speed

	if cars.size() > 0:
		averaged_settings.engine_power /= cars.size()
		averaged_settings.max_speed /= cars.size()
		averaged_settings.steer_speed /= cars.size()


func _process(delta: float) -> void:
	get_input()
	apply_input()
	delay_timer -= delta
	if delay_timer < 0:
		delay_timer = delay
		align_fleet()


func get_input() -> void:
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Up") - Input.get_action_strength("Down")
	


func apply_input() -> void:
	if cars.size() > 0:
		cars[0].take_input(input_vector.y, input_vector.x)


func align_fleet() -> void:
	if cars.size() == 0 or fleet_positions.size() == 0:
		return

	var leader = cars[0]
	fleet_position_holder.global_position = leader.get_future_position(prediction_offset)
	fleet_position_holder.rotation = leader.get_parent().rotation

	for i in range(1, cars.size()):
		if i < fleet_positions.size():
			cars[i].take_position(fleet_positions[i].global_position, leader.get_parent().rotation_degrees)
			
