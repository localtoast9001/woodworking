height = 1.75;
width = 11.5;
length = 16.5;
side_thickness = 1/2;
leather_thickness = 1/8;
base_thickness = 1/4 + leather_thickness;
handle_thickness = 1/2;
handle_length = 3;

cube([length, width, base_thickness], center=false);

module face_side()
{
    translate([-side_thickness/2, -side_thickness/2, 0])
    cube([length + side_thickness, side_thickness, height], center = false);
}

module handle_side()
{
    translate([-side_thickness/2, -side_thickness/2, 0])
    difference()
    {
        cube(
            [side_thickness, width + side_thickness, height],
            center=false);
        translate([0, (width + side_thickness) / 2, height /2])
        translate([-0.1, -handle_length / 2, -handle_thickness / 2])
        union()
        {
            cube([side_thickness + 0.2, handle_length, handle_thickness], center=false);
            translate([0, 0, handle_thickness/2])
            rotate([0, 90, 0])
            cylinder(h = side_thickness + 0.2, r = handle_thickness / 2, $fn=16); 
            translate([0, handle_length, handle_thickness/2])
            rotate([0, 90, 0])
            cylinder(h = side_thickness + 0.2, r = handle_thickness / 2, $fn=16); 
                
        }
    }
}

face_side();
mirror([0, 1, 0])
translate([0, -width, 0])
face_side();

handle_side();
mirror([1, 0, 0])
translate([-length, 0, 0])
handle_side();