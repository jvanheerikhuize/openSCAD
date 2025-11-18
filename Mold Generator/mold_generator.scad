/*#################################################################################*\
	   _____ _______ _______      ______ _______ __  __ _______ _______ 
	 _|     |    ___|_     _|    |   __ \   _   |  |/  |    ___|_     _|
	|       |    ___| |   |      |      <       |     <|    ___| |   |  
	|_______|_______| |___|      |___|__|___|___|__|\__|_______| |___|  

  -----------------------------------------------------------------------------

	Developed by:			Jerry van Heerikhuize
	Modified by:            Jerry van Heerikhuize

	-----------------------------------------------------------------------------

	Version:                1.0.0
	Creation Date:          28/11/20
	Modification Date:      30/11/20
	Email:                  jvanheerikhuize@gmail.com
	Description:            Customizable mold for open scad
    Dependencies:           none

\*#################################################################################*/


/*#################################################################################*\
    
    CONFIGURATION

\*#################################################################################*/

/* [Object:] */

// object file
object_file = "_skull.stl";

// scale
object_scale = 1; //[0.01:0.01:2]

// preview
object_preview = true; //[true:false]


/* [Object Rotation:] */

// x rotation
object_rotation_x = 0; //[-180:180]
// y rotation
object_rotation_y = -90; //[-180:180]
// z rotation
object_rotation_z = 0; //[-180:180]


/* [Object Translation:] */

// x translate
object_translate_x = 25; //[-100:100]
// y translate
object_translate_y = 0; //[-100:100]
// z translate
object_translate_z = 0; //[-100:100]


/* [Mold:] */

// mold width
mold_width = 75; //[10:500]
// mold length
mold_length = 70; //[10:500]
// mold depth
mold_depth = 23; //[10:500]

// mold placement gap
mold_placement_gap = 10; //[10:100]


/* [Pouring hole:] */

// pouring hole radius 1
pouring_hole_r1 = 4; //[1:100]
// pouring hole radius 2
pouring_hole_r2 = 3; //[1:100]


/* [Pouring hole translation:] */

// x translate
pouring_hole_translate_x = 0; //[-100:100]
// y translate
pouring_hole_translate_y = 0; //[-100:100]
// z translate
pouring_hole_translate_z = 0; //[-100:100]


/* [Registration marks:] */
registration_marks_size = 7; //[3:20]
registration_marks_margin = 3; //[0:10]

/*#################################################################################*\
    
    START

\*#################################################################################*/

mold_a();
mold_b();



/*#################################################################################*\
    
    MODULES

\*#################################################################################*/

module mold_part (){
    cube(size = [mold_width, mold_length, mold_depth], center = true);
}


module mold_a (){
    translate ([-((mold_width / 2) + (mold_placement_gap / 2)), 0, 0]){
        difference (){
            union(){
                mold_part ();
                registration_mark_a_pos ();
            }
    
            registration_mark_a_neg ();
        
            translate ([-(mold_width / 4), 0, (mold_depth / 2)]){
                rotate ([0, 90, 0]){
                    pouring_hole ();
                }
            }
        
            translate ([0, 0, (mold_depth / 2)]){
                rotate ([0, 0, 0]){
                    import_object_file(object_file);
                }
            }
        }
        
        if (object_preview){
            translate ([0, 0, (mold_depth / 2)]){
                rotate ([0, 0, 0]){
                    import_object_file(object_file, preview = true);
                }
            }
        }
    }
}


module mold_b (){
    translate ([((mold_width / 2) + (mold_placement_gap / 2)), 0, 0]){
        
        mirror ([180, 0, 0]){
    
            difference (){
                union(){
                    mold_part ();
                    registration_mark_b_pos ();
                }
    
                registration_mark_b_neg ();
        
                translate ([-(mold_width / 4), 0, (mold_depth / 2)]){
                    rotate ([0, 90, 0]){
                        pouring_hole ();
                    }
                }
        
                translate ([0, 0, (mold_depth / 2)]){
                    rotate ([0, 180, 0]){
                        import_object_file(object_file, true);
                    }
                }
            }
            
            if (object_preview){
                translate ([0, 0, (mold_depth / 2)]){
                    rotate ([0, 180, 0]){
                        import_object_file(object_file, true, preview = true);
                    }
                }
            }
        }
    }
}


module pouring_hole (){
    translate ([pouring_hole_translate_x, pouring_hole_translate_y, pouring_hole_translate_z]){
        color("#CCCCFF"){
            cylinder(h = mold_width / 2, r1 = pouring_hole_r1, r2 = pouring_hole_r2, center = true);
        }
    }
}


module registration_mark_a_pos (){
    translate ([-(mold_width / 2) + ((registration_marks_size / 2) + registration_marks_margin), (mold_length / 2) - (registration_marks_size / 2) - registration_marks_margin, (mold_depth / 2)]){
        registration_mark();  
    }
}


module registration_mark_a_neg (){
    translate ([(mold_width / 2) - ((registration_marks_size / 2) + registration_marks_margin), -(mold_length / 2) + (registration_marks_size / 2) + registration_marks_margin, (mold_depth / 2)]){
        registration_mark();  
    }
}

module registration_mark_b_pos (){
    translate ([(mold_width / 2) - ((registration_marks_size / 2) + registration_marks_margin), -(mold_length / 2) + (registration_marks_size / 2) + registration_marks_margin, (mold_depth / 2)]){
        registration_mark();  
    }
}

module registration_mark_b_neg (){
    translate ([-(mold_width / 2) +((registration_marks_size / 2) + registration_marks_margin), (mold_length / 2) - (registration_marks_size / 2) - registration_marks_margin, (mold_depth / 2)]){
        registration_mark();  
    }
}

module registration_mark(positive = false){
    color("#333333"){
        if (positive){
            sphere (d = registration_marks_size);
        } else {
            sphere (d = registration_marks_size - 0.1);
        }
    }
}


module import_object_file (file, mirror = false, preview = false){

    if (mirror){
        scale(object_scale){
            translate([-object_translate_x, object_translate_y, object_translate_z]){
                rotate([object_rotation_x, -object_rotation_y, -object_rotation_z]){
                    color("SteelBlue"){
                        if (preview){
                            %#import(file);
                        } else {
                            import(file);
                        }
                    }
                }
            }    
        }
    } else {
        scale(object_scale){
            translate([object_translate_x, object_translate_y, object_translate_z]){
                rotate([object_rotation_x, object_rotation_y, object_rotation_z]){
                    color("Lime"){
                        if (preview){
                            %#import(file);
                        } else {
                            import(file);                        
                        }
                    }
                }
            }    
        }
    }
}
