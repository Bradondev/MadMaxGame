extends CarPart
class_name Wheel

@export var MaxSpeed: float = 0.0
@export var SteeringPower: float = 0.0

func set_speed(value: float) -> void:
    MaxSpeed = value
    print("Speed set to:", MaxSpeed)

func get_speed() -> float:
    return MaxSpeed