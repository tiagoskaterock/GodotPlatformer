extends Node2D

func _ready():
	$Area.connect("area_entered", self, "on_area_entered")
	
	
func on_area_entered(_Area2):
	$AnimationPlayer.play("pickup")
	call_deferred("disable_pickup")
	var baseLevel = get_tree().get_nodes_in_group("base_level")[0]
	baseLevel.coinCollected()
	
	
func disable_pickup():
	$Area/Shape.disabled = true
