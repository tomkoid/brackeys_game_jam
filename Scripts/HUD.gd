extends CanvasLayer

@onready var money_label = $"Panel/LeftTop/Money Count"

var money_count := 0

func set_money(new_value):
	money_count = new_value
	money_label.text = str(money_count)

func update_money(change_by):
	set_money(money_count + change_by)
	
