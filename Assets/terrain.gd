
extends Sprite


export(ImageTexture) var depthFileIT
onready var depthFile = depthFileIT.get_data()

export(float) var nearScale = 0.9
export(float) var farScale = 0.5
var originalScale = farScale + (nearScale-farScale)/2




func get_scale(pos):
	var depthPx = depthFile.get_pixel(pos.x, pos.y)
	return _get_scale_range(depthPx.gray())


func _get_scale_range(r):
	var dr = farScale + (nearScale - farScale) * r
	return Vector2(dr, dr)
	
func get_scale_diff(begin, end):
	#printt("BEGIN", begin, get_scale(begin))
	#printt("END", end, get_scale(end))
	#printt("DIFF", abs((get_scale(begin) - get_scale(end)).x) )
	#print()
	return abs( (get_scale(begin) - get_scale(end)).x)
	
func _ready():
	# bg is now ready, notify actors to rescale them automatically according to their positions
	get_tree().call_group(0, "Actors", "_update_scale")
	
	# TODO : temporary.
	for n in get_node("Masks").get_children():
		if (n extends Light2D):
			var pos2DZ = n.get_node("Position2D").get_pos()
			
			var scale = get_scale( pos2DZ ) / 0.5 * 3.2
			n.set_z_range_min( 1 ) 
			n.set_z_range_max( scale.x-1 ) 
			print ("Obj ", n.get_name(), " = ", scale.x)
		
	pass
