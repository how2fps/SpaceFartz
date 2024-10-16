extends Node2D

var upgrade_scene: PackedScene = load("res://upgrade.tscn")
var player_scene: PackedScene = load("res://player.tscn")
var enemy_ship_scene: PackedScene = load("res://enemy_ship.tscn")

var upgrade
var player

var spawn_timer = 0.0  # Timer to control spawn frequency
var spawn_interval = 1.5  # Time interval between spawns


# Called when the node enters the scene tree for the first time.
func _ready():
	
	upgrade = upgrade_scene.instantiate()
	player = player_scene.instantiate()
	upgrade.position = Vector2(500, 200) 
	player.position = Vector2(270, 800)  # Set the player's position (x, y)
	add_child(player)  # Add the player to the scene
	add_child(upgrade)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_timer += delta  # Update the spawn timer
	if spawn_timer >= spawn_interval:
		spawn_enemy()  # Call the spawn function
		spawn_timer = 0.0  # Reset the timer


func spawn_enemy():
	var enemy_ship_instance = enemy_ship_scene.instantiate()  # Instantiate the enemy
	var screen_size = get_viewport().get_size()  # Get the size of the screen

	# Randomly choose to spawn from the top, left, or right
	var spawn_side = randi() % 3  # Generate a random number (0, 1, or 2)
	match spawn_side:
		0:  # Spawn from the top
			enemy_ship_instance.position = Vector2(randf() * 540/3, 0)  # Random X, Y at top
		1:  # Spawn from the left
			enemy_ship_instance.position = Vector2(0, randf() * 960/3)  # Random Y, X at left
		2:  # Spawn from the right
			enemy_ship_instance.position = Vector2(screen_size.x, randf() * screen_size.y)  # Random Y, X at right
	add_child(enemy_ship_instance)  # Add the enemy instance to the scene tree
