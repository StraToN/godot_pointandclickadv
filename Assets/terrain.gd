
extends Sprite


export(Image) var depthFile
export(float) var nearScale = 1.0
export(float) var farScale = 0.5
var originalScale = farScale + (nearScale-farScale)/2

func get_scale(pos):
	var depthPx = depthFile.get_pixel(pos.x, pos.y)
	return _get_scale_range(depthPx.gray())
	
func _get_scale_range(r):
	var dr = farScale + (nearScale - farScale) * r
	return Vector2(dr, dr)
	
func get_scale_diff(begin, end):
	printt("BEGIN", begin, get_scale(begin))
	printt("END", end, get_scale(end))
	printt("DIFF", abs((get_scale(begin) - get_scale(end)).x) )
	print()
	return abs( (get_scale(begin) - get_scale(end)).x)
	
func _ready():
	# Initialization here
	
	pass


