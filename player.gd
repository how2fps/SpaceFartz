extends CharacterBody2D

@export var weapon_scene: PackedScene = preload("res://weapon.tscn")
@export var upgrade_fire_rate_scene: PackedScene = preload("res://upgrade_fire_rate.tscn")
var weapon


var _lives: int = 5
var _movement_speed: float = 300.0
var _fire_rate: float = 0.5
var _bullet_count: int = 1

@export var fire_rate: float = 0.5:
	get:
		return _fire_rate
	set(value):
		print("Fire rate new value: ", value)
		_fire_rate = value
		weapon.fire_rate = _fire_rate
		
@export var movement_speed: float = 300.0:
	get:
		return _movement_speed
	set(value):
		print("Movement speed new value: ", value)
		_movement_speed = value
		
@export var lives: int = 5:
	get:
		return _lives
	set(value):
		print("Lives new value: ", value)
		_lives = value
		
@export var bullet_count: int = 1:
	get:
		return _bullet_count
	set(value):
		print("Bullet count new value: ", value)
		_bullet_count = value
		weapon.bullet_count = _bullet_count

signal shot_fired

func _physics_process(delta):

	if _lives <= 0:
		pass
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("ui_accept"):
		weapon.shoot()
	var direction_x = Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * _movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, _movement_speed)
	var direction_y = Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * _movement_speed
	else:
		velocity.y = move_toward(velocity.y, 0, _movement_speed)
	move_and_slide()

func _ready():
	add_to_group("player")
	weapon = weapon_scene.instantiate()
	add_child(weapon)  # Add the weapon as a child of the player character
	weapon.position = Vector2(0, -50)  # Adjust weapon's position relative to the player
	weapon.fire_rate = _fire_rate
	


	
