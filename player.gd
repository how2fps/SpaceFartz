extends CharacterBody2D

@export var weapon_scene: PackedScene = preload("res://weapon.tscn")
@export var upgrade_scene: PackedScene = preload("res://upgrade.tscn")
var weapon

var speed = 300.0
var bullet_amount = 1
var fire_rate = 0.1
var lives = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 0

signal shot_fired

func _physics_process(delta):

	if lives <= 0:
		print("u ded")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("ui_accept"):
		weapon.shoot()
	var direction_x = Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	var direction_y = Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	move_and_slide()

func _ready():
	# Instance the weapon and attach it to the player
	
	add_to_group("player")
	weapon = weapon_scene.instantiate()
	add_child(weapon)  # Add the weapon as a child of the player character
	weapon.position = Vector2(0, -50)  # Adjust weapon's position relative to the player
	weapon.fire_rate = fire_rate
	weapon.connect("shot_fired", _on_weapon_shot_fired)
	upgrade_scene.connect("collected", _on_upgrade_collected)


func _on_weapon_shot_fired():
	#print("Weapon shot fired!")
	pass
	
func _on_upgrade_collected():
	print('hi')
	fire_rate -= 0.9
	weapon.fire_rate = fire_rate
