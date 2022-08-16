extends Node
class_name Chunk

var chunk_origin = null
var cell_map = []
var positions = []

var chance_cave = 0.35
var chance_alive = 0.4
var death_limit = 3
var birth_limit = 4
var number_of_steps = 10

func _init(origin: Vector2):
	randomize()
	chunk_origin = origin
	generate_map()
	
	
	for yy in range(WorldVariables.g_chunk_size):
		for xx in range(WorldVariables.g_chunk_size):
			positions.push_back(Vector2(chunk_origin.x*(WorldVariables.g_tile_size*WorldVariables.g_chunk_size) + xx*WorldVariables.g_tile_size, 
										chunk_origin.y*(WorldVariables.g_tile_size*WorldVariables.g_chunk_size) + yy*WorldVariables.g_tile_size))
	
	#if(!positions.empty() && chunk_origin.y != 0):
#		var directions = [1,-1]
#		var xory = [0,1]
#		var pos = positions
#		var dir = 1
#
#		if(randf() < .4):
#			pos.shuffle()
#			pos = pos[0]
#			positions.erase(pos)
#
#			for step in range(0, randi() % 200 + 25):
#				xory.shuffle() 
#				directions.shuffle()
#				dir = directions[0]
#
#				var next_pos = pos
#				next_pos[xory[0]] += dir*WorldVariables.g_tile_size
#				if(positions.has(next_pos)):
#					positions.erase(pos)
#					pos = next_pos


func generate_map() -> void:
	if(randf() < chance_cave && chunk_origin.y != 0):
		init_Map()
		for step in range(number_of_steps):
			cell_map = do_simulation_step(cell_map)
	else:
		populate_array(cell_map, true)


func populate_array(map, val):
	for i in range(WorldVariables.g_chunk_size):
		map.append([])
		for j in range(WorldVariables.g_chunk_size):
			map[i].append(val)
	return map


func init_Map() -> void:
	cell_map = populate_array(cell_map, false)
	for yy in range(WorldVariables.g_chunk_size):
		for xx in range(WorldVariables.g_chunk_size):
			if(randf() < chance_alive):
				cell_map[xx][yy] = true
			else:
				cell_map[xx][yy] = false


func do_simulation_step(old_map) -> Array:
	var new_map = populate_array([], false)
	var n_count = 0
	
	for yy in range(old_map.size()):
		for xx in range(old_map.size()):
			n_count = count_alive_neighbors(old_map, xx, yy)
			
			if(old_map[xx][yy]):
				if(n_count < death_limit):
					new_map[xx][yy] = false
				else:
					new_map[xx][yy] = true
			else:
				if(n_count > birth_limit):
					new_map[xx][yy] = true
				else:
					new_map[xx][yy] = false
	return new_map


func count_alive_neighbors(map, x, y) -> int:
	var count = 0
	var n_x = 0
	var n_y = 0
	
	for i in range(-1, 2):
		for j in range(-1, 2):
			n_x = x+i
			n_y = y+j
			
			if(i == 0 && j == 0):
				pass
			elif(n_x < 0 || n_y < 0 || n_x >= map.size() || n_y >= map.size()):
				count += 1
			elif(map[n_x][n_y]):
				count += 1
	return count
