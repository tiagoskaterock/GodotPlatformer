extends Position2D

enum Direction { RIGHT, LEFT }

export(PackedScene) var enemyScene
export (Direction) var start_direction

var currentEnemyNode = null
var spawnOnNextTick = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.connect("timeout", self, "on_spawn_timer_timeout")
	call_deferred("spawn_enemy")	
	

func spawn_enemy():
	currentEnemyNode = enemyScene.instance()
	currentEnemyNode.startDirection = Vector2.RIGHT if start_direction == Direction.RIGHT else Vector2.LEFT
	get_parent().add_child(currentEnemyNode)
	currentEnemyNode.global_position = global_position


func check_enemy_spawn():
	if ! is_instance_valid(currentEnemyNode):
		if spawnOnNextTick:
			spawn_enemy()	
			spawnOnNextTick = false
		else:
			spawnOnNextTick = true	
		
		
func on_spawn_timer_timeout():
	check_enemy_spawn()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
