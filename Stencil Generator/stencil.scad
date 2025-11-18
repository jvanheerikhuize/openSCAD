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
	Creation Date:          25/01/25
	Modification Date:      25/01/25
	Email:                  jvanheerikhuize@gmail.com
	Description:            Customizable stencil for open scad
    Dependencies:           none

\*#################################################################################*/


/*#################################################################################*\
    
    CONFIGURATION

\*#################################################################################*/

/* [Object:] */
svg_file = "_skull.svg";
svg_extrusion = 2;

// scale
svg_scale = 1; //[1:0.1:10]

/* [Mold:] */

// mold width
stencil_width = 500; //[10:500]
// mold length
stencil_length = 500; //[10:500]
// mold depth
stencil_depth = 5; //[10:500]

/*#################################################################################*\
    
    START

\*#################################################################################*/

start();


/*#################################################################################*\
    
    MODULES

\*#################################################################################*/


module start (){
	difference (){
		stencil();
		import_svg();
	}
}

module stencil (){
	cube(size = [stencil_width, stencil_length, stencil_depth], center = true);
}


module import_svg (){
	scale(svg_scale){
		linear_extrude(height = stencil_depth + 1, center = true, convexity = 100){
			color("SteelBlue"){
				import(svg_file, center = true);
			}
		}
	}
}
