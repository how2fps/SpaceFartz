extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var sprite1_resized_size = sprite1.texture.get_size() * sprite1.scale
	sprite2.position = sprite1.position + Vector2(0, sprite1_resized_size.y)

@export var scroll_speed: float = 400.0  # Speed of the scrolling background
@onready var sprite1 = $BackgroundMain
@onready var sprite2 = $BackgroundRepeat

func _process(delta):
	var sprite1_resized_size = sprite1.texture.get_size() * sprite1.scale
	var sprite2_resized_size = sprite2.texture.get_size() * sprite2.scale

	# Move both sprites down
	sprite1.position.y += scroll_speed * delta
	sprite2.position.y += scroll_speed * delta

# When sprite1 is fully off the screen, move it above sprite2
	if sprite1.position.y >= get_viewport_rect().size.y *1.5:
		sprite1.position.y = sprite2.position.y - sprite1_resized_size.y

	# When sprite2 is fully off the screen, move it above sprite1
	if sprite2.position.y >= get_viewport_rect().size.y * 1.5:
		sprite2.position.y = sprite1.position.y - sprite2_resized_size.y

