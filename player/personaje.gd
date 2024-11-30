extends CharacterBody2D
class_name Player

# Velocidad de movimiento del personaje
@export var speed: float = 300.0

# Referencia al AnimatedSprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Variables para manejar las animaciones de daño
var enemy_hit_count: int = 0
var death_animations: Array = ["death1", "death2", "death3", "death4"]

# Control de los movimientos
var inverted_controls: bool = false  # Si los controles están invertidos

# Referencia al Area2D para las colisiones
@onready var collision_area: Area2D = $Area2D

func _ready() -> void:
	# Conectar las señales de colisión para detectar toques con enemigos e ítems
	if collision_area:
		collision_area.connect("body_entered", Callable(self, "_on_body_entered"))
	else:
		print("Error: collision_area no encontrado.")

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
		print("Animación de daño: ", death_animations[enemy_hit_count])
	else:
		# De lo contrario, volver a la animación 'idle'
		animated_sprite.play("idle")
		print("Animación idle")
		
func _on_body_entered(body) -> void:
	# Verificar si el cuerpo con el que colidió es un enemigo
	if body.is_in_group("enemy"):
		_on_enemy_touched()  # Llamar al método que maneja los toques con enemigos

func _on_enemy_touched() -> void:
	# Cambiar el estado de los controles
	if inverted_controls:
		# Si los controles ya están invertidos, restaurarlos a su estado normal
		inverted_controls = false
		print("Controles restaurados a la normalidad.")
	else:
		# Si los controles no están invertidos, invertirlos
		inverted_controls = true
		print("Controles invertidos por enemigo.")

	# Cambiar la animación de daño y asegurarse de que no se reproduzcan más de las permitidas
	if enemy_hit_count < death_animations.size():
		enemy_hit_count += 1
		print("Controles invertidos")
	else:
		print("Jugador sin vidas restantes.")
		# Redirigir a la escena de fin del juego después de la cuarta colisión
		get_tree().change_scene_to_file("res://win-lose/win-lose.tscn")
