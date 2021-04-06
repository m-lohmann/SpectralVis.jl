"""
`luminance_spec(λ::Vector{Float64},r::Vector{Float64})`

Luminance spectrum of type `RSpec`
"""
function luminance_spec(λ,l)
    return LSpec(λ,l)
end

"""
`reflectance_spec(λ::Vector{Float64},r::Vector{Float64})`

Reflectance spectrum of type `RSpec`
"""
function reflectance_spec(λ,s)
    return RSpec(λ,s)
end

"""
`transmittance_spec(λ,t)`

Tansmittance spectrum at unit thickness.
"""
function transmittance_spec(λ,t)
    return TSpec(λ,t)
end

"""
`transmittance_spec(λ,t,x)`

Transmittance spectrum with thickness `x` given relative to unit thickness, according to Bougouer’s Law/Lambert’s Law.

See: "Color Measurement" by David L. MacAdam, chapter 3.2: "Bouguer’s Law"
"""
function transmittance_spec(λ::Vector{Real},t::Vector{Real},x::Real)
    return TSpec(λ, t, x)
end

"""
`transmittance_spec(λ,t,d,d0)`

Transmittance spectrum with thickness term `d`. Unit thickness is `d0`, according to Bouguer’s Law/Lambert’s Law.

See: "Color Measurement" by David L. MacAdam, chapter 3.2: "Bougouer’s Law"
"""
function transmittance_spec(λ::Vector{Real},t::Vector{Real},d::Real,d0::Real)
    transmittance_spec(λ,t,(d/d0))
end

"""
`reinterpolate(spectrum::Spectrum,λmin,Δλ,λmax,style="natural")`
"""
function reinterpolate(spectrum::Spectrum,λmin,Δλ,λmax,style=:natural)
    if typeof(spectrum) == RSpec
        spl = cubicspline(spectrum.λ,spectrum.r,style)
        l,s = interp(spl,(λmin:Δλ,λmax))
        RSpec(l,s)
    elseif typeof(spectrum) == LSpec
        spl = cubicspline(spectrum.λ,spectrum.l,style)
        l,s = interp(spl,(λmin:Δλ,λmax))
        LSpec(l,s)
    end
end