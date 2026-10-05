extends Node2D

const TILE_SIZE := 32
const MAP_SIZE := Vector2i(75, 50)
const SOURCE_ID := 0

const TILE_GRASS := Vector2i(0, 0)
const TILE_DIRT := Vector2i(1, 0)
const TILE_WATER := Vector2i(2, 0)
const TILE_TUFT := Vector2i(3, 0)
const TILE_STONE := Vector2i(4, 0)
const TILE_FENCE := Vector2i(5, 0)
const TILE_FLOWER := Vector2i(6, 0)
const TILE_TREE := Vector2i(7, 0)

@onready var ground: TileMapLayer = $Ground
@onready var decoration: TileMapLayer = $Decoration
@onready var collision: TileMapLayer = $Collision


func _ready() -> void:
	var village_tileset := _create_tileset()
	ground.tile_set = village_tileset
	decoration.tile_set = village_tileset
	collision.tile_set = village_tileset
	_paint_ground()
	_paint_decoration()


func _create_tileset() -> TileSet:
	var tileset := TileSet.new()
	tileset.tile_size = Vector2i(TILE_SIZE, TILE_SIZE)

	var atlas := TileSetAtlasSource.new()
	atlas.texture = load("res://assets/maps/qingfeng_v04/qingfeng_tiles.svg")
	atlas.texture_region_size = Vector2i(TILE_SIZE, TILE_SIZE)

	for x in range(8):
		atlas.create_tile(Vector2i(x, 0))

	tileset.add_source(atlas, SOURCE_ID)
	return tileset


func _paint_ground() -> void:
	for y in range(MAP_SIZE.y):
		for x in range(MAP_SIZE.x):
			ground.set_cell(Vector2i(x, y), SOURCE_ID, TILE_GRASS)

	_fill_rect(ground, Rect2i(0, 24, 75, 5), TILE_DIRT)
	_fill_rect(ground, Rect2i(31, 6, 4, 19), TILE_DIRT)
	_fill_rect(ground, Rect2i(10, 20, 4, 5), TILE_DIRT)
	_fill_rect(ground, Rect2i(15, 18, 3, 7), TILE_DIRT)
	_fill_rect(ground, Rect2i(40, 19, 4, 6), TILE_DIRT)
	_fill_rect(ground, Rect2i(50, 19, 4, 6), TILE_DIRT)
	_fill_rect(ground, Rect2i(54, 24, 21, 5), TILE_DIRT)

	for y in range(36, 44):
		var start_x := 34 + int((y - 36) / 2)
		for x in range(start_x, MAP_SIZE.x):
			ground.set_cell(Vector2i(x, y), SOURCE_ID, TILE_WATER)


func _paint_decoration() -> void:
	for x in range(4, 10):
		decoration.set_cell(Vector2i(x, 31), SOURCE_ID, TILE_FENCE)
	for y in range(29, 35):
		decoration.set_cell(Vector2i(3, y), SOURCE_ID, TILE_FENCE)

	var grass_cells := [
		Vector2i(7, 8), Vector2i(12, 11), Vector2i(18, 7), Vector2i(23, 15),
		Vector2i(29, 19), Vector2i(36, 11), Vector2i(43, 8), Vector2i(58, 15),
		Vector2i(62, 32), Vector2i(18, 38), Vector2i(27, 42), Vector2i(52, 34)
	]
	for cell in grass_cells:
		decoration.set_cell(cell, SOURCE_ID, TILE_TUFT)

	var flower_cells := [
		Vector2i(9, 33), Vector2i(11, 34), Vector2i(14, 32), Vector2i(20, 17),
		Vector2i(25, 22), Vector2i(39, 10), Vector2i(47, 29), Vector2i(59, 31)
	]
	for cell in flower_cells:
		decoration.set_cell(cell, SOURCE_ID, TILE_FLOWER)

	var stone_cells := [
		Vector2i(6, 14), Vector2i(22, 23), Vector2i(30, 30), Vector2i(44, 33),
		Vector2i(51, 35), Vector2i(60, 44), Vector2i(68, 34)
	]
	for cell in stone_cells:
		decoration.set_cell(cell, SOURCE_ID, TILE_STONE)

	for x in range(1, 74, 4):
		decoration.set_cell(Vector2i(x, 1), SOURCE_ID, TILE_TREE)
	for y in range(4, 47, 5):
		decoration.set_cell(Vector2i(1, y), SOURCE_ID, TILE_TREE)
	for y in range(5, 21, 5):
		decoration.set_cell(Vector2i(73, y), SOURCE_ID, TILE_TREE)
	for y in range(32, 47, 5):
		decoration.set_cell(Vector2i(73, y), SOURCE_ID, TILE_TREE)


func _fill_rect(layer: TileMapLayer, rect: Rect2i, tile: Vector2i) -> void:
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			layer.set_cell(Vector2i(x, y), SOURCE_ID, tile)
