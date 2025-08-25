extends CanvasLayer

@onready var money_label = $"Panel/Money Count"
@onready var panel = $Panel

var money_count := 0
var in_critical_debt = false
const base_panel_x_size = 55
const panel_x_digit_change = 18

func _ready():
	set_money(0)

func set_money(new_value):
	money_count = new_value
	var money_as_str = str(money_count)
	money_label.text = money_as_str
	panel.size.x = base_panel_x_size + money_as_str.length() * panel_x_digit_change
	if money_count < 0: active_critical_debt()
	elif in_critical_debt: end_critical_debt()

func update_money(change_by):
	set_money(money_count + change_by)

func active_critical_debt():
	if in_critical_debt: return
	Audio.play_music("Critical Debt")
	in_critical_debt = true
	print("CRITICAL DEBT ACTIVATED")

func end_critical_debt():
	Audio.stop_music()
	in_critical_debt = false
	print("CRITICAL DEBT ENDED")
