#function cmf(::Type{CIE31},λ::Real)
#    λs = 360.0
#    l = Float(length(CMF1931[:,1]))
#    λe = λs+(l-1.0)
#    360.0 < λ < 830.0 ? nothing : error("$λ out of defined range $λs...$λe for this CMF!")
#    @inbounds x=CMF1931[Int(λ-λs)+1,1]
#    @inbounds y=CMF1931[Int(λ-λs)+1,2]
#    @inbounds z=CMF1931[Int(λ-λs)+1,3]
#    return CIE31(λ,x,y,z)
#end

"""
`cmf(table)`

Returns the full multispectral matching functions based on the CMF data in `cmf_tables.jl`

"""
function cmf(table)
    if table == CMF1931
        CIE31(CMF1931[:,1],CMF1931[:,2],CMF1931[:,3],CMF1931[:,4])
    elseif table == CMF1964
        CIE64(CMF1964[:,1],CMF1964[:,2],CMF1964[:,3],CMF1964[:,4])
    elseif table == CMF1931_J
        CIE31_J(CMF1931_J[:,1],CMF1931_J[:,2],CMF1931_J[:,3],CMF1931_J[:,4])
    elseif table == CMF1931_JV
        CIE31_JV(CMF1931_JV[:,1],CMF1931_JV[:,2],CMF1931_JV[:,3],CMF1931_JV[:,4])
    elseif table == CMF2012_2
        CIE12_2(CMF2012_2[:,1],CMF2012_2[:,2],CMF2012_2[:,3],CMF2012_2[:,4])
    elseif table == CMF2012_10
        CIE12_10(CMF2012_10[:,1],CMF2012_10[:,2],CMF2012_10[:,3],CMF2012_10[:,4])
    elseif table == LMS2006_2
        LMS06_2(LMS2006_2[:,1],LMS2006_2[:,2],LMS2006_2[:,3],LMS2006_2[:,4])
    elseif table == LMS2006_10
        LMS06_10(LMS2006_10[:,1],LMS2006_10[:,2],LMS2006_10[:,3],LMS2006_10[:,4])
    else
        error("CMF unknown!")
    end
end