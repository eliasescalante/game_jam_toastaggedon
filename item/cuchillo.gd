extends CharacterBody2D
class_name Knife

@export var speed: float = 150.0  # Velocidad del cuchillo
@export var screen_bounds: Rect2 = Rect2(Vector2(0, 0), Vector2(1024, 768))  # Límites de movimiento del cuchillo

var target_direction: Vector2  # Dirección del movimiento

func _ready() -> void:
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	set_random_direction()

func _process(delta: float) -> void:
	move_in_direction(delta)

func move_in_direction(delta: float) -> void:
	# Mover el cuchillo en la dirección actual
	velocity = target_direction * speed
	move_and_slide()

	# Rebotar si llega a los límites de la pantalla
	if position.x < screen_bounds.position.x or position.x > screen_bounds.size.x:
		target_direction.x *= -1
	if position.y < screen_bounds.position.y or position.y > screen_bounds.size.y:
		target_direction.y *= -1

func set_random_direction() -> void:
	# Generar una dirección aleatoria y normalizarla
	target_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _on_body_entered(body: Node) -> void:
	# Verificar si el cuerpo que toca es el jugador
	if body.is_in_group("player"):
		# Retroceder en las animaciones del jugador al tocar el cuchillo
		if body.has_method("_on_knife_touched"):
			body._on_knife_touched()
		else:
			print("El jugador no tiene el método '_on_knife_touched'.")
		# Eliminar el cuchillo después de la colisión
		queue_free()
