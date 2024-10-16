extends Node2D

@export var bullet_scene: PackedScene = preload("res://bullet.tscn")  # The bullet scene to instantiate
@export var fire_rate: float = 0.5 
@export var bullet_count: int = 1
var last_shot_time: float = 0.0

func shoot():
	var current_time = Time.get_ticks_msec()

	# Check if enough time has passed since the last shot
	if current_time - last_shot_time >= fire_rate * 1000:
		var spread: float = 30.0  # Define the distance between bullets
		var middle_index: float = (bullet_count - 1) / 2.0  # Centering bullets around the middle

		for i in range(bullet_count):
			var bullet_instance = bullet_scene.instantiate()
			bullet_instance.position = global_position
			bullet_instance.position.y -= 70  # Set bullet at the weapon's position
			bullet_instance.position.x += (i - middle_index) * spread  # Calculate horizontal offset
			get_tree().current_scene.add_child(bullet_instance)
			
		last_shot_time = current_time  # Update the last shot time

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
