extends Camera2D

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 5

func _process(delta):
	if Input.is_action_just_pressed("ScrollUp"):
		zoom_out()
	elif Input.is_action_just_pressed("ScrollDown"):
		zoom_in()

func zoom_in():
	zoom *= (1 - zoom_speed)
	zoom = zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func zoom_out():
	zoom *= (1 + zoom_speed)
	zoom = zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
