class Idler < CrystalScad::Assembly
	def initialize(args={})
		super(args)
	end	
	
	def show
	  part(true)
	end
	
	def output
	  part(false)
	end
	
	def part(show)
		spring_length=9.4 # compressed length
		res = cube([@x=22,@y=50,@height=15])
		
		# hinge
		hinge_length = 14.4
		res -= cube([hinge_length,12,@height+1]).translate(x:(x-hinge_length)/2.0,y:-0.1,z:-0.1).color("blue")


		# idler bearing
		bearing = Bearing.new(type:"608",margin_diameter:2.0,output_margin_height:margin=0.5)

		bearing_pos = {x:@x/2.0-bearing.height/2.0-margin/2.0,y:23,z:13}		
		res -= bearing.output.rotate(y:90).translate(bearing_pos)
		
		# idler bearing axis
		res -= long_slot(d:8.25,l:20.5,h:20).rotate(y:-90).translate(bearing_pos).translate(x:13.5).color("red")
		
		res += bearing.show.rotate(y:90).translate(bearing_pos).translate(x:margin/2.0) if show

		# idler bolt holes
		res -= long_slot(d:4.4,l:10,h:20).rotate(z:-90).translate(x:5,y:@y,z:-0.1).color("red")
		res -= long_slot(d:4.4,l:10,h:20).rotate(z:-90).translate(x:17,y:@y,z:-0.1).color("red")
		

    res
	end
	
end
