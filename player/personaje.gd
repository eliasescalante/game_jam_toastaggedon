extends CharacterBody2D
class_name Player

@export var speed: float = 300.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_area: Area2D = $Area2D

var death_animations: Array = ["death1", "death2", "death3"]
var enemy_hit_count: int = 0
var inverted_controls: bool = false

func _ready() -> void:
	animated_sprite.play("idle")
	
	# Conectar la señal de body_entered del Area2D
	if collision_area:
		collision_area.connect("body_entered", Callable(self, "_on_body_entered"))
	else:
		print("Advertencia: collision_area no encontrado.")

func _process(delta: float) -> void:
	handle_movement()

func handle_movement() -> void:
	velocity = Vector2.ZERO

	var move_right = "ui_right"
	var move_left = "ui_left"
	var move_up = "ui_up"
	var move_down = "ui_down"

	if inverted_controls:
		move_right = "ui_left"
		move_left = "ui_right"
		move_up = "ui_down"
		move_down = "ui_up"

	if Input.is_action_pressed(move_right):
		velocity.x += 1
		animated_sprite.scale.x = 1
	if Input.is_action_pressed(move_left):
		velocity.x -= 1
		animated_sprite.scale.x = -1
	if Input.is_action_pressed(move_down):
		velocity.y += 1
	if Input.is_action_pressed(move_up):
		velocity.y -= 1

	velocity = velocity.normalized() * speed
	move_and_slide()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		body.queue_free()
		_on_enemy_touched()

	if body.is_in_group("knife"):
		_on_knife_touched()

func _on_enemy_touched() -> void:
	inverted_controls = true
	print("Controles invertidos.")

	if enemy_hit_count < death_animations.size():
		animated_sprite.play(death_animations[enemy_hit_count])
		enemy_hit_count += 1
	else:
		print("Fin del juego.")
		get_tree().change_scene_to_file("res://win-lose/win-lose.tscn")

func _on_knife_touched() -> void:
	inverted_controls = false
	print("Controles restaurados.")

	if enemy_hit_count > 0:
		enemy_hit_count -= 1
		animated_sprite.play(death_animations[enemy_hit_count])
	else:
		print("Ya estás en el estado inicial.")
