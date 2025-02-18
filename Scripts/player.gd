# Player script
extends CharacterBody2D

var current_size: float = 1.0
var food_eaten: int = 0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")

	velocity.x = direction_x * SPEED
	velocity.y = direction_y * SPEED
	move_and_slide()

func get_size() -> int:
	return $CollisionBox.shape.radius * current_size

# This function should not expect any arguments
func eat_food(food_size: float) -> void:
	food_eaten += 1  # Track food count
	current_size += food_size

	# Animate the growth smoothly
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(current_size, current_size), 0.5)
	tween.tween_property($CollisionBox, "scale", Vector2(current_size, current_size), 0.5)

	#print("Food eaten:", food_eaten)
	#print("Player grew! New current size:", current_size, " new CollisionBox size=", get_size())
