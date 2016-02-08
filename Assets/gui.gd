
extends Label

# member variables here, example:
# var a=2
# var b="textvar"

func _on_need_show(what):
	set_text(what)

func _ready():
	add_to_group("GUI")
	pass


