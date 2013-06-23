// (c) 2013 by Joachim Glauche
// Dual Licensed under the GPLv3 and the TAPR Open Hardware License


include <nema_motor.scad>

$fn=64;
gear_module = 0.5;

motor_gear_teeth = 14;
motor_gear_mounting_part_length=7;
motor_gear_mounting_part_dia = 10;
motor_gear_gear_length=6;

driven_gear_teeth=60;
driven_gear_length=4;
driven_gear_hub_length=4;
driven_gear_hub_dia = 20;
driven_shaft_length=40;

drive_offset=-7.5;
shafts_distance=(gear_module*(driven_gear_teeth+motor_gear_teeth))/2;
// not sure yet why neeeded
motor_extra_offset = 0.5;

motor_height=38.2;
motor_OD=35;



module drive_assembly(){

	rotate(a=90,v=[0,1,0]){
		
		translate([-shafts_distance/2-drive_offset,0,-(motor_height)/2]) nema14();
		translate([-shafts_distance/2-drive_offset,0,5.5]) translate([0,0,-5]) rotate(a=0,v=[1,0,0]) motor_gear();

		translate([shafts_distance/2-drive_offset,0,-4])driven_gear();
	}
}


module mgs_v2(){
    union(){
        motor_part();
        side_part();
    }

}
mgs_v2();
translate([0,-36,-33]) idler();

%drive_assembly();

%idler_assembly();


module idler_assembly(){
    
    translate([18,5,2]) {
        rotate([180,0,0]) idler();   
    
    }
    

}

module idler(){
    difference(){
       union(){
             cube([18,10,6]);
             hull(){
                cube([10.5,10,6]);      
                translate([-4,-5,0]) cube([12,20,6]);
             }
             translate([11,0,0]) cube([7,10,10]);
        }
        // 10mm m5 grub screw + mr115 bearing (oversized fitting)
        #translate([0,5,6]) rotate([0,90,0]){
            translate([0,0,0.3]) cylinder(r=2.6,h=10.5);
            translate([0,0,4]) cylinder(r=12.0/2,h=4.5);
        }
        // hinge hole
        translate([14.5,20,6.5]) rotate([90,0,0]){
            cylinder(r=1.75,h=30);
        }
        
        // tensioner holes
        
        translate([1,-2,-0.1]) cylinder(r=2.2,h=10);
        translate([1,12,-0.1]) cylinder(r=2.2,h=10);
        
        // motor shaft cutout
        translate([-5.5,1.5,-0.1]) cube([5,7,10]);
        
    }

}


module motor_part(){

	difference(){
		translate([-4,-20,-33]) cube([11,40,53]);
		translate([-5.9,0,2+motor_extra_offset]) rotate([0,90,0]) motor_holes(13);
        
        // extra hole for inserting a 1,5mm hex from the top to tighten the motor gear 
        translate([2,30,2]) rotate([90,0,0]) cylinder(r=2,h=25);
		
		
		// bearing near the motor
		translate([3-0.1,0,-shafts_distance+2]) rotate([0,90,0]) long_slot(r=5.6,h=4.2, h2=15);
	//	%translate([3-0.1,0,-shafts_distance+2]) rotate([0,90,0]) cylinder(r=5.6,h=4.2);
		// allow the bearing to move freely behind
		translate([-10,0,-shafts_distance+2]) rotate([0,90,0]) long_slot(r=4.5,h=20, h2=15);
        // fix for overhang 
        translate([-10,0,-shafts_distance+2+5]) rotate([0,90,0]) long_slot(r=5.6,h=14.1,h2=15); 
      

        // bearing fixation hole
        //translate([3.5,21,-9.8]) rotate([90,0,0]) cylinder(r=3.1/2,h=42);
        
        //translate([3.5,-17.5,-9.8]) rotate([90,30,0]) cylinder(r=6.8/2,h=6,$fn=6);
        // need to use DIN 7984 to not look out of the model
        //translate([3.5,20.1,-9.8]) rotate([90,30,0]) cylinder(r=5.6/2,h=2.1);
        			
	}


}

module side_part(){
	difference(){
		union(){		
			translate([6,-20,-33]) cube([30,40,6]);
			//translate([6,-20,-33]) cube([7.5,40,15]);
			// filament channel block
		//	#translate([19,-10,-33]) cube([15,18,12]);
			
			// bearing holder
			translate([29,-13,-33]) cube([7,26,38]);
			
		}
		translate([0,0,-shafts_distance+2]) rotate([0,90,0]) cylinder(r=((driven_gear_teeth+0)*gear_module)/2+1,h=driven_gear_hub_length+12);
		
        // filament channel
//        translate([24.5,4.3,-50]) cylinder(r=filament_OD/2,h=100);
//          translate([24.5,4.3,-22.5]) cylinder(r1=filament_OD/2,r2=filament_OD/2+1,h=2);
        
        
        // bearing slot
        translate([29-0.1-1,0,-shafts_distance+2]) rotate([0,90,0]) long_slot(r=5.6,h=4.1+1,h2=30); 
        translate([26.5,0,-shafts_distance+2]) rotate([0,90,0]) long_slot(r=4.5,h=10,h2=30); 
        // fix for impossible overhang because of the hole
        translate([32.5,0,-shafts_distance+2+5]) rotate([0,90,0]) long_slot(r=5.6,h=4.1,h2=30); 
        
        // bearing fixation hole
        // #translate([32,15,-9.4]) rotate([90,0,0]) cylinder(r=3.05/2,h=30);
        // actually, instead of the bearing fixation bolt, we put a hinge for the idler there 
        // and let the idler bearing push the bolt downward. In operation, the bearing cannot go up.
       
	// slide in shaft trap for the idler
	translate([32.5,10,-7]) rotate([90,90,0]) long_slot(r=1.90,h=21,h2=8);
	translate([32.5,-4,-2]) rotate([90,90,0]) long_slot(r=1.90,h=10,h2=2);

	// make a 1.5mm hole to be able to push it out again if it doesn't want to go out by gravity
	translate([32.5,14,1]) rotate([90,0,0]) long_slot(r=0.75,h=5);

           
	// shaft = either 3mm x 20mm shaft or m3x20 grub     
	// %translate([32.5,9,-7]) rotate([90,0,0]) cylinder(r=1.75,h=20);
        
        
        // idler tensioner cut
        translate([19,7,-40]) cylinder(r=2.2,h=20);
        translate([19,-7,-40]) cylinder(r=2.2,h=20);
        
        
        
	}
}


module motor_holes(thickness){
	union(){
		cylinder(r=22.5/2,h=thickness);		
		// motor mounting holes		
		translate([13,13,0]) cylinder(r=1.8,h=thickness); 	
		translate([13,13,6]) cylinder(r=4,h=thickness-3); 	
		
		translate([13,-13,0]) cylinder(r=1.8,h=thickness); 	
		translate([13,-13,6]) cylinder(r=4,h=thickness-3); 	
				
		translate([-13,13,0]) cylinder(r=1.8,h=thickness); 	
		translate([-13,13,6]) cylinder(r=3.1,h=thickness-3); 	
		
		translate([-13,-13,0]) cylinder(r=1.8,h=thickness); 	
		translate([-13,-13,6]) cylinder(r=3.1,h=thickness-3); 	
		
	}
	
}


module long_slot(r, h, h2){
    hull(){
       cylinder(r=r,h=h);
        translate([-h2,0,0]) cylinder(r=r,h=h);
    }
}



module motor_gear(){
	color(Stainless)cylinder(r1=motor_gear_mounting_part_dia/2,r2=(gear_module*motor_gear_teeth+1)/2,h=motor_gear_mounting_part_length);
	translate([0,0,motor_gear_mounting_part_length])color(Steel)cylinder(r=(gear_module*motor_gear_teeth)/2,h=motor_gear_gear_length);
}

module driven_gear(){
	translate(v=[0,0,37]) rotate(a=180,v=[1,0,0]) driven_shaft();
	translate([0,0,7])bearing_mr115();
	translate([0,0,7+4])color(Silver)cylinder(r=10.0/2,h=1);// 1mm scheibe
	translate([0,0,12])big_gear();
	translate([0,0,12]) translate(v=[0,0,8]) filament_gear();

	translate([0,0,33])bearing_mr115();
}

//driven gear:
module big_gear(){
	color(Steel)cylinder(r=(gear_module*driven_gear_teeth)/2,h=driven_gear_length);
	translate([0,0,driven_gear_length])color(Stainless)cylinder(r=driven_gear_hub_dia/2,h=driven_gear_hub_length);
}

module filament_gear(){
    // FIXME: currently unparametric
	//color(Steel) cylinder(r=4,h=13);
	translate([0,0,13]) rotate([180,0,0]) color(Brass){
	     cylinder(r=4,h=3);
	     translate([0,0,3]) cylinder(r1=4,r2=3.1,h=1.5);
	     translate([0,0,4.5]) cylinder(r1=3.1,r2=4,h=1.5);
	     translate([0,0,6]) cylinder(r=4,h=7);
	     
	}
	

}

module driven_shaft(){
	translate([0,0,0])color(BlackPaint)cylinder(r=2.5,h=30);
}


module bearing_mr115(){
    difference(){
        color("lightgrey")cylinder(r=11.0/2, h=4);
        translate([0,0,-0.1]) cylinder(r=2.5,h=5);       
    }

}








// unused code for the moment


// without head, measurements for j-head mk-v
module hotend(){
    union(){
        cylinder(r=6, h=40);
        cylinder(r=8, h=5);
        translate([0,0,10]) cylinder(r=8, h=30);    
    }
}
 
module fan_40mm(){
    union(){
       difference(){
           cube([40,40,10]);
       //    translate([20,20,-1]) cylinder(r=19,h=22);
       }
       // holes for bolts. make them male to be able to substract later
       translate([4,4,-1]) cylinder(r=1.4,h=22); 
       translate([4,4+32,-1]) cylinder(r=1.4,h=22); 
       translate([4+32,4,-1]) cylinder(r=1.4,h=22); 
       translate([4+32,4+32,-1]) cylinder(r=1.4,h=22); 

   }

}

