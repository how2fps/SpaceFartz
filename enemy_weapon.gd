extends Node2D

@export var enemy_bullet_scene: PackedScene = preload("res://enemy_bullet.tscn")  # The bullet scene to instantiate
var last_shot_time: float = 0.0
var player: CharacterBody2D
var random = RandomNumberGenerator.new()
@export var fire_rate: float = 1.0
@export var bullet_speed_multiplier: float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Main").player
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shoot()

func shoot():
	var current_time = Time.get_ticks_msec()
	# Check if enough time has passed since the last shot
	if current_time - last_shot_time >= fire_rate * 3000:
		random.randomize()  # Randomize the generator seed
		var chance = random.randf()  # Generate a random float between 0 and 1
		for i in range(2):
			var enemy_bullet_instance = enemy_bullet_scene.instantiate()
			enemy_bullet_instance.speed = enemy_bullet_instance.speed * bullet_speed_multiplier
			enemy_bullet_instance.position = global_position
			enemy_bullet_instance.position.y += i*70  # Set bullet at the weapon's position
			var player_position = (player.position - global_position).normalized()
			if chance <= 0.5:
				enemy_bullet_instance.rotation = player_position.angle() - deg_to_rad(90)
				enemy_bullet_instance.direction = player_position
			else:
				enemy_bullet_instance.direction = Vector2(0, 1)
			get_tree().current_scene.add_child(enemy_bullet_instance)
			last_shot_time = current_time  # Update the last shot time
			
		

	
