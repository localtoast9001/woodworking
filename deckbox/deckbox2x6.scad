use <common2.scad>

height = 19;
length = 6 * 12;
width = 2 * 12;
lid_angle = round(atan(width / 2));
echo(lid_angle);

// front

difference()
{
FaceFrame(length, height);

translate([0, 0, height])
rotate([0, 90-lid_angle, 0])
translate([-2, 0, 0])
cube([4, length, 4]);
}

// left side
SideFrame(width, height, lid_angle);

// back
difference()
{
translate([-width, length, 0])
rotate([0, 0, 180])
    FaceFrame(length, height+2.25);
    
translate([0, 0, height])
rotate([0, 90-lid_angle, 0])
translate([-2 - width, 0, 0])
cube([4, length, 4]);

}
    
// right
translate([0, length, 0])
mirror([0, 1, 0])
    SideFrame(width, height, lid_angle);
    