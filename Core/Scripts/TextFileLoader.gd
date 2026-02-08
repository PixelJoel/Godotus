extends Label

@export_file_path("*.txt") var textPath

func _ready() -> void:
	print("File path is ", var_to_str(textPath))
	text = load_file_to_text(textPath)

func load_file_to_text(_filePath: String) -> String:
	var file = FileAccess.open(_filePath, FileAccess.READ)
	
	print("Starting to load ", _filePath, " it exists: ", FileAccess.file_exists(_filePath))
	if file == null:
		push_error("Failed to open file: " + _filePath)
		return "null"
	else:
		print(file)
	var content: String = file.get_as_text()
	return content
	
