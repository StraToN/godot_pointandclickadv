
extends Sprite


export(ImageTexture) var depthFileIT
var depthFile

export(float) var nearScale
export(float) var farScale
export(int) var nbZScales = 10
onready var originalScale = farScale + (nearScale-farScale)/2

# return a Z value between 1 and nbZScales
# corresponding to pos position in the image
func get_z_at_px(pos):
	if (depthFile == null && depthFileIT != null):
		depthFile = depthFileIT.get_data()
	var depthPx = depthFile.get_pixel(pos.x, pos.y).gray() # 0 < depthPx < 1
	#printt("pixel val = ", depthPx, "Z = ", int(depthPx * nbZScales + 1))
	return int(depthPx * nbZScales + 1) # 1 < z < nbZScales

func get_scale(pos):
	if (depthFile == null && depthFileIT != null):
		depthFile = depthFileIT.get_data()
	var depthPx = depthFile.get_pixel(pos.x, pos.y).gray()
	return _get_scale_range(depthPx)


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
	get_tree().call_group(0, "Actors", "_update_scale", null)
	get_tree().call_group(0, "Actors", "_update_z")
	
	get_node("Masks").init_masks()
		
	pass
