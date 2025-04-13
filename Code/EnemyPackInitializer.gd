extends Node2D

@export var fleetManager: FleetManager
@export var enemiesMinMax: Vector2
@export var enemyBodyParts: Array[Body]
@export var enemyWheelParts: Array[Wheel]
@export var enemyWeaponParts: Array[Weapon]

@export var enemy_scene: PackedScene

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	add_to_group("EnemyFleet")

	var enemies = rng.randi_range(enemiesMinMax.x, enemiesMinMax.y)
	for i in enemies:
		var enemy: car_part_obj = enemy_scene.instantiate()
		enemy.position = global_position
		print_debug(enemy)
		var newCar = enemy.CreateNewCar(
			enemyBodyParts[rng.randi_range(0, enemyBodyParts.size() - 1)],
			enemyWheelParts[rng.randi_range(0, enemyWheelParts.size() - 1)],
			enemyWeaponParts.pick_random()
			)
		newCar.add_to_group("Enemies")
		newCar.Cam.enabled = false
		add_child(newCar)
		newCar.global_position = global_position
		var hitbox = newCar.get_node("HitBox")  # or get_child if you're certain of the index
		hitbox.collision_layer = 1 << 1                     # Layer 2
		hitbox.collision_mask = (1 << 0)    # Collides with layers 1 and 2
		fleetManager.AddNewCar(newCar)
