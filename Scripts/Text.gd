extends CanvasLayer

@onready var text_label = $Label

const text_hide_pos_y = 700
const text_show_pos_y = 500

func change_text(new_text):
	text_label.text = new_text

const text_tween_duration = 0.4

func text_tween(final_pos_y):
	var text_move_tween = create_tween()
	text_move_tween.tween_property(text_label, "position:y", final_pos_y, text_tween_duration)
	text_move_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func show_text(): text_tween(text_show_pos_y)
func hide_text(): text_tween(text_hide_pos_y)
