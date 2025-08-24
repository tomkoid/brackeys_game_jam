extends Node

func play(audio_name: String, pitch_shift = 0.0, volume = 0.0):
	var audio_path = "res://Audio/" + audio_name + ".mp3"
	var stream = load(audio_path)
	if not stream: return
	var player = AudioStreamPlayer.new()
	player.stream = stream
	
	player.volume_db  = volume
	player.pitch_scale = generate_pitch_scale(pitch_shift)
	
	add_child(player)
	player.play()

	player.finished.connect(func():
		player.queue_free()
	)

func generate_pitch_scale(pitch_shift):
	var direction = -1 if randf() < 0.5 else 1
	var shiftAmount = randf_range(0, pitch_shift)
	var randomPitch = 1 + direction * shiftAmount
	return max(0.01, randomPitch)
