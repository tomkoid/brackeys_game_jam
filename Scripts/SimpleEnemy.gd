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

func player_in_hitbox():
	var bodies = hitbox.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"): return true
	return false

func _process(_delta):
	if player_in_hitbox(): Player.get_damage(2)
