"""
`i_luminance_spec(λ::Vector{Float64},r::Vector{Float64})`

irregular luminance spectrum of type `RSpec`
"""
function i_luminance_spec(λ,l)
    return ILSpec(λ,l)
end

"""
`i_reflectance_spec(λ::Vector{Float64},r::Vector{Float64})`

irregular reflectance spectrum of type `RSpec`
"""
function i_reflectance_spec(λ,s)
    return IRSpec(λ,s)
end

"""
`i_transmittance_spec(λ,t)`

Irregular transmittance spectrum at unit thickness.
"""
function i_transmittance_spec(λ,t)
    return ITSpec(λ,t)
end

"""
`i_transmittance_spec(λ,t,x)`

Irregular transmittance spectrum with thickness `x` given relative to unit thickness, according to Bougouer’s Law/Lambert’s Law.

See: "Color Measurement" by David L. MacAdam, chapter 3.2: "Bouguer’s Law"
"""
function i_transmittance_spec(λ::Vector{Real},t::Vector{Real},x::Real)
    return ITSpec(λ, t, x)
end

"""
`i_transmittance_spec(λ,t,d,d0)`

Irregular transmittance spectrum with thickness term `d`. Unit thickness is `d0`, according to Bouguer’s Law/Lambert’s Law.

See: "Color Measurement" by David L. MacAdam, chapter 3.2: "Bougouer’s Law"
"""
function i_transmittance_spec(λ::Vector{Real},t::Vector{Real},d::Real,d0::Real)
    i_transmittance_spec(λ,t,(d/d0))
end