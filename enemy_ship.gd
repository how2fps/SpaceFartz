extends CharacterBody2D

var random = RandomNumberGenerator.new()

var main_scene: Node

var upgrade_fire_rate_scene: PackedScene = load("res://upgrade_fire_rate.tscn")
var upgrade_movement_speed_scene: PackedScene = load("res://upgrade_movement_speed.tscn")
var upgrade_lives_scene: PackedScene = load("res://upgrade_lives.tscn")
var upgrade_bullet_count_scene: PackedScene = load("res://upgrade_bullet_count.tscn")

var enemy_weapon_scene: PackedScene = preload("res://enemy_weapon.tscn")
@onready var explode_sound_player = $ExplodeSoundPlayer

@onready var enemy_sprite = $Sprite2D  # Adjust to point to your Sprite2D node
var flash_time := 0.1  # Duration of the flash effect
var original_color : Color  # Store the original sprite color
var is_flashing := false  # Flag to prevent multiple flashes at once

@onready var collision_area = $Area2D
@export var vertical_speed: float = 40.0
@export var horizontal_speed: float = 100.0
@export var bullet_count = 1
@export var lives = 1
@export var bonus_lives = 0

var change_direction_timer: float = 0.0  # Timer to change direction
var horizontal_amplitude: float = 400.0  # How far left and right to move
var direction: int = 1  # Direction of horizontal movement (1 for right, -1 for left)
var direction_change_interval: float = 1.0  # Time in seconds between direction changes

func _ready():
	var chance = random.randf()  # Generate a random float between 0 and 1
	
	var enemy_weapon_instance = enemy_weapon_scene.instantiate()
	if chance <= 0.33:
		enemy_sprite.texture = preload("res://Images/green enemy.png")
		lives = 1 + bonus_lives
		horizontal_speed = 300
		direction_change_interval = 0.5
		enemy_weapon_instance.fire_rate = 1
		enemy_weapon_instance.bullet_speed_multiplier = 1.5
		enemy_weapon_instance.bullet_count = 1
	elif chance > 0.33 and chance <= 0.66:
		enemy_sprite.texture = preload("res://Images/orange enemy.png")
		lives = 2 + bonus_lives
		horizontal_speed = 200
		direction_change_interval = 1.3
		enemy_weapon_instance.fire_rate = 1
		enemy_weapon_instance.bullet_speed_multiplier = 0.5
		enemy_weapon_instance.bullet_count = 1
	else:
		enemy_sprite.texture = preload("res://Images/purple enemy.png")
		lives = 4 + bonus_lives
		horizontal_speed = 100
		direction_change_interval = 2.2
		enemy_weapon_instance.fire_rate = 1.5
		enemy_weapon_instance.bullet_speed_multiplier = 0.25
		enemy_weapon_instance.bullet_count = 2
	add_child(enemy_weapon_instance)  # Add the weapon as a child of the player character
	original_color = enemy_sprite.modulate
	main_scene = get_tree().current_scene
	add_to_group("enemies")
	vertical_speed = randf_range(vertical_speed/2, vertical_speed)
	horizontal_speed = randf_range(horizontal_speed/2, horizontal_speed)
	if randi() % 2 == 0:
		direction = 1  # Move right
	else:
		direction = -1  # Move left

	enemy_weapon_instance.position = Vector2(0, 50)  # Adjust weapon's position relative to the player
	collision_area.connect("body_entered", _on_body_entered)


func _physics_process(delta):
	position.y += vertical_speed * delta
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
	position.x += direction * horizontal_speed * delta
	
	if lives <= 0:
		explode_sound_player.play()
		queue_free()
		main_scene.update_score(1)
		random.randomize()  # Randomize the generator seed
		var chance = random.randf()  # Generate a random float between 0 and 1
		if chance <= 0.5:
			var upgrade_roll = random.randf()
			if upgrade_roll <= 0.30:
				var upgrade_fire_rate_instance = upgrade_fire_rate_scene.instantiate()
				main_scene.add_child(upgrade_fire_rate_instance)  # Add it to the scene
				upgrade_fire_rate_instance.position = global_position  # Set the position of the upgrade
				print("FIRE RATE.")
			if upgrade_roll > 0.30 and upgrade_roll <= 0.60:
				var upgrade_movement_speed_instance = upgrade_movement_speed_scene.instantiate()
				main_scene.add_child(upgrade_movement_speed_instance)  # Add it to the scene
				upgrade_movement_speed_instance.position = global_position  # Set the position of the upgrade
				print("MOVEMENT.")
			if upgrade_roll > 0.60 and upgrade_roll <= 0.90:
				var upgrade_lives_instance = upgrade_lives_scene.instantiate()
				main_scene.add_child(upgrade_lives_instance)  # Add it to the scene
				upgrade_lives_instance.position = global_position  # Set the position of the upgrade
				print("HEALTH.")
			if upgrade_roll > 0.90:
				var upgrade_bullet_count_instance = upgrade_bullet_count_scene.instantiate()
				main_scene.add_child(upgrade_bullet_count_instance)  # Add it to the scene
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

func start_flash():
	is_flashing = true
	enemy_sprite.modulate = Color(2, 2, 2)  # Brighten the sprite (lighter color)
	
	# Use a timer with a callback to reset the sprite color after `flash_time`
	var flash_timer = Timer.new()
	flash_timer.wait_time = flash_time
	flash_timer.one_shot = true
	flash_timer.timeout.connect(reset_flash)
	add_child(flash_timer)
	flash_timer.start()

func reset_flash():
	enemy_sprite.modulate = original_color  # Revert the color to its original state
	is_flashing = false
