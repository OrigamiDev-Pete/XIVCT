extends VBoxContainer

signal searched
signal found
signal gatherable

var panel = preload("res://Scenes/Panel.tscn")

var item_array : Array = []
var item_times : Array = []
var regex = RegEx.new()


func add_panels(item):
	var new_panel = panel.instance()
#	item_times.append(new_panel.item_time)
	new_panel.item = item
	add_child(new_panel, true)
	new_panel.name = item
	sort(new_panel)
	connect("searched", new_panel, "_on_searched")
	connect("found", new_panel, "_on_found")
	
	#Overlay Setup
#	get_node("/root/Main/OverlayMode").add_panels(item)
	
func remove_panels(item):
	get_node(item).queue_free()


func _on_ItemSelect_item_changed(item, _id):
	if item_array.has(item):
		item_array.erase(item)
		remove_panels(item)
	else:
		item_array.append(item)
		add_panels(item)
	get_node("/root/Main/OverlayMode").add_panels()


func _on_LineEdit_text_changed(new_text):
	emit_signal("searched")
	search(new_text)

func search(text):
	regex.compile("(?i)" + text) #(?i) makes regex case insensitive
	var result = regex.search_all(str(item_array))
	for result in regex.search_all(str(item_array)):
		emit_signal("found", "(?i)" + text)

func sort(new_panel):
	if new_panel.item_time == 0:
		move_child(new_panel, 0)
		return
	var children = get_children()
	var times = []
	for i in children.size():
#		print(children[i].item)
#		print(children[i].item_time)
#		print(children[i].compare_time(children[i].item_time, children[i].life))
		if children[i].compare_time(children[i].item_time, children[i].life) == null:
			return
		times.append(children[i].item_time + children[i].compare_time(children[i].item_time, children[i].life))
	var this_time = times.back()
#	print(new_panel.compare_time(new_panel.item_time))
#	print(new_panel.compare_time_fish(new_panel.item_time))
#	print(new_panel.sort_helper(new_panel.item_time))
#	print(times)
	times.sort()
	move_child(new_panel, times.find(this_time))
	times.clear()
	

func refresh_sort():
	yield(get_tree().create_timer(0.1), "timeout")
	var children = get_children()
	var times = []
	for i in children.size():
		if children[i].compare_time(children[i].item_time, children[i].life) == null:
			return
		times.append(children[i].item_time + children[i].compare_time(children[i].item_time, children[i].life))
	times.sort()
	for i in children.size():
		move_child(children[i], times.find(children[i].item_time + children[i].compare_time(children[i].item_time, children[i].life)))
	print("sorted")
	times.clear()

func save():
	return item_array

func load():
	item_array = SaveLoad.saved_array
	for i in item_array.size():
		add_panels(item_array[i])
		print("Panel")
		print(i)
		print(item_array[i])

func _on_gatherable(node):
	emit_signal("gatherable")
#	move_child(node, 0)
	
func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		refresh_sort()