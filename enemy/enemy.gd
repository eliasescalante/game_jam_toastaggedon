extends CharacterBody2D

# Velocidad del enemigo
@export var speed: float = 200.0
# Dirección inicial (moviéndose hacia la izquierda o hacia la derecha)
var direction: Vector2 = Vector2.LEFT

# Nodo Area2D para detectar colisiones con el jugador
@onready var collision_area: Area2D = $Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# No queremos que los enemigos colisionen entre sí, por lo que desactivamos la colisión entre ellos
	# Esto se logra configurando las capas de colisión adecuadamente
	collision_layer = 1  # Asignamos al enemigo a la capa 1 (puede ser cualquier capa que no se use para otros enemigos)
	collision_mask = 2   # Establecemos la máscara de colisión para que solo interactúe con los jugadores (suponiendo que el jugador está en la capa 2)

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
		queue_free()  # Eliminar el enemigo

	# Invertir la animación dependiendo de la dirección
	if direction.x > 0:
		animated_sprite.flip_h = false  # No invertir (moviéndose a la derecha)
	else:
		animated_sprite.flip_h = true   # Invertir (moviéndose a la izquierda)

	# Reproducir la animación de caminar si no está ya jugando
	if not animated_sprite.is_playing():
		animated_sprite.play("walk")

func is_out_of_bounds() -> bool:
	# Comprobar si el enemigo ha salido de los límites de la pantalla
	var screen_rect = get_viewport_rect()
	return not screen_rect.has_point(position)

# Función que se ejecuta cuando el enemigo colisiona con el jugador
func _on_body_entered(body) -> void:
	if body.is_in_group("player"):  # Asegúrate de que el jugador esté en el grupo "player"
		queue_free()  # Eliminar el enemigo al chocar con el jugador
		body._on_enemy_touched()  # Llamar al método del jugador que maneja el toque
