#function multiline(type,s::Real,d::Real,n::Real)
#    for i in s:d:n
#        col(type,T,colmatch,i)
#    end
#end

"""
`col(type,lum::LSpec,whitepoint::Color3,colmatch,dl)`

This function creates the color loci of the theoretically maximum color gamut under a given illuminant.

type: color space

lum: illuminant

whitepoint: XYZ whitepoint

colmatch: color matching function

dl: delta lambda

output: a,b,c (locus vectors in given color space)

        x,y,Y for Yxy

        X,Z,Y for XYZ

        a,b,L Lab, DIN99, DIN99d, DIN99o

        u,v,L for Luv
"""
function col(type,lum::LSpec,whitepoint::Color3,colmatch,dl)
    u=Vector{Float64}()
    v=Vector{Float64}()
    w=Vector{Float64}()
    #collection of spectral runs
    locus1=Vector{type}()
    locus2=Vector{type}()
    wp=lum
    normfact=1/(wp*cmf(colmatch)).y

    @inbounds for i in 390:830-dl+1
        bs=block_spec(390,830,1.0,i,i+dl-1,1.0,0)*wp
        xyzcol=(bs*cmf(colmatch))/XYZ(1,1/normfact,1).y
        labcol=convert(type,Colors.convert(Colors.Lab,xyzcol,whitepoint))
        push!(locus1,labcol)
    end
    if type == XYZ
        @inbounds for i in 1:length(locus1)
            push!(u,locus1[i].y)
            push!(v,locus1[i].x)
            push!(w,locus1[i].z)
        end
    elseif type in (Lab, DIN99, DIN99d, DIN99o)
        @inbounds for i in 1:length(locus1)
            push!(u,locus1[i].l)
            push!(v,locus1[i].a)
            push!(w,locus1[i].b)
        end
    elseif type == Luv
        @inbounds for i in 1:length(locus1)
            push!(u,locus1[i].l)
            push!(v,locus1[i].u)
            push!(w,locus1[i].v)
        end
    else nothing
    end
    # type 1 block spectra
    @inbounds for i in 390:830-dl+1
        bs=block_spec(390,830,1.0,i,i+dl-1,1.0,1)*wp
        xyzcol=(bs*cmf(colmatch))/XYZ(1,1/normfact,1).y
        labcol=convert(type,Colors.convert(Colors.Lab,xyzcol,whitepoint))
        push!(locus2,labcol)
    end
    if type == XYZ
        @inbounds for i in 1:length(locus2)
            push!(u,locus2[i].y)
            push!(v,locus2[i].x)
            push!(w,locus2[i].z)
        end
    elseif type in (Lab, DIN99, DIN99d, DIN99o)
        @inbounds for i in 1:length(locus2)
            push!(u,locus2[i].l)
            push!(v,locus2[i].a)
            push!(w,locus2[i].b)
        end
    elseif type == Luv
        @inbounds for i in 1:length(locus2)
            push!(u,locus2[i].l)
            push!(v,locus2[i].u)
            push!(w,locus2[i].v)
        end
    else nothing
    end
    #scatter!(v,w,u,markersize=0.2,labels=false)
    locus1,locus2
end

"""
`colv(type,T,colmatch,s)`

type: color space

T: whitepoint correlated color temperature

colmatch: color matching function

dl: delta lambda

output: a,b,c (locus vectors in given color space)

        x,y,Y for Yxy

        X,Z,Y for XYZ

        a,b,L for Luv, Lab, DIN99, DIN99d, DIN99o
"""
function colv(type,lum::LSpec,whitepoint::Color3,colmatch,s) # s = start 
    u=Vector{Float64}()
    v=Vector{Float64}()
    w=Vector{Float64}()
    #collection of spectral runs
    locus1=Vector{type}()
    locus2=Vector{type}()
    wp=lum
    normfact=1/(wp*cmf(colmatch)).y
    # dark spectrals
    @inbounds for h in 0.0:0.05:0.95
        bs=block_spec(390,830,1.0,s,s,h,0)*wp
        xyzcol=(bs*cmf(colmatch))/XYZ(1,1/normfact,1).y
        labcol=convert(type,Colors.convert(Colors.Lab,xyzcol,whitepoint))
        push!(locus1,labcol)
    end
    # normal spectrals
    @inbounds for i in s:830
        bs=block_spec(390,830,1.0,s,i,1.0,0)*wp
        xyzcol=(bs*cmf(colmatch))/XYZ(1,1/normfact,1).y
        labcol=convert(type,Colors.convert(Colors.Lab,xyzcol,whitepoint))
        push!(locus1,labcol)
    end
    if type == XYZ
        @inbounds for i in 1:length(locus1)
            push!(u,locus1[i].y)
            push!(v,locus1[i].x)
            push!(w,locus1[i].z)
        end
    elseif type == xyY
        @inbounds for i in 1:length(locus1)
            push!(u,locus1[i].Y)
            push!(v,locus1[i].x)
            push!(w,locus1[i].y)
        end        
    elseif type in (Lab, DIN99, DIN99d, DIN99o)
        @inbounds for i in 1:length(locus1)
            push!(u,locus1[i].l)
            push!(v,locus1[i].a)
            push!(w,locus1[i].b)
        end
    elseif type == Luv
        @inbounds for i in 1:length(locus1)
            push!(u,locus1[i].l)
            push!(v,locus1[i].u)
            push!(w,locus1[i].v)
        end
    else nothing
    end
    # type 1 block spectra
    @inbounds for i in s:830
        bs=block_spec(390,830,1.0,s,i,1.0,1)*wp
        xyzcol=(bs*cmf(colmatch))/XYZ(1,1/normfact,1).y
        labcol=convert(type,Colors.convert(Colors.Lab,xyzcol,whitepoint))
        push!(locus2,labcol)
    end
    if type == XYZ
        @inbounds for i in 1:length(locus2)
            push!(u,locus2[i].y)
            push!(v,locus2[i].x)
            push!(w,locus2[i].z)
        end
    elseif type == xyY
        @inbounds for i in 1:length(locus1)
            push!(u,locus1[i].Y)
            push!(v,locus1[i].x)
            push!(w,locus1[i].y)
        end        
    elseif type in (Lab, DIN99, DIN99d, DIN99o)
        @inbounds for i in 1:length(locus2)
            push!(u,locus2[i].l)
            push!(v,locus2[i].a)
            push!(w,locus2[i].b)
        end
    elseif type == Luv
        @inbounds for i in 1:length(locus2)
            push!(u,locus2[i].l)
            push!(v,locus2[i].u)
            push!(w,locus2[i].v)
        end
    else nothing
    end
    #scatter!(v,w,u,markersize=0.2,labels=false)
    locus1,locus2
end

"""
`sl(type,lum::LSpec,whitepoint,colmatch,s,d,e)`
"""
function sl(type,lum::LSpec,whitepoint,colmatch,s,d,e)
    locuscollect=Vector()
    @inbounds for dl in s:d:e
        l1,l2=colv(type,lum,whitepoint,colmatch,dl)
        push!(locuscollect,l1)
        push!(locuscollect,l2)
    end
    n=length(locuscollect)
    a=Vector{}()
    c=Vector{}()
    b=Vector{}()
    @inbounds for i in 1:n
        r=locuscollect[i] # each run of dl
        l=length(r)
        e=Vector{Float64}()
        f=Vector{Float64}()
        g=Vector{Float64}()
        if type == XYZ
            @inbounds for j in 1:l
                push!(e,r[j].x)
                push!(f,r[j].z)
                push!(g,r[j].y)
            end
        elseif type == xyY
            @inbounds for j in 1:l
                push!(e,r[j].x)
                push!(f,r[j].y)
                push!(g,r[j].Y)
            end
        elseif type in (Lab, DIN99, DIN99d, DIN99o)
            @inbounds for j in 1:l
                push!(e,r[j].a)
                push!(f,r[j].b)
                push!(g,r[j].l)
            end
        elseif type == Luv
            @inbounds for j in 1:l
                push!(e,r[j].u)
                push!(f,r[j].v)
                push!(g,r[j].l)
            end
        else nothing
        end
        push!(a,e)
        push!(b,f)
        push!(c,g)
    end
    a,b,c
end

function getslice(x,z,y,sl,type)
    a=Vector{}()
    b=Vector{}()
    c=Vector{}()
    xz=0.0
    yz=0.0
    #go throuhg all runs
    for i in 1:length(x)
        l=length(x[i])
        @inbounds for j in 1:l-1
            yt=y[i][j]
            y2=y[i][j+1]
            if (yt-sl)*(y2-sl) <= 0
                #x=(r[j+1].x-r[j].x) / (r[j+1].y-r[j].y) * (sl - r[j].y) + r[j].x
                u=(x[i][j+1]-x[i][j]) / (y[i][j+1]-y[i][j]) * (sl-y[i][j]) + x[i][j]
                #z=(r[j+1].z-r[j].z) / (r[j+1].y-r[j].y) * (sl - r[j].y) + r[j].z
                v=(z[i][j+1]-z[i][j]) / (y[i][j+1]-y[i][j]) * (sl-y[i][j]) + z[i][j]
                w=sl
                push!(a,u)
                push!(b,v)
                push!(c,w)
            end
        end
    end
    if type == xyY
        xz=1/3
        yz=1/3
    elseif type == XYZ
        xz=sl
        yz=sl
    elseif type in (Lab, DIN99, DIN99d, DIN99o)
        xz=0.0
        yz=0.0
    end
    sortslice(a,b,c,xz,yz)
end

function polar(x::Real,y::Real,xz::Real,yz::Real)
    r=sqrt((x-xz)^2.0+(y-yz)^2.0)
    α=atan(y-yz,x-xz)
    r,α
end

function sortslice(a,b,c,xz,yz)
    r=Array{Float64,2}(undef,length(a),4)
    @inbounds for i in 1:length(a)
        rr,αα = polar(a[i],b[i],xz,yz)
        r[i,1]=αα
        r[i,2]=rr
        r[i,3]=a[i]
        r[i,4]=b[i]
    end
    s=sortslices(r, dims=1)
    a,b,c = s[:,3],s[:,4],c
end