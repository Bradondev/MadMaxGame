extends Node

@export var fleetManager: FleetManager

func playerEnteredRange(playerCar: Node2D) -> void:
	if(playerCar.get_node("HitBox").collision_layer == 1):
		fleetManager.SetTarget(playerCar)

func playerExitedRange(playerCar: Node2D) -> void:
	if(playerCar.get_node("HitBox").collision_layer == 1):
		fleetManager.SetTarget(null)
