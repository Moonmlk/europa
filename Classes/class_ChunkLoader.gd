extends Node
class_name ChunkLoader

const TILE_SIZE = WorldVariables.g_tile_size
const CHUNK_SIZE = WorldVariables.g_chunk_size
const CHUNK_LIMIT = WorldVariables.g_chunk_limit
const RENDER_DISTANCE = WorldVariables.g_render_distance

var chunks = {}
var loaded_chunks = []
var tile_map = null

var current_chunk:Vector2 setget set_current_chunk, get_current_chunk

func _init(tm: TileMap):
	randomize()
	tile_map = tm
	WorldVariables.chunk_loader = self


func get_current_chunk() -> Vector2:
	return current_chunk


func set_current_chunk(coords: Vector2) -> bool:
	#if the current player location is outside the map bounds, return false. else return true
	if(is_out_of_bounds(coords)):
		return false
	else:
		current_chunk = coords#get_chunk_origin(coords)
		load_chunks()
		return true 


func unload_chunk(chunk: Vector2) -> void:
	loaded_chunks.erase(chunk)


func load_chunks() -> void:
	var surrounding_chunks = get_surrounding_chunks()
	
	#unload chunks that are out of render distance
	for old_chunk in loaded_chunks:
		if(!surrounding_chunks.has(old_chunk)):
			unload_chunk(old_chunk)
	
	#load new chunks
	for chunk in surrounding_chunks:
		if(!loaded_chunks.has(chunk)):
			loaded_chunks.push_back(chunk)


func create_new_chunk(origin: Vector2) -> void:
	var new_chunk = Chunk.new(origin)
	chunks[origin] = new_chunk


func get_surrounding_chunks() -> Array:
	var start = Vector2(clamp(current_chunk.x-RENDER_DISTANCE, 0, current_chunk.x-RENDER_DISTANCE), 
						clamp(current_chunk.y-RENDER_DISTANCE, 0, current_chunk.y-RENDER_DISTANCE))
	var end = Vector2(clamp(current_chunk.x+RENDER_DISTANCE, current_chunk.x+RENDER_DISTANCE, CHUNK_LIMIT), 
					clamp(current_chunk.y+RENDER_DISTANCE, current_chunk.y+RENDER_DISTANCE, CHUNK_LIMIT))
	
	#delete out of bounds chunks
	var neighbor_chunks = []
	for yy in range(start.y, end.y+1):
		for xx in range(start.x, end.x+1):
			if(!is_out_of_bounds(Vector2(xx,yy))):
				neighbor_chunks.push_back(Vector2(xx,yy))
	
	#Add chunks that do not exist to chunk map 
	for x in neighbor_chunks:
		if(!chunks.has(x)):
			create_new_chunk(x)
	return neighbor_chunks

#DEPERCATED/ NOT IN USE
#Return the chunk the player is currently in
func get_chunk_origin(coords: Vector2) -> Vector2:
	var chunk_origin = coords
	for x in range(2):
		if(chunk_origin[x] == 0 || fmod(chunk_origin[x], CHUNK_SIZE) == 0):
			continue
		else:
			var pos = floor(coords[x])
			var str_pos = str(pos)
			
			#Find the location of the player relative to the chunk the player is in
			var loc_in_chunk = int(str_pos.substr(str_pos.length()-str(CHUNK_SIZE).length(), -1))
			var difference = loc_in_chunk - CHUNK_SIZE
			var origin = 0
			
			if(difference < 0):
				origin = (pos+abs(difference)) - CHUNK_SIZE
			else:
				origin = pos - difference
			
			chunk_origin[x] = origin
	
	return chunk_origin


#Checks if coordinate is out of map bounds
func is_out_of_bounds(coords: Vector2) -> bool:
	if(coords.x < 0 || coords.y < 0 || coords.x > CHUNK_LIMIT || coords.y > CHUNK_LIMIT):
		return true
	else:
		return false
