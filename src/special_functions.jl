"""
`normalizespec(s::Spectrum)`

returns a spectrum with reflectance values normalized to 1.0
"""
function normalize_spec(s::Spectrum)
    res=Spectrum
    typeof(Spectrum) == RSpec ? (RSpec(s.λ,s.r ./ maximum(s.r))) : (LSpec(s.λ,s.l ./ maximum(s.l)))
end

"""
`normalize_spec(s::Spectrum,value::Real)`

returns a spectrum with reflectance distribution normalized to `value`
"""
function normalize_spec(s::Spectrum,value::Real)
    res=Spectrum
    typeof(Spectrum) == RSpec ? (RSpec(s.λ,s.r ./ value)) : (LSpec(s.λ,s.l ./ value))
end

"""
`hardlimit_spec(s::Spectrum,limit::Real)`

limits a spectrum to `limit`

Default limit is `1.0`
"""
function hardlimit_spec(s::Spectrum,limit=1.0)
    typeof(s) == RSpec ? reflectance_spec(s.λ,clamp.(s.r,0.0,limit)) :
    typeof(s) == RSpec ? reflectance_spec(s.λ,clamp.(s.r,0.0,limit)) :
    typeof(s) == LSpec ? luminance_spec(s.λ,clamp.(s.l,0.0,limit)) :
    typeof(s) == LSpec ? luminance_spec(s.λ,clamp.(s.l,0.0,limit)) :
    typeof(s) == TSpec ? transmittance_spec(s.λ,clamp.(s.t,0.0,limit),s.x) :
    error("Wrong Type!")
end

"""
`adapt_spec(spec::Spectrum,specenv::SpecEnvironment,interporder...)`

adapts spectra according to the spectral environment.

Arguments for `interporder...`:

`:linear` for linear splines

`:quadratic` for quadratic splines

`:cubic, :natural` for natural cubic splines (zero curvature at boundaries)

`:cubic, :periodic` for periodic cubic splines (both endpoints must have same value)

`:cubic, :clamped, slope_start, slope_end` for clamped cubic splines with defined slopes at boundaries

`:cubic, :constrained` for cubic constrained splines

**Output**

Output corresponds to input spectrum type:
    `RSpec`, `LSpec`, `TSpec`
"""
function adapt_spec(spec::Spectrum,specenv::SpecEnvironment,interporder...)
    # get environment variables
    lmin=specenv.λmin
    dlam=specenv.Δλ
    lmax=specenv.λmax
    extr=specenv.ex
    x=Vector{Real}()
    y=Vector{Real}()
    # adapt spectrum
    λ=spec.λ
    st=typeof(spec)
    if st == LSpec
        s=spec.l
    elseif st == RSpec
        s=spec.r
    elseif st == TSpec
        s=spec.t
    end
    
    if interporder[1] == :linear
        spl=linearspline(λ,s)
    elseif interporder[1] == :quadratic
        spl=quadraticspline(λ,s)
    elseif interporder[1] == :cubic
        if interporder[2] == :natural
            spl=cubicspline(λ,s,:natural)
        elseif interporder[2] == :periodic
            spl=periodicspline(x,y)
        elseif interporder[2] == :clamped
            spl=clampedspline(λ,s,interporder[3],interporder[4])
        elseif interporder[2] == :constrained
            spl=constrainedspline(λ,s)
        else
            error("Cubic interpolation style $(interporder[2]) does not exist!")
        end
    else error("Interpolation type $(interporder[1]) does not exist!")
    end
    x,y= interp(spl,(lmin:dlam:lmax))
    if typeof(spec) == LSpec
        luminance_spec(x,y)
    elseif typeof(spec) == RSpec
        reflectance_spec(x,y)
    elseif typeof(spec) == TSpec
        transmittance_spec(x,y,spec.x)
    else nothing
    end
end

"""
`shift_spec(spec::Spectrum,Δλ)`

returns spectrum of same type, shifted by Δλ
"""
function shift_spec(spec::Spectrum,Δλ)
    if typeof(spec) == LSpec
        return LSpec(spec.λ.+Δλ,spec.l)
    elseif typeof(spec) == RSpec
        return RSpec(spec.λ.+λ,spec.r)
    end
end

function shift_cmf(cmf::ConeFund,conetype::Symbol,Δλ)
    if conetype == :l
    elseif conetype ==:m
    elseif conetype ==:s
    else error("Cone type $conetype does not exist!")
    end
end

"""
`spline_extrap(Spl, env=SPECENV)`

extrapolation of a spline according to spectral environment.
"""
function spec_extrapolate(spec::Spectrum, env=SPECENV)
    
    SSpline.extrapolate(spec, env.λmin:env.λmax, env.ex)
end
