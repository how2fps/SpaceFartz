extends CharacterBody2D

var random = RandomNumberGenerator.new()
var upgrade_scene: PackedScene = load("res://upgrade.tscn")
var enemy_weapon_scene: PackedScene = preload("res://enemy_weapon.tscn")

@export var enemy_ship_speed = 50.0
var bullet_amount = 1
var lives = 3

func _physics_process(delta):
	position.y += enemy_ship_speed * delta
	if lives <= 0:
		queue_free()
		random.randomize()  # Randomize the generator seed
		var chance = random.randf()  # Generate a random float between 0 and 1
		if chance <= 0.1:  # 10% chance
			var upgrade_instance = upgrade_scene.instantiate()
			get_tree().current_scene.add_child(upgrade_instance)  # Add it to the scene
			upgrade_instance.position = global_position  # Set the position of the upgrade
			print("Upgrade spawned.")
		else:
			print("No upgrade spawned this time.")
	move_and_slide()
	


func _ready():
	add_to_group("enemies")
	var enemy_weapon_instance = enemy_weapon_scene.instantiate()
	add_child(enemy_weapon_instance)  # Add the weapon as a child of the player character
	enemy_weapon_instance.position = Vector2(0, 50)  # Adjust weapon's position relative to the player
	connect("area_entered", _on_area_entered)  # Optional, in case you want two-way detection
	connect("body_entered", _on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Enemy collided with the player!")
		body.lives -= 1  # Call player damage function
		queue_free()  # Optional: destroy enemy
		
func _on_area_entered(area):
	print(area)
	if area.name == "Bullet":  # If the enemy detects the bullet
		print("Enemy hit by bullet!")
		lives -= 1
		if lives <= 0:
			queue_free()  # Destroy the enemy when health reaches 0

