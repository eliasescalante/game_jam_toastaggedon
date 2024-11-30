extends CharacterBody2D
class_name EnemyCharacter

@export var speed: float = 100.0  # Velocidad del enemigo
@export var screen_bounds: Rect2 = Rect2(Vector2(0, 0), Vector2(1024, 768))  # Tamaño de la pantalla (ajústalo)

var target_direction: Vector2

func _ready():
	# Conecta la señal del Area2D para detectar colisiones con el jugador
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	# Genera una dirección aleatoria inicial
	set_random_direction()

func _process(delta: float) -> void:
	move_in_direction(delta)

func move_in_direction(delta: float) -> void:
	# Mueve al enemigo en la dirección actual
	velocity = target_direction * speed
	move_and_slide()

	# Si el enemigo está cerca de los bordes de la pantalla, cambia la dirección
	if position.x < screen_bounds.position.x or position.x > screen_bounds.size.x:
		target_direction.x *= -1
	if position.y < screen_bounds.position.y or position.y > screen_bounds.size.y:
		target_direction.y *= -1

func set_random_direction() -> void:
	# Genera una dirección aleatoria normalizada
	target_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _on_body_entered(body: Node) -> void:
	# Comprueba si el jugador ha tocado al enemigo
	if body.is_in_group("player"):
		# Llama a una función en el jugador para manejar la animación de daño
		body.play_death_animation()
		# El enemigo desaparece
		queue_free()
