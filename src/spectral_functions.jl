"""
    luminance_spec(λ,r)`

Luminance spectrum of type `RSpec`
"""
function luminance_spec(λ,l)
    return LSpec(λ,l)
end

"""
`reflectance_spec(λ,r)`

Reflectance spectrum of type `RSpec`
"""
function reflectance_spec(λ,r)
    return RSpec(λ,r)
end

"""
    transmittance_spec(λ,t)

Tansmittance spectrum at unit thickness (x = 1.0).
"""
function transmittance_spec(λ,t)
    return TSpec(λ,t,1.0)
end

"""
    transmittance_spec(λ, t, x)

Transmittance spectrum with thickness `x` given relative to unit thickness, according to Bougouer’s Law/Lambert’s Law.

See: "Color Measurement" by David L. MacAdam, chapter 3.2: "Bouguer’s Law"
"""
function transmittance_spec(λ::Vector{Real},t::Vector{Real},x::Real)
    return TSpec(λ, t, x)
end

"""
    transmittance_spec(λ,t,d,d0)

Transmittance spectrum with thickness term `d`. Unit thickness is `d0`, according to Bouguer’s Law/Lambert’s Law.

See: "Color Measurement" by David L. MacAdam, chapter 3.2: "Bougouer’s Law"
"""
function transmittance_spec(λ::Vector{Real},t::Vector{Real},d::Real,d0::Real)
    transmittance_spec(λ,t,(d/d0))
end

"""
`reinterpolate(spectrum,λmin,Δλ,λmax,style=:natural)`
"""
function reinterpolate(spectrum,λmin,Δλ,λmax,istyle=:natural,estyle=:linear)
    if typeof(spectrum) == RSpec
        spl = cubicspline(spectrum.λ,spectrum.r,istyle)
        epsl = extrap(spl,)
        extrapolate(spl,xrange,extr::Symbol)
        l,s = interp(spl,(λmin:Δλ:λmax))
        return RSpec(l,s)
    elseif typeof(spectrum) == LSpec
        spl = cubicspline(spectrum.λ,spectrum.l,istyle)
        l,s = interp(spl,(λmin:Δλ,λmax))
        return LSpec(l,s)
    end
end

"""
    adaptated_color(spectrum)
"""
function adapted_color(illuminant1,λrange)
    lum=normalize_spec(blackbody_illuminant(T))
    wp=blackbody_whitepoint(SPECENV, T)
end
