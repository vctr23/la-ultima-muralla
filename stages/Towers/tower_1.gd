extends StaticBody2D

var arrow = preload("res://stages/Towers/arrow.tscn")
var arrowDamage = 5
var pathName
var currentTargets = []
var current

func _process(delta: float) -> void:
	if (is_instance_valid(current)):
		self.look_at(current.global_position)
	else:
		# Reviso si hay balas que se han quedado en el mapa al haber muerto un enemigo
		for i in get_node("ArrowContainer").get_child_count():
			get_node("ArrowContainer").get_child(i).queue_free()

func _on_tower_area_body_entered(body: Node2D) -> void:
	if "Enemy1" in body.name:
		# Array temporal para gurdar solo los enemigos 
		var temporaryArray = []
		currentTargets = get_node("TowerArea").get_overlapping_bodies()
		
		# Filtro solo a los enemigos y los añado
		for i in currentTargets:
			if "Enemy" in i.name:
				temporaryArray.append(i)
				
		var currentTarget = null
		
		for i in temporaryArray:
			# Miro el pathFollow del enemigo
			if currentTarget == null:
				currentTarget = i.get_node("../")
			else:
				"""Si hay algún enemigo por delante del actual,
				 ataca al que más avanzado esté"""
				if i.get_parent().get_progress() > currentTarget.get_progress():
					currentTarget = i.get_node("../")
				
		current = currentTarget
		pathName = currentTarget.get_parent().name
		
		var temporaryArrow = arrow.instantiate()
		temporaryArrow.pathName = pathName
		temporaryArrow.arrowDamage = arrowDamage
		get_node("ArrowContainer").add_child(temporaryArrow)
		temporaryArrow.global_position = $Marker.global_position


func _on_tower_area_body_exited(body: Node2D) -> void:
	currentTargets = get_node("TowerArea").get_overlapping_bodies()
