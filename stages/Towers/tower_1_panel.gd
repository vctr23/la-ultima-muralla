extends Panel

@onready var tower = preload("res://stages/Towers/tower_1.tscn")
var currentTile
var temporaryTower
var tilemap


func _on_gui_input(event: InputEvent) -> void:
	if Game.money >= 10:
		temporaryTower = tower.instantiate()
		if event is InputEventMouseButton and event.button_mask == 1:
			# Hago click izquierdo (button_mask 1 click pulsado)
			add_child(temporaryTower)
			temporaryTower.global_position = event.global_position
			temporaryTower.process_mode = Node.PROCESS_MODE_DISABLED
			
		elif event is InputEventMouseMotion and event.button_mask == 1:
			# Mientras tengo el click pulsado arrastro
			if get_child_count() > 1:
				get_child(1).global_position = event.global_position
			var targets = get_child(1).get_node("TowerDetector").get_overlapping_bodies()
			if (targets.size() > 0):
				get_child(1).get_node("Area").modulate = Color(1,0,0,0.3)
			else:
				get_child(1).get_node("Area").modulate = Color(0,0,0,0.3)
		elif event is InputEventMouseButton and event.button_mask == 0:
			# Hago click izquierdo (button_mask 0 click soltado)
			# Elimino la torre provisional que arrastraba 
			if event.global_position.y >= 736:
				if get_child_count() >= 1:
					get_child(1).queue_free()
			else:
				if get_child_count() > 1:
					get_child(1).queue_free()
				# Creo una torre en el lugar donde he soltado el click
				var path = get_tree().get_root().get_node("Main/Towers")
				var targets = get_child(1).get_node("TowerDetector").get_overlapping_bodies()
				if (targets.size() < 1):
					path.add_child(temporaryTower)
					temporaryTower.global_position = event.global_position
					temporaryTower.get_node("Area").hide()
					Game.money -= 10
					# LLamo a la animación inicial al colocar la torre
					var sprite = temporaryTower.get_node("AnimatedSprite2D")
					var sprite_archer = temporaryTower.get_node("AnimatedSprite2D/Archer")
					if sprite:
						sprite.play("upgrade1")
						sprite_archer.play("idle")
		else:
			if get_child_count() > 1:
				get_child(1).queue_free()
