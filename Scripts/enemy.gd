extends CharacterBody2D

@export var speed: float = 100.0
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: Node2D = null

func _process(delta):
	if navigation_agent.is_navigation_finished():
		return  # Stop moving if there is no path

	var next_position = navigation_agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func update_path():
	if player:
		navigation_agent.set_target_position(player.global_position)

func _on_follow_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		update_path()


func _on_follow_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		navigation_agent.set_target_position(global_position)  # Stop moving


func _on_timer_timeout() -> void:
	update_path()  # Update path every second

func _on_kill_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().reload_current_scene()
