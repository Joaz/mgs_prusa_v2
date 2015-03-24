class MotorMount < CrystalScad::Printed
	def initialize()
		@motor_gear = Gear.new(module:0.5,teeth:14,height:6)	
		@filament_center = {x:-4.5,y:22.5} # TODO: check if the x-offset here needs to be reduced
		@idler_rotation = {x:90,z:90}
		@idler_position = {x:-30,y:11.5,z:-23}
		@idler = Idler.new
	end

	def part(show)

		drive = DriveShaft.new
		res = cube([63.5-0.1,42,@height=23]).translate(x:-23)

#		res -= cube([30,45,25]).center_x.translate(x:20,y:18+5.5,z:-1)

		# basic idler cutout
		res -= cube([40,25,@height+1]).translate(x:-54,y:13,z:-0.1)
		
		# cutout for the idler bearing
		res -= @idler.output_bearing.rotate(@idler_rotation).translate(x:@idler_position[:x]+2.2,y:@idler_position[:y]+3)
	 # notes: I have no idea where that y offset comes from
	 # That X offset I made to not have a sub 1mm wall on top that would break instantly


#		res -= cube([40,25,@height+1]).translate(x:-48,y:13,z:-0.1)

		res = res.translate(y:-3,z:-23)
		

		res -= drive.output.rotate(x:-90)		
		motor_gear_with_hub = @motor_gear.show
		motor_gear_with_hub += cylinder(h:7,d1:7,d2:10).translate(z:@motor_gear.height)
		
		motor = Nema14.new
		motor_assembly = motor.show
		motor_assembly += motor_gear_with_hub.color("silver").translate(z:45)
		bolts = create_bolts("top",res,motor,bolt_height:8,height:@height)		

		motor_rotation = {y:90,x:90}
		motor_offset = {x:drive.big_gear.distance_to(@motor_gear),y:50+6.5}

		res -= cylinder(d:6,h:30).translate(x:13,y:-13).rotate(motor_rotation).translate(motor_offset).translate(y:-41.5)		
		res -= cylinder(d:6,h:30).translate(x:13,y:13).rotate(motor_rotation).translate(motor_offset).translate(y:-41.5)		
		res -= motor.output.rotate(motor_rotation).translate(motor_offset)
		bolts.each do |bolt| 
			
			res -= bolt.rotate(motor_rotation).translate(motor_offset).translate(y:-19)		
			res += bolt.rotate(motor_rotation).translate(motor_offset).translate(y:-19) if show		
		
		end

	

		# Filament channel		

		res -= cylinder(d:3.3,h:50).translate(@filament_center).translate(z:-30)
		
		# TODO: groovemount holes 
		groovemount_holes = cylinder(d:3.5,h:50).translate(x:25)
		groovemount_holes += cylinder(d:3.5,h:50).translate(x:-25)
		
		# Cutout for J-Head
		res -= cylinder(d:16.5,h:5.5).translate(@filament_center).translate(z:-@height-0.1)





		res += groovemount_holes.rotate(z:-110).translate(@filament_center).translate(z:-@height-5).color("green")
	

		# moved this to the end, so it wouldn't be cut
		if show	
			res += motor_assembly.rotate(motor_rotation).translate(motor_offset)
			res += drive.show.rotate(x:-90)
		#	res += @idler.show.rotate(@idler_rotation).translate(@idler_position)

		end


		res

	end

end	
