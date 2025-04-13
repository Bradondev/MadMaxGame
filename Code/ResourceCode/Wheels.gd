extends CarPart
class_name Wheel

@export var speed: float = 0.0


func set_speed(value: float) -> void:
    speed = value
    print("Speed set to:", speed)

func get_speed() -> float:
    return speed