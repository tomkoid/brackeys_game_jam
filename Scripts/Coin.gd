extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		var hud = get_tree().get_root().get_node("/root/HUD")
		hud.update_money(1)
		get_parent().queue_free()
