"""
`blockspec(λmin,λmax,Δλ,λs,λe,mode=1)`
regular `block spectrum` initialized to 0.0, with blocks λs..λe = 1.0

`blockspec(λmin,λmax,Δλ,λs,λe,mode=0)`
inversed `block spectrum` initialized to 1.0, with blocks λs..λe = 0.0

"""
function block_spec(λmin,λmax,Δλ,λs,λe,str=1.0,mode=0)
    r= mode == 0 ? (zeros(Float64, Int(1.0+(λmax-λmin)/Δλ))) : (ones(Float64,Int(1.0+(λmax-λmin)/Δλ)))
    for n = λs:Δλ:λe
        r[Int((n-λmin)/Δλ)+1] = mode==0 ? str : 0.0
    end
    λ = collect(λmin:Δλ:λmax)
    i_reflectance_spec(λ,r)
end

"""
`led_spec(λmin,λmax,Δλ,λ0,Δλ1_2)`

LED spectrum simulation
λ0 = peak wavelength
Δλ1_2 = half spectral width
"""
function led_spec(λmin,λmax,Δλ,λ0,Δλ1_2)
    λ = collect(λmin:Δλ:λmax)
    n = length(λ)
    l = zeros(n)
    for i in 1:n
        l[i] = led(λ[i],λ0,Δλ1_2)
    end
    ILSpec(λ,l)
end

"""
LED function
"""
function led(λ,λ0,Δλ1_2)
    (ghelp(λ,λ0,Δλ1_2) + 2.0 * ghelp(λ,λ0,Δλ1_2)^5.0)/3.0
end

"""
LED helper function
"""
function ghelp(λ,λ0,Δλ1_2)
    exp(-((λ-λ0)/Δλ1_2)^2.0)
end

"""
`D_series_illuminant(T::Real)`

The relative spectral power distribution (SPD) SD(λ) of a D series illuminant from 300 to 830 nm in 5 nm steps
"""
function D_series_illuminant(T::Real)
    #xD,yD = CIE Daylight Locus
    if T < 4000
        error("CCT must be between 4000 and 25000 K!")
    elseif 4000 ≤ T ≤ 7000
        xD = 0.244063 + 0.09911 * 1000.0 / T + 2.9678 * 1_000_000.0/T^2 - 4.6070 * 1_000_000_000.0/T^3
    elseif 7000 < T ≤ 25000
        xD = 0.237040 + 0.24748*1000.0/T + 1.9018*1_000_000.0/T^2 -2.0064*1000_000_000.0/T^3
    end

    yD = -3.000 * xD^2 + 2.870*xD-0.275
    M  = 0.0241 + 0.2562*xD - 0.7341*yD
    M1 = (-1.3515-1.7703*xD + 5.9114*yD)/M
    M2 = (0.03000 - 31.4424*xD + 30.0717*yD)/M
    S0 = daylight_generator_table[:,2]
    S1 = daylight_generator_table[:,3]
    S2 = daylight_generator_table[:,4]
    SD = S0 .+ M1*S1 .+ M2*S2
    i_luminance_spec(daylight_generator_table[:,1],SD)
end

function D_series_whitepoint(T::Real,colmatch)
    # color matching function 
    cm = cmf(colmatch)
    # create normalized D series spectrum
    nT = normalize_spec(D_series_illuminant(T))
    # create spline and interpolate to cm range (390 to 830 nm  with Δλ = 1 nm)
    sT = SSpline.linearspline(nT.λ,nT.l)
    iT = SSpline.interp(sT, collect(390.0:1.0:830.0))
    # convert back to luminance spectrum
    dT = ILSpec(iT[1],iT[2])
    # calculate whitepoint
    wp = dT*cm
    # normalize whitepoint to Y=1.0
    whitepoint=Colors.XYZ(wp.x/wp.y,1.0,wp.z/wp.y)
end

function D_series_luminance(T::Real)
    nT = normalize_spec(D_series_illuminant(T))
    sT = SSpline.linearspline(nT.λ,nT.l)
    iT = SSpline.interp(sT, collect(390.0:1.0:830.0))
    ILSpec(iT[1],iT[2])
end

function blackbody_illuminant(T::Real,λs,Δλ,λe)
    h=6.62607015e-34
    k=1.380649e-23
    c=299792458
    wl=collect(λs:Δλ:λe)
    il=zeros(length(wl))
    @inbounds for n in 1:length(wl)
        λ=wl*1e-9
        il[n] = (2*π*h*c^2)/(λ[n]^5 * (exp(h*c/(λ[n]*k*T))-1))
    end
    ILSpec(wl,il)
end

function blackbody_whitepoint(T::Real,λs,Δλ,λe,colmatch)
    # color matching function 
    cm = cmf(colmatch)
    # create normalized D series spectrum
    nT = normalize_spec(blackbody_illuminant(T,λs,Δλ,λe))
    wp = nT*cm
    whitepoint=Colors.XYZ(wp.x/wp.y,1.0,wp.z/wp.y)
end

## color matching function CIE2006 2° observer
## from 390 to 830 nm in 1 nm steps
#cm = cmf(CMF2012_2)
#
## create normalized d65 illuminant spectrum from 300 nm to 830 nm in 5 nm steps
#n65=normalize_spec(D_series_illuminant(6500))
#
## interpolate n65 to 1nm steps from 390 to 830 nm to suit the color matching function
#
## 1. create linear spline from n65
#s65=spline1(n65.λ,n65.l)
#
## 2. interpolate spline from 390 to 830 nm in 1 nm steps
#i65=interp(s65,collect(390.0:1.0:830.0))
#
## 3. create illuminant spectrum from i65
#d65=ILSpec(i65[1],i65[2])
#
## 4. create whitepoint
#
#julia> wp=d65*cm
#XYZ{Float64}(89.87949703455338,94.85275571514701,101.96262075866588)
#
## 5. normalize by Y
#julia> whitepoint=XYZ(wp.x/wp.y,1.0,wp.z/wp.y)
#XYZ{Float64}(0.9475686431764949,1.0,1.0749568632973674)