abstract type Spectrum end
abstract type SPD <: Spectrum end #Spectral Power Distribution of luminous source
abstract type STD <: Spectrum end #Spectral Transmittance Distribution

"""
`LSpec` Luminance Spectrum

fields:

`λ::Vector{Real}`, vector containing wavelengths

`l::Vector{Real}`, vector containing luminance values
"""
struct LSpec <: SPD
    λ::Vector{Real}  #wavelength vector
    l::Vector{Real}  #reflectance vector
    function LSpec(λ,l)
        new(λ,l)
    end
end

"""
`RSpec` Reflectance Spectrum

fields:

`λ::Vector{Real}`, vector containing wavelengths

`r::Vector{Real}, vector containing reflectanceS values
"""
struct RSpec <: SPD
    λ::Vector{Real}  #wavelength vector
    r::Vector{Real}  #reflectance vector
    function RSpec(λ,r)
        new(λ,r)
    end
end

"""
`TSpec` Transmittance spectrum

`λ::Vector{Real}`, vector containing wavelengths

`t::Vector{Real}`, vector containing transmittance values

`x::Real`, unit thickness value
"""
struct TSpec <: STD
    λ::Vector{Real}  #start wavelength
    t::Vector{Real}  #transmittance vector at unit thickness
    x::Real          #thickness in terms of unit thickness
    function TSpec(λ,t,x)
        new(λ,t,x)
    end
end