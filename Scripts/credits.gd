extends Control

func _ready(): 
	$BackButton.connect("pressed", Callable(self, "_on_back_pressed"))

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
