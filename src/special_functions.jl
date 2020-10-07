"""
`normalizespec(s::Spectrum)`

returns a spectrum with reflectance values normalized to 1.0
"""
function normalize_spec(s::Spectrum)
    return RSpec(s.λ,s.r ./ maximum(s.r))
end

"""
`blockspec(λmin,λmax,Δλ,λs,λe,mode=1)`
regular `block spectrum` initialized to 0.0, with blocks λs..λe = 1.0

`blockspec(λmin,λmax,Δλ,λs,λe,mode=0)`
inversed `block spectrum` initialized to 1.0, with blocks λs..λe = 0.0

"""
function block_spec(λmin,λmax,Δλ,λs,λe,mode=1)
    r= mode == 1 ? zeros(Float64, Int(1.0+(λmax-λmin)/Δλ)) : ones(Float64,Int(1.0+(λmax-λmin)/Δλ))
    @inbounds for n = λs:Δλ:λe
        r[Int((n-λmin)/Δλ)+1] = mode==1 ? 1.0 : 0.0
    end
    λ = collect(λs:Δλ:λe)
    reflectance_spec(λ,r)
end

"""
LED spectrum simulation
λ0 = peak wavelength
Δλ1_2 = half spectral width
"""
function led_spec(λmin,λmax,Δλ,λ0,Δλ1_2)
    λ = collect(λmin:Δλ:λmax)
    n = length(λ)
    l = zeros(n)
    for i in 1:n
        l[i] = led(λ[i],λ0,Δλ1_2)
    end
    return ILSpec(λ,l)
end

"""
LED function
"""
function led(λ,λ0,Δλ1_2)
    s_led = (ghelp(λ,λ0,Δλ1_2) + 2.0 * ghelp(λ,λ0,Δλ1_2)^5.0)/3.0
end

"""
LED helper function
"""
function ghelp(λ,λ0,Δλ1_2)
    ghelp = exp(-((λ-λ0)/Δλ1_2)^2.0)
end