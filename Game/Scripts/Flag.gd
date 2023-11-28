extends Node2D


# Declare member variables here. Examples:
signal player_won


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("area_entered", self, "on_area_entered")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func on_area_entered(_area2d):
	emit_signal('player_won')
