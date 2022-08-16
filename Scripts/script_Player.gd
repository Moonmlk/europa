extends KinematicBody2D

var move_speed = 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _init():
	WorldVariables.player_object = self
	position = Vector2(WorldVariables.g_tile_size*WorldVariables.g_chunk_size*WorldVariables.g_chunk_limit/2, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	print(self.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed("sprint")):
		move_speed = 10
	else:
		move_speed = 4
	
	if(Input.is_action_pressed("ui_left")):
		position.x = position.x - move_speed
	if(Input.is_action_pressed("ui_right")):
		position.x = position.x + move_speed
	if(Input.is_action_pressed("ui_up")):
		position.y = position.y - move_speed
	if(Input.is_action_pressed("ui_down")):
		position.y = position.y + move_speed
