extends Node2D

signal shot_fired

@export var bullet_scene: PackedScene = preload("res://bullet.tscn")  # The bullet scene to instantiate
@export var fire_rate: float = 0.5  # Firing rate for the weapon
var last_shot_time: float = 0.0

func shoot():
	emit_signal("shot_fired")  # Emit a signal when shooting
	var bullet_instance = bullet_scene.instantiate()
	print(bullet_instance)
	bullet_instance.position = global_position  # Set bullet at the weapon's position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
