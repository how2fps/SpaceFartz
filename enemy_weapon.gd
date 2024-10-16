extends Node2D

@export var enemy_bullet_scene: PackedScene = preload("res://enemy_bullet.tscn")  # The bullet scene to instantiate
var last_shot_time: float = 0.0

func shoot():
	var current_time = Time.get_ticks_msec()

	# Check if enough time has passed since the last shot
	if current_time - last_shot_time >= 1 * 3000:
		for i in range(3):
			var enemy_bullet_instance = enemy_bullet_scene.instantiate()
			enemy_bullet_instance.position = global_position
			enemy_bullet_instance.position.y += i*70  # Set bullet at the weapon's position
			get_tree().current_scene.add_child(enemy_bullet_instance)
			last_shot_time = current_time  # Update the last shot time
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shoot()
	
