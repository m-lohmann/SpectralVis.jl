"""
`lumminance_spec(λ::Vector{Float64},r::Vector{Float64})`

creates a regular illuminance spectrum of type `RSpec`
"""
function luminance_spec(λs,Δλ,l)
    return LSpec(λs,Δλ,l)
end

"""
`i_luminancespec(λ::Vector{Float64},r::Vector{Float64})`

irregular luminance spectrum of type `RSpec`
"""
function i_luminance_spec(λ,l)
    return LSpec(λ,l)
end

"""
`reflectancespec(λ::Vector{Float64},r::Vector{Float64})`

regular reflectance spectrum of type `RSpec`
"""
function reflectance_spec(λ,Δλ,s)
    return RSpec(λs,Δλ,s)
end

"""
`i_reflectancespec(λ::Vector{Float64},r::Vector{Float64})`

irregular reflectance spectrum of type `RSpec`
"""
function i_reflectance_spec(λ,s)
    return IRSpec(λ,s)
end

#"""
#`transmittancespec(λ::Vector{Float64},r::Vector{Float64})`
#
#regular transmittance spectrum
#"""
#function transmittancespec(λ,Δλ,D0,D,t)
#    return TSpec(collect(λ:Δλ:length(t),Δλ,D0,D,a,t))
#end

function i_transmittance_spec()

end