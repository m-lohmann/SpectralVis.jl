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