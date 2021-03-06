class DriveShaft < CrystalScad::Assembly

	def initialize()
		@diameter = 5 # That is not going to change any time soon
		
		@length = 35	
		@big_gear = Gear.new(module:0.5,teeth:80,height:4,hub_height:4,hub_dia:20)
		@filament_diameter = 3.3
		@filament_position_x = -4
		@filament_position_y = 22.5
		@filament_height = 100 # for cut
	end

	def part(show)
		res = cylinder(d:@diameter,h:@length).color("silver")		
		
		unless show
			# scale 1.8 results in 9mm dia and should both do nicely to give a nice cut for the m115 bearing exit
			# eventually also a din912 screw as drive rod, but DIN913 should do
			res = res.scale([1.8,1.8,1.05]).translate(z:-1)  
			res += cylinder(d:13.5,h:2).translate(z:-1)
		end		

		# Bearing. For now I'm putting in 625 in there, might change to F625 or smaller variants.
		b = Bearing.new(type:"625")
		bearing = b.show		
		unless show
			bearing = b.output.scale([1.075,1.075,1.4])
		end		
		res+= bearing

		# Bottom washer. This is necesary in order to have the bottom bearing spin freely
		washer = Washer.new(5.3).show		
		# output must 		
		unless show
			washer = washer.scale([1.2,1.2,1])
		end		
		res += washer.translate(z:z=5)

		big_gear = @big_gear.show
		unless show
			big_gear.scale([1.075,1.075,1.25]).translate(z:-0.5)
		end		
		res += big_gear.translate(z:z+=1)

		# Filament drive gear, hardcoded as the small one from RRD for the moment
		if show
			filament_gear = cylinder(d:8,h:3)
			filament_gear += cylinder(d1:8,d2:6.2,h:1.5).translate(z:3)
			filament_gear += cylinder(d1:6.2,d2:8,h:1.5).translate(z:4.5)
			filament_gear += cylinder(d:8,h:7).translate(z:6)		
			filament_gear.color("Brass")
		else
			filament_gear += cylinder(d:9,h:11+2).translate(z:-1)
			res += cylinder(d:@filament_diameter,h:@filament_height).color("Gainsboro").rotate(x:-90).translate(x:@filament_position_x,y:-@filament_height/2.0,z:@filament_position_y)
		end		


		
		res += filament_gear.mirror(z:1).translate(z:13+z+=8).color("Orange")

		# adding a metal distance bolt to the shaft, for having more space between the filament hole and the bearing. 
		# Plan is to make the filament guide exchangable. While the exchangable part could host the bearing slot,
		# I fear that this could skew the axis if the printing tolerances are not right.
		
		res += cylinder(d:8,h:5).color("Gainsboro").translate(z:8+z+=5)
	 


		# Top Bearing. Using more expensive type MR105 here in order to have enough clearance of the motor
		b = Bearing.new(type:"mr105")
		bearing = b.show		
		unless show
			bearing = b.output.scale([1.075,1.075,1.0])
		end		
		res+= bearing.translate(z:z+=13).color("DarkGray")
		
		# That top bearing leaves a very tiny wall towards the motor
		# which I am eliminating here.
		res += cube([20,2.5+0.1,4]).translate(y:-0.1,z:z) unless show

		res
	end

end	
