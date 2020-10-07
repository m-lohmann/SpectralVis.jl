abstract type Spectrum end
abstract type SPD <: Spectrum end #Spectral Power Distribution of luminous source
abstract type STD <: Spectrum end #Spectral Transmittance Distribution
abstract type Multispectral <: Spectrum end
abstract type CMatch <: Multispectral end #Color Matching Functions

abstract type SpecEnv end #global settings for spectral calculations

struct SpecEnvironment <: SpecEnv
    λmin
    λmax
    Δλ
end

function specenvironment(λmin,λmax,Δλ)
    SpecEnvironment(λmin,λmax,Δλ)
end

"""
Luminance spectrum
"""
struct LSpec <: SPD
    λs::Real  # start wavelength
    Δλ::Real
    l::Vector{Real}  #luminance vector
end

"""
Irregular Reflectance spectrum
"""
struct ILSpec <: SPD
    λ::Vector{Real}  #wavelength vector
    l::Vector{Real}  #reflectance vector
end

"""
Reflectance spectrum
"""
struct RSpec <: SPD
    λs::Vector{Real}  #wavelength vector
    Δλ::Real          #Δλ
    s::Vector{Real}  #reflectance vector
end

"""
Irregular Reflectance spectrum
"""
struct IRSpec <: SPD
    λ::Vector{Real}  #wavelength vector
    s::Vector{Real}  #reflectance vector
end

"""
Transmittance spectrum
"""
struct TSpec <: STD
    λs::Vector{Real}  #start wavelength
    t::Vector{Real}  #transmittance vector at unit thickness
    Δλ::Real
    D0::Real
    D::Real
    a::Float64       #absorption coefficient

end

"""
LMS cone fundamentals
"""
struct LMSCM <: CMatch
    λ::Vector{Real} #wavelength vector
    l::Vector{Real} #l cone matching function
    m::Vector{Real} #m cone matching function
    s::Vector{Real} #s cone matching function
end

#struct XYZCM <: CMatch
#    λ::Vector{Real} #wavelength vector
#    x::Vector{Real} #x_bar cone matching function
#    y::Vector{Real} #y_bar cone matching function
#    z::Vector{Real} #z_bar cone matching function
#end

struct CIE31 <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #l cone matching function
    y::Vector{Real} #m cone matching function
    z::Vector{Real} #s cone matching function
end

struct CIE64 <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #l cone matching function
    y::Vector{Real} #m cone matching function
    z::Vector{Real} #s cone matching function
end

struct CIE31_J <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #l cone matching function
    y::Vector{Real} #m cone matching function
    z::Vector{Real} #s cone matching function
end

struct CIE64_JV <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #l cone matching function
    y::Vector{Real} #m cone matching function
    z::Vector{Real} #s cone matching function
end

struct CIE06_2 <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #l cone matching function
    y::Vector{Real} #m cone matching function
    z::Vector{Real} #s cone matching function
end

struct CIE06_10 <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #l cone matching function
    y::Vector{Real} #m cone matching function
    z::Vector{Real} #s cone matching function
end