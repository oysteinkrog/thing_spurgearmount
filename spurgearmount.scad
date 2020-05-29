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

module spurgearhub(part, with_grub=false)
{
    h=1*mm;
    gear_holes_spacing = 15.3*mm;
    main_dia=gear_holes_spacing*sqrt(2)-1*mm;
    bore_dia = 5*mm + .25*mm;
    bore_dia_ = 3.85*mm;;
    hub_dia = main_dia;
    knurl_nut = NutKnurlM2_6_42;
    hub_h = with_grub? get(NutWidthMax, knurl_nut)+1*mm : 2*mm;
    stub_d = 3.15*mm;
    stub_h = h+2.5*mm;

    inner_dia=9.55*mm;
    inner_h = 3.5*mm;

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
            /*rcylindera(d=hub_dia, h=hub_h, orient=Z, align=Z);*/

            if(with_grub)
            {
                rz(45)
                for(a=[-1,1])
                tx(-a*(bore_dia/2 - .1*mm))
                rcylindera(h=get(NutThickness,knurl_nut), d=hub_h, orient=-X*a, align=-X*a+Z);
            }

            tz(hub_h+0*mm)
            rz(90)
            for(i=[45:360/2:360+45])
            rz(i)
            tx(8*mm)
            rcylindera(h=hub_h, d=8*mm, orient=-Z, align=-Z, round_r=.5*mm);

            for(i=[0:360/8:360])
            if(i%2 == 0)
            rz(i)
            tx(8*mm)
            rcylindera(d=stub_d+3*mm, h=hub_h, orient=Z, align=Z, round_r=.5*mm);
        }

        rcylindera(d=inner_dia, h=inner_h, orient=Z, align=-Z, extra_h=h, extra_align=Z);

        tz(hub_h)
        for(i=[0:8])
        for(i=[0:360/8:360])
        if(i%2 == 0)
        rz(i)
        tx(8*mm)
        rcylindera(d=stub_d, h=stub_h+hub_h, orient=Z, align=-Z, round_r=.5*mm);

    }
    else if(part=="neg")
    {
        intersection()
        {
            cylindera(d=bore_dia, h=100*mm, orient=Z, align=N, extra_h=.1, extra_align=-Z);
            rz(45)
            cubea([bore_dia_,100*mm,100*mm]);
        }

        if(with_grub)
        for(a=[-1,1])
        rz(45)
        tx(-a*(bore_dia_/2 - .1*mm))
        tz(2.1*mm)
        {
            cylindera(d=3.25*mm, h=20*mm, orient=X*a, align=-X*a);
            screw_cut(nut=knurl_nut, h=6*mm, head="set", nut_offset=0*mm, with_nut=true, with_nut_cut=false, orient=X*a, align=-X*a);
        }

        tz(-hub_h+0*mm)
        rz(90)
        for(i=[45:360/2:360+45])
        rz(i)
        tx(8*mm)
        /*tz(1*mm)*/
        screw_cut(nut=NutHexM2, h=7*mm, head="button", head_embed=false, with_nut=false, orient=Z, align=Z);
    }
}

module part_spurgearhub()
{
    rx(180)
    spurgearhub();
}

spurgearhub();

