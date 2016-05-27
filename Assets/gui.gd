
extends Label



func _on_need_show(what):
	set_text(what)
	
func on_mouse_enter_object(name):
	if name == "":
		name = "noname_" + name
	set_text(name)


func on_mouse_exit_object():
	set_text("")

func _ready():
	add_to_group("GUI")
	pass


