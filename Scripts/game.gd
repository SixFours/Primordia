extends Node2D
#
#func _process(delta: float) -> void:
	#if $Music.fini == true:
		#$Music.play()

func _process(delta):
	if Input.is_action_just_pressed("ESC"):  # "ui_cancel" is mapped to the ESC key by default
		change_scene("res://Scenes/main_menu.tscn")  # Replace with your scene path

func change_scene(scene_path: String):
	get_tree().change_scene()  # Change to the specified scene
