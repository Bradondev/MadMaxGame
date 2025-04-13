
extends CarPart
class_name Body

@export var Health: float = 100.0

func _ready():
    print("Body initialized with Health:", Health)

func set_Health(value: float) -> void:
    Health = value
    print("Health set to:", Health)

func get_Health() -> float:
    return Health