extends CharacterBody2D

@export var speed: float = 125.0  # Speed of the enemy
@onready var area: Area2D = $Area2D  # The Area2D node where the detection will happen
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: Node2D = null
var eaten = false  # Track if the item is already consumed

func _process(delta: float) -> void:
	if player:
		update_path()
	
	if navigation_agent.is_navigation_finished():
		return  # Stop moving if there is no path

	var next_position = navigation_agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_in_group("Player"):
			print("+1 Food!")
			queue_free()

func update_path():
	if player:
		# Calculate a direction away from the player
		var direction_away = (global_position - player.global_position).normalized()

		# Set a target position in the opposite direction from the player
		var flee_distance = 200  # Adjust the flee distance to control how far the enemy flees
		var flee_target = global_position + direction_away * flee_distance

		# Set the target position for the navigation agent to flee from the player
		navigation_agent.set_target_position(flee_target)

# Stop the enemy from fleeing (optional)
func stop_fleeing():
	velocity = Vector2.ZERO  # Stop moving when the player leaves the area

func _on_eat_area_body_entered(body: Node2D) -> void:		
	if eaten:
		return  # Don't do anything if we are already eaten
			
	if body.is_in_group("Player"):
		eaten = true  # Mark that we have been eaten, so can't be eaten again
		visible = false  # Hide the food immediately
		print("+1 Food!")
		$EatSound.play()
		call_deferred("queue_free_after_eat_sound")

func queue_free_after_eat_sound():
	await $EatSound.finished
	queue_free()
	

func _on_run_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		update_path()		


func _on_run_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		navigation_agent.set_target_position(global_position)  # Stop moving
