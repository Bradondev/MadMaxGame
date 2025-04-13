
extends CarPart
class_name Weapon

@export var damage: int = 10
@export var fire_rate: float = 1.0 # shots per second
@export var projectile_scene: PackedScene# Shots per second

func _ready():
    print("Weapon initialized with damage:", damage, "and fire rate:", fire_rate)

func fire() -> void:
    print("Firing weapon! Damage:", damage)

func set_damage(value: float) -> void:
    damage = value
    print("Damage set to:", damage)

func get_damage() -> float:
    return damage