abstract type Spectrum end
abstract type SPD <: Spectrum end #Spectral Power Distribution of luminous source
abstract type STD <: Spectrum end #Spectral Transmittance Distribution
abstract type Multispectral <: Spectrum end
abstract type CMatch <: Multispectral end #Color Matching Functions
abstract type ConeFund <: Multispectral end # Cone fundamentals (lms)

abstract type SpecEnv end #global settings for spectral calculations

mutable struct SpecEnvironment <: SpecEnv
    λmin::Real
    λmax::Real
    Δλ::Real
    extrapolate::AbstractString
    function SpecEnvironment(λmin,Δλ,λmax,extrapolate)
        new(λmin,Δλ,λmax,extrapolate)
    end
end

"""
`set_env(λmin=390.0,Δλ,λmax=830.0,extrap="zero")`

Initializes the environment to standard values:

λmin = 380.0 nm
λmax = 780.0 nm
Δλ   =   1.0 nm
extr = "zero"
"""
function set_specenv(λmin=390.0,Δλ=1.0,λmax=830.0,extrapolate="zero")
    SpecEnvironment(λmin,Δλ,λmax,extrapolate)
end

global SPECENV=set_specenv()

"""
`set_extrapolationmode(e::AbstractString,env)`

Sets the extrapolation mode of the environment `env` to one of the available extrapolation settings:

`"none"` or `"zero"`: out of range values are zero.

`constant`: out of range values are set to λmin and λmax, respectively.

`"linear"`: out of range values are linearly extrapolated through the first/last two data points.

`"parabolic"`: out fo range values are extrapolated with a parabola through the first/last three datapoints. *Recommended extrapolation method according to D.L. MacAdams* in "Color Measurement", chapter 5.4 *"Truncations"*.
"""
function set_extrapolationmode(e::AbstractString,env::SpecEnvironment)
    e == "none" || "zero" ? env.extrapolate="none" : # sets out of range values to zero
    e == "constant" ? env.extrapolate="constant" : #sets out of range values to λmin and λmax, respectively
    e == "linear" ? env.extrapolate="linear" : # linear extrapolation through the first/last two data points
    e == "parabolic" ? env.extrapolate="parabolic" : # parabolic runout, through the first/last 3 data points
    error("Extrapolation mode does not exist!")
end

"""
`ILSpec` Irregular Luminance Spectrum

fields:

`λ::Vector{Real}`, vector containing wavelengths
l::Vector{Real}, vector containing luminance values
"""
struct ILSpec <: SPD
    λ::Vector{Real}  #wavelength vector
    l::Vector{Real}  #reflectance vector
    function ILSpec(λ,l)
        new(λ,l)
    end
end

"""
`IRSpec` Irregular Reflectance Spectrum

fields:

`λ::Vector{Real}`, vector containing wavelengths
`r::Vector{Real}, vector containing reflectanceS values
"""
struct IRSpec <: SPD
    λ::Vector{Real}  #wavelength vector
    r::Vector{Real}  #reflectance vector
    function IRSpec(λ,r)
        new(λ,r)
    end
end

"""
Irregular transmittance spectrum
"""
struct ITSpec <: STD
    λ::Vector{Real}  #start wavelength
    t::Vector{Real}  #transmittance vector at unit thickness
    x::Real          #thickness in terms of unit thickness
    function ITSpec(λ,t,x)
        new(λ,t,x)
    end
end

struct CIE31 <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #l cone matching function
    y::Vector{Real} #m cone matching function
    z::Vector{Real} #s cone matching function
    function CIE31(λ,x,y,z)
        new(λ,x,y,z)
    end
end

struct CIE31_J <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #l cone matching function
    y::Vector{Real} #m cone matching function
    z::Vector{Real} #s cone matching function
    function CIE31_J(λ,x,y,z)
        new(λ,x,y,z)
    end
end

struct CIE31_JV <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #l cone matching function
    y::Vector{Real} #m cone matching function
    z::Vector{Real} #s cone matching function
    function CIE31_JV(λ,x,y,z)
        new(λ,x,y,z)
    end
end

struct CIE64 <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #l cone matching function
    y::Vector{Real} #m cone matching function
    z::Vector{Real} #s cone matching function
    function CIE64(λ,x,y,z)
        new(λ,x,y,z)
    end
end

struct CIE12_2 <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #l cone matching function
    y::Vector{Real} #m cone matching function
    z::Vector{Real} #s cone matching function
    function CIE12_2(λ,x,y,z)
        new(λ,x,y,z)
    end
end

struct CIE12_10 <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #l cone matching function
    y::Vector{Real} #m cone matching function
    z::Vector{Real} #s cone matching function
    function CIE12_10(λ,x,y,z)
        new(λ,x,y,z)
    end
end

struct LMS06_2 <: ConeFund
    λ::Vector{Real} #wavelength vector
    l::Vector{Real} #l cone matching function
    m::Vector{Real} #m cone matching function
    s::Vector{Real} #s cone matching function
    function LMS06_2(λ,l,m,s)
        new(λ,l,m,s)
    end
end

struct LMS06_10 <: ConeFund
    λ::Vector{Real} #wavelength vector
    l::Vector{Real} #l cone matching function
    m::Vector{Real} #m cone matching function
    s::Vector{Real} #s cone matching function
    function LMS06_10(λ,l,m,s)
        new(λ,l,m,s)
    end
end