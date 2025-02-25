extends StaticBody2D

@onready var archer: AnimatedSprite2D = $AnimatedSprite2D/Archer
var arrow = preload("res://stages/Towers/arrow.tscn")
var arrowDamage = 5
var pathName
var currentTargets = []
var current

var reload = 0
var range = 120
@onready var timer: Timer = get_node("Upgrade/ProgressBar/Timer")
var startShooting = false


func _process(delta: float) -> void:
	get_node("Upgrade/ProgressBar").global_position = self.position + Vector2(-28, 37)
	if (is_instance_valid(current)):
		# Reviso la dirección en el eje x del enemigo y el arquero
		var dir = current.global_position.x - archer.global_position.x
		if dir > 0:
			# Mirar a la derecha
			archer.scale.x = abs(archer.scale.x)  
		else:
			# Mirar a la izquierda
			archer.scale.x = -abs(archer.scale.x)  
		if timer.is_stopped():
			timer.start()
	else:
		# Reviso si hay balas que se han quedado en el mapa al haber muerto un enemigo
		for i in get_node("ArrowContainer").get_child_count():
			get_node("ArrowContainer").get_child(i).queue_free()
	update_powers()

func Shoot():
	var temporaryArrow = arrow.instantiate()
	temporaryArrow.pathName = pathName
	temporaryArrow.arrowDamage = arrowDamage
	get_node("ArrowContainer").add_child(temporaryArrow)
	temporaryArrow.global_position = $Marker.global_position
	

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
		


func _on_tower_area_body_exited(body: Node2D) -> void:
	currentTargets = get_node("TowerArea").get_overlapping_bodies()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_mask == 1:
		var towerPath = get_tree().get_root().get_node("Main/Towers")
		# Reviso si ya había un Upgrade panel en otra torre abierto y lo cierro
		for i in towerPath.get_child_count():
			if towerPath.get_child(i).name != self.name:
				towerPath.get_child(i).get_node("Upgrade/Upgrade").hide()
		# Si esta visible lo hago invisible (por defecto invisible)
		get_node("Upgrade/Upgrade").visible = !get_node("Upgrade/Upgrade").visible 
		get_node("Upgrade/Upgrade").global_position = self.position + Vector2(-150, 50)


func _on_timer_timeout() -> void:
	Shoot()


func _on_range_pressed() -> void:
	if Game.money >= 5:
		range += 15
		Game.money -= 5


func _on_power_pressed() -> void:
	if Game.money >= 10:
		arrowDamage += 1
		Game.money -= 10


func _on_attack_speed_pressed() -> void:
	if Game.money >= 5:
		if reload <= 2:
			reload += 0.1
		timer.wait_time = 3 - reload
		Game.money -= 5

func update_powers():
	get_node("Upgrade/Upgrade/HBoxContainer/Range/Label").text = str(range)
	get_node("Upgrade/Upgrade/HBoxContainer/Power/Label").text = str(arrowDamage)
	get_node("Upgrade/Upgrade/HBoxContainer/Attack speed/Label").text = str(3 - reload)
	
	get_node("TowerArea/CollisionShape2D").shape.radius = range


func _on_range_mouse_entered() -> void:
	get_node("TowerArea/CollisionShape2D").show()


func _on_range_mouse_exited() -> void:
	get_node("TowerArea/CollisionShape2D").hide()
