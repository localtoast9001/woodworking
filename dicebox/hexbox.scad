thickness = 1/2;
height = 2; // 1 + 1/2;

base_thickness = 3/8;
base_size = 4; // 4 / sin(60);

module base()
{
    pts = [for (angle = [0:5]) 
        [base_size * cos(60 * angle), base_size * sin(60 * angle)]
    ];
    
    linear_extrude(base_thickness)
        polygon(pts);
}

module side()
{
    intersection()
    {
        //rotate([0, 0, -30])
        translate([-base_size, 0, 0])
        rotate([0, 0, 330])
        translate([0, -base_size/2, 0])
        difference()
        {
            union()
            {
                translate([-thickness/2, 0, 0])
                cube([thickness, base_size *2, height - thickness], center = false);
                translate([0, 0, height - thickness])
                rotate([-90, 0, 0])
                cylinder(h = base_size * 2, r = thickness / 2, $fn = 16);
            }
            
            translate([0, -0.1, -0.1])
            cube([thickness + 0.1, base_size *2 + 0.2, base_thickness + 0.1], center = false);
        }
        
        // triangle cut-out.
        pts = [[0, 0], [-base_size * 2, 0], [-base_size * 2 * cos(60), base_size * 2 * sin(60)]];
        translate([0, 0, -0.1])
        linear_extrude(height + 0.2)
            polygon(pts);
    }
}

for (angle = [0:5])
    rotate([0, 0, 60 * angle])
        side();

base();