abstract type Spectrum end
abstract type Multispectral <: Spectrum end # Multispectral types
abstract type CMatch <: Multispectral end #Color Matching Functions (x_bar, y_bar, z_bar)
abstract type ConeFund <: Multispectral end # Cone fundamentals (l, m, s)
abstract type COpp <: Multispectral end # Color opponent channels
# abstract type MSpec <: Multispectral end # Generalized multispectral type, maybe implemented later

"""
`LSpec` Luminance Spectrum

fields:

`λ::Vector{Real}`, vector containing wavelengths

`l::Vector{Real}`, vector containing luminance values
"""
struct LSpec <: Spectrum
    λ::Vector{Real}  #wavelength vector
    l::Vector{Real}  #reflectance vector
    function LSpec(λ, l)
        new(λ, l)
    end
end

"""
`RSpec` Reflectance Spectrum

fields:

`λ::Vector{Real}`, vector containing wavelengths

`r::Vector{Real}, vector containing reflectanceS values
"""
struct RSpec <: Spectrum
    λ::Vector{Real}  #wavelength vector
    r::Vector{Real}  #reflectance vector
    function RSpec(λ, r)
        new(λ, r)
    end
end

"""
`TSpec` Transmittance spectrum

`λ::Vector{Real}`, vector containing wavelengths

`t::Vector{Real}`, vector containing transmittance values

`x::Real`, unit thickness value
"""
struct TSpec <: Spectrum
    λ::Vector{Real}  #start wavelength
    t::Vector{Real}  #transmittance vector at unit thickness
    x::Real          #thickness in terms of unit thickness
    function TSpec(λ, t, x)
        new(λ, t, x)
    end
end

#=  Multispectral types
    These include color matching functions and cone fundamentals defined by the CIE
=#

struct CIE31 <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #x_bar cone matching function
    y::Vector{Real} #y_bar cone matching function
    z::Vector{Real} #z_bar cone matching function
    function CIE31(λ, l, m, s)
        new(λ, l, m, s)
    end
end

struct LMS31 <: ConeFund
    λ::Vector{Real}
    l::Vector{Real}
    m::Vector{Real}
    s::Vector{Real}
    function LMS31(λ, l, m, s)
        new(λ, l, m, s)
    end
end

struct CIE31_J <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #x_bar cone matching function
    y::Vector{Real} #y_bar cone matching function
    z::Vector{Real} #z_bar cone matching function
    function CIE31_J(λ, l, m, s)
        new(λ, l, m, s)
    end
end

struct CIE31_JV <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #x_bar cone matching function
    y::Vector{Real} #y_bar cone matching function
    z::Vector{Real} #z_bar cone matching function
    function CIE31_JV(λ, l, m, s)
        new(λ, l, m, s)
    end
end

struct CIE64 <: CMatch
    λ::Vector{Real} #wavelength vector
    x::Vector{Real} #x_bar cone matching function
    y::Vector{Real} #y_bar cone matching function
    z::Vector{Real} #z_bar cone matching function
    function CIE64(λ, l, m, s)
        new(λ, l, m, s)
    end
end

struct LMS64 <: ConeFund
    λ::Vector{Real}
    l::Vector{Real}
    m::Vector{Real}
    s::Vector{Real}
    function LMS64(λ, l, m, s)
        new(λ, l, m, s)
    end
end

struct CIE12_2 <: CMatch
    λ::Vector{Real} # wavelength vector
    x::Vector{Real} #x_bar cone matching function
    y::Vector{Real} #y_bar cone matching function
    z::Vector{Real} #z_bar cone matching function
    function CIE12_2(λ, l, m, s)
        new(λ, l, m, s)
    end
end

struct CIE12_10 <: CMatch
    λ::Vector{Real} # wavelength vector
    x::Vector{Real} #x_bar cone matching function
    y::Vector{Real} #y_bar cone matching function
    z::Vector{Real} #z_bar cone matching function
    function CIE12_10(λ, l, m, s)
        new(λ, l, m, s)
    end
end

struct LMS06_2 <: ConeFund
    λ::Vector{Real} #wavelength vector
    l::Vector{Real} #l cone response function
    m::Vector{Real} #m cone response function
    s::Vector{Real} #s cone response function
    function LMS06_2(λ, l, m, s)
        new(λ, l, m, s)
    end
end

struct LMS06_10 <: ConeFund
    λ::Vector{Real} #wavelength vector
    l::Vector{Real} #l cone response function
    m::Vector{Real} #m cone response function
    s::Vector{Real} #s cone response function
    function LMS06_10(λ, l, m, s)
        new(λ, l, m, s)
    end
end

struct WSYBRG <: COpp
    λ::Vector{Real}
    Vλ::Vector{Real}
    yb::Vector{Real}
    rg::Vector{Real}
    function WSYBRG(λ, Vλ, yb, rg)
        new(λ, Vλ, yb, rg)
    end
end