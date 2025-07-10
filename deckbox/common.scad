TwoByFourDims = [2-1/2, 4-1/2];
OneBySixDims = [1-11/16, 6-1/2];

TongueWidth = 1/2;
PegDiameter = 1/2;
PegRadius = PegDiameter / 2;
PlankTongueWidth = 3/8;
PlankGrooveDepth = 1/2;
TabWidth = 1/2;
TabDepth = 1 + 1/2;
FootHeight = 1 + 1/2;
BottomRailCutDepth = 1/2;
BottomRailCutIndent = 1 + 1/2;

function GetTabHeight(height) = 
    height - TabWidth * 2;
   
function GetPegSpacing(height, count) =
    (GetTabHeight(height) - count * PegDiameter) / (count + 1);

module TwoByFour(length)
{
    cube(
        [TwoByFourDims[0], TwoByFourDims[1], length],
        center = false);
}

module OneBySix(length)
{
    cube(
        [OneBySixDims[0], OneBySixDims[1], length],
        center = false);
}

module PegHoles(height, count)
{
    for(i = [0:count-1])
    {
    translate(
        [
            -1,
            TabDepth/2, 
            TabWidth + GetPegSpacing(height, count) * (i+1) + PegRadius + PegDiameter * i
        ])
    rotate([0, 90, 0])
        cylinder(
            h = TwoByFourDims[0] + 2,
            r = PegRadius,
            $fn = 16);
    }      
}

module FaceLegLeft(height)
{
    difference()
    {
        TwoByFour(height);
        
        // Cut the groove for the edge leg.
        translate(
            [
                -1,
                (TwoByFourDims[0] - TongueWidth)/2, 
                -1
            ])
            cube([TongueWidth+1, TongueWidth, height + 2], center=false);
        
        // Cut the notch for the top rail.
        translate(
            [
                (TwoByFourDims[0] - TabWidth) / 2,
                TwoByFourDims[1] - TabDepth,
                height - TabWidth - GetTabHeight(TwoByFourDims[1])
            ])
            cube(
                [TabWidth, TabDepth + 0.1, GetTabHeight(TwoByFourDims[1])],
                center = false);
        
        // Cut the notch for the bottom rail.
        translate(
            [
                (TwoByFourDims[0] - TabWidth) / 2,
                TwoByFourDims[1] - TabDepth,
                FootHeight + TabWidth
            ])
            cube(
                [TabWidth, TabDepth + 0.1, GetTabHeight(TwoByFourDims[1])],
                center = false);
        
        // Cut the peg holes for the bottom.
        translate([0, TwoByFourDims[1] - TabDepth, FootHeight])
            PegHoles(TwoByFourDims[1], 2);

        // Cut the peg holes for the top.
        translate([0, TwoByFourDims[1] - TabDepth, height - TwoByFourDims[1]])
            PegHoles(TwoByFourDims[1], 2);
            
        // Cut the groove for the panels.
        translate([(TwoByFourDims[0] - PlankTongueWidth) / 2, TwoByFourDims[1] - PlankGrooveDepth, FootHeight + TwoByFourDims[1] - PlankGrooveDepth])
        cube(
            [
                PlankTongueWidth,
                PlankGrooveDepth + 0.1,
                height - 2 * TwoByFourDims[1] - FootHeight + 2 * PlankGrooveDepth
            ],
            center = false);
    }
}

module FaceSlat(height)
{
    translate([0, -TwoByFourDims[1] / 2, -TabDepth])
    difference()
    {
        TwoByFour(height + 2 * TabDepth);
        
        // cut out the tabs.
        mirror([0, 1, 0])
        rotate([90, 0, 0])
        NegativeTab(TwoByFourDims[1]);
        
        translate([0, 0, height + 2 * TabDepth])
        mirror([0, 0, 1])
        mirror([0, 1, 0])
        rotate([90, 0, 0])
        NegativeTab(TwoByFourDims[1]);        
        
        // cut grooves for the panels.
        grooveX = (TwoByFourDims[0] - PlankTongueWidth) / 2;
        for (y = [-0.1, TwoByFourDims[1] - PlankGrooveDepth])
        {
            translate([grooveX, y, -0.1])
            cube(
                [
                    PlankTongueWidth,
                    PlankGrooveDepth + 0.1,
                    height + 2 * TabDepth + 0.2
                ],
                center = false);
        }   
    }
}

module SideLegFront(height)
{
    width = (TwoByFourDims[0] - TongueWidth)/2;
    translate([TongueWidth, 0, 0])
    difference()
    {
        rotate([0, 0, 90])
            TwoByFour(height);
        translate(
            [
                -TongueWidth,
                -1, 
                -1
            ])
            cube(
                [TongueWidth+1, width+1, height + 2],
                center=false);
        translate(
            [
                -TongueWidth,
                width + TongueWidth, 
                -1
            ])
            cube(
                [TongueWidth+1, width+1, height + 2],
                center=false);
        
        // Cut the notch for the bottom rail.
        translate(
            [
                -TwoByFourDims[1] - 1,
                (TwoByFourDims[0] - TabWidth) / 2,
                FootHeight + TabWidth
            ])
            cube(
                [TabDepth + 1, TabWidth, GetTabHeight(TwoByFourDims[1])],
                center = false); 
         
        // Cut the peg holes for the bottom.
        translate([-TwoByFourDims[1] + TabDepth, 0, FootHeight])
            rotate([0, 0, 90])
                PegHoles(TwoByFourDims[1], 2);
        
        // Cut the groove for the panels
        translate(
            [
                -TwoByFourDims[1] + TongueWidth - PlankGrooveDepth - 0.1, 
                (TwoByFourDims[0] - PlankTongueWidth) / 2, 
                FootHeight + TwoByFourDims[1] - PlankGrooveDepth
            ])
        cube(
            [
                PlankGrooveDepth + 0.1, 
                PlankTongueWidth,
                height - FootHeight - 2 * TwoByFourDims[1] + PlankGrooveDepth * 2]);
    }
}

module FaceLegRight(height)
{
    translate([0, TwoByFourDims[1], 0])
    mirror([0, 1, 0])
        FaceLegLeft(height);
}

module SideLegBack(height)
{
    translate([-TwoByFourDims[1] , 0, 0])
    mirror([1, 0, 0])
       SideLegFront(height);
}

module NegativeTab(height)
{
    difference()
    {
        translate([-1, -1, -1])
            cube([TwoByFourDims[0] + 2, TabDepth + 1,  TwoByFourDims[1] + 2], center = false);
        translate([(TwoByFourDims[0] - TabWidth)/2, 0, TabWidth])
            cube([TabWidth, TabDepth, GetTabHeight(height)], center = false);
    }
}

module BottomRailCut(length)
{
    union()
    {
        translate([-1, BottomRailCutDepth + BottomRailCutIndent, -BottomRailCutDepth])
        cube(
            [
                2 + TwoByFourDims[0], 
                length - (BottomRailCutDepth + BottomRailCutIndent) * 2, 
                BottomRailCutDepth * 2
            ],
            center = false);
        
        translate(
            [
                -1, 
                BottomRailCutDepth + BottomRailCutIndent,
                0
            ])
        rotate([0, 90, 0])
            cylinder(
                h = 2 + TwoByFourDims[0],
                r = BottomRailCutDepth,
                $fn = 16);
        
        translate(
            [
                -1, 
                length - (BottomRailCutDepth + BottomRailCutIndent) * 2 + BottomRailCutIndent + BottomRailCutDepth,
                0
            ])
        rotate([0, 90, 0])
            cylinder(
                h = 2 + TwoByFourDims[0],
                r = BottomRailCutDepth,
                $fn = 16);        
    }
}

module SideBottomRail(width)
{
    translate([0, -TabDepth, FootHeight])
    difference()
    {
        translate([0, 0, TwoByFourDims[1]])
        rotate([-90, 0, 0])
            TwoByFour(width + TabDepth * 2);
        
        // cut out the tabs.
        NegativeTab(TwoByFourDims[1]);
        translate([TwoByFourDims[0], width + TabDepth * 2, 0])
            rotate([0, 0, 180])
                NegativeTab(TwoByFourDims[1]);
        
        // cut out the pegs in the tabs
        PegHoles(TwoByFourDims[1], 2);
        translate([0, width + TabDepth, 0])
            PegHoles(TwoByFourDims[1], 2);
        
        // cut out the groove for the panels
        translate([(TwoByFourDims[0] - PlankTongueWidth) / 2, TabDepth - 0.1, TwoByFourDims[1] - PlankGrooveDepth])
            cube([PlankTongueWidth, width + 0.2, PlankGrooveDepth + 1]);
        
        // cut out the curved arch at the bottom.
        translate([0, TabDepth, 0])
            BottomRailCut(width);
    }
}

module FaceBottomRail(length, section_count)
{
    section_width = length / section_count;
    translate([0, -TabDepth, FootHeight])
    difference()
    {
        translate([0, 0, TwoByFourDims[1]])
        rotate([-90, 0, 0])
        TwoByFour(length + TabDepth * 2);
        
        // cut out the tabs.
        NegativeTab(TwoByFourDims[1]);
        translate([TwoByFourDims[0], length + TabDepth * 2, 0])
            rotate([0, 0, 180])
                NegativeTab(TwoByFourDims[1]);
      
        
        // cut out the pegs in the tabs
        PegHoles(TwoByFourDims[1], 2);
        translate([0, length + TabDepth, 0])
            PegHoles(TwoByFourDims[1], 2);
        
        // cut out the groove for the panels
        translate([(TwoByFourDims[0] - PlankTongueWidth) / 2, TabDepth - 0.1, TwoByFourDims[1] - PlankGrooveDepth])
            cube([PlankTongueWidth, length + 0.2, PlankGrooveDepth + 0.1]);        
        
        // cut out arch at bottom
        for (i = [0 : section_count - 1])
        {
            translate([0, TabDepth + i * section_width, 0])
            BottomRailCut(section_width);
        }
        
        // cut out holes for thick slats
        for (i = [1 : section_count - 1])
        {
            translate([0, TabDepth + i * section_width, 0])
            translate([(TwoByFourDims[0] - TabWidth)/2, -GetTabHeight(TwoByFourDims[1])/2, TwoByFourDims[1] + 0.1 - TabDepth])
            cube(
                [TabWidth, GetTabHeight(TwoByFourDims[1]), TabDepth + 0.1],
                center = false);
        }
    }
    
    overhang = TwoByFourDims[1] - TwoByFourDims[0];
    translate([-TwoByFourDims[0], -overhang, FootHeight + BottomRailCutDepth])
        cube([TwoByFourDims[0], length + 2 * overhang, TwoByFourDims[0]], center = false);
}

module FaceTopRail(length, section_count)
{
    section_width = length / section_count;
    translate([0, -TabDepth, 0])
    difference()
    {
        translate([0, 0, TwoByFourDims[1]])
        rotate([-90, 0, 0])
        TwoByFour(length + TabDepth * 2);
        
        // cut out the tabs.
        NegativeTab(TwoByFourDims[1]);
        translate([TwoByFourDims[0], length + TabDepth * 2, 0])
            rotate([0, 0, 180])
                NegativeTab(TwoByFourDims[1]);
      
        
        // cut out the pegs in the tabs
        PegHoles(TwoByFourDims[1], 2);
        translate([0, length + TabDepth, 0])
            PegHoles(TwoByFourDims[1], 2);
        
        // cut out the groove for the panels
        translate([(TwoByFourDims[0] - PlankTongueWidth) / 2,  -0.1, -0.1])
            cube([PlankTongueWidth, length + 0.2, PlankGrooveDepth + 0.1]);

        // cut out holes for thick slats
        for (i = [1 : section_count - 1])
        {
            translate([0, TabDepth + i * section_width, 0])
            translate([(TwoByFourDims[0] - TabWidth)/2, -GetTabHeight(TwoByFourDims[1])/2, -0.1])
            cube(
                [TabWidth, GetTabHeight(TwoByFourDims[1]), TabDepth + 0.1],
                center = false);
        }        
    }
}

module FaceFrame(length, height)
{
    section_count = 4;
    FaceLegLeft(height);
    
    translate([0, length - TwoByFourDims[1], 0])
        FaceLegRight(height);
    
    translate([0, TwoByFourDims[1], 0])
        FaceBottomRail(length - 2 * TwoByFourDims[1], section_count);
    
    translate([0, TwoByFourDims[1], height - TwoByFourDims[1]])
        FaceTopRail(length - 2 * TwoByFourDims[1], section_count);
    
    section_length = (length - 2 * TwoByFourDims[1]) / section_count;
    for (i = [1:section_count - 1])
    {
        translate([0, i * section_length + TwoByFourDims[1], FootHeight + TwoByFourDims[1]])
        FaceSlat(height - 2 * TwoByFourDims[1] - FootHeight);
    }
}

module SideTopRail(width, height, lid_angle)
{
    translate([0, 0, height])
    difference()
    {
        union()
        {
            // rail.
            difference()
            {
                rotate([0, -lid_angle, 0])
                rotate([0, 0, 90])
                    TwoByFour(width / sin(lid_angle));

                translate(
                    [-TwoByFourDims[1] + TabWidth, -1, -TwoByFourDims[1] - 1])
                cube(
                    [TwoByFourDims[1] ,2 + TwoByFourDims[0], TwoByFourDims[1] + 2],
                    center = false);

                translate(
                    [-width - 2 - TabWidth, -1, -TwoByFourDims[1] - 1 + width * cos(lid_angle)])
                cube(
                    [TwoByFourDims[1] + 2 ,2 + TwoByFourDims[0], TwoByFourDims[1] + 2],
                    center = false);
            }
            
            // tabs
            rotate([0, -lid_angle, 0])
            translate(
                [
                    -TabWidth,
                    (TwoByFourDims[0] - TabWidth) / 2,
                    (TwoByFourDims[1] - TongueWidth - TabDepth) * sin(lid_angle)  
                ])
            rotate([0, 0, 90])
            cube(
                [
                    TabWidth,
                    GetTabHeight(TwoByFourDims[1]),
                    (width - (TwoByFourDims[1] - TabWidth) * 2) / sin(lid_angle) + TabDepth * 2
                ]);
        }
        
        // cut out peg holes.
        translate([-TwoByFourDims[1] + TabDepth + TongueWidth, 0, -GetTabHeight(TwoByFourDims[1])])
            rotate([0, 0, 90])
            PegHoles(TwoByFourDims[1], 1);
        
        translate([-width + TwoByFourDims[1] - TabDepth + TongueWidth * 2, 0,  ( width - TwoByFourDims[1]) * cos(lid_angle) - GetTabHeight(TwoByFourDims[1])])
            rotate([0, 0, 90])
                PegHoles(TwoByFourDims[1], 1);
        
        // cut out groove for planks
        translate([0, (TwoByFourDims[0] - PlankTongueWidth)/2, 0])
        rotate([0, -lid_angle, 0])
            translate([-TwoByFourDims[1] - 0.1, 0, 0])
            cube([PlankGrooveDepth + 0.1, PlankTongueWidth, width], center = false);
        
    }
}

module SideFrame(width, height, lid_angle)
{
    difference()
    {
        SideLegFront(height + cos(lid_angle) * TwoByFourDims[1]);
        
        translate([0, 0, height])
        rotate([0, 90-lid_angle, 0])
        translate([-4, -4, 0])
        cube([8, 8, 4]);
        
        translate([0, 0, height])
            translate([-TwoByFourDims[1] + TabDepth + TongueWidth, 0, -GetTabHeight(TwoByFourDims[1])])
                rotate([0, 0, 90])
                PegHoles(TwoByFourDims[1], 1);

        translate([0, 0, height])
        rotate([0, -lid_angle, 0])
        translate(
            [
                -TabWidth,
                (TwoByFourDims[0] - TabWidth) / 2,
                (TwoByFourDims[1] - TongueWidth - TabDepth) * sin(lid_angle)  
            ])
        rotate([0, 0, 90])
        cube(
            [
                TabWidth,
                GetTabHeight(TwoByFourDims[1]),
                (width - (TwoByFourDims[1] - TabWidth) * 2) / sin(lid_angle) + TabDepth * 2
            ]);
    }
    
    difference()
    {
        translate([-width + TwoByFourDims[1], 0, 0])
            SideLegBack(height + cos(lid_angle) * width);
        
        translate([0, 0, height])
        rotate([0, 90-lid_angle, 0])
        translate([-width + TwoByFourDims[1], 0, 0])
        translate([-4, -4, 0])
        cube([8, 8, 4]);
        
        translate([0, 0, height])
        translate([-width + TwoByFourDims[1] - TabDepth + TongueWidth * 2, 0,  ( width - TwoByFourDims[1]) * cos(lid_angle) - GetTabHeight(TwoByFourDims[1])])
            rotate([0, 0, 90])
                PegHoles(TwoByFourDims[1], 1);        

        translate([0, 0, height])
        rotate([0, -lid_angle, 0])
        translate(
            [
                -TabWidth,
                (TwoByFourDims[0] - TabWidth) / 2,
                (TwoByFourDims[1] - TongueWidth - TabDepth) * sin(lid_angle)  
            ])
        rotate([0, 0, 90])
        cube(
            [
                TabWidth,
                GetTabHeight(TwoByFourDims[1]),
                (width - (TwoByFourDims[1] - TabWidth) * 2) / sin(lid_angle) + TabDepth * 2
            ]);
    }
    
    translate([-TwoByFourDims[1] + TabWidth, 0, 0])
    rotate([0, 0, 90])
        SideBottomRail(width - (TwoByFourDims[1] - TabWidth) * 2);
    
    SideTopRail(width, height, lid_angle);
}