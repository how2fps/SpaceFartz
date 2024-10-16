extends Area2D

@export var bullet: PackedScene = preload("res://bullet.tscn")  # The bullet scene to instantiate
@export var fire_rate: float = 0.5  # Firing rate for the weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
