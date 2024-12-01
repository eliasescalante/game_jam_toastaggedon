extends Node2D

# Número máximo de enemigos en la pantalla
var max_enemy_count: int = 20
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
	screen_size = get_viewport_rect().size
	player_area = $Personaje/Area2D
	spawn_timer = Timer.new()
	
	spawn_timer.wait_time = 0.3
	spawn_timer.autostart = true
	spawn_timer.one_shot = false
	
	add_child(spawn_timer)
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	player_area.connect("area_entered", Callable(self, "_on_player_collision"))

func _on_spawn_timer_timeout() -> void:
	if current_enemies.size() < max_enemy_count and game_is_running:
		for i in range(3):
			spawn_enemy()
	else:
		spawn_timer.stop()

func spawn_enemy() -> void:
	var enemy_instance = enemy_scene.instantiate()
	var edge = randi() % 4
	var spawn_position: Vector2
	var direction: Vector2

	match edge:
		0:
			spawn_position = Vector2(0, randi() % int(screen_size.y))
			direction = Vector2.RIGHT
		1:
			spawn_position = Vector2(screen_size.x, randi() % int(screen_size.y))
			direction = Vector2.LEFT
		2:
			spawn_position = Vector2(randi() % int(screen_size.x), 0)
			direction = Vector2.DOWN
		3:
			spawn_position = Vector2(randi() % int(screen_size.x), screen_size.y)
			direction = Vector2.UP
	
	enemy_instance.position = spawn_position
	enemy_instance.direction = direction
	add_child(enemy_instance)
	current_enemies.append(enemy_instance)
	enemy_instance.tree_exiting.connect(Callable(self, "_on_enemy_exit").bind(enemy_instance))

func _on_enemy_exit(enemy: Node) -> void:
	current_enemies.erase(enemy)
	if current_enemies.size() < max_enemy_count and game_is_running:
		spawn_timer.start()

func player_hit() -> void:
	hit_count += 1
	print("Golpes recibidos: ", hit_count)
	if hit_count >= max_hits:
		print("Número de golpes alcanzado. Ejecutando game_over.")
		game_over()

func game_over() -> void:
	print("Se ejecutó game_over")
	game_is_running = false

	# Guardar el tiempo en el script global
	Global.tiempo = game_time
	print("Tiempo guardado en Global: ", Global.tiempo)

	# Cambiar a la escena "win-lose"
	get_tree().change_scene_to_file("res://win-lose/win-lose.tscn")

func _process(delta: float) -> void:
	game_time += delta
