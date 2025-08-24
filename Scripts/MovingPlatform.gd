extends Node2D

@export var moving_range : float
@onready var area = $Area2D

const speed = 200

var direction = -1
var x_left_dest : float
var x_right_dest : float

func _ready():
	x_left_dest = position.x - moving_range
	x_right_dest = position.x + moving_range

func _physics_process(delta):
	var pos_change = delta * speed * direction
	position.x += pos_change
	if player_on_platform(): Player.position.x += pos_change
	if position.x < x_left_dest: direction = 1
	if position.x > x_right_dest: direction = -1

func player_on_platform():
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"): return true
	return false
