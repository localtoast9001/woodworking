
base_width = 6.5;
golden_ratio = (1 + sqrt(5)) / 2;
base_length = round(4 * base_width * golden_ratio) / 4; // Closest quarter inch.
base_thickness = 3/8;

echo(base_length);
echo(base_width);
color("gold")
//translate([0, 0, 1/2 * sin(60) - base_thickness])
cube([base_width, base_length, base_thickness]);

module edge(length)
{
    board_thickness = 1/2;
    board_height = 1.5;
    top_angle = 30;
    difference()
    {
        // mitred edge.
        intersection()
        {
            // edge piece.
            rotate([top_angle, 0, 0])
                translate([-board_height, 0, 0])
                    union()
                    {
                        translate([0, board_thickness/2, board_height - board_thickness/2])
                            rotate([0, 90, 0])
                                cylinder(h = length + board_height * 2, r = board_thickness/2, $fn=16);
                        cube([length + board_height * 2, board_thickness, board_height - board_thickness/2]);
                    }
                    
            // mitre
            translate([length /2, length / 2, 0])
                rotate([0, 0, -135])
                    cube([length * 4, length * 4, board_height * 4], center = false);
        }
        
        // base groove
        cube([length + board_height * 2, board_thickness, base_thickness]);
    }
}

color("brown")
edge(base_width);
color("brown")
translate([base_width, 0, 0])
    rotate([0, 0, 90])
        edge(base_length);
color("brown")
translate([base_width, base_length, 0])
    rotate([0, 0, 180])
        edge(base_width);
color("brown")
translate([0, base_length, 0])
    rotate([0, 0, 270])
        edge(base_length);