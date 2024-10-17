extends Node2D

@export var enemy_timer = Timer.new()
@export var boss_timer = Timer.new()
@onready var boss_music_player = $BossMusic
@onready var hp_sprite = $HPSprite

@onready var background = $Background

var player_scene: PackedScene = load("res://player.tscn")
var enemy_ship_scene: PackedScene = load("res://enemy_ship.tscn")
var big_boss_scene: PackedScene = load("res://big_boss.tscn")
var enemy_lives: int = 0
var enemy_horizontal_speed: float = 100.0
@export var enemy_can_spawn: bool = true
@export var boss_is_spawned: bool = false

var player: CharacterBody2D
@export var score: int = 0  # Initialize the score variable

var spawn_timer: float = 0.0  # Timer to control spawn frequency
var spawn_interval: float = 1.0  # Time interval between spawns

@onready var score_label = $ScoreLabel  # Assuming ScoreLabel is a Label node in your scene

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score(score)
	
	player = player_scene.instantiate()
	player.position = Vector2(270, 800)  # Set the player's position (x, y)
	add_child(player)  # Add the player to the scene
	
	enemy_timer.set_wait_time(20)
	enemy_timer.set_one_shot(false)
	add_child(enemy_timer)
	enemy_timer.start()
	enemy_timer.timeout.connect(_on_enemy_timer_timeout)
	
	boss_timer.set_wait_time(41) 
	boss_timer.set_one_shot(false)
	add_child(boss_timer)
	boss_timer.start()
	boss_timer.timeout.connect(_on_boss_timer_timeout)
	
func _on_enemy_timer_timeout():
	enemy_lives += 1
	background.scroll_speed += 20
	print("New enemy lives: ", enemy_lives)
	
func _on_boss_timer_timeout():
	print("Boss event triggered")
	despawn_all_enemies()
	enemy_can_spawn = false
	enemy_timer.stop()
	if boss_is_spawned ==  true:
		return
	spawn_boss()
	
	
func _upgrade_hp_sprite():
	match player.lives:
		0:
			hp_sprite.texture = preload("res://Images/upgrade icons/0 lives.png")
		1:
			hp_sprite.texture = preload("res://Images/upgrade icons/1 lives.png")
		2:
			hp_sprite.texture = preload("res://Images/upgrade icons/2 lives.png")
		3:
			hp_sprite.texture = preload("res://Images/upgrade icons/3 lives.png")
		4:
			hp_sprite.texture = preload("res://Images/upgrade icons/4 lives.png")
		5:
			hp_sprite.texture = preload("res://Images/upgrade icons/5 lives.png")
		6:
			hp_sprite.texture = preload("res://Images/upgrade icons/6 lives.png")
		7:
			hp_sprite.texture = preload("res://Images/upgrade icons/7 lives.png")
		8:
			hp_sprite.texture = preload("res://Images/upgrade icons/8 lives.png")
		9:
			hp_sprite.texture = preload("res://Images/upgrade icons/9 lives.png")
		10:
			hp_sprite.texture = preload("res://Images/upgrade icons/10 lives.png")
			
func spawn_boss():
	boss_music_player.play()
	boss_is_spawned = true
	var big_boss_instance = big_boss_scene.instantiate()
	add_child(big_boss_instance)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_upgrade_hp_sprite()
	if enemy_can_spawn:
		spawn_timer += delta  # Update the spawn timer
		if spawn_timer >= spawn_interval:
			spawn_enemy()  # Call the spawn function
			spawn_timer = 0.0  # Reset the timer

func spawn_enemy():
	var enemy_ship_instance = enemy_ship_scene.instantiate()  # Instantiate the enemy
	var screen_size = get_viewport().get_size()  # Get the size of the screen
	enemy_ship_instance.bonus_lives = enemy_lives
	enemy_ship_instance.position = Vector2(randf() * 540, 0)  # Random X, Y at top
	add_child(enemy_ship_instance)  # Add the enemy instance to the scene tree
	
func despawn_all_enemies():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.queue_free()  # Remove each enemy from the scene

func update_score(amount: int):
	score += amount  # Increment the score
	update_score_display()  # Update the display

func update_score_display():
	score_label.text = "Score: " + str(score)  # Update the Label text
	

