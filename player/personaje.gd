extends CharacterBody2D
class_name Player

# Velocidad de movimiento del personaje
@export var speed: float = 300.0

# Referencia al AnimatedSprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Variables para manejar las animaciones de daño
var enemy_hit_count: int = 0
var death_animations: Array = ["idle", "death1", "death2", "death3", "death4"]

# Control de los movimientos
var inverted_controls: bool = false  # Si los controles están invertidos

func _process(delta: float) -> void:
	handle_movement()
	handle_animation()

func handle_movement() -> void:
	# Reiniciar la velocidad
	velocity = Vector2.ZERO

	# Detectar teclas y actualizar la dirección
	var move_right = "ui_right"
	var move_left = "ui_left"
	var move_up = "ui_up"
	var move_down = "ui_down"

	# Invertir controles si es necesario
	if inverted_controls:
		move_right = "ui_left"
		move_left = "ui_right"
		move_up = "ui_down"
		move_down = "ui_up"

	if Input.is_action_pressed(move_right):
		velocity.x += 1
		animated_sprite.scale.x = 1  # Mirar hacia la derecha
	if Input.is_action_pressed(move_left):
		velocity.x -= 1
		animated_sprite.scale.x = -1  # Mirar hacia la izquierda
	if Input.is_action_pressed(move_down):
		velocity.y += 1
	if Input.is_action_pressed(move_up):
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

func _on_enemy_touched() -> void:
	# Cambia a la siguiente animación de daño si no se han reproducido todas
	if enemy_hit_count < death_animations.size() - 1:
		enemy_hit_count += 1
		inverted_controls = true  # Invertir controles al ser tocado por un enemigo
		print("Controles invertidos por enemigo. Animación: ", death_animations[enemy_hit_count])
	else:
		print("Jugador sin vidas restantes.")

func _on_item_touched() -> void:
	# Contador de daño si es posible (recuperar vida)
	if enemy_hit_count > 0:
		enemy_hit_count -= 1
		inverted_controls = false  # Restaurar controles normales al tocar un item
		print("Controles normales restaurados. Animación: ", death_animations[enemy_hit_count])
