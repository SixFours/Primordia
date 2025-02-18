extends CharacterBody2D

@export var speed: float = 100.0
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: Node2D = null

var eaten: bool = false
var chase_player: bool = true

func _process(delta):
	if navigation_agent.is_navigation_finished():
		return  # Stop moving if there is no path

	var next_position = navigation_agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	
	velocity = direction * speed
	move_and_slide()

func update_path():
	if player:
		if is_bigger_than_me(player):
			if chase_player:
				print("Now I'm scared! Running away!")
			chase_player = false
		else:
			chase_player = true
		
		if chase_player:
			#print("Chase - my size="+str(get_size())+" player size="+str(player.get_size()))
			navigation_agent.set_target_position(player.global_position)
		else:
			var direction_away = (global_position - player.global_position).normalized()

			# Set a target position in the opposite direction from the player
			var flee_distance = 200  # Adjust the flee distance to control how far the enemy flees
			var flee_target = global_position + direction_away * flee_distance

			# Set the target position for the navigation agent to flee from the player
			navigation_agent.set_target_position(flee_target)
			
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

func get_size() -> int:
	return $CollisionBox.shape.radius

func is_bigger_than_me(body: Node2D) -> bool:
	return get_size() < body.get_size()


func _on_kill_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# if player is bigger than me then i am food
		if is_bigger_than_me(body):
			eaten = true  # Mark that we have been eaten, so can't be eaten again
			visible = false  # Hide the food immediately
			print("+1 Food!")
			body.eat_food(0.2)
			$EatSound.play()
			call_deferred("queue_free_after_eat_sound")
		else:
			print("Enemy was bigger than you! Now you dead")
			get_tree().reload_current_scene()

func queue_free_after_eat_sound():
	await $EatSound.finished
	queue_free()


func _on_run_area_body_entered(body: Node2D) -> void:
	if is_bigger_than_me(body):
		player = body
		update_path()		


func _on_run_area_body_exited(body: Node2D) -> void:
	if is_bigger_than_me(body):
		player = null
		navigation_agent.set_target_position(global_position)  # Stop moving
