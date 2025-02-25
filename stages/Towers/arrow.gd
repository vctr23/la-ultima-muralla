extends CharacterBody2D


var target
var speed = 1000
var pathName = ""
var arrowDamage

func _physics_process(delta):
	var pathSpawnerNode = get_tree().get_root().get_node("Main/PathSpawner")
	for i in pathSpawnerNode.get_child_count():
		if pathSpawnerNode.get_child(i).name == pathName:
			var target_node = pathSpawnerNode.get_child(i).get_child(0).get_child(0)
			if target_node:
				target = target_node.global_position
	
	
	if target:
		velocity = global_position.direction_to(target) * speed
		look_at(target)
		move_and_slide()
	else:
		velocity = Vector2.ZERO


func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= arrowDamage
		queue_free()
	
