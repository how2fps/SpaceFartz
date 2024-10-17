extends Area2D

@onready var player = get_tree().get_root().get_node("Main").player  # Adjust the path to your player node
var speed: float = 200.0
@onready var upgrade_sound_player = $UpgradeSoundPlayer

func _ready():
	# Connect the body_entered signal to a function
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body == player:
		upgrade_sound_player.play()
		if player.fire_rate > 0.2:
			player.fire_rate -=  0.1
		else:
			player.fire_rate -=0.01
		queue_free()
		
func _process(delta):
	position.y += speed * delta  # Multiply by delta to ensure frame-independent movement
	if position.y < 0 or position.y > 960: # If out of screen remove it
		queue_free()
