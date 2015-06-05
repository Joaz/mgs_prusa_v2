class MotorMount < CrystalScad::Printed
	def initialize()
		@motor_gear = Gear.new(module:0.5,teeth:14,height:6)	


		@idler_rotation = {x:90,z:90}
		@idler_position = {x:-30,y:11.5,z:-23}
		@idler = Idler.new
		@idler_release = IdlerRelease.new

		@x_offset = 23
		@y_offset = 1
		@drive = DriveShaft.new.rotate(x:-90).translate(x:@x_offset,y:@y_offset)
		@motor_gear_with_hub = @motor_gear.show
		@motor_gear_with_hub += cylinder(h:7,d1:7,d2:10).translate(z:@motor_gear.height)
		
		@motor = Nema14.new(output_shaft:cylinder(d:15,h:25)).rotate(y:90,x:90).translate(x:@drive.big_gear.distance_to(@motor_gear)+@x_offset,y:50+6.5)


		
		@x = 63.4
		@y = 42
		@height=23	


		@filament_position_x = @drive.filament_position_x + @x_offset
		@filament_position_y = @drive.filament_position_y + @y_offset

		@color = "LightBlue"
			

	end

	def half_part(show)
		res = cube([@x,@y,@height]).translate(z:-@height)
		res -= @motor.output
		res -= @drive.output


		res
	end

	def half_part_old(show,color=nil)
			
		# Basic body, one half of
		res = cube([63.5-0.1,42,@height]).translate(x:-23,y:-3)

		# basic idler cutout
		res -= cube([40,25,@height+1]).translate(x:-54,y:10,z:-0.1)
		
		# cutout for the idler bearing
		res -= @idler.output_bearing.rotate(@idler_rotation).translate(x:@idler_position[:x]+2.2,y:@idler_position[:y])
		# That X offset I made to not have a sub 1mm wall on top that would break instantly

		# position the body below z
		res = res.translate(z:-23)
		
		# make a cut for the whole drive shaft
		res -= @drive.output.rotate(x:-90)		

		# Cutout for the motor
		res -= @motor.output.rotate(@motor_rotation).translate(@motor_offset)




		# Extra cutout for making the motor bolts accessable
		res -= cylinder(d:6,h:30).translate(x:13,y:-13).rotate(@motor_rotation).translate(@motor_offset).translate(y:-41.5)		
		res -= cylinder(d:6,h:30).translate(x:13,y:13).rotate(@motor_rotation).translate(@motor_offset).translate(y:-41.5)		
		
		# Giving it color
		if color
			res = res.color(color)
		end	
	
		# Bolts for mounting the motor
	
		if @motor_bolts == nil # don't make the bolts twice, if this method called twice	
			@motor_bolts = create_bolts("top",res,@motor,bolt_height:80,height:@height)				
		end
		@motor_bolts.each do |bolt| 	
			res -= bolt.output.rotate(@motor_rotation).translate(@motor_offset).translate(y:-19)		
			#res += bolt.show.rotate(@motor_rotation).translate(@motor_offset).translate(y:-19) if show		
		end
	


		# TODO: groovemount holes 
		groovemount_holes = cylinder(d:3.5,h:50).translate(x:25)
		groovemount_holes += cylinder(d:3.5,h:50).translate(x:-25)
		
		# will move the cutout for J-Head to a seperate plate, makes it easier to finish the goal of a removable
		# filament guide
		#		res -= cylinder(d:16.5,h:5.5).translate(@filament_center).translate(z:-@height-0.1)

		#	res += groovemount_holes.rotate(z:-110).translate(@filament_center).translate(z:-@height-5).color("green") if show
	


		res
	end

	def part(show)

		lower = half_part(show)
#		upper = half_part(show)
		
#		n = Nut.new(4)
#		upper += n.show.rotate(@idler_rotation).translate(@idler_position)	
		res = lower

		res =	colorize(res)

		if show	
			#res = lower.translate(z:-@height)
			#res += upper.translate(z:@height)
			res += @motor.show
			res += @drive.show
			#res += @idler.show.rotate(@idler_rotation).translate(@idler_position)
			#res += @idler_release.show.rotate(@idler_rotation).translate(@idler_position).translate(x:-7,y:11,z:40)
		end
		res
	end

end	
