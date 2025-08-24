extends CharacterBody2D

@onready var hitbox = $Hitbox

const speed = 200
var direction = -1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += Player.gravity * delta
	else: velocity.y = 0
	
	velocity.x = speed * direction
	move_and_slide()
	
	if is_on_wall():
		direction *= -1

func _on_body_entering_hitbox(body: Node2D) -> void:
	if not body.is_in_group("Player"): return
	Player.get_damage(2)
