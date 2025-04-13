extends Resource
class_name VehicleSettings
@icon("res://icon.svg") # Optional icon for editor display

@export var engine_power: float = 5.0
@export var max_speed: float = 10.0

@export var power_curve: Curve = Curve.new()
@export var steer_speed: float = 3.0
@export var steer_curve: Curve = Curve.new()

@export var drift_factor: float = 0.95
@export var grip_factor: float = 0.9
@export var brake_friction: float = 1.0
