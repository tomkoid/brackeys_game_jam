extends CanvasLayer

@onready var overlay = $Overlay
var tween: Tween = null

func _ready():
	overlay.color.a = 0

func overlay_alpha(final_alpha, duration := 1.0, ease_param = Tween.EASE_IN_OUT, trans_param = Tween.TRANS_SINE):
	overlay.color = Color(Color.BLACK, overlay.color.a)
	await overlay_tween(Color(Color.BLACK, final_alpha), duration, ease_param, trans_param)

func overlay_tween(final_color, duration := 1.0, ease_param = Tween.EASE_IN_OUT, trans_param = Tween.TRANS_SINE):
	if tween != null: tween.kill()
	tween = create_tween()
	tween.tween_property(overlay, "color", final_color, duration)
	tween.set_ease(ease_param).set_trans(trans_param)
	await tween.finished
