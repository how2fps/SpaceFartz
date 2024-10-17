extends Control
@export var main_scene: PackedScene = preload("res://main.tscn")
@onready var high_score_label = $HighScoreLabel  # Assuming ScoreLabel is a Label node in your scene
# Called when the node enters the scene tree for the first time.
func _ready():
	update_score_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_packed(main_scene)


func update_score_display():
	high_score_label.text = "High score: " + str(Global.high_score)  # Update the Label text
