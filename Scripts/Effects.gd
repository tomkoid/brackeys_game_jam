extends Node2D

var ongoing_effects : Dictionary[Effect, float] = {}
var effects_scenes := {}
var latest_updated_effect = null

enum Effect {
	Poison,
	Burning,
	JumpBoost
}

func _ready():
	update_effect(Effect.JumpBoost, 5)

func _process(delta: float):
	update_effect_durations(delta)

func has_effect(effect: Effect):
	return effect in ongoing_effects

func has_any_effects():
	return ongoing_effects.size() > 0

func get_effect_count():
	return ongoing_effects.size()

func update_effect_durations(delta):
	for effect in ongoing_effects.keys():
		var current_duration = ongoing_effects[effect]
		var updated_duration = current_duration - delta
		ongoing_effects[effect] = updated_duration
		var effect_instance = effects_scenes[effect]
		
		var rounded_time = ceili(updated_duration)
		if updated_duration <= 0:
			end_effect(effect_instance, effect)
		else: effect_instance.time.text = str(rounded_time)

func end_effect(effects_instance, effect: Effect):
	effects_instance.queue_free()
	effects_scenes.erase(effect)
	ongoing_effects.erase(effect)

func update_effect(effect: Effect, update_duration_by: float):
	if effect in ongoing_effects:
		ongoing_effects[effect] += update_duration_by
		return
	ongoing_effects[effect] = update_duration_by
	var effect_scene = load("res://Scenes/EffectIcon.tscn")
	var effect_instance = effect_scene.instantiate()
	add_child(effect_instance)
	effect_instance.set_icon_texture(get_effect_icon(effect))
	effects_scenes[effect] = effect_instance
	latest_updated_effect = effect

func get_effect_icon(effect: Effect):
	var effect_name = Effect.find_key(effect)
	var effect_path = "res://Effects/" + effect_name + ".png"
	return load(effect_path)

func get_effect_color(effect):
	match effect:
		Effect.JumpBoost: return Color("6dffff")
