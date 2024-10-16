extends CharacterBody2D


var speed = 300.0
var lives = 3

func _physics_process(delta):
	position.y += speed * delta
	move_and_slide()
	
func _ready():
	connect("area_entered", _on_area_entered)  # Optional, in case you want two-way detection

func _on_area_entered(area):
	print(area)
	if area.name == "Bullet":  # If the enemy detects the bullet
		print("Enemy hit by bullet!")
		lives -= 1
		if lives <= 0:
			queue_free()  # Destroy the enemy when health reaches 0

