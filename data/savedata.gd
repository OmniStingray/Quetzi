class_name SaveData extends Resource

@export var high_score:int = 0

const SAVE_PATH:String = "E://Projects//!Game_Dev Club//Team//Sam//Temp//Quetzi_hs_save.tres"

func save():
	ResourceSaver.save(self, SAVE_PATH)
	
static func load_or_create() -> SaveData:
	var res:SaveData
	if FileAccess.file_exists(SAVE_PATH):
		res = load(SAVE_PATH)
		print("Loaded!")
	else:
		res = SaveData.new()
		print("New Save!")
	return res
