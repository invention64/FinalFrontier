extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	pass
	# Escaping sub-scene like settings with ESC seems to carry over
	#if event is InputEventKey:
	#	if (event as InputEventKey).scancode == KEY_ESCAPE:
	#		_on_Exit_Game_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Settings_pressed():
	get_tree().change_scene("res://Settings.tscn")
	
func _on_TextureButton_pressed():
	OS.shell_open("https://github.com/invention64/FinalFrontier")

func _on_Exit_Game_pressed():
	get_tree().quit()


