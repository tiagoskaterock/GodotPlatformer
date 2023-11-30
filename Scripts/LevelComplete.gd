extends CanvasLayer

func _ready():
	$MarginContainer/VBoxContainer/Button.connect("pressed", self, "on_next_button_pressed")
	
	
func on_next_button_pressed():
	$"/root/LevelManager".increment_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
