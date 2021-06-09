"""
`gamut_vis(type, title, lum, whitepoint, colmatch,name::AbstractString,altitude::Real,slice=collect(5:5:95))`

creates 3D flyaround of gamut given by illuminant

Example: `gamut_vis(Colors.DIN99o,"DIN99o at 6500K", D_series_luminance(6500),D_series_whitepoint(6500,CMF2012_10),CMF2012_10,"DIN99o_6500K_",35,collect(5:5:95))`
"""
function gamut_vis(type, title::AbstractString, lum::LSpec, whitepoint, colmatch, name::AbstractString,altitude::Real,slice=collect(5:5:95))
    println("Preparing gamut... this may take about 30s.")
    a,b,c=sl(type,lum,whitepoint,colmatch,390.0,1.0,830.0)
    println("Creating animation frames... this may take a while.")
    n=name
    if type == xyY
        xl = (0,1)
        yl = (0,1)
        zl = (0,1)
        xg = "x"
        yg = "y"
        zg = "Y"
    elseif type == XYZ
        xl = (0,1.5)
        yl = (0,1.5)
        zl = (0,1.5)
        xg = "X"
        yg = "Z"
        zg = "Y"
    elseif type == Lab
        xl = (-130,130)
        yl = (-130,130)
        zl = (0,100)
        xg = "a"
        yg = "b"
        zg = "L"
    elseif type == Luv
        xl = (-130,130)
        yl = (-130,130)
        zl = (0,100)
        xg = "u"
        yg = "v"
        zg = "L"
    elseif type in (DIN99,DIN99d,DIN99o)
        xl = (-60,60)
        yl = (-60,60)
        zl = (0,100)
        xg = "a99"
        yg = "b99"
        zg = "L99"
    end

    
    @inbounds for azimuth in 0:359
        gamutslice(type, title, a, b, c,(xl,yl,zl,xg,yg,zg), azimuth, altitude, slice)
        png("$(name)_$(string(azimuth, pad=3))")
        perc=round((azimuth+1)/360*100,digits=2)
        println("Frame $azimuth finished. $perc%")

    end
end

"""
`gamut_vis(type,T1::Real,dT::Real,T2::Real,colmatch,name::AbstractString,altitude::Real,azimuth::Real,slice=collect(5:5:95))`

Creates gamut given by Temperature range
"""
function gamut_vis(type,T1::Real,dT::Real,T2::Real,colmatch,name::AbstractString,altitude::Real,azimuth::Real,slice=collect(5:5:95))
    println("Preparing gamut... this may take about 30s.")
    for T in T1:dT:T2
        lum=normalize_spec(blackbody_illuminant(T,390,1,830))
        wp=blackbody_whitepoint(T,390,1,830,colmatch)
        a,b,c=sl(type,lum,wp,colmatch,390.0,1.0,830.0)
        println("Creating animation frames... this may take a while.")
        n=name
        if type == xyY
            xl = (0,1)
            yl = (0,1)
            zl = (0,1)
            xg = "x"
            yg = "y"
            zg = "Y"
        elseif type == XYZ
            xl = (0,1.5)
            yl = (0,1.5)
            zl = (0,1.5)
            xg = "X"
            yg = "Z"
            zg = "Y"
        elseif type == Lab
            xl = (-130,130)
            yl = (-130,130)
            zl = (0,100)
            xg = "a"
            yg = "b"
            zg = "L"
        elseif type == Luv
            xl = (-130,130)
            yl = (-130,130)
            zl = (0,100)
            xg = "u"
            yg = "v"
            zg = "L"
        elseif type in (DIN99,DIN99d,DIN99o)
            xl = (-60,60)
            yl = (-60,60)
            zl = (0,100)
            xg = "a99"
            yg = "b99"
            zg = "L99"
        end
        title=T
        gamutslice(type, title, a, b, c,(xl,yl,zl,xg,yg,zg), azimuth, altitude, slice)
        png("$(name)_$(string(tstr, pad=5))")
        println("Frame for CCT $tstr K finished.")
    end
end

function gamutslice(type, title, a, b, c, (xl,yl,zl,xg,yg,zg), azimuth, altitude, slice)
    scatter()
    @inbounds for s in slice
        h,i,j=getslice(a,b,c,s,type)
        plot!(h,i,j,labels=false,color=:black,linewidth=0.5,markersize=0.35,xlims=xl,xguide=xg,ylims=yl,yguide=yg,zlims=zl,zguide=zg,camera=(azimuth,altitude),title="$(title)")
    end
end