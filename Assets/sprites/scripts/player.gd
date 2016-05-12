
extends KinematicBody2D

onready var tester = get_node("../DebugNode")

export(NodePath) var terrainPath
onready var terrain = get_node(terrainPath) # "bg"

var begin=Vector2()
var end=Vector2()
var path=[]

var animation = "idle_rightfront"
var next_idle = "idle_rightfront"
var force_next_idle = ""
var arrived_to_destination = false

var target_obj

const DEFAULT_SPEED = 150.0
var speed = DEFAULT_SPEED

func interact(target, action):
	var actionList = target.get_actions()
	
	if (!actionList.empty()):
		if (action == "primary_action" or action == "secondary_action"):
			action = actionList[action]
		printt("ACTION : ", action, "RESULT : ", actionList[action])
	else:
		print("LOG ERROR: Hostspot '"+str(target.name)+"' has no script!")
	pass

func _process(delta):
	arrived_to_destination = false
	set_scale(terrain.get_scale(get_global_pos()))
	
	if (path.size()>1):
		#print(speed)
		var to_walk = delta*speed
		
		while(to_walk>0 and path.size()>=2):
			var pfrom = path[path.size()-1]
			var pto = path[path.size()-2]
			var d = pfrom.distance_to(pto)
			
			_update_speeddepth(pfrom, pto)
			to_walk = delta*speed
			
			var pVecFromTo = Vector2(pto.x - pfrom.x, pfrom.y - pto.y)
			var angle = pVecFromTo.normalized().angle()
			
			if (angle > -PI/8 || angle < PI/8):
				animation = "walk_rightup"
				next_idle = "idle_rightup"
			if (angle > 3*PI/8 && angle < 5*PI/8):
				animation = "walk_right"
				next_idle = "idle_rightfront"
			if (angle < PI/8 && angle >= -PI/8):
				animation = "walk_up"
				next_idle = "idle_up"
			if (angle > 5*PI/8 && angle < 7*PI/8):
				animation = "walk_rightfront"
				next_idle = "idle_rightfront"
			if (angle > 7*PI/8 || angle < -7*PI/8):
				animation = "walk_front"
				next_idle = "idle_front"
			if (angle < -PI/8 && angle > -3*PI/8):
				animation = "walk_leftup"
				next_idle = "idle_leftup"
			if (angle < -3*PI/8 && angle > -5*PI/8):
				animation = "walk_left"
				next_idle = "idle_leftfront"
			if (angle < -5*PI/8 && angle > -7*PI/8):
				animation = "walk_leftfront"
				next_idle = "idle_leftfront"
			
			# if no animation is running
			if (not get_node("sprite/anim").is_playing()):
				get_node("sprite/anim").play(animation)
			else: # an animation is currently running, replace it if we wish to start a different one
				if (animation != get_node("sprite/anim").get_current_animation()):
					get_node("sprite/anim").play(animation)
			
			# waypoint reached, remove it from the list
			if (d<=to_walk):
				path.remove(path.size()-1)
				to_walk-=d
			else:
				path[path.size()-1] = pfrom.linear_interpolate(pto,to_walk/d)
				to_walk=0
			
			
		# modify sprite position at time T
		var atpos = path[path.size()-1]
		set_pos(atpos)
		
		# rescale player sprite according to the depth given by the terrain
		#print("Terrain Depth = ", terrain.get_scale(atpos))
		#set_scale(terrain.get_scale(atpos))
		_update_scale()
		# modification of Z-index according to the depth given by the terrain
		_update_z()
		#print("ScaleX = ", terrain.get_scale(atpos).x/0.5)
		#print("PlayerZ = ", get_z())
		terrain.update_shader(get_pos())
		
		
		if (path.size()<2):
			path=[]
			arrived_to_destination = true
			if get_node("sprite").is_flipped_h():
				get_node("sprite").set_flip_h(false)
			
			if force_next_idle != "":
				get_node("sprite/anim").play(force_next_idle)
				force_next_idle = ""
			else:
				get_node("sprite/anim").play(next_idle)
				
		# action if player arrived to destination
		if (arrived_to_destination && target_obj):
			interact(target_obj, "primary_action")

	else:
		set_process(false)


			
			

func _update_path():
	#print("END = ", end)
	var p = terrain.get_node("Navigation2D").get_simple_path(begin,end,true)
	path=Array(p) # Vector2array to complex to use, convert to regular array
	path.invert()
	
	#print (get_pos())
	#print ("path = ", path)
	tester.draw_points(p)
	set_process(true)


func _update_scale():
	set_scale(terrain.get_scale(get_pos()))
	_update_z()

# update Z-index
func _update_z():
	var z = terrain.get_scale(get_pos()).x/0.5*2.3
	set_z(z)

# update speed according to distance to camera
# the closer the player, the biggest his speed
func _update_speeddepth(begin, end):
	var vdif = terrain.get_scale_diff(begin, end)
	if vdif < 0.1:
		speed = 100.0
	else:
		speed = DEFAULT_SPEED

func _input(ev):
	if (ev.type==InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index==BUTTON_LEFT):
		begin=get_global_pos()
		end = ev.pos
		_update_path()
		
		
		
func _go_to_object(pos, obj, animation_arrived):
	target_obj = obj
	
	var ev = InputEvent()
	ev.type = InputEvent.MOUSE_BUTTON 
	ev.pressed = true
	ev.button_index = BUTTON_LEFT
	ev.pos = pos
	force_next_idle = animation_arrived
	_input(ev)

func _ready():
	# Initialization here
	##var arrNodesInGrp = get_tree().get_nodes_in_group("Movement")
	##for nodesGrp in arrNodesInGrp:
	##	if nodesGrp.get_name() == "player":
	##		player = nodesGrp
	add_to_group("Actors")
	get_node("sprite/anim").set_current_animation("idle_right")
	#print(terrain.get_scale(get_pos()))
	
	set_process_input(true)
	pass