extends CharacterBody2D
class_name Item

@export var speed: float = 100.0  # Velocidad del item
@export var screen_bounds: Rect2 = Rect2(Vector2(0, 0), Vector2(1024, 768))  # Tamaño de la pantalla

var target_direction: Vector2

func _ready() -> void:
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	set_random_direction()

func _process(delta: float) -> void:
	move_in_direction(delta)

func move_in_direction(delta: float) -> void:
	velocity = target_direction * speed
	move_and_slide()

	if position.x < screen_bounds.position.x or position.x > screen_bounds.size.x:
		target_direction.x *= -1
	if position.y < screen_bounds.position.y or position.y > screen_bounds.size.y:
		target_direction.y *= -1

func set_random_direction() -> void:
	# Genera una dirección aleatoria normalizada
	target_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body._on_item_touched()
		queue_free()
