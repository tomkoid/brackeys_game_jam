extends Node2D

@onready var icon = $Background/Icon
@onready var time = $Time

func set_icon_texture(texture):
	icon.texture = texture

const icon_x_offset = -150

func _ready():
	position.x += icon_x_offset * (Effects.get_effect_count() - 1)
