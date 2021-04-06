abstract type Multispectral <: Spectrum end
abstract type CMatch <: Multispectral end #Color Matching Functions
abstract type ConeFund <: Multispectral end # Cone fundamentals (lms)

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