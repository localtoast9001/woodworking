// Copyright (c) Jon Rowlett. All rights reserved.
// Licensed under the MIT ya know. Blah.

// X-axis = Width
// Y-axis = Depth
// Z-axis = Height

top_width = 24;
top_depth = 17;
top_thick = 1;
top_lip = 1;
total_height = 28;
leg_thick = 1 + 3/4;
leg_height = total_height - top_thick;
foot_thick = 1 + 1/4;
leg_taper_height = 5;
shelf_thick = 3/4;
top_compartment_height = 4 + 1/4;
panel_thick = 3/4;
bottom_compartment_height = 7 + 1/2;
side_panel_overhang = (2 - shelf_thick) / 2;
bottom_compartment_bottom = leg_taper_height + side_panel_overhang;
echo(bottom_compartment_bottom);
slat_thick = 1/4;
slat_width = 1;
slat_spacing = 1;
slat_count = 3;
side_depth = top_depth - 2 * (top_lip + leg_thick);
side_width = top_width - 2 * (top_lip + leg_thick);

module slat() {
    slat_height = leg_height
        - top_compartment_height
        - shelf_thick
        - bottom_compartment_bottom
        - bottom_compartment_height
        - shelf_thick
        - shelf_thick
        - side_panel_overhang;
    cube([
        slat_thick,
        slat_width,
        slat_height
    ]);
}

module slat_array(width) {
    array_width = slat_count * (slat_width + slat_spacing) - slat_spacing;
    array_offset = (width - array_width) / 2;
    panel_offset = (panel_thick - slat_thick) / 2;
    for(i = [0:slat_count - 1]) {
        translate([
            panel_offset,
            array_offset + i * (slat_width + slat_spacing), 
            0])
            slat();
    }
}

module inner_leg() {
    offset = (leg_thick - foot_thick) / 2;
    angle = atan(leg_taper_height / offset);
    difference() {
        cube([leg_thick, leg_thick, leg_height]);
        
        // inside taper
        rotate([-90+angle, 0, 0])
            translate([-1, leg_thick - offset, 0])
                cube([6, 6, 6]);
        rotate([0, 90-angle, 0])
            translate([leg_thick - offset, -1, 0])
                cube([6, 6, 6]);
        
        // outside taper
        translate([-1, offset, 0])
            rotate([180-angle, 0, 0])
                cube([6, 6, 6]);
        translate([offset, -1, 0])
            rotate([0, 180+angle, 0])
                cube([6, 6, 6]);
    }
}

module leg() {
    translate([top_lip, top_lip, 0])
    inner_leg();
}

module side_panel() {
    offset = top_lip + (leg_thick - panel_thick)/2;
    translate([offset, top_lip + leg_thick, leg_height - top_compartment_height - shelf_thick])
        cube([panel_thick, top_depth - 2 * (top_lip + leg_thick), top_compartment_height + shelf_thick]);
}

module side_slats() {
    offset = top_lip + (leg_thick - panel_thick)/2;
    width = side_depth;
    translate([
        offset,
        top_lip + leg_thick,
        bottom_compartment_bottom - side_panel_overhang + bottom_compartment_height + 2 * (shelf_thick + side_panel_overhang)])
        slat_array(width);
}

module bottom_side_panel() {
    offset = top_lip + (leg_thick - panel_thick)/2;
    translate([
        offset,
        top_lip + leg_thick, 
        bottom_compartment_bottom - side_panel_overhang])
        cube([
            panel_thick, 
            side_depth, 
            bottom_compartment_height + 2 * (shelf_thick + side_panel_overhang)]);   
}

module intermediate_shelf() {
    side_offset = (leg_thick - panel_thick)/2 + top_lip;
    front_offset = top_lip + panel_thick;
    translate([
        side_offset + panel_thick, 
        front_offset, 
        0])
    cube([
        top_width - 2 * (side_offset + panel_thick), 
        top_depth - 2 * front_offset, 
        shelf_thick]);
}

module drawer(height) {
    side_thick = 1/2;
    bottom_thick = 1/4;
    top_lip = 1/2;
    bottom_lip = side_thick /2;
    drawer_depth = side_depth + panel_thick;
    inner_height = height - top_lip;
    
    // face
    cube([
        side_width, 
        panel_thick, 
        height]);
    
    // handle
    translate([side_width /2, -1, height /2])
    rotate([-90, 0, 0])
    cylinder(h = 1, r = 3/4);
    
    difference() {
        union() {
    // back
    translate([
        side_thick,
        drawer_depth + panel_thick - side_thick,
        0,
        ])
    cube([
        side_width - 2 * side_thick, 
        side_thick, 
        inner_height]);
        
    // inside front
    translate([
        side_thick,
        panel_thick,
        0])
    cube([
        side_width - 2 * side_thick, 
        side_thick, 
        inner_height]);
    
    // sides
    translate([
        0,
        panel_thick,
        0])
    cube([
        side_thick,
        drawer_depth,
        inner_height]);
    translate([
        side_width - side_thick,
        panel_thick,
        0])
    cube([
        side_thick,
        drawer_depth,
        inner_height]);
    }

    // bottom (cutout)
    translate([
        bottom_lip,
        panel_thick + bottom_lip,
        bottom_lip])
    cube([
        side_width - 2 * bottom_lip,
        drawer_depth - 2 * bottom_lip,
        bottom_thick]);
}

    // bottom
    translate([
        bottom_lip,
        panel_thick + bottom_lip,
        bottom_lip])
    cube([
        side_width - 2 * bottom_lip,
        drawer_depth - 2 * bottom_lip,
        bottom_thick]);
}

module nightstand() {
    // legs
    leg();

    translate([top_width, 0, 0])
    rotate([0, 0, 90])
    leg();

    translate([0, top_depth, 0])
    rotate([0, 0, -90])
    leg();

    translate([top_width, top_depth, 0])
    rotate([0, 0, 180])
    leg();

    // top.
    translate([0, 0, leg_height])
    cube([top_width, top_depth, top_thick]);
    
    // top sides
    side_panel();
    translate([top_width, top_depth, 0])
        rotate([0, 0, 180])
            side_panel();
            
    // bottom sides
    bottom_side_panel();
    translate([top_width, top_depth, 0])
        rotate([0, 0, 180])
            bottom_side_panel();
            
    // slats
    side_slats();
    translate([top_width, top_depth, 0])
        rotate([0, 0, 180])
            side_slats();
            
    // top compartment shelf
    translate([0, 0, leg_height - top_compartment_height - shelf_thick])
        intermediate_shelf();
        
    // top compartment back
    translate([
        top_lip + leg_thick,
        top_depth - top_lip - 2* panel_thick,
        total_height - top_thick - top_compartment_height])
    cube([
        side_width,
        panel_thick,
        top_compartment_height]);
        
    // bottom compartment bottom
    translate([0, 0, bottom_compartment_bottom])
        intermediate_shelf();
    
    // bottom compartment top
    translate([0, 0, bottom_compartment_bottom + shelf_thick + bottom_compartment_height])
        intermediate_shelf();
        
    // bottom compartment back
    translate([
        top_lip + leg_thick,
        top_depth - top_lip - 2* panel_thick,
        bottom_compartment_bottom + panel_thick])    
    cube([
        side_width,
        panel_thick,
        bottom_compartment_height]);
}

//inner_leg();
nightstand();

// top drawer.
translate([
    top_lip + leg_thick,
    top_lip + panel_thick,
    total_height - top_thick - top_compartment_height])
drawer(top_compartment_height);

// bottom drawer.
translate([
    top_lip + leg_thick,
    top_lip + panel_thick,
    bottom_compartment_bottom + panel_thick])   
drawer(bottom_compartment_height);

// mid drawer (test).
/*
translate([
    top_lip + leg_thick,
    top_lip + panel_thick - 1,
    bottom_compartment_bottom + panel_thick * 2 + bottom_compartment_height])   
drawer(bottom_compartment_height);*/