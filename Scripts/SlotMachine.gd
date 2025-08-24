extends Node2D

@onready var interact_area = $"Interact Area"

const overlay_tween_duration = 0.4
const overlay_show_alpha = 0.4

func _on_enter_interaction_area(body: Node2D) -> void:
	if not body.is_in_group("Player"): return
	Overlay.overlay_tween(overlay_show_alpha, overlay_tween_duration)
	Text.show_text()

func _on_exit_interaction_area(body: Node2D) -> void:
	if not body.is_in_group("Player"): return
	Overlay.overlay_tween(0, overlay_tween_duration)
	Text.hide_text()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact") and can_interact():
		print("INTERACTS WITH SLOT MACHINE")
		pass

func can_interact():
	var overlapping_bodies = interact_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("Player"): return true
	return false
