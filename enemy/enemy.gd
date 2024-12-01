extends CharacterBody2D

# Velocidad del enemigo
@export var speed: float = 200.0
var direction: Vector2 = Vector2.LEFT

# Nodo Area2D para detectar colisiones con el jugador
@onready var collision_area: Area2D = $Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	collision_layer = 1
	collision_mask = 2  

	# Conectar la señal de colisión cuando el enemigo toque el jugador
	collision_area.connect("body_entered", Callable(self, "_on_body_entered"))
	# Reproducir la animación de caminar al principio
	animated_sprite.play("walk")

func _physics_process(delta: float) -> void:
	# Mover al enemigo en la dirección actual
	velocity = direction * speed
	move_and_slide()

	# Detectar si el enemigo ha chocado con el borde de la pantalla
	if is_out_of_bounds():
		queue_free()
	# Invertir la animación dependiendo de la dirección
	if direction.x > 0:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true

	# Reproducir la animación de caminar si no está ya jugando
	if not animated_sprite.is_playing():
		animated_sprite.play("walk")

func is_out_of_bounds() -> bool:
	# Comprobar si el enemigo ha salido de los límites de la pantalla
	var screen_rect = get_viewport_rect()
	return not screen_rect.has_point(position)
# Función que se ejecuta cuando el enemigo colisiona con el jugador
func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		queue_free()
		body._on_enemy_touched()
