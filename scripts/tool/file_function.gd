@tool

extends Script
class_name FileFunction


static func get_file_list(path: String, extension: bool = true) -> Dictionary:
	var file_name: String = ""
	var file_basename: String = ""
	var files: Dictionary
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		file_name = dir.get_next()
		file_basename = file_name.get_basename()
		while file_name != "":
			if dir.current_is_dir():
				var sub_path = path + "/" + file_name
				files.merge(get_file_list(sub_path, extension), true)
			else:
				var path_name = path + "/" + file_name
				files.merge({file_basename: path_name}, true)
			file_name = dir.get_next()
			file_basename = file_name.get_basename()
		dir.list_dir_end()
	else:
		print_debug("Failed to open:"+path)
	
	return files

static func get_file_name_list(path: String, extension: bool = true) -> Dictionary:
	var file_name: String = ""
	var file_basename: String = ""
	var files: Dictionary
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		file_name = dir.get_next()
		file_basename = file_name.get_basename()
		while file_name != "":
			if dir.current_is_dir():
				var sub_path = path + "/" + file_name
				files.merge(get_file_list(sub_path, extension), true)
			else:
				var path_name = path + "/" + file_name
				files.merge({path_name: file_basename}, true)
			file_name = dir.get_next()
			file_basename = file_name.get_basename()
		dir.list_dir_end()
	else:
		print_debug("Failed to open:"+path)
	
	return files

static func json_as_dictionary(path: String) -> Dictionary:
	var data = JSON.parse_string(FileAccess.open(path, FileAccess.READ).get_as_text()) as Dictionary
	return data
