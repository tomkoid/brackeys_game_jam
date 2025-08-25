extends CanvasLayer

@onready var text_label = $Label

var text_start_x: int
var text_hide_pos_y = 700
var text_show_pos_y = 500
var previous_text = ""

func _ready():
	text_label.modulate.a = 0
	text_label.position.y = text_hide_pos_y

func change_text(new_text):
	previous_text = text_label.text
	text_label.text = new_text

func change_text_to_previous():
	change_text(previous_text)

const text_tween_duration = 0.4

func text_tween(final_pos_y, final_alpha):
	text_label.position.x = text_start_x
	var text_move_tween = create_tween()
	text_move_tween.tween_property(text_label, "position:y", final_pos_y, text_tween_duration)
	text_move_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var text_alpha_tween = create_tween().tween_property(text_label, "modulate:a", final_alpha, text_tween_duration)

func show_text(): text_tween(text_show_pos_y, 1)
func hide_text(): text_tween(text_hide_pos_y, 0)
