extends Control

func _ready():
	$PlayButton.connect("pressed", Callable(self, "_on_play_pressed"))
	$ExitButton.connect("pressed", Callable(self, "_on_exit_pressed"))
	$CreditsButton.connect("pressed", Callable(self, "_on_credits_pressed"))

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")  # Change this path to your actual game scene

func _on_exit_pressed():
	get_tree().quit()

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
