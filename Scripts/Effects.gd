extends Node2D

var ongoing_effects : Dictionary[Effect, float] = {}
var effects_scenes := {}

enum Effect {
	Poison,
	Burning
}

func _ready():
	add_effect(Effect.Poison, 5)

func _process(delta: float):
	update_effect_durations(delta)

func update_effect_durations(delta):
	for effect in ongoing_effects.keys():
		var current_duration = ongoing_effects[effect]
		var updated_duration = current_duration - delta
		ongoing_effects[effect] = updated_duration
		var effect_instance = effects_scenes[effect]
		var rounded_time = ceili(updated_duration)
		if updated_duration <= 0:
			effect_instance.queue_free()
			effects_scenes.erase(effect)
			ongoing_effects.erase(effect)
		effect_instance.time.text = str(rounded_time)
	
func add_effect(effect: Effect, duration: float):
	ongoing_effects[effect] = duration
	var effect_scene = load("res://Scenes/EffectIcon.tscn")
	var effect_instance = effect_scene.instantiate()
	effect_instance.icon = get_effect_icon(effect)
	add_child(effect_instance)
	effects_scenes[effect] = effect_instance

func get_effect_icon(effect: Effect):
	var effect_name = Effect.find_key(effect)
	var effect_path = "res://Effects/" + effect_name + ".png"
	return load(effect_path)
