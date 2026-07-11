inner_content_dims = [6.5, 4.5, 8.5];
inner_padding = 0.25;
frame_thick = 1;
tab_thick = 1/4;

inner_dims = ([inner_padding, inner_padding, inner_padding] * 2) + inner_content_dims;
echo (inner_dims);

module bottom_x_frame() {
    outer_x = inner_dims[0] + frame_thick * 2;
    intersection() {
        cube([outer_x, frame_thick, frame_thick]);
        translate([outer_x / 2, outer_x / 2, -1])        
        rotate([0, 0, 45 + 180])
            cube([100, 100, 100]);
        
        translate([outer_x / 2, -1, outer_x / 2])
        rotate([0, 180 - 45, 0])
            cube([100, 100, 100]);
    }
}

module bottom_y_frame() {
    outer_y = inner_dims[2] + frame_thick * 2;
    intersection() {
        cube([frame_thick, outer_y, frame_thick]);
        translate([outer_y / 2, outer_y / 2, -1])        
        rotate([0, 0, -45 + 180])
            cube([100, 100, 100]);
        
        translate([-1, outer_y / 2, outer_y / 2])
        rotate([45 + 180, 0, 0])
            cube([100, 100, 100]);
        
    }
}

module side_frame() {
    outer_z = inner_dims[1] + frame_thick * 2;
    cube([frame_thick, frame_thick, outer_z]);
}

module bottom() {
    difference() {
    union() {
    bottom_x_frame();
    
    bottom_y_frame();
    
    translate([inner_dims[0] + frame_thick * 2, inner_dims[2] + frame_thick * 2, 0])
        rotate([0, 0, 180])
            bottom_x_frame();
    translate([inner_dims[0] + frame_thick * 2, inner_dims[2] + frame_thick * 2, 0])
        rotate([0, 0, 180])
           bottom_y_frame();
    }
    
    translate([frame_thick - tab_thick, frame_thick - tab_thick, tab_thick])
        cube([inner_dims[0] + 2 * tab_thick, inner_dims[2] + 2 * tab_thick, tab_thick]);
    }
}

bottom();
side_frame();
