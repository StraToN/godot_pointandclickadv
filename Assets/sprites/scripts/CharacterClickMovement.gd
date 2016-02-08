
extends Navigation2D

export(NodePath) var playerPath
var player
var terrain

var begin=Vector2()
var end=Vector2()
var path=[]

var animation = "idle_rightfront"
var next_idle = "idle_rightfront"
var force_next_idle = ""

const DEFAULT_SPEED = 150.0
var speed = DEFAULT_SPEED



func _process(delta):
	if (path.size()>1):
		print(speed)
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
			
			# si aucune animation n'est en cours
			if (not player.get_node("sprite/anim").is_playing()):
				player.get_node("sprite/anim").play(animation)
			else: # une animation est déjà en cours, on la remplace si celle qu'on veut jouer est différente
				if (animation != player.get_node("sprite/anim").get_current_animation()):
					player.get_node("sprite/anim").play(animation)
			
			# waypoint atteint, on le supprime de la liste
			if (d<=to_walk):
				path.remove(path.size()-1)
				to_walk-=d
			else:
				path[path.size()-1] = pfrom.linear_interpolate(pto,to_walk/d)
				to_walk=0
			
			
		# modifier position du sprite au temps T
		var atpos = path[path.size()-1]
		player.set_pos(atpos)
		
		# rescale selon la profondeur donnée par le terrain
		player.set_scale(terrain.get_scale(atpos))
		
		
		if (path.size()<2):
			path=[]
			if player.get_node("sprite").is_flipped_h():
				player.get_node("sprite").set_flip_h(false)
			
			if force_next_idle != "":
				player.get_node("sprite/anim").play(force_next_idle)
				force_next_idle = ""
			else:
				player.get_node("sprite/anim").play(next_idle)

	else:
		set_process(false)

	
	

func _update_path():
	var p = get_simple_path(begin,end,true)
	path=Array(p) # Vector2array to complex to use, convert to regular array
	path.invert()
	
	set_process(true)


func _update_speeddepth(begin, end):
	var vdif = terrain.get_scale_diff(begin, end)
	if vdif < 0.1:
		speed = 100.0
	else:
		speed = DEFAULT_SPEED

func _input(ev):
	if (ev.type==InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index==BUTTON_LEFT):
		# si clic sur un objet, alors destination = Position2d associée à cet objet
		begin=player.get_pos()
		#mouse to local navigation coords
		end=ev.pos - get_pos()
		
		_update_path()
		
		
		
func _go_to_object(pos, animation_arrived):
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
	player = get_node(playerPath)

	player.get_node("sprite/anim").set_current_animation("idle_right")
	
	terrain = get_parent()
	
	set_process_input(true)
	pass
	