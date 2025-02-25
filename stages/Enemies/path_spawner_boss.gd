extends Node2D


@onready var path = preload("res://stages/Enemies/stage 2.tscn")

func _on_timer_timeout() -> void:
	var tempPath = path.instantiate()
	add_child(tempPath)
