extends Node

@onready var music_player = $"Music Player"

func play(audio_name: String, pitch_shift = 0.0, volume = 0.0):
	var stream = get_stream(audio_name)
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

func play_music(music_name):
	music_player.stop()
	music_player.stream = get_stream(music_name)
	music_player.play()

func get_music_remaining_time():
	if music_player.stream == null: return 0
	var total_length = music_player.stream.get_length()
	var time_already_played = music_player.get_playback_position()
	return total_length - time_already_played

func get_stream(audio_name):
	var audio_path = "res://Audio/" + audio_name + ".mp3"
	return load(audio_path)

func stop_music():
	music_player.stop()
