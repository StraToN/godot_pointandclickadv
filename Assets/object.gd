
extends Area2D

export var name = ""
# "walk_up", "walk_rightup", "walk_right", "walk_rightfront", "walk_front", "walk_leftfront", "walk_left", "walk_leftup"
export (String, "idle_up", "idle_rightup", "idle_rightfront", "idle_front", "idle_leftfront", "idle_leftup") var animation_arrived = "idle_rightfront"
export (String,FILE) var ScriptRes = ""
var actions = {} setget set_actions,get_actions

var pointing # is the player pointing this hotspot with mouse?

func get_interact_pos():
	if has_node("interactpos"):
		#print("Object ", name, " Pos=", get_node("interactpos").get_global_pos())
		return get_node("interactpos").get_global_pos()
	else:
		return get_global_pos()


func on_mouse_enter():
	if name == "":
		name = "noname_" + get_name()
	get_tree().call_group(0, "GUI", "_on_need_show", name)
	pointing = true
	#print(name)


func on_mouse_exit():
	get_tree().call_group(0, "GUI", "_on_need_show", "")
	pointing = false
	#print("exit")


func _input_event( viewport, event, shape_idx ):
	if event.is_pressed() and event.button_index == BUTTON_LEFT:
		print("INPUT")
		get_tree().call_group(0, "Actors", "_go_to_object", get_interact_pos(), self, animation_arrived)

func prepare_object_script():
	var file = File.new()
	file.open(ScriptRes, file.READ)
	var actionsString = file.get_as_text()
	file.close()
	actions.parse_json(actionsString)
	#print(actions)


func _ready():
	add_to_group("Actors")
	add_to_group("GUI")
	connect("mouse_enter", self, "on_mouse_enter")
	connect("mouse_exit", self, "on_mouse_exit")
	connect("input_event", self, "_input_event")
	
	if (ScriptRes != ""):
		prepare_object_script()
		
	
	pass


func set_actions(new_actions):
	actions = new_actions

func get_actions():
	return actions
	
