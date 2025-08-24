extends Camera2D

const screen_shake_offset = 24
const screen_shake_duration = 0.15

func screen_shake_multiple(count, cam_offset = screen_shake_offset):
	for i in range(count):
		await screen_shake(float(count-i)/count, cam_offset)

func screen_shake(power = 1, cam_offset = screen_shake_offset):
	var original_camera_offset = offset
	var used_offset = cam_offset * power
	var screen_shake_final = Vector2(original_camera_offset.x + used_offset, original_camera_offset.y + used_offset)
	
	var shake_tween = create_tween()
	await shake_tween.tween_property(self, "offset",\
		screen_shake_final, screen_shake_duration/2).\
		set_trans(Tween.TRANS_SINE).\
		set_ease(Tween.EASE_IN_OUT).finished
	
	await create_tween().tween_property(self, "offset", original_camera_offset, screen_shake_duration/2).finished
	await get_tree().create_timer(screen_shake_duration/2).timeout
