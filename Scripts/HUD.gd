extends CanvasLayer

@onready var money_label = $"Panel/Money Count"
@onready var panel = $Panel
@onready var debt_reminder_label = $"Debt Reminder"
@onready var debt_timer = $"Debt Reminder/Debt Timer"

var money_count := 0
var in_critical_debt = false
const base_panel_x_size = 55
const panel_x_digit_change = 18
 
signal critical_debt_ended

func _ready():
	set_money(0)

func _process(delta: float) -> void:
	change_critical_debt_timer()

func change_critical_debt_timer():
	var remaining_time = Audio.get_music_remaining_time()
	var remaining_time_as_str = str(ceili(remaining_time))
	if remaining_time_as_str.length() == 1: remaining_time_as_str = "0" + remaining_time_as_str
	debt_timer.text = "0:" + remaining_time_as_str

func set_money(new_value):
	money_count = new_value
	var money_as_str = str(money_count)
	money_label.text = money_as_str
	panel.size.x = base_panel_x_size + money_as_str.length() * panel_x_digit_change
	if money_count < 0:
		if ending_critical_debt: await critical_debt_ended
		elif in_critical_debt: return
		active_critical_debt()
	elif in_critical_debt: end_critical_debt()

func update_money(change_by):
	set_money(money_count + change_by)

const color_tween_duration = 0.35
const debt_reminder_y_destination = 450
const debt_reminder_hide_y = 700
const debt_reminder_tween_duration = 0.5
const final_critical_debt_color = Color(Color.RED, 0.5)
const overlay_reset_tween_duration = 0.2

func active_critical_debt():
	Audio.play_music("Critical Debt")
	create_tween().tween_property(panel, "modulate", Color.RED, color_tween_duration)
	create_tween().tween_property(debt_reminder_label, "position:y", debt_reminder_y_destination, debt_reminder_tween_duration)
	Overlay.overlay_alpha(0)
	in_critical_debt = true
	Text.hide_text()
	await Overlay.overlay_alpha(0, overlay_reset_tween_duration)
	await Overlay.overlay_tween(final_critical_debt_color, Audio.get_music_remaining_time())
	print("GAME OVER!!!")

const critical_debt_end_tween_duration = 0.2

var ending_critical_debt = false

func end_critical_debt():
	ending_critical_debt = true
	Audio.stop_music()
	create_tween().tween_property(panel, "modulate", Color.WHITE, critical_debt_end_tween_duration)
	create_tween().tween_property(debt_reminder_label, "position:y", debt_reminder_hide_y, critical_debt_end_tween_duration)
	await Overlay.overlay_tween(Color(Color.BLACK, 0), critical_debt_end_tween_duration)
	in_critical_debt = false
	ending_critical_debt = false
	emit_signal("critical_debt_ended")
