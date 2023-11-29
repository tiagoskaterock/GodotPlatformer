extends Node2D

signal coin_total_changed

var player_scene = preload("res://Scenes/Player.tscn")
var spawn_position = Vector2.ZERO
var current_player_node = null
var totalCoins = 0
var colletedCoins = 0

func _ready():	
	spawn_position = $Player.global_position
	register_player($Player)
	coinTotalChanged(get_tree().get_nodes_in_group("coin").size())
	$Flag.connect("player_won", self, "on_player_won")
	
	
func coinCollected():
	colletedCoins += 1
	print(totalCoins, " - " ,colletedCoins)
	emit_signal("coin_total_changed", totalCoins, colletedCoins)
	
	
func coinTotalChanged(newTotal):
	totalCoins = newTotal
	emit_signal("coin_total_changed", totalCoins, colletedCoins)
	
	
func register_player(player):
	current_player_node = player
	current_player_node.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)
	
	
func create_player():
	var player_instance = player_scene.instance()
	add_child_below_node(current_player_node, player_instance)
	player_instance.global_position = spawn_position
	register_player(player_instance)
	
	
func on_player_died():
	current_player_node.queue_free()
	create_player()
	

func on_player_won():
	$"/root/LevelManager".increment_level()
