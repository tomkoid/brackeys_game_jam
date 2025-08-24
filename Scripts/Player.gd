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
@onready var effect_particle: CPUParticles2D = $"Effect Particle"
@onready var camera: Camera2D = $Camera2D

var _facing: int = 1
var physics_disabled := false
var invunerability := false

func _process(delta: float):
	effect_particle.emitting = Effects.has_any_effects()
	var particle_color = Effects.get_effect_color(Effects.latest_updated_effect)
	if particle_color != null: effect_particle.modulate = particle_color

func _physics_process(delta: float) -> void:
	if physics_disabled: return
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
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			velocity.y = wall_slide_speed

	# ---- SKOK ----
	if Input.is_action_just_pressed("jump"):
		player_jump(on_left_wall, on_right_wall)

	# ---- POHYB ----
	move_and_slide()

	# ---- ANIMACE ----
	_update_animation(input_dir)

const jump_boost_multiplier = 1.5

func player_jump(on_left_wall, on_right_wall):
	if is_on_floor():
		var jump_multiplier = 1
		if Effects.has_effect(Effects.Effect.JumpBoost): jump_multiplier = jump_boost_multiplier
		velocity.y = jump_velocity * jump_multiplier
	elif on_left_wall or on_right_wall:
		var push_dir = 0
		if on_left_wall: push_dir = 1
		if on_right_wall: push_dir = -1
		velocity.x = push_dir * wall_jump_push
		velocity.y = wall_jump_boost

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
		sprite.play("idle")

var hurt_tween_duration = 0.2

func get_damage(coins_lost):
	if invunerability: return
	Audio.play("Hurt", 0.2)
	invunerability = true
	HUD.update_money(-coins_lost)
	camera.screen_shake_multiple(3)
	var hurt_tween = create_tween().tween_property(self, "modulate", Color.RED, hurt_tween_duration)
	await hurt_tween.finished
	var undo_color_tween = create_tween().tween_property(self, "modulate", Color.WHITE, hurt_tween_duration)
	await undo_color_tween.finished
	invunerability = false
