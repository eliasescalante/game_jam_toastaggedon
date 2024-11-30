extends CharacterBody2D

# Velocidad del enemigo
@export var speed: float = 100.0
# Dirección inicial (moviéndose hacia la izquierda)
var direction: Vector2 = Vector2.LEFT

func _ready() -> void:
	# Reproducir la animación de caminar al principio
	$AnimatedSprite2D.play("walk")

func _physics_process(delta: float) -> void:
	# Mover al enemigo en la dirección actual
	velocity = direction * speed
	move_and_slide()

	# Detectar si choca con una pared u obstáculo
	if is_on_wall():
		change_direction()

	# Invertir la animación dependiendo de la dirección
	if direction.x > 0:
		$AnimatedSprite2D.flip_h = false  # No invertir (moviéndose a la derecha)
	else:
		$AnimatedSprite2D.flip_h = true   # Invertir (moviéndose a la izquierda)

	# Reproducir la animación de caminar si no está ya jugando
	if not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play("walk")

func change_direction():
	# Cambiar la dirección horizontal al opuesto
	direction.x *= -1
