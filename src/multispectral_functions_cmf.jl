#function cmf(::Type{CIE31},λ::Real)
#    λs = 360.0
#    l = Float(length(CMF31[:,1]))
#    λe = λs+(l-1.0)
#    360.0 < λ < 830.0 ? nothing : error("$λ out of defined range $λs...$λe for this CMF!")
#    @inbounds x=CMF31[Int(λ-λs)+1,1]
#    @inbounds y=CMF31[Int(λ-λs)+1,2]
#    @inbounds z=CMF31[Int(λ-λs)+1,3]
#    return CIE31(λ,x,y,z)
#end

"""
`cmf(table)`

Returns the full multispectral matching function from 360.0 to 830.0 nm in 1 nm steps.
"""
function cmf(CMF31)
    return CIE31(collect(360.0:1.0:830.0),CMF31[:,1],CMF31[:,2],CMF31[:,3])
end

#function cmf(::Type{CIE64},λ::Real)
#    380.0 < λ < 780.0 ? error("λ out of defined range for this CMF!") : nothing
#    @inbounds x=CMF64[Int(λ-380.0)+1,1]
#    @inbounds y=CMF64[Int(λ-380.0)+1,2]
#    @inbounds z=CMF64[Int(λ-380.0)+1,3]
#    return CIE64(λ,x,y,z)
#end

function cmf(table)
    if table == CMF31
        return CIE31(collect(360.0:1.0:830.0),CMF31[:,1],CMF31[:,2],CMF31[:,3])
    elseif table == CMF64
        return CIE64(collect(380.0:1:830.0),CMF64[:,1],CMF64[:,2],CMF64[:,3])
    elseif table == CMF31_J
        return CIE31_J(collect(370.0:10:770.0),CMF31_J[:,1],CMF31_J[:,2],CMF31_J[:,3])
    elseif table == CMF31_JV
        return CIE31_JV(collect(380.0:5:780.0),CMF31_JV[:,1],CMF31_JV[:,2],CMF31_JV[:,3])
    elseif table == CMF06_2
        return CIE06_2(collect(380.0:1:780.0),CMF06_2[:,1],CMF06_2[:,2],CMF06_2[:,3])
    elseif table == CMF06_10
        return CIE06_10(collect(380.0:1:780.0),CMF06_10[:,1],CMF06_10[:,2],CMF06_10[:,3])
    else
        error("CMF unknown!")
    end
end