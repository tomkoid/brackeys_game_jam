extends Node2D

@export var moving_range : float
@export var tween_duration := 0.2

func _ready():
	var current_direction = -1
	while true:
		var x_destination = position.x + moving_range * current_direction
		var move_tween = create_tween().tween_property(self, "position:x", x_destination, tween_duration)
		move_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		await move_tween.finished
		current_direction *= -1
