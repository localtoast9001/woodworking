
function best32(v) = [
    "",
    " 1/32",
    " 1/16",
    " 3/32",
    " 1/8",
    " 5/32",
    " 3/16",
    " 7/32",
    " 1/4",
    " 9/32",
    " 5/16",
    " 11/32",
    " 3/8",
    " 13/32",
    " 7/16",
    " 15/32",
    " 1/2",
    " 17/32",
    " 9/16",
    " 19/32",
    " 5/8",
    " 21/32",
    " 11/16",
    " 23/32",
    " 3/4",
    " 25/32",
    " 13/16",
    " 27/32",
    " 7/8",
    " 29/32",
    " 15/16",
    " 31/32"
][floor(v * 32)];

function inch_str(v) = 
    str(floor(v), best32(v - floor(v)), "\"");

module measure_stick_y(
    dist,
    label = 10,
    cap = 5,
    stroke = 0.1)
{
    h_stroke = stroke / 2;
    arrow_cap = cap < dist / 8 ? cap : dist / 8;
    line_cap = dist < label ?
        dist / 2 :
        (dist - label) / 2;
    cap_pts = [
        [-cap, -h_stroke],
        [cap, -h_stroke],
        [cap, h_stroke],
        [h_stroke, h_stroke],
        [arrow_cap, arrow_cap],
        [h_stroke, arrow_cap],
        [h_stroke, line_cap],
        [-h_stroke, line_cap],
        [-h_stroke, arrow_cap],
        [-arrow_cap, arrow_cap],
        [-h_stroke, h_stroke]
    ];
    
    color("black")
    linear_extrude(stroke)
     {
    polygon(cap_pts);
    translate([0, dist, 0])
    mirror([0, 1, 0])
        polygon(cap_pts);
    if (label < dist)
    {
        translate([0, line_cap, 0])
            text(inch_str(dist), size = label);
    }
    else
    {
        translate([cap, (dist - label) / 2, 0])
            text(inch_str(dist), size=label);        
    }
}
}
