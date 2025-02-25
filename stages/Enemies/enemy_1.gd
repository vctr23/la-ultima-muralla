extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@export var speed = 200
var health = 10
var is_dying = false  # Para evitar que la animación se reproduzca más de una vez

func _ready():
	anim.animation_finished.connect(_on_animation_finished)  # Conectar la señal

	
func _process(delta):
	# Si se muere, hago que no se mueva
	if is_dying:
		return  

	anim.play("walk")
	add_to_group("Enemy")
	get_parent().set_progress(get_parent().get_progress() + speed * delta)

	if get_parent().get_progress_ratio() == 1:
		queue_free()

	if health <= 0 and not is_dying:
		die()
		

func die():
	is_dying = true  # Evita que la animación se reproduzca múltiples veces
	anim.play("death")
	
	# Desactivo colisión mientras realiza animación de muerte
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)

func _on_animation_finished():
	# Al terminar la animación de muerte se elimina
	if anim.animation == "death":  
		queue_free()
