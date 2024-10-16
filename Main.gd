extends Node2D

var player_scene: PackedScene = load("res://player.tscn")
var enemy_ship_scene: PackedScene = load("res://enemy_ship.tscn")

var player: CharacterBody2D
var score: int = 0  # Initialize the score variable

var spawn_timer: float = 0.0  # Timer to control spawn frequency
var spawn_interval: float = 1.0  # Time interval between spawns

@onready var score_label = $ScoreLabel  # Assuming ScoreLabel is a Label node in your scene

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score(score)
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
	
func update_score(amount: int):
	score += amount  # Increment the score
	update_score_display()  # Update the display

func update_score_display():
	score_label.text = "Score: " + str(score)  # Update the Label text
