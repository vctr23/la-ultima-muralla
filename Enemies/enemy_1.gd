extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@export var speed = 200

func _process(delta):
	anim.play("walk")
	get_parent().set_progress(get_parent().get_progress() + speed*delta)
	if get_parent().get_progress_ratio() == 1:
		queue_free()
	
