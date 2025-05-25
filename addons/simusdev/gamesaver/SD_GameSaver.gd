extends SD_Object
class_name SD_GameSaver

signal game_saved_pre(data: SD_SavedGameData)
signal game_loaded_pre(data: SD_SavedGameData)

signal game_saved(data: SD_SavedGameData)
signal game_loaded(data: SD_SavedGameData)

const SAVEABLE_NODE_GROUP := "__saveable__"

var current_save := SD_SavedGameData.new()

func save_game(path: String) -> SD_SavedGameData:
	game_saved_pre.emit(current_save)
	var error = ResourceSaver.save(current_save, path)
	
	if error != OK:
		return current_save
	
	game_saved.emit(current_save)
	return current_save

func load_game(path: String) -> SD_SavedGameData:
	if not ResourceLoader.exists(path):
		return current_save
	
	var resource = ResourceLoader.load(path)
	
	if resource != null:
		if resource is SD_SavedGameData:
			current_save = resource.duplicate()
			game_loaded_pre.emit(current_save)
			game_loaded.emit(current_save)
	
	return current_save
