extends Node2D

func _ready():
	$Area.connect("area_entered", self, "on_area_entered")
	
func on_area_entered(_Area2):
	$AnimationPlayer.play("pickup")
	call_deferred("disable_pickup")
	
func disable_pickup():
	$Area/Shape.disabled = true
