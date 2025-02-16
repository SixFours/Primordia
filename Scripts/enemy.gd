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
	print("Update path called!")
	if player:
		print("and we have a player to follow")
		navigation_agent.set_target_position(player.global_position)
	else:
		print("but we don't have a player to follow")

func _on_follow_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("This is the player! Time to attack!")
		player = body
		update_path()


func _on_follow_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player ran away!")
		player = null
		navigation_agent.set_target_position(global_position)  # Stop moving


func _on_timer_timeout() -> void:
	print("Timer timed out!")
	update_path()  # Update path every second

func _on_kill_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Kill")
		get_tree().reload_current_scene()
