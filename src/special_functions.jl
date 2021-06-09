"""
`normalize_spec(s::Spectrum)`

returns a spectrum with reflectance values normalized to 1.0
"""
function normalize_spec(s::Spectrum)
    isa(s, LSpec) ? normalize_spec(s, maximum(s.l)) :
    isa(s, RSpec) ? normalize_spec(s, maximum(s.r)) :
    isa(s, TSpec) ? normalize_spec(s, maximum(s.t)) :
    nothing
end

"""
`normalize_spec(s::Spectrum,value::Real)`

returns a spectrum with reflectance distribution normalized to `value` relative to max.
"""
function normalize_spec(s::Spectrum,value::Real)
    isa(s, RSpec) ? reflectance_spec(s.λ, s.r ./ (maximum(s.r) ./ value)) :
    isa(s, LSpec) ? luminance_spec(s.λ, s.l ./ (maximum(s.l) ./ value)) :
    isa(s, TSpec) ? transmittance_spec(s.λ, s.t ./ (maximum(s.t) ./ value), 1.0) : nothing
end

"""
`normalize_D_series(s::Spectrum)`

normalize a D_series spectrum to 1.0 at 560 nm.
"""
function normalize_D_series(s::Spectrum)
    luminance_spec(s.λ, s.l ./ s.l[53])
end

"""
`normalize_blackbody(s::Spectrum)`

normalize a blackbody spectrum analogous to D series to 1.0 at 560 nm.
"""
function normalize_blackbody(s::Spectrum)
    ind = findfirst(isequal(560.0), s.λ)
    luminance_spec(s.λ, s.l ./ s.l[ind])
end

"""
`hardlimit_spec(s::Spectrum,limit::Real)`

limits a spectrum to `limit`

Default limit is `1.0`
"""
function hardlimit_spec(s::Spectrum,limit=1.0)
    isa(s, RSpec) ? reflectance_spec(s.λ,clamp.(s.r, 0.0, limit)) :
    isa(s, LSpec) ? luminance_spec(s.λ,clamp.(s.l, 0.0, limit)) :
    isa(s, TSpec) ? transmittance_spec(s.λ,clamp.(s.t, 0.0, limit), s.x) :
    throw(TypeError(:hardlimit_spec, "s", Spectrum, typeof(s)))
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
    #extr=specenv.ex
    x=Vector{Real}()
    y=Vector{Real}()
    # adapt spectrum
    λ = spec.λ
    st = typeof(spec)
    if st == LSpec
        s = spec.l
    elseif st == RSpec
        s = spec.r
    elseif st == TSpec
        s = spec.t
    end
    
    if interporder[1] == :linear
        spl = linearspline(λ, s)
    elseif interporder[1] == :quadratic
        spl = quadraticspline(λ, s)
    elseif interporder[1] == :cubic
        if interporder[2] == :natural
            spl = cubicspline(λ, s, :natural)
        elseif interporder[2] == :periodic
            spl = periodicspline(x, y)
        elseif interporder[2] == :clamped
            spl = clampedspline(λ, s, interporder[3], interporder[4])
        elseif interporder[2] == :constrained
            spl = constrainedspline(λ, s)
        else
            error("Cubic interpolation style $(interporder[2]) does not exist!")
        end
    else error("Interpolation type $(interporder[1]) does not exist!")
    end
    x, y = interp(spl,(lmin:dlam:lmax))
    if typeof(spec) == LSpec
        luminance_spec(x, y)
    elseif typeof(spec) == RSpec
        reflectance_spec(x, y)
    elseif typeof(spec) == TSpec
        transmittance_spec(x, y, spec.x)
    else nothing
    end
end

"""
`shift_spec(spec::Spectrum,Δλ)`

returns spectrum of same type, shifted by Δλ
"""
function shift_spec(spec::Spectrum, Δλ)
    if isa(spec, LSpec)
        return luminance_spec(spec.λ .+ Δλ, spec.l)
    elseif isa(spec, LSpec)
        return reflectance_spec(spec.λ .+ λ, spec.r)
    end
end


"""
`shift_colormatch(cmf::ConeFund,conetype::Symbol,Δλ)`

returns cone fundamental with shifted cone response function `l`, `m`, or `s`.

cone types: `:l`, `:m`, `:s`

Result: `CMatch`
"""
function shift_colormatch(conefund::ConeFund, conetype::Symbol,Δλ::Real)
    if conetype == :l
        a = conefund.l
    elseif conetype == :m
        a = conefund.m
    elseif conetype == :s
        a = conefund.s
    else
        DomainError(conetype, "Cone type does not exist.")
    end

    senv = SPECENV

    shifted = shift_spec(luminance_spec(conefund.λ, a), Δλ)
    shiftspl = cubicspline(shifted.λ, shifted.l, :natural)
    extr = extrapolate(shiftspl, senv.λmin:senv.λmax, :linear)
    l, v = interp(extr, senv.λmin:senv.Δλ:senv.λmax)
    cmftype = typeof(conefund)
    if conetype == :l
        return cmftype(l, v, conefund.m, conefund.s)
    elseif conetype == :m
        return cmftype(l, conefund.l, v, conefund.s)
    else
        return cmftype(l, conefund.l, conefund.m, v)
    end
end


"""
`shift_colormatch(cmf::CMatch, conetype::Symbol, Δλ)`

returns cone fundamental associated with the given CMF, with shifted cone response function `l`, `m`, or `s`

cone types: `:l`, `:m`, `:s`

Result: `CMatch`
"""
function shift_colormatch(cmf::CMatch, conetype::Symbol, Δλ::Real)
    isa(cmf, CIE31) ? conefund = :lms31 :
    isa(cmf, CIE64) ? conefund = :lms64 :
    isa(cmf, CIE12_2) ? conefund = :lms06_2 :
    isa(cmf, CIE12_10) ? conefund = :lms06_10 :
    DomainError(cmf, "CMF can’t be converted to cone fundamental.")
    shift_colormatch(conefund, conetype, Δλ)
end


"""
`deactivate_cone(cmf::ConeFund, conetype::Symbol`

returns cone fundamental either `l`, `m`, or `s` cone function deactivated.

cone types: `:l`, `:m`, `:s`

Result: `CMatch`
"""
function deactivate_cone(cmf, conetype::Symbol)
    isa(cmf, SpectralVis.CMatch) ? cmf=conefund(cmf) : nothing

    conetype in (:l, :m, :s) ? nothing : DomainError(conetype,"Cone type does not exist.")
    cmftype = typeof(cmf)

    if conetype == :l
        cmftype(cmf.λ, zeros(length(cmf.λ)), cmf.m, cmf.s)
    elseif conetype == :m
        cmftype(cmf.λ, cmf.l, zeros(length(cmf.λ)), cmf.s)
    else
        cmftype(cmf.λ, cmf.l, cmf.m, zeros(length(cmf.λ)))
    end
end

# cpspline2=cubicspline(macbeth_colorpatch.λ,macbeth_colorpatch.r,:natural)
# cpextr2=extrap(cpspline2,390.0:830.0,:linear)
# l2,s2 = interp(cpextr2,(390.0:1.0:830.0))
# colorpatch2=reflectance_spec(l2,s2)


"""
`deactivate_cone(conetype::Symbol`

returns cone fundamental either `l`, `m`, or `s` cone function deactivated.

cone types: `:l`, `:m`, `:s`

Result: `CMatch`
"""
function deactivate_cone(conetype::Symbol)
    deactivate_cone(SPECENV.cmf, conetype)
end

"""
`spline_extrap(Spl, env=SPECENV)`

extrapolation of a spline according to spectral environment.
"""
function spec_extrapolate(spec::Spectrum, env=SPECENV)
    
    SSpline.splextrapolate(spec, env.λmin:env.λmax, env.ex)
end