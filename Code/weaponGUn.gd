extends Node2D
class_name Gun

@export var weapon: Weapon
@export var muzzle_position: Node2D
@export var gun_sprite: Sprite2D

var can_fire := true

func _ready():
	if weapon == null:
		push_warning("Weapon resource not set on gun.")
	if gun_sprite == null:
		push_warning("Gun sprite not assigned.")
func _process(delta):
	if !weapon:return
	
	# Rotate sprite to face mouse
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	rotation = direction.angle()
	if gun_sprite:
		
		gun_sprite.rotation = rotation - 90.0
		
		
	# Fire on input
	if Input.is_action_pressed("fire") and can_fire:
		fire()
		can_fire = false
		await get_tree().create_timer(1.0 / weapon.fire_rate).timeout
		can_fire = true



func fire():
	if weapon.projectile_scene == null:
		return

	var bullet = weapon.projectile_scene.instantiate()
	bullet.global_position = muzzle_position.global_position
	
	# Set bullet rotation and direction properly
	bullet.rotation = (get_global_mouse_position() - muzzle_position.global_position).angle()

	get_tree().get_first_node_in_group("MainLevel").add_child(bullet)

	if bullet.has_method("setup"):
		bullet.setup(weapon.damage, bullet.rotation)
