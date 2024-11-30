extends CharacterBody2D
class_name Player

# Velocidad de movimiento del personaje
@export var speed: float = 300.0

# Referencia al AnimatedSprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Variables para manejar las animaciones de daño
var enemy_hit_count: int = 0
var death_animations: Array = ["idle","death1", "death2", "death3", "death4"]

func _process(delta: float) -> void:
	handle_movement()
	handle_animation()

func handle_movement() -> void:
	# Reiniciar la velocidad
	velocity = Vector2.ZERO

	# Detectar teclas y actualizar la dirección
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		animated_sprite.scale.x = 1  # Mirar hacia la derecha
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		animated_sprite.scale.x = -1  # Mirar hacia la izquierda
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	# Normalizar la velocidad para evitar que sea más rápida en diagonal
	velocity = velocity.normalized() * speed

	# Movimiento
	move_and_slide()

func handle_animation() -> void:
	# Si el jugador recibió daño, usar la animación correspondiente
	if enemy_hit_count < death_animations.size():
		animated_sprite.play(death_animations[enemy_hit_count])
	else:
		# De lo contrario, volver a la animación 'idle'
		animated_sprite.play("idle")

func play_death_animation() -> void:
	# Cambia a la siguiente animación de muerte si aún no se han reproducido todas
	if enemy_hit_count < death_animations.size():
		enemy_hit_count += 1
