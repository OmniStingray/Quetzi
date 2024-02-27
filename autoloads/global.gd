extends Node


const GRID_SIZE:int = 128

var face_direction:int = 0
var turn_location:Vector2 = Vector2.ZERO
var save_data:SaveData

func _ready():
	save_data = SaveData.load_or_create()
