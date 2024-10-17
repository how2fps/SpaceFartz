extends CharacterBody2D

@onready var collision_shape = $CollisionShape2D
@onready var player_sprite = $Sprite2D
@export var flash_time: float = 0.2  # Time for each flash
@export var flash_count: int = 3  # Number of flashes

@onready var flash_timer = Timer.new()  # Create a new timer
@onready var original_color: Color = Color(1, 1, 1)  # Original color
@onready var flash_color: Color = Color(2, 2, 2)  # Flash color (brighter)

var current_flashes: int = 0  # Track how many flashes have occurred
var is_flashing: bool = false  # Track if it's flashing

@export var weapon_scene: PackedScene = preload("res://weapon.tscn")
@export var upgrade_fire_rate_scene: PackedScene = preload("res://upgrade_fire_rate.tscn")
@export var start_menu_scene: PackedScene = preload("res://start_menu.tscn")

var weapon: Node

var screen_size: Vector2
var collision_size: Vector2

var _lives: int = 10
var _movement_speed: float = 300.0
var _fire_rate: float = 0.5
var _bullet_count: int = 1

var iframe: bool = false

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
		if iframe == true:
			return
		if(value) < _lives:
			var iframe_timer = Timer.new()
			add_child(iframe_timer)  # Add the timer to the scene
			iframe = true
			iframe_timer.wait_time = 2
			iframe_timer.one_shot = true  # Set the timer to one-shot mode
			iframe_timer.timeout.connect(turn_iframe_off)  # Connect the timeout signal
			iframe_timer.start()
			
			add_child(flash_timer)  # Add the timer to the scene
			flash_timer.wait_time = flash_time
			flash_timer.one_shot = true  # Set the timer to one-shot mode
			flash_timer.timeout.connect(_on_flash_timeout)  # Connect the timeout signal
			start_flash()
		print("Lives new value: ", value)
		_lives = value
		if lives <= 0:
			print('u ded')
			game_over()
		
@export var bullet_count: int = 1:
	get:
		return _bullet_count
	set(value):
		print("Bullet count new value: ", value)
		_bullet_count = value
		weapon.bullet_count = _bullet_count

signal shot_fired

func turn_iframe_off():
	iframe = false

func game_over():
	# Check and update the high score
	Global.set_high_score(get_tree().current_scene.score)
	get_tree().change_scene_to_packed(start_menu_scene)

func start_flash():
	if is_flashing:
		return  # Prevent starting another flash while already flashing
	is_flashing = true
	current_flashes = 0  # Reset the flash counter
	_trigger_flash()  # Start the first flash

# Trigger a flash
func _trigger_flash():
	if current_flashes % 2 == 0:
		player_sprite.modulate = flash_color  # Change to flash color
	else:
		player_sprite.modulate = original_color  # Reset to original color
	current_flashes += 1

	if current_flashes < flash_count * 2:  # Multiply by 2 because each flash has an on and off state
		flash_timer.start()  # Start the timer for the next flash
	else:
		is_flashing = false  # Flashing sequence complete

# When the timer times out, toggle the flash state
func _on_flash_timeout():
	_trigger_flash()  # Trigger the next flash or reset

func _physics_process(delta):
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
	position.x = clamp(position.x, collision_size.x / 2, screen_size.x - collision_size.x / 2)
	position.y = clamp(position.y, collision_size.y / 2, screen_size.y - collision_size.y / 2)

func _ready():
	original_color = player_sprite.modulate
	var shape = collision_shape.shape
	if shape is RectangleShape2D:
		collision_size =  (shape.extents * 2)  # Get the size of the rectangle shape (double the extents)
	else:
		collision_size =  Vector2(shape.radius * 2, shape.radius * 2)  # Get the size of the circle
	# Handle other shapes if needed
	screen_size = get_viewport_rect().size  # Get the screen size
	add_to_group("player")
	weapon = weapon_scene.instantiate()
	add_child(weapon)  # Add the weapon as a child of the player character
	weapon.position = Vector2(0, -50)  # Adjust weapon's position relative to the player
	weapon.fire_rate = _fire_rate
	


	
