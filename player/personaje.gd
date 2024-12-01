extends CharacterBody2D
class_name Player

@export var speed: float = 300.0  # Velocidad de movimiento del jugador
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  # Referencia al nodo AnimatedSprite2D
@onready var collision_area: Area2D = $Area2D  # Área de colisión del jugador

# Lista de animaciones de muerte
var death_animations: Array = ["death1", "death2", "death3"]
var enemy_hit_count: int = 0  # Contador de golpes del enemigo

# Control del estado
var inverted_controls: bool = false  # Si los controles están invertidos

func _ready() -> void:
	# Configurar la animación inicial
	animated_sprite.play("idle")
	# Conectar la señal del área de colisión
	if collision_area:
		collision_area.connect("body_entered", Callable(self, "_on_body_entered"))
	else:
		print("Advertencia: collision_area no encontrado.")

func _process(delta: float) -> void:
	handle_movement()

func handle_movement() -> void:
	# Inicializar el vector de velocidad
	velocity = Vector2.ZERO

	# Definir las acciones de movimiento
	var move_right = "ui_right"
	var move_left = "ui_left"
	var move_up = "ui_up"
	var move_down = "ui_down"

	# Invertir los controles si es necesario
	if inverted_controls:
		move_right = "ui_left"
		move_left = "ui_right"
		move_up = "ui_down"
		move_down = "ui_up"

	# Detectar entrada de teclado y actualizar dirección
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

	# Normalizar y aplicar la velocidad
	velocity = velocity.normalized() * speed
	move_and_slide()

func _on_body_entered(body: Node) -> void:
	# Verificar si colisiona con un enemigo
	if body.is_in_group("enemy"):
		body.queue_free()  # Eliminar el enemigo
		_on_enemy_touched()

	# Verificar si colisiona con un cuchillo
	elif body.is_in_group("knife"):
		body._on_knife_touched()

func _on_enemy_touched() -> void:
	# Invertir controles
	inverted_controls = true
	print("Controles invertidos. Recibiste daño de un enemigo.")

	# Avanzar en las animaciones de daño
	if enemy_hit_count < death_animations.size():
		animated_sprite.play(death_animations[enemy_hit_count])
		print("Animación actual:", death_animations[enemy_hit_count])
		enemy_hit_count += 1
	else:
		print("No quedan vidas. Fin del juego.")
		# Cambiar a la escena de derrota
		get_tree().change_scene_to_file("res://win-lose/win-lose.tscn")

func _on_knife_touched() -> void:
	# Restaurar controles
	inverted_controls = false
	print("Controles restaurados. Tocado por un cuchillo.")

	# Retroceder en las animaciones de daño
	if enemy_hit_count > 0:
		enemy_hit_count -= 1
		animated_sprite.play(death_animations[enemy_hit_count])
		print("Animación regresada a:", death_animations[enemy_hit_count])
	else:
		print("Ya estás en el estado inicial, no puedes retroceder más.")
