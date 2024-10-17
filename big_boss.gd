extends CharacterBody2D

var random = RandomNumberGenerator.new()

@export var boss_weapon_scene: PackedScene = preload("res://big_boss.tscn")
@export var boss_speed = 30.0  # Speed of the boss
@export var boss_lives = 20  # Higher health for the boss
@export var amplitude = 200.0  # Oscillation width for the boss movement
@export var frequency = 0.5  # How fast the boss oscillates
@export var attack_interval = 1.5  # Time between boss attacks

var boss_direction = 1  # 1 for right, -1 for left
var attack_timer = 0.5  # Timer to track when the boss can attack
var oscillation_timer = 0.5  # Timer to track movement oscillation

func _ready():
	# Set boss's initial position at the top of the screen
	position.x = get_viewport().size.x / 2  # Start in the center horizontally
	position.y = 50  # Near the top of the screen

	# Initialize the boss weapon system
	var boss_weapon_instance = boss_weapon_scene.instantiate()
	add_child(boss_weapon_instance)
	boss_weapon_instance.position = Vector2(0, 100)

	connect("area_entered", _on_area_entered)  # Detect bullet collisions
	random.randomize()  # Randomize the generator seed

func _physics_process(delta):
	# Move horizontally in a sinusoidal (oscillating) pattern
	oscillation_timer += delta
	position.x += amplitude * sin(frequency * oscillation_timer)  # Oscillation effect

	# Allow the boss to attack at intervals
	attack_timer += delta
	if attack_timer >= attack_interval:
		attack()
		attack_timer = 0  # Reset the attack timer

	# Destroy the boss if its health (lives) reaches 0
	if boss_lives <= 0:
		queue_free()
		print("Boss defeated!")

	move_and_slide()

func attack():
	# Boss's attack behavior (shoots a series of bullets or a unique attack)
	var boss_weapon_instance = boss_weapon_scene.instantiate()
	add_child(boss_weapon_instance)
	boss_weapon_instance.position = global_position  # Set the weapon's position relative to the boss
	print("Boss is attacking!")

func _on_area_entered(area):
	if area.name == "Bullet":  # If the boss is hit by the player's bullet
		print("Boss hit by bullet!")
		boss_lives -= 1  # Decrease boss's health
		if boss_lives <= 0:
			queue_free()  # Remove the boss from the scene when health reaches 0

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Boss collided with the player!")
		body.lives -= 1  # Deal damage to the player
		queue_free()  # Optionally remove the boss


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	pass
