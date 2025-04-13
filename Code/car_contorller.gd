extends Node
class_name  car_controller


@export var settings: VehicleSettings = VehicleSettings.new()
var averaged_settings: VehicleSettings

var accel_input: float = 0.0
var steer_input: float = 0.0

var current_steer: float = 0.0

var target_position: Vector2
var target_angle: float = 0.0

var is_leader: bool = false

func _ready():
	averaged_settings = settings.duplicate()


func set_info(leader: bool, avg_settings: VehicleSettings) -> void:
	is_leader = leader
	averaged_settings = avg_settings


func take_input(accel: float, steer: float) -> void:
	accel_input = accel
	steer_input = steer


func take_position(pos: Vector2, angle: float) -> void:
	target_position = pos
	target_angle = angle


func get_future_position(future_time: float) -> Vector2:
	return get_parent().global_position + get_parent().linear_velocity * future_time


func _process(delta: float) -> void:
	
	if not is_leader:
		var direction_to_target = (target_position - get_parent().global_position).normalized()
		var angle_to_target = rad_to_deg(direction_to_target.angle_to(get_parent().transform.y))
		var forward_dot = get_parent().transform.y.dot(direction_to_target)

		steer_input = clamp(angle_to_target, -2.0, 2.0)
		var normalized_forward_dot = inverse_lerp(-1.0, 1.0, forward_dot)
		#steer_input *= normalized_forward_dot

		var distance = get_parent().global_position.distance_to(target_position)
		if distance > 30:
			accel_input = 1.0
		else:
			accel_input = 0.0
			steer_input = 0.0

		accel_input *= inverse_lerp(-3.0, 1.0, forward_dot)


func _physics_process(delta: float) -> void:
	var forward = get_parent().transform.y
	var current_speed = get_parent().linear_velocity.dot(forward)
	var normalized_speed = get_parent().linear_velocity.length() / 200

	# Acceleration
	if accel_input != 0.0 and abs(current_speed) < 200:
		var available_torque = accel_input
		get_parent().apply_force(-forward  * available_torque* 800)
		
	
	# Braking
	if accel_input == 0.0:
		get_parent().linear_velocity = get_parent().linear_velocity.lerp(Vector2.ZERO, .2 )


	# Drift / grip
	var lateral_vel = get_parent().transform.x * get_parent().linear_velocity.dot(get_parent().transform.x)
	var forward_vel = get_parent().transform.y * get_parent().linear_velocity.dot(get_parent().transform.y)
	var drift =   averaged_settings.drift_factor if Input.is_action_pressed("drift") else  0.05
	get_parent().linear_velocity = forward_vel + lateral_vel * drift

	# Steering
	var direction_multiplier = -1.0 if current_speed >= 0.0 else  1.0
	var available_steering =  1
	var steer_amount = steer_input * .1 * normalized_speed * available_steering
	current_steer = lerp(current_steer, steer_amount, 5 * delta)
	get_parent().rotation +=  current_steer * direction_multiplier 
