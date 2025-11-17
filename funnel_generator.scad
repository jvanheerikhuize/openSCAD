/*#################################################################################*\
 
	 ██░ ██  ▄▄▄       ██▓      █████▒    ▄▄▄▄    ██▀███   ▒█████    ██████      
	▓██░ ██▒▒████▄    ▓██▒    ▓██   ▒    ▓█████▄ ▓██ ▒ ██▒▒██▒  ██▒▒██    ▒      
	▒██▀▀██░▒██  ▀█▄  ▒██░    ▒████ ░    ▒██▒ ▄██▓██ ░▄█ ▒▒██░  ██▒░ ▓██▄        
	░▓█ ░██ ░██▄▄▄▄██ ▒██░    ░▓█▒  ░    ▒██░█▀  ▒██▀▀█▄  ▒██   ██░  ▒   ██▒     
	░▓█▒░██▓ ▓█   ▓██▒░██████▒░▒█░       ░▓█  ▀█▓░██▓ ▒██▒░ ████▓▒░▒██████▒▒ ██▓ 
	 ▒ ░░▒░▒ ▒▒   ▓▒█░░ ▒░▓  ░ ▒ ░       ░▒▓███▀▒░ ▒▓ ░▒▓░░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░ ▒▓▒ 
	 ▒ ░▒░ ░  ▒   ▒▒ ░░ ░ ▒  ░ ░         ▒░▒   ░   ░▒ ░ ▒░  ░ ▒ ▒░ ░ ░▒  ░ ░ ░▒  
	 ░  ░░ ░  ░   ▒     ░ ░    ░ ░        ░    ░   ░░   ░ ░ ░ ░ ▒  ░  ░  ░   ░   
	 ░  ░  ░      ░  ░    ░  ░            ░         ░         ░ ░        ░    ░  
	                                           ░                              ░ 
	-----------------------------------------------------------------------------

	Developed by:			      Jerry van Heerikhuize
	Modified by:            Jerry van Heerikhuize

	-----------------------------------------------------------------------------

	Version:                1.0.1
	Creation Date:          24/10/20
	Modification Date:      24/01/25
	Email:                  jvanheerikhuize@gmail.com
	Description:            Customizable funnel for open scad
  Dependencies:           none

\*#################################################################################*/

/*#################################################################################*\
    
    CONFIGURATION

\*#################################################################################*/

/* [Bowl:] */
bowl_height = 70; //[1:999]
bowl_radius = 50; //[1:999]

/* [Stem:] */
stem_height = 50; //[1:999]
stem_radius_1 = 7; //[1:999]
stem_radius_2 = 7; //[1:999]

/* [Handle 1:] */
handle_1 = true; //[true:false]
handle_1_width = 20;
handle_1_length = 80;

/* [Handle 2:] */
handle_2 = true; //[true:false]
handle_2_width = 20;
handle_2_length = 80;

/* [Extra:] */
thickness = 2;
transition_curve_radius = 20;

/* [Hidden] */
$fa = 1; // minimum angle
$fs = $fa / 10; //minimum size
eps = 0.00001;


go();

module go (){
	if (handle_1){
		handle_1();
	}
	if (handle_2){
		handle_2();
	}
    funnel();
}


module handle_1(){
    translate([-(handle_1_width / 2), bowl_radius - 1, (stem_height + bowl_height) - thickness]){
        cube ([handle_1_width, handle_1_length, thickness], 0);
    }
}


module handle_2(){
    translate([-(handle_1_width / 2), -(bowl_radius - 1) - handle_1_length, (stem_height + bowl_height) - thickness]){
        cube ([handle_1_width, handle_1_length, thickness], 0);
    }
}


module funnel (){
    rotate_extrude(){
        difference() {
            shape();
            translate([thickness, 0]){
                shape();
            }
        }
    }
}


module shape (){
    hull() {
        translate([stem_radius_2, 0]){
            square([thickness, eps]);
        }

        translate([stem_radius_1 + transition_curve_radius, stem_height]){
            circle(r = transition_curve_radius);
        }

        translate([bowl_radius, stem_height + bowl_height - eps]){
            square([thickness, eps]);
        }
    } 
}
