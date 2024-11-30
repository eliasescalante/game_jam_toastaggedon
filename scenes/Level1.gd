extends Node2D

# Número máximo de enemigos en la pantalla
var max_enemy_count: int = 10

# Ruta de la escena del enemigo
var enemy_scene = preload("res://enemy/enemy.tscn")

# Temporizador para generar enemigos de a poco
var spawn_timer: Timer

# Lista para mantener un seguimiento de los enemigos en la escena
var current_enemies: Array = []

# Tamaño de la pantalla para determinar los bordes
var screen_size: Vector2

func _ready() -> void:
	# Obtener el tamaño de la pantalla
	screen_size = get_viewport_rect().size

	# Crear el temporizador
	spawn_timer = Timer.new()
	# Configurar el temporizador para que llame a la función spawn_enemy() cada 0.5 segundos
	spawn_timer.wait_time = 0.5
	spawn_timer.autostart = true
	spawn_timer.one_shot = false  # Esto hace que el temporizador siga repitiéndose
	add_child(spawn_timer)
	
	# Conectar la señal del temporizador para que llame a la función cada vez que se dispara
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))  # Usamos Callable en Godot 4

# Función que se ejecutará cada vez que el temporizador termine
func _on_spawn_timer_timeout() -> void:
	# Verificar si el número de enemigos actuales es menor que el máximo permitido
	if current_enemies.size() < max_enemy_count:
		spawn_enemy()  # Generar un nuevo enemigo
	else:
		# Detener el temporizador si ya hay 10 enemigos en pantalla
		spawn_timer.stop()

# Función para generar un enemigo
func spawn_enemy() -> void:
	# Instanciar un nuevo enemigo
	var enemy_instance = enemy_scene.instantiate()

	# Elegir aleatoriamente si el enemigo aparecerá en el borde izquierdo, derecho, superior o inferior
	var edge = randi() % 4
	var spawn_position: Vector2
	var direction: Vector2

	match edge:
		0:  # Aparece desde la izquierda y va hacia la derecha
			spawn_position = Vector2(0, randi() % int(screen_size.y))  # Posición aleatoria en el borde izquierdo
			direction = Vector2.RIGHT  # Mover hacia la derecha
		1:  # Aparece desde la derecha y va hacia la izquierda
			spawn_position = Vector2(screen_size.x, randi() % int(screen_size.y))  # Posición aleatoria en el borde derecho
			direction = Vector2.LEFT  # Mover hacia la izquierda
		2:  # Aparece desde arriba y va hacia abajo
			spawn_position = Vector2(randi() % int(screen_size.x), 0)  # Posición aleatoria en el borde superior
			direction = Vector2.DOWN  # Mover hacia abajo
		3:  # Aparece desde abajo y va hacia arriba
			spawn_position = Vector2(randi() % int(screen_size.x), screen_size.y)  # Posición aleatoria en el borde inferior
			direction = Vector2.UP  # Mover hacia arriba
	
	# Establecer la posición del enemigo y su dirección
	enemy_instance.position = spawn_position
	enemy_instance.direction = direction  # Asignar la dirección de movimiento

	# Añadir el enemigo como hijo de la escena actual
	add_child(enemy_instance)

	# Añadir el enemigo a la lista de enemigos actuales
	current_enemies.append(enemy_instance)

	# Conectar la señal "tree_exiting" para eliminar el enemigo cuando sale de la pantalla
	enemy_instance.tree_exiting.connect(Callable(self, "_on_enemy_exit").bind(enemy_instance))

# Función para manejar cuando un enemigo sale de la escena
func _on_enemy_exit(enemy: Node) -> void:
	# Eliminar el enemigo de la lista cuando salga de la escena
	current_enemies.erase(enemy)
	# Esto permite que el temporizador se reanude para generar nuevos enemigos
	if current_enemies.size() < max_enemy_count:
		spawn_timer.start()  # Reiniciar el temporizador si hay espacio para más enemigos
