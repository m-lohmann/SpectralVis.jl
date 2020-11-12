"""
`normalizespec(s::Spectrum)`

returns a spectrum with reflectance values normalized to 1.0
"""
function normalize_spec(s::Spectrum)
    res=Spectrum
    typeof(Spectrum) == IRSpec ? (IRSpec(s.λ,s.r ./ maximum(s.r))) : (ILSpec(s.λ,s.l ./ maximum(s.l)))
end

function normalize_spec(s::Spectrum,value::Real)
    res=Spectrum
    typeof(Spectrum) == IRSpec ? (IRSpec(s.λ,s.r ./ value)) : (ILSpec(s.λ,s.l ./ value))
end


"""
`hardlimit_spec(s::Spectrum,limit::Real)`

limit spectrum to `limit`
"""
function hardlimit_spec(s::Spectrum,limit=1.0)
    typeof(s) == RSpec ? reflectance_spec(s.λ,clamp.(s.r,0.0,limit),Δλ) :
    typeof(s) == IRSpec ? i_reflectance_spec(s.λ,clamp.(s.r,0.0,limit)) :
    typeof(s) == LSpec ? luminance_spec(s.λ,clamp.(s.l,0.0,limit),Δλ) :
    typeof(s) == ILSpec ? i_luminance_spec(s.λ,clamp.(s.l,0.0,limit)) :
    typeof(s) == ITSpec ? i_transmittance_spec(s.λ,clamp.(s.t,0.0,limit),s.x) :
    error("Wrong Type!")
end