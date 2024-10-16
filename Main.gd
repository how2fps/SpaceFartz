extends Node2D

var player_scene: PackedScene = load("res://player.tscn")
var enemy_ship_scene: PackedScene = load("res://enemy_ship.tscn")

var player

var spawn_timer = 0.0  # Timer to control spawn frequency
var spawn_interval = 1  # Time interval between spawns

# Called when the node enters the scene tree for the first time.
func _ready():
	
	player = player_scene.instantiate()
	player.position = Vector2(270, 800)  # Set the player's position (x, y)
	add_child(player)  # Add the player to the scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_timer += delta  # Update the spawn timer
	if spawn_timer >= spawn_interval:
		spawn_enemy()  # Call the spawn function
		spawn_timer = 0.0  # Reset the timer

func spawn_enemy():
	var enemy_ship_instance = enemy_ship_scene.instantiate()  # Instantiate the enemy
	var screen_size = get_viewport().get_size()  # Get the size of the screen

	
	enemy_ship_instance.position = Vector2(randf() * 540, 0)  # Random X, Y at top
	add_child(enemy_ship_instance)  # Add the enemy instance to the scene tree
