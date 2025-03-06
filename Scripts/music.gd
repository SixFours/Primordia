extends AudioStreamPlayer

func _ready():
	if stream:  # Ensure there's an audio file assigned
		play()  # Start playing
