extends Label

var bgZ
var masksZ
var mask_deskZ
var lightsZ
var canvasModZ=""

func _ready():
	set_process(true)

func _process(delta):
	bgZ = str( get_parent().get_z() )
	masksZ = str( get_parent().get_node("Masks").get_z() )
	mask_deskZ = str( get_parent().get_node("Masks/mask_desk").get_z() )
	lightsZ = str( get_parent().get_node("Lights").get_z() )
	#canvasModZ = str( get_parent().get_node("Lights/CanvasModulate").get_z() )
	set_text("bgZ "+bgZ+"\nmasksZ "+masksZ+"\nmask_deskZ "+mask_deskZ+"\nlightsZ "+lightsZ+"\ncanvasModZ "+canvasModZ)