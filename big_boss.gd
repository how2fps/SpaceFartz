extends CharacterBody2D

var random = RandomNumberGenerator.new()

var main_scene: Node

var upgrade_fire_rate_scene: PackedScene = load("res://upgrade_fire_rate.tscn")
var upgrade_movement_speed_scene: PackedScene = load("res://upgrade_movement_speed.tscn")
var upgrade_lives_scene: PackedScene = load("res://upgrade_lives.tscn")
var upgrade_bullet_count_scene: PackedScene = load("res://upgrade_bullet_count.tscn")

var boss_weapon_scene: PackedScene = preload("res://boss_weapon.tscn")

@onready var boss_sprite = $Sprite2D  # Adjust to point to your Sprite2D node
var flash_time := 0.1  # Duration of the flash effect
var original_color : Color  # Store the original sprite color
var is_flashing := false  # Flag to prevent multiple flashes at once

@onready var collision_area = $Area2D
@export var vertical_speed: float = 40.0
@export var bullet_count = 1
@export var lives = 1000
@export var bonus_lives = 0

func _ready():
	position.y = -300
	var chance = random.randf()  # Generate a random float between 0 and 1
	if chance <= 0.33:
		boss_sprite.texture = preload("res://Images/purple boss.png")
	elif chance > 0.33 and chance <= 0.66:
		boss_sprite.texture = preload("res://Images/orange boss.png")
	else:
		boss_sprite.texture = preload("res://Images/green boss.png")
		
	var boss_weapon_left_instance = boss_weapon_scene.instantiate()
	var boss_weapon_right_instance = boss_weapon_scene.instantiate()
	var boss_weapon_middle_instance = boss_weapon_scene.instantiate()
	
	add_child(boss_weapon_middle_instance)
	add_child(boss_weapon_left_instance)  # Add the weapon as a child of the player character
	add_child(boss_weapon_right_instance)  # Add the weapon as a child of the player character
	original_color = boss_sprite.modulate
	main_scene = get_tree().current_scene
	add_to_group("boss")

	boss_weapon_left_instance.position = Vector2(100, 250)  # Adjust weapon's position relative to the player
	boss_weapon_right_instance.position = Vector2(440, 250)  # Adjust weapon's position relative to the player
	#collision_area.connect("body_entered", _on_body_entered)


func _physics_process(delta):
	if position.y < 50:
		position.y += vertical_speed * delta
   # Update the timer for changing direction
	
	if lives <= 0:
		queue_free()
		main_scene.update_score(50)
		main_scene.enemy_can_spawn = true
		main_scene.boss_is_spawned = false
		main_scene.enemy_timer.set_wait_time(20)
		main_scene.enemy_timer.set_one_shot(false)
		main_scene.enemy_timer.start()
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
	boss_sprite.modulate = Color(2, 2, 2)  # Brighten the sprite (lighter color)
	
	# Use a timer with a callback to reset the sprite color after `flash_time`
	var flash_timer = Timer.new()
	flash_timer.wait_time = flash_time
	flash_timer.one_shot = true
	flash_timer.timeout.connect(reset_flash)
	add_child(flash_timer)
	flash_timer.start()

func reset_flash():
	boss_sprite.modulate = original_color  # Revert the color to its original state
	is_flashing = false
