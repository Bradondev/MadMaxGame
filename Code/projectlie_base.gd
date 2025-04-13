extends Area2D

@export var speed := 400.0
@export var damage := 10
@export var direction := Vector2.RIGHT

@export var z_height := 5     # fake vertical height
@export var z_velocity := 0   # upward force
@export var gravitys := 0

@export var bullet_sprite: Sprite2D
@export var shadow_sprite: Sprite2D
@export var KillOnScale:bool = false

@export var landPrefab: PackedScene
@export var hitEffect: PackedScene

@export var soundeffect:Array[AudioStream]
func setup(dmg: int, rot: float):
	damage = dmg
	rotation = rot
	direction = Vector2.RIGHT.rotated(rotation)
	

func _process(delta):
	if(speed < 0.05):
		return
	
	# Move forward in rotated direction
	position += direction * speed * delta

	# Simulate vertical motion
	z_height += z_velocity * delta
	z_velocity -= gravitys * delta

	# Clamp to ground
	if z_height <= 0:
		z_height = 0
		z_velocity = 0

	# Move bullet sprite upwards visually (in local space, factoring rotation)
	var height_offset = Vector2(0, -z_height).rotated(rotation)
	bullet_sprite.position = height_offset

	# Optional: Shadow gets smaller the higher the bullet is
	var shadow_scale = clamp(1.0 - z_height / 200.0, 0.3, 1.0)
	shadow_sprite.scale = Vector2.ONE * shadow_scale
	if KillOnScale:
		if shadow_sprite.scale == Vector2(1,1):
			
			if(landPrefab != null):
				var effect = hitEffect.instantiate()
				get_tree().get_first_node_in_group("MainLevel").add_child(effect)
				if soundeffect:
					SodaAudioManager.play_sfx(soundeffect.pick_random().resource_path,.5)
				effect.global_position = global_position
				
			if(hitEffect != null):
				var effect :GPUParticles2D= hitEffect.instantiate()
				get_tree().get_first_node_in_group("MainLevel").add_child(effect)
				effect.global_position = global_position
				effect.emitting= true
				effect.finished.connect(effect.queue_free)
				
			queue_free()



func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area:Area2D) -> void:
	var parent: Node2D = area.get_parent()
	
	if parent.has_method("TakeDamage"):
		
		if(landPrefab != null):
				var effect = hitEffect.instantiate()
				get_tree().get_first_node_in_group("MainLevel").add_child(effect)
				effect.global_position = global_position
		
		if(hitEffect != null):
			var effect :GPUParticles2D= hitEffect.instantiate()
			get_tree().get_first_node_in_group("MainLevel").add_child(effect)
			effect.global_position = global_position
			effect.emitting= true
			effect.finished.connect(effect.queue_free)
		
		parent.TakeDamage(damage)
		if soundeffect:
			SodaAudioManager.play_sfx(soundeffect.pick_random().resource_path,.5)
		queue_free()
