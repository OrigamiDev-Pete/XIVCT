extends Node

var saved_array : Array
var settings : Array
var overlay : Array
var itembox : Array

func save():
	var save_state = File.new()
	save_state.open("res://savestate.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("save")
	for i in save_nodes:
		var node_data = i.call("save");
		save_state.store_line(to_json(node_data))
	save_state.close()

func load():
	var save_state = File.new()
	if not save_state.file_exists("res://savestate.save"):
		return
	
	save_state.open("res://savestate.save", File.READ)
	saved_array = (parse_json(save_state.get_line()))
	itembox = (parse_json(save_state.get_line()))
	settings = (parse_json(save_state.get_line()))
	overlay = (parse_json(save_state.get_line()))
	var load_nodes = get_tree().get_nodes_in_group("load")
	for i in load_nodes:
		i.call("load")
	save_state.close()