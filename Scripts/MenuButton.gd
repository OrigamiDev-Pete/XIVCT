extends MenuButton

func _ready():
# warning-ignore:return_value_discarded
	get_popup().connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(id):
	text = get_popup().get_item_text(id)