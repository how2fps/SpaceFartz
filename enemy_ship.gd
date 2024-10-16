extends CharacterBody2D

var random = RandomNumberGenerator.new()

var upgrade_fire_rate_scene: PackedScene = load("res://upgrade_fire_rate.tscn")
var upgrade_movement_speed_scene: PackedScene = load("res://upgrade_movement_speed.tscn")
var upgrade_lives_scene: PackedScene = load("res://upgrade_lives.tscn")
var upgrade_bullet_count_scene: PackedScene = load("res://upgrade_bullet_count.tscn")

var enemy_weapon_scene: PackedScene = preload("res://enemy_weapon.tscn")

@onready var collision_area = $Area2D
@export var enemy_ship_speed = 50.0
@export var bullet_count = 1
@export var lives = 3

var change_direction_timer: float = 0.0  # Timer to change direction
var horizontal_amplitude: float = 400.0  # How far left and right to move
var direction: int = 1  # Direction of horizontal movement (1 for right, -1 for left)
var direction_change_interval: float = 1.0  # Time in seconds between direction changes

func _ready():
	add_to_group("enemies")
	if randi() % 2 == 0:
		direction = 1  # Move right
	else:
		direction = -1  # Move left
	var enemy_weapon_instance = enemy_weapon_scene.instantiate()
	add_child(enemy_weapon_instance)  # Add the weapon as a child of the player character
	enemy_weapon_instance.position = Vector2(0, 50)  # Adjust weapon's position relative to the player
	collision_area.connect("body_entered", _on_body_entered)
	
func _physics_process(delta):
	position.y += enemy_ship_speed * delta
	# Calculate the horizontal movement using sine wave
	position.x += direction * enemy_ship_speed * delta

   # Update the timer for changing direction
	change_direction_timer += delta

	# Change direction randomly at specified intervals
	if change_direction_timer >= direction_change_interval:
		if randi() % 2 == 0:
			direction = 1  # Move right
		else:
			direction = -1  # Move left
		change_direction_timer = 0.0  # Reset timer

	# Move left or right
	position.x += direction * enemy_ship_speed * delta
	
	if lives <= 0:
		queue_free()
		random.randomize()  # Randomize the generator seed
		var chance = random.randf()  # Generate a random float between 0 and 1
		if chance <= 1:
			var upgrade_roll = random.randf()
			if upgrade_roll <= 0.30:
				var upgrade_fire_rate_instance = upgrade_fire_rate_scene.instantiate()
				get_tree().current_scene.add_child(upgrade_fire_rate_instance)  # Add it to the scene
				upgrade_fire_rate_instance.position = global_position  # Set the position of the upgrade
				print("FIRE RATE.")
			if upgrade_roll > 0.30 and upgrade_roll <= 0.60:
				var upgrade_movement_speed_instance = upgrade_movement_speed_scene.instantiate()
				get_tree().current_scene.add_child(upgrade_movement_speed_instance)  # Add it to the scene
				upgrade_movement_speed_instance.position = global_position  # Set the position of the upgrade
				print("MOVEMENT.")
			if upgrade_roll > 0.60 and upgrade_roll <= 0.90:
				var upgrade_lives_instance = upgrade_lives_scene.instantiate()
				get_tree().current_scene.add_child(upgrade_lives_instance)  # Add it to the scene
				upgrade_lives_instance.position = global_position  # Set the position of the upgrade
				print("HEALTH.")
			if upgrade_roll > 0.90:
				var upgrade_bullet_count_instance = upgrade_bullet_count_scene.instantiate()
				get_tree().current_scene.add_child(upgrade_bullet_count_instance)  # Add it to the scene
				upgrade_bullet_count_instance.position = global_position  # Set the position of the upgrade
				print("BULLET COUNT.")
		else:
			print("No upgrade spawned this time.")
	move_and_slide()
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Enemy collided with the player!")
		body.lives -= 1  # Call player damage function
		queue_free()  # Optional: destroy enemy
		
func _on_area_entered(area):                                        
	if area.name == "Bullet":  # If the enemy detects the bullet
		print("Enemy hit by bullet!")
		lives -= 1
		if lives <= 0:
			queue_free()  # Destroy the enemy when health reaches 0

