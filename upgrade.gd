extends Area2D

# Reference to the Player node (assign this in the editor or find it in code)
@onready var player = get_tree().get_root().get_node("Main").player  # Adjust the path to your player node
var speed: float = 200.0  # Bullet speed in pixels per second
# Signal to notify when the upgrade is collected
signal collected

func _ready():
	# Connect the body_entered signal to a function
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body == player:
		emit_signal("collected")  # Emit the collected signal
		queue_free()  # Remove the upgrade from the scene
		
func _process(delta):
	position.y += speed * delta  # Multiply by delta to ensure frame-independent movement
	if position.y < 0 or position.y > 960: # If out of screen remove it
		queue_free()
