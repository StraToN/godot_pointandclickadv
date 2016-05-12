
extends Sprite


export(ImageTexture) var depthFileIT
onready var depthFile = depthFileIT.get_data()

export(float) var nearScale = 0.9
export(float) var farScale = 0.5
var originalScale = farScale + (nearScale-farScale)/2

func update_shader(actor_feet_pos):
	pass


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
	# bg is now ready, notify actors
	get_tree().call_group(0, "Actors", "_update_scale")
	
	
	for n in get_node("Masks").get_children():
		var height = n.get_item_rect().size
		var scale = get_scale( Vector2(n.get_pos().x, n.get_pos().y + height.y ) ) / 0.5 * 1.9
		n.set_z( scale.x ) 
		print ("Obj ", n.get_name(), " = ", scale.x)
		
	pass
