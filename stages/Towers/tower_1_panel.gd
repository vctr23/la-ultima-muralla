extends Panel

@onready var tower = preload("res://stages/Towers/tower_1.tscn")
var currentTile
var temporaryTower
var tilemap

func _ready():
	tilemap = get_tree().get_root().get_node("Main/TileMapLayers/Background")
	
func _on_gui_input(event: InputEvent) -> void:
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
			_check_tile_collision()
			
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
			path.add_child(temporaryTower)
			temporaryTower.global_position = event.global_position
			temporaryTower.get_node("Area").hide()
	else:
		if get_child_count() > 1:
			get_child(1).queue_free()
			
func _check_tile_collision():
	if tilemap and temporaryTower:
		var local_pos = tilemap.to_local(temporaryTower.global_position)  # Convierte a coordenadas locales del TileMap
		var cell_coords = tilemap.local_to_map(local_pos)  # Obtiene la celda correspondiente
			# Obtiene el ID del tile en la capa actual
		var tile_data = tilemap.get_cell_tile_data(1, cell_coords)  # "0" es la layer, ajústalo si tienes varias
		if tile_data and tile_data.get_custom_data("path") == true:
			temporaryTower.get_node("Area").modulate = Color(1, 0, 0, 0.5)  # Rojo si está sobre el camino
		else:
			temporaryTower.get_node("Area").modulate = Color(0, 1, 0, 0.5)  # Verde si no está sobre el camino
