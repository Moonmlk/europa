extends TileMap

var chunk_loader = ChunkLoader
var chunk_changed = true
var chunk_gen = true

var update_bitmask = true

func _init():
	chunk_loader = chunk_loader.new(self)

func _process(delta):
	#Loop through currently loaded chunks
	var chunks = chunk_loader.chunks
	if(!chunk_loader.loaded_chunks.empty()):
		for chunk in chunk_loader.loaded_chunks:
			var cur_chunk = chunk_loader.chunks[chunk]
			var cell_map = cur_chunk.cell_map
			
			#Use chunks cell_map to determine which tiles to draw
			for yy in range(cell_map.size()):
				for xx in range (cell_map.size()):
					var world_pos = Vector2(cur_chunk.chunk_origin.x*(WorldVariables.g_tile_size*WorldVariables.g_chunk_size) + xx*WorldVariables.g_tile_size,
											cur_chunk.chunk_origin.y*(WorldVariables.g_tile_size*WorldVariables.g_chunk_size) + yy*WorldVariables.g_tile_size)
					if(cell_map[xx][yy] == true):
						set_cellv(world_to_map(world_pos), 0)
						update_bitmask = true
	#Update autotile map
	if(update_bitmask):
		update_bitmask = false
		update_bitmask_region()


func _on_clear_cells_timeout():
	clear()
	if(WorldVariables.player_object != null):
		var chunk_pos = world_to_map(WorldVariables.player_object.position)
		
		#Translate chunk position to chunk number
		chunk_pos.x = floor(chunk_pos.x/WorldVariables.g_chunk_size)
		chunk_pos.y = floor(chunk_pos.y/WorldVariables.g_chunk_size)
		if(chunk_pos.y < 0): chunk_pos.y = 0
		chunk_loader.set_current_chunk(chunk_pos)
	
