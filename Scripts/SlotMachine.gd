extends Node2D

@onready var interact_area = $"Interact Area"
@onready var sprite = $Sprite

const overlay_tween_duration = 0.4
const overlay_show_alpha = 0.4
var interact_disabled = false

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
		interact_with_slot_machine()

const final_zoom := Vector2(3, 3)
const camera_zoom_tween := 0.5

func interact_with_slot_machine():
	sprite.play("button")
	interact_disabled = true
	Player.camera.global_position = global_position
	Text.hide_text()
	var zoom_tween = create_tween().tween_property(Player.camera, "zoom", final_zoom, camera_zoom_tween)
	zoom_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).finished
	await Overlay.overlay_tween(1)
	Player.physics_disabled = true
	get_tree().change_scene_to_file("res://Scenes/Gamble.tscn")

func can_interact():
	if interact_disabled: return false
	var overlapping_bodies = interact_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("Player"): return true
	return false
