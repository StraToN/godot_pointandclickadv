
extends Control

export var name = ""
# "walk_up", "walk_rightup", "walk_right", "walk_rightfront", "walk_front", "walk_leftfront", "walk_left", "walk_leftup"
export (String, "idle_up", "idle_rightup", "idle_rightfront", "idle_front", "idle_leftfront", "idle_leftup") var animation_arrived = "idle_rightfront"
export (String,FILE) var ScriptRes = ""

func get_interact_pos():
	if has_node("interactpos"):
		print("Object ", name, " Pos=", get_node("interactpos").get_global_pos())
		return get_node("interactpos").get_global_pos()
	else:
		return get_global_pos()


func on_mouse_enter():
	if name == "":
		name = "noname_" + get_name()
	get_tree().call_group(0, "GUI", "_on_need_show", name)
	#print(name)


func on_mouse_exit():
	get_tree().call_group(0, "GUI", "_on_need_show", "")
	#print("exit")


func _input_event(ev):
	if ev.is_pressed() and ev.button_index == BUTTON_LEFT:
		get_tree().call_group(0, "Actors", "_go_to_object", get_interact_pos(), self, animation_arrived)


func _ready():
	add_to_group("Actors")
	add_to_group("GUI")
	connect("mouse_enter", self, "on_mouse_enter")
	connect("mouse_exit", self, "on_mouse_exit")
	connect("input_event", self, "_input_event")
	pass


