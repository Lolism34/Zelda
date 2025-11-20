extends Node2D

@export var room_scenes: Array[PackedScene]

var current_room_index: int = 0
var current_room: Node2D
var enter_from: String = ""

@onready var room_root: Node2D = get_parent().get_node("RoomRoot")
@onready var player: Node2D = get_parent().get_node("Player")

func _ready() -> void:
	_load_room(current_room_index)

func _load_room(index: int) -> void:
	if current_room:
		current_room.queue_free()
		if index < 0 or index >= room_scenes.size():
			return

	var scene := room_scenes[index]
	current_room = scene.instantiate() as Node2D
	room_root.add_child(current_room)
	
	

	var spawn: Node2D = null
	if current_room.has_node("PlayerSpawn"):
		spawn = current_room.get_node("PlayerSpawn")

	if spawn != null:
		player.global_position = spawn.global_position

	match enter_from:
		"right":
			if current_room.has_node("ExitRight_Spawn"):
				spawn = current_room.get_node("ExitRight_Spawn")
		"left":if current_room.has_node("ExitLeft_Spawn"):
			spawn = current_room.get_node("ExitLeft_Spawn")
		"up":
			if current_room.has_node("ExitUp_Spawn"):
				spawn = current_room.get_node("ExitUp_Spawn")
		"down":
			if current_room.has_node("ExitDown_Spawn"):
				spawn = current_room.get_node("ExitDown_Spawn")
		_:
			if current_room.has_node("PlayerSpawn"):
				spawn = current_room.get_node("PlayerSpawn")

			if spawn:
				player.global_position = spawn.global_position

	enter_from = ""

func request_room_change(new_index: int) -> void:
	if new_index < 0 or new_index >= room_scenes.size():
		return
	current_room_index = new_index
	_load_room(current_room_index)
