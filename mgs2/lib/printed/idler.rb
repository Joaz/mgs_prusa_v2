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
		spring_length=9.4 # desired compressed length
		idler= cube([20,12+spring_length,16])
		
		bearing = Bearing.new(type:"608",margin_diameter:1.5,margin:0.5)
		idler -= bearing.output.translate(x:10,z:6)
		idler += bearing.show.translate(x:10,z:6) if show
		
		idler -= cylinder(d:8.1, h:16).translate(x:10,z:0)
    
    idler += cylinder(d:8, h:16).translate(x:10,z:0).color("Silver") if show
    
    # spring holes
    idler -= cylinder(d:7,h:20).rotate(x:90).translate(x:5,y:32.1,z:9.5)
    idler -= cylinder(d:7,h:20).rotate(x:90).translate(x:15,y:32.1,z:9.5)
    
    idler
	end
	
end
