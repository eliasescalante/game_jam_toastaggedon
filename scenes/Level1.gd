extends Node2D

# Número máximo de enemigos en la pantalla
var max_enemy_count: int = 10
var game_time: float = 0.0
var player_area: Area2D

# Ruta de la escena del enemigo
var enemy_scene = preload("res://enemy/enemy.tscn")

# Temporizador para generar enemigos de a poco
var spawn_timer: Timer

# Lista para mantener un seguimiento de los enemigos en la escena
var current_enemies: Array = []

# Tamaño de la pantalla para determinar los bordes
var screen_size: Vector2

# Contador de golpes recibidos
var hit_count: int = 0
var max_hits: int = 4

var game_is_running: bool = true

func _ready() -> void:
	# Obtener el tamaño de la pantalla
	screen_size = get_viewport_rect().size
	player_area = $Personaje/Area2D 
	spawn_timer = Timer.new()
	# Configurar el temporizador para que llame a la función spawn_enemy() cada 0.5 segundos
	spawn_timer.wait_time = 0.5
	spawn_timer.autostart = true
	spawn_timer.one_shot = false
	add_child(spawn_timer)
	# Conectar la señal del temporizador para que llame a la función cada vez que se dispara
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	player_area.connect("area_entered", Callable(self, "_on_player_collision"))

func _on_spawn_timer_timeout() -> void:
	# Verificar si el número de enemigos actuales es menor que el máximo permitido
	if current_enemies.size() < max_enemy_count and game_is_running:
		spawn_enemy()
	else:
		spawn_timer.stop()

# Función para generar un enemigo
func spawn_enemy() -> void:
	var enemy_instance = enemy_scene.instantiate()
	var edge = randi() % 4
	var spawn_position: Vector2
	var direction: Vector2

	match edge:
		0:  # Aparece desde la izquierda y va hacia la derecha
			spawn_position = Vector2(0, randi() % int(screen_size.y))
			direction = Vector2.RIGHT
		1:  # Aparece desde la derecha y va hacia la izquierda
			spawn_position = Vector2(screen_size.x, randi() % int(screen_size.y))
			direction = Vector2.LEFT
		2:  # Aparece desde arriba y va hacia abajo
			spawn_position = Vector2(randi() % int(screen_size.x), 0)
			direction = Vector2.DOWN
		3:  # Aparece desde abajo y va hacia arriba
			spawn_position = Vector2(randi() % int(screen_size.x), screen_size.y)
			direction = Vector2.UP
	
	# Establecer la posición del enemigo y su dirección
	enemy_instance.position = spawn_position
	enemy_instance.direction = direction
	# Añadir el enemigo como hijo de la escena actual
	add_child(enemy_instance)
	# Añadir el enemigo a la lista de enemigos actuales
	current_enemies.append(enemy_instance)
	enemy_instance.tree_exiting.connect(Callable(self, "_on_enemy_exit").bind(enemy_instance))

# Función para manejar cuando un enemigo sale de la escena
func _on_enemy_exit(enemy: Node) -> void:
	# Eliminar el enemigo de la lista cuando salga de la escena
	current_enemies.erase(enemy)
	if current_enemies.size() < max_enemy_count and game_is_running:
		spawn_timer.start()

# Función llamada cuando el jugador es golpeado por un enemigo
func player_hit() -> void:
	hit_count += 1
	print("Golpes recibidos: ", hit_count)
	if hit_count >= max_hits:
		print("Número de golpes alcanzado. Ejecutando game_over.")
		game_over()

# Función para finalizar el juego y pasar el tiempo a la escena de pérdida
func game_over() -> void:
	print("Se ejecutó game_over")
	# Detener el juego
	game_is_running = false
	# Instanciamos la escena de "win-lose"
	var win_lose_scene = load("res://win-lose/win-lose.tscn")
	var win_lose_instance = win_lose_scene.instantiate()

	# Pasamos el tiempo a la escena de "win-lose"
	print("Tiempo pasado a win-lose: ", game_time)
	var win_lose_script = win_lose_instance.get_node("win_lose")

	# Llamamos a la función set_game_time del script
	win_lose_script.set_game_time(game_time)

	# Cambiar a la escena de perder
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(win_lose_instance)

# Actualizar el tiempo de juego en cada frame
func _process(delta: float) -> void:
	game_time += delta
	
