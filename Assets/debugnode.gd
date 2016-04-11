
extends Node2D


var color = Color("FEDE0D")
var points = null

func draw_points(points):
	self.points = points
	update() # updates the state of this node, _draw() gets called

func _draw():
	if points != null:
		for i in range(0, points.size()): # loop over the points
			draw_circle(points[i], 10.0, color) # draw circle
			if i > 0:
				draw_line(points[i-1], points[i], color) # draw lines
				print("DRAWING")



