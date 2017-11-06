include <thing_libutils/nut-data.scad>;
include <thing_libutils/system.scad>;
include <thing_libutils/units.scad>;
use <thing_libutils/shapes.scad>;
use <thing_libutils/transforms.scad>;
include <thing_libutils/screws.scad>;

e=0.01*mm;

// high quality etc
is_build = false;

// minimum size of a fragment
// resolution of any round object (segment length)
// Because of this variable very small circles have a smaller number of fragments than specified using $fa. 
// The default value is 2.
$fs = is_build ? 0.5 : 1;

// minimum angle for a fragment.
// The default value is 12 (i.e. 30 fragments for a full circle)
$fa = is_build ? 4 : 16;

$show_vit = is_build ? false : true;

// enable preview model (faster openscad)
$preview_mode = is_build ? false : true;

module spurgearhub(part)
{
    h=2*mm;
    gear_holes_spacing = 15.3*mm;
    main_dia=gear_holes_spacing*sqrt(2)+0*mm;
    bore_dia = 5.25*mm;
    hub_dia = main_dia;
    hub_h = h+3.5*mm;

    inner_dia=9.55*mm;
    inner_h = 6*mm;
    if(part==U)
    {
        difference()
        {
            spurgearhub(part="pos");
            spurgearhub(part="neg");
        }
        spurgearhub(part="vit");
    }
    else if(part=="pos")
    {
        hull()
        {
            // main body
            rcylindera(d=main_dia, h=h, orient=Z, align=Z);

            rcylindera(d=hub_dia, h=hub_h, orient=Z, align=Z);

            for(a=[-1,1])
            tz(h+.5*mm)
            tx(a*hub_dia/2)
            cylindera(h=5*mm, d=5*mm, orient=-X*a, align=-X*a);
        }

        rcylindera(d=inner_dia, h=inner_h, orient=Z, align=-Z, extra_h=h, extra_align=Z);
    }
    else if(part=="neg")
    {
        cylindera(d=bore_dia, h=100*mm, orient=Z, align=N, extra_h=.1, extra_align=-Z);

        for(a=[-1,1])
        tz(h+.5*mm)
        tx(a*(bore_dia/2-.1))
        screw_cut(nut=NutKnurlM3_8_42, head="set", h=6, with_nut=true, with_nut_cut=true, with_nut_access=false, orient=-X*a, align=X*a);

        tz(hub_h+1*mm)
        rz(90)
        for(i=[45:360/4:360+45])
        rz(i)
        tx(7.65*mm)
        screw_cut(nut=NutHexM3, h=hub_h, head="button", head_embed=true, with_nut=false, orient=-Z, align=-Z);

    }
}

module part_spurgearhub()
{
    rx(180)
    spurgearhub();
}

spurgearhub();

