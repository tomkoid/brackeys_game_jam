extends CanvasLayer

@onready var overlay = $Overlay

func _ready():
	overlay.color.a = 0

func overlay_tween(final_alpha, duration := 1.0):
	var tween = create_tween().\
	tween_property(overlay, "color:a", final_alpha, duration)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
