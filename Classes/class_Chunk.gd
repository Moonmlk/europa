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
	
	#Add the tilemap positions of the chunk
	for yy in range(WorldVariables.g_chunk_size):
		for xx in range(WorldVariables.g_chunk_size):
			positions.push_back(Vector2(chunk_origin.x*(WorldVariables.g_tile_size*WorldVariables.g_chunk_size) + xx*WorldVariables.g_tile_size, 
										chunk_origin.y*(WorldVariables.g_tile_size*WorldVariables.g_chunk_size) + yy*WorldVariables.g_tile_size))
	

#Populate given 2D array with given value
func populate_array(map, val):
	for i in range(WorldVariables.g_chunk_size):
		map.append([])
		for j in range(WorldVariables.g_chunk_size):
			map[i].append(val)
	return map


#Cellular automata cave generator adapted from link below
#https://gamedevelopment.tutsplus.com/tutorials/generate-random-cave-levels-using-cellular-automata--gamedev-9664
func generate_map() -> void:
	if(randf() < chance_cave && chunk_origin.y != 0):
		init_Map()
		for step in range(number_of_steps):
			cell_map = do_simulation_step(cell_map)
	else:
		populate_array(cell_map, true)


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
