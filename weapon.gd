extends Node2D

signal shot_fired

@export var bullet_scene: PackedScene = preload("res://bullet.tscn")  # The bullet scene to instantiate
@export var fire_rate: float = 0.5  # Firing rate for the weapon
var last_shot_time: float = 0.0

func shoot():
	var current_time = Time.get_ticks_msec()

	# Check if enough time has passed since the last shot
	if current_time - last_shot_time >= fire_rate * 1000:
		emit_signal("shot_fired")  # Emit a signal when shooting
		var bullet_instance = bullet_scene.instantiate()
		bullet_instance.position = global_position
		bullet_instance.position.y -= 70  # Set bullet at the weapon's position
		print(global_position)
		get_tree().current_scene.add_child(bullet_instance)
		last_shot_time = current_time  # Update the last shot time

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
