extends Area2D

@export var speed: float = 300.0  # Bullet speed in pixels per second

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta  # Multiply by delta to ensure frame-independent movement

	# Optionally: Check if the bullet is out of the screen and queue it for deletion
	if position.y < 0 or position.y > 960:  # Assuming the screen's upper bound is at y = 0
		queue_free()  # Remove the bullet from the scene to avoid clutter
