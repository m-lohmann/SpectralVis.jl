function cmf(::Type{CIE31},λ::Real)
    λs = 360.0
    l = Float(length(CMF31[:,1]))
    λe = λs+(l-1.0)
    360.0 < λ < 830.0 ? nothing : error("$λ out of defined range $λs...$λe for this CMF!")
    @inbounds x=CMF31[Int(λ-λs)+1,1]
    @inbounds y=CMF31[Int(λ-λs)+1,2]
    @inbounds z=CMF31[Int(λ-λs)+1,3]
    return CIE31(λ,x,y,z)
end

"""
`cmf(::Type{CIE31})`

Returns the full multispectral CIE1931 color matching function from 360.0 to 830.0 nm in 1 nm steps.
"""
function cmf(::Type{CIE31})
    return CIE31(collect(360.0:1.0:830.0),CMF31[:,1],CMF31[:,2],CMF31[:,3])
end

function cmf(::Type{CIE64},λ::Real)
    380.0 < λ < 780.0 ? error("λ out of defined range for this CMF!") : nothing
    @inbounds x=CMF64[Int(λ-380.0)+1,1]
    @inbounds y=CMF64[Int(λ-380.0)+1,2]
    @inbounds z=CMF64[Int(λ-380.0)+1,3]
    return CIE64(λ,x,y,z)
end

function cmf(::Type{CIE64})
    return CIE64(collect(380.0:1:780.0),CMF64[:,1],CMF64[:,2],CMF64[:,3])
end

"""
`lumminance_spec(λ::Vector{Float64},r::Vector{Float64})`

creates a regular illuminance spectrum of type `RSpec`
"""
function lumminance_spec(λs,Δλ,r)
    λ=Vector{Real}(λs,)
    return LSpec(λ,r)
end

"""
`i_luminancespec(λ::Vector{Float64},r::Vector{Float64})`

irregular luminance spectrum of type `RSpec`
"""
function i_luminancespec(λ,r)
    return LSpec(λ,r)
end

"""
`reflectancespec(λ::Vector{Float64},r::Vector{Float64})`

regular reflectance spectrum of type `RSpec`
"""
function reflectancespec(λs,Δλ,r)
    λ=λs

    return RSpec(λ,r)
end

"""
`i_reflectacespec(λ::Vector{Float64},r::Vector{Float64})`

irregular reflectance spectrum of type `RSpec`
"""
function i_reflectancespec(λ,r)
    return RSpec(λ,r)
end

"""
`normalizespec(s::Spectrum)`

returns a spectrum with reflectance values normalized to 1.0
"""
function normalizespec(s::Spectrum)
    return RSpec(s.λ,s.r ./ maximum(s.r))
end

"""
`blockspec(λmin,λmax,Δλ,λs,λe,mode=1)`
regular block spectrum initialized to 0.0, with blocks λs..λe = 1.0

`blockspec(λmin,λmax,Δλ,λs,λe,mode=0)`
inversed block spectrum initialized to 1.0, with blocks λs..λe = 0.0

"""
function blockspec(λmin,λmax,Δλ,λs,λe,mode=1)
    r= mode == 1 ? zeros(Float64, Int(1.0+(λmax-λmin)/Δλ)) : ones(Float64,Int(1.0+(λmax-λmin)/Δλ))
    @inbounds for n = λs:Δλ:λe
        r[Int((n-λmin)/Δλ)+1]= mode==1 ? 1.0 : 0.0
    end
    block=reflectspec(λmin,λmax,Δλ,r)
end

