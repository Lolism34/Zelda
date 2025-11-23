extends CharacterBody2D
class_name Evil_wizard


@export var speed: float = 60.0
@export var max_health: int = 2
@export var contact_damage: int = 1
@export var detection_radius: float = 120.0

var current_health: int
var player: Node2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_area: Area2D = $HurtArea

func _ready() -> void:
	current_health = max_health
	hurt_area.body_entered.connect(_on_hurt_area_body_entered)

func _physics_process(_delta: float) -> void:
	if player == null or not is_instance_valid(player):
		_find_player()

	if player == null or not is_instance_valid(player):
		velocity = Vector2.ZERO
		move_and_slide()
		_update_animation(Vector2.ZERO)
		return

	var to_player: Vector2 = player.global_position - global_position

	if to_player.length() > detection_radius:
		velocity = Vector2.ZERO
		move_and_slide()
		_update_animation(Vector2.ZERO)
		return

	var dir: Vector2 = to_player.normalized()
	velocity = dir * speed
	move_and_slide()
	_update_animation(dir)

func _find_player() -> void:
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0] as Node2D

func _update_animation(dir: Vector2) -> void:
	if dir.length() == 0.0:
		var idle_name := "idle_down"
		if anim.animation.begins_with("walk_"):
			idle_name = "idle_" + anim.animation.trim_prefix("walk_")
		anim.play(idle_name)
		return

	var dir_name := ""
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0.0:
			dir_name = "right"
		else:
			dir_name = "left"
	else:
		if dir.y > 0.0:
			dir_name = "down"
		else:
			dir_name = "up"

	var anim_name := "walk_" + dir_name
	anim.play(anim_name)

func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		queue_free()

#func _on_hurt_area_body_entered(body: Node) -> void:
#	if body.has_method("take_damage"):
#		body.take_damage(contact_damage)
func _on_hurt_area_body_entered(body: Node) -> void:
	print("HurtArea hit: ", body.name)
	if body.has_method("take_damage"):
			print("Calling take_damage on ", body.name)
			body.take_damage(contact_damage)
