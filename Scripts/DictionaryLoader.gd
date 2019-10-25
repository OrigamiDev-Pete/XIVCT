extends Node

var item_dictionary : Dictionary
var versions : Dictionary
var master_dictionary : bool = false

func _ready():
	item_dictionary = read_json()
	versions = read_version()


func read_json():
	var file = File.new()
	if master_dictionary:
		file.open("res://JSON/ItemDictionaryMaster.json", File.READ)
	else:
		file.open("res://JSON/ItemDictionary.json", File.READ)
	var content = parse_json(file.get_as_text())
	file.close()
	return content

func read_version():
	var file = File.new()
	file.open("res://JSON/Versions.json", File.READ)
	var content = parse_json(file.get_as_text())
	file.close()
	return content