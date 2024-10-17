extends Node


var high_score = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
# Global.gd	
func set_high_score(new_score):
	if new_score > high_score:
		high_score = new_score
		print(high_score)

func get_high_score():
	return high_score
