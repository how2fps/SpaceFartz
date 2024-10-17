extends Area2D

@export var speed: float = 300.0  # Bullet speed in pixels per second
@onready var bullet_sound_player = $BulletSound
# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_sound_player.play()
	connect("body_entered", _on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.lives -= 1
		body.start_flash()
		queue_free()
	if body.is_in_group("boss"):
		body.lives -= 1
		body.start_flash()
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta  # Multiply by delta to ensure frame-independent movement

	# Optionally: Check if the bullet is out of the screen and queue it for deletion
	if position.y < 0 or position.y > 960:  # Assuming the screen's upper bound is at y = 0
		queue_free()


