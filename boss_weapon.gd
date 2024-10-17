extends Node2D

@export var boss_bullet_scene: PackedScene = preload("res://boss_bullet.tscn")  # The bullet scene to instantiate
var last_shot_time: float = 0.0
var player: CharacterBody2D
var random = RandomNumberGenerator.new()
@export var fire_rate: float = 0.1
@export var bullet_speed_multiplier: float = 1.0
# Called when the node enters the scene tree for the first time.
var move_direction: int = 1  # 1 for right, -1 for left
var movement_range: float = 540.0  # Range for horizontal movement
var horizontal_speed = 50


func _ready():
	player = get_tree().get_root().get_node("Main").player
	if randi() % 2 == 0:
		move_direction = 1  # Move right
	else:
		move_direction = -1  # Move left

func _process(delta: float) -> void:
	# Update the shooting timer

	# Move the weapon left and right
	position.x += move_direction * horizontal_speed * delta

	# Change direction if it reaches the movement range
	if position.x > movement_range or position.x < 0:
		move_direction *= -1  # Reverse the direction

	# Keep the weapon within the defined horizontal range
	position.x = clamp(position.x, 0, movement_range)
	
	shoot()

func shoot():
	var current_time = Time.get_ticks_msec()
	# Check if enough time has passed since the last shot
	if current_time - last_shot_time >= fire_rate * 3000:
		random.randomize()  # Randomize the generator seed
		var chance = random.randf()  # Generate a random float between 0 and 1
		for i in range(1):
			var boss_bullet_instance = boss_bullet_scene.instantiate()
			boss_bullet_instance.speed = boss_bullet_instance.speed * bullet_speed_multiplier
			boss_bullet_instance.position = global_position
			boss_bullet_instance.position.y += i*70  # Set bullet at the weapon's position
			var player_position = (player.position - global_position).normalized()
			if chance <= 0.5:
				boss_bullet_instance.rotation = player_position.angle() - deg_to_rad(90)
				boss_bullet_instance.direction = player_position
			else:
				boss_bullet_instance.direction = Vector2(0, 1)
			get_tree().current_scene.add_child(boss_bullet_instance)
			last_shot_time = current_time  # Update the last shot time
			
		

	
