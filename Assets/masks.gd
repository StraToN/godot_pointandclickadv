
extends Node2D

export(NodePath) var canvasmodulatePath = "../CanvasModulate"

func init_masks():
	for n in get_children():
		if (n extends Light2D):
			var pos2DZ = n.get_node("Position2D").get_global_pos()
			var scale = get_node("..").get_z_at_px( pos2DZ )
			n.set_z_range_min( 1 ) 
			n.set_z_range_max( scale-1 ) 
			# set the light color emitted by the Light2D acting as a mask to the same color as CanvasModulate, if one
			if has_node(canvasmodulatePath):
				print("color=", get_node(canvasmodulatePath).get_color())
				n.set_color(get_node(canvasmodulatePath).get_color())
			#n.set_z_range_max( scale-1 ) 
	debug_print_z()

func debug_print_z():
	printt("MASKS node Z : ", get_z())
	printt("node", "name", "Z", "Z_range_min", "Z_range_max")
	for n in get_children():
		if (n extends Light2D):
			printt("node", n.get_name(), n.get_z(), n.get_z_range_min(), n.get_z_range_max(), "\n")

func _ready():	
	init_masks()
	#debug_print_z()
	pass


