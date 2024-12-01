extends CharacterBody2D
class_name Knife

@export var speed: float = 150.0
@export var screen_bounds: Rect2 = Rect2(Vector2(0, 0), Vector2(1024, 768))

var target_direction: Vector2

func _ready() -> void:
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	set_random_direction()

func _process(delta: float) -> void:
	move_in_direction(delta)

func move_in_direction(delta: float) -> void:
	position += target_direction * speed * delta

	# Rebotar en los límites de la pantalla
	if position.x < screen_bounds.position.x or position.x > screen_bounds.size.x:
		target_direction.x *= -1
	if position.y < screen_bounds.position.y or position.y > screen_bounds.size.y:
		target_direction.y *= -1

func set_random_direction() -> void:
	target_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("_on_knife_touched"):
			body._on_knife_touched()
		queue_free()
