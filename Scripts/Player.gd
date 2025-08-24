extends CharacterBody2D

# ---- PARAMETRY ----
@export var move_speed: float = 500.0
@export var jump_velocity: float = -650.0
@export var gravity: float = 1250.0

@export var wall_slide_speed: float = 100.0
@export var wall_jump_push: float = 280.0
@export var wall_jump_boost: float = -600.0

@onready var ray_left: RayCast2D  = $RayLeft
@onready var ray_right: RayCast2D = $RayRight
@onready var sprite: AnimatedSprite2D = $ASS2D # ⚡ tady připojíme AnimatedSprite2D

var _facing: int = 1


func _physics_process(delta: float) -> void:
	# ---- VSTUP ----
	var input_dir := Input.get_action_strength("right") - Input.get_action_strength("left")
	if input_dir != 0:
		_facing = sign(input_dir)

	# ---- POHYB ----
	velocity.x = move_toward(velocity.x, input_dir * move_speed, move_speed * 6.0 * delta)

	if not is_on_floor():
		velocity.y += gravity * delta

	# ---- DETEKCE ZDI ----
	var on_left_wall  := ray_left.is_colliding()  and not is_on_floor()
	var on_right_wall := ray_right.is_colliding() and not is_on_floor()
	var on_wall := on_left_wall or on_right_wall

	if on_wall and velocity.y > wall_slide_speed:
		velocity.y = wall_slide_speed

	# ---- SKOK ----
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
		elif on_left_wall or on_right_wall:
			var push_dir = 0
			if on_left_wall: push_dir = 1
			if on_right_wall: push_dir = -1
			velocity.x = push_dir * wall_jump_push
			velocity.y = wall_jump_boost

	# ---- POHYB ----
	move_and_slide()

	# ---- ANIMACE ----
	_update_animation(input_dir)

func _update_animation(input_dir: float) -> void:
	# Otočení podle směru pohybu
	if _facing != 0:
		sprite.flip_h = _facing < 0

	# Výběr animace
	if is_on_floor():
		if abs(velocity.x) > 10:   # pokud se hýbe
			if sprite.animation != "run":
				sprite.play("run")
		else:
			if sprite.animation != "idle":
				sprite.play("idle")
	else:
		# ve vzduchu necháme poslední animaci (run/idle)
		pass
