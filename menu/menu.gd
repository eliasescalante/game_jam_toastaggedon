extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	# Cambia a la escena del nivel usando una ruta
	get_tree().change_scene_to_file("res://instrucciones/instrucciones.tscn")

func _on_creditos_pressed() -> void:
	# Cambia a la escena de créditos usando una ruta
	get_tree().change_scene_to_file("res://creditos/creditos.tscn")

func _on_salir_pressed() -> void:
	# Cierra el juego
	get_tree().quit()
