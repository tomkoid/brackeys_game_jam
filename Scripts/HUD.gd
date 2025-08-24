extends CanvasLayer

@onready var money_label = $"Panel/Money Count"
@onready var panel = $Panel

var money_count := 0
const base_panel_x_size = 55
const panel_x_digit_change = 18

func set_money(new_value):
	money_count = new_value
	var money_as_str = str(money_count)
	money_label.text = money_as_str
	panel.size.x = base_panel_x_size + money_as_str.length() * panel_x_digit_change

func update_money(change_by):
	set_money(money_count + change_by)
	
