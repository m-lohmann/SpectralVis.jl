# """
# `normalize_spec(s::Spectrum)`
# 
# returns a spectrum with reflectance values normalized to 1.0
# """
# function normalize_spec(s::Spectrum)
#     isa(s, LSpec) ? normalize_spec(s, maximum(s.l)) :
#     isa(s, RSpec) ? normalize_spec(s, maximum(s.r)) :
#     isa(s, TSpec) ? normalize_spec(s, maximum(s.t)) : nothing
# 
#     #isa(s, LSpec) ? luminance_spec(s.λ, s.l ./ maximum(s.l)) :
#     #isa(s, RSpec) ? reflectance_spec(s.λ, s.r ./ maximum(s.r)) :
#     #isa(s, TSpec) ? transmittance_spec(s.λ, s.t ./ maximum(s.t)) : nothing
# end


"""
`normalize_spec(s::Spectrum,value::Real)`

returns a spectrum with reflectance distribution normalized to `value`.
"""
function normalize_spec(s::Spectrum, value = 1.0)
    isa(s, RSpec) ? reflectance_spec(s.λ, s.l ./ (maximum(s.r) * value)) :
    isa(s, LSpec) ? luminance_spec(s.λ, s.l ./ (maximum(s.l) * value)) :
    isa(s, TSpec) ? transmittance_spec(s.λ, s.l ./ (maximum(s.t) * value)) : nothing
end


"""
`normalize_D_series(s::Spectrum)`

normalize a D_series spectrum to 1.0 at 560 nm.
"""
function normalize_D_series(s::Spectrum)
    luminance_spec(s.λ, s.l ./ s.l[53])
end


"""
    `normalize_blackbody(env = SPECENV, T::Real)`

Normalize a blackbody spectrum analogous to D series to 1.0 at 560 nm.
"""
function normalize_blackbody(T::Real, env = SPECENV)
    s = blackbody_illuminant(env, T)
    ind = findfirst(isequal(560.0), s.λ)
    luminance_spec(s.λ, s.l ./ s.l[ind])
end


"""
    `hardlimit_spec(s::Spectrum,limit::Real = 1.0)`

Hardlimits an SPD to the maximum value `limit`.

Default limit is `1.0`

# Examples

```jldoctest
julia> hardlimit_spec(D50_illuminant())
LSpec(Real[390.0, 391.0, 392.0, 393.0, 394.0, 395.0, 396.0, 397.0, 398.0, 399.0  …  821.0, 822.0, 823.0, 824.0, 825.0, 826.0, 827.0, 828.0, 829.0, 830.0], Real[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0  …  1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0])

julia> hardlimit_spec(D_series_illuminant(6500),59.0)
LSpec(Real[390.0, 391.0, 392.0, 393.0, 394.0, 395.0, 396.0, 397.0, 398.0, 399.0  …  821.0, 822.0, 823.0, 824.0, 825.0, 826.0, 827.0, 828.0, 829.0, 830.0], Real[54.60212796545921, 57.41151658372402, 59.0, 59.0, 59.0, 59.0, 59.0, 59.0, 59.0, 59.0  …  57.744482738230694, 58.03176686777033, 58.319050997309965, 58.6063351268496, 58.893619256389236, 59.0, 59.0, 59.0, 59.0, 59.0])
```
"""
function hardlimit_spec(s::Spectrum, limit::Real = 1.0)
    isa(s, RSpec) ? reflectance_spec(s.λ,clamp.(s.r, 0.0, limit)) :
    isa(s, LSpec) ? luminance_spec(s.λ,clamp.(s.l, 0.0, limit)) :
    isa(s, TSpec) ? transmittance_spec(s.λ,clamp.(s.t, 0.0, limit), s.x) :
    throw(TypeError(:hardlimit_spec, "s", Spectrum, typeof(s)))
end


"""
    `adapt_spec(spec::Spectrum, specenv::SpecEnvironment = SPECENV, extraptype::Symbol = specenv.ex, interporder...)`

adapts spectra according to the spectral environment.

Arguments for `extraptype`:
* `:zero`, sets SPD outside the data range to zero.
* `:boundary`, sets SPD outside the data range to boundary values.
* `:linear`, linear extrapolation of SPD.
* `:quadratic`, quadratic extrapolation of SPD.

Arguments for `interporder...`:

* `:linear` for linear splines
* `:quadratic` for quadratic splines
* `:cubic, :natural` for natural cubic splines (zero curvature at boundaries).
* `:cubic, :periodic` for periodic cubic splines (both endpoints must have same value).
* `:cubic, :clamped, slope_start, slope_end` for clamped cubic splines with defined slopes at boundaries.
* `:cubic, :constrained` for cubic constrained splines.

# Examples

```jldoctest
julia> adapt_spec(agfait(2), SPECENV, :linear, :cubic, :natural)
RSpec(Real[390.0, 391.0, 392.0, 393.0, 394.0, 395.0, 396.0, 397.0, 398.0, 399.0  …  821.0, 822.0, 823.0, 824.0, 825.0, 826.0, 827.0, 828.0, 829.0, 830.0], Real[0.06193665145465862, 0.06273298630919276, 0.06352932116372689, 0.06432565601826104, 0.06512199087279517, 0.06591832572732931, 0.06671466058186346, 0.06751099543639759, 0.06830733029093172, 0.06910366514546587  …  0.44181513985324095, 0.444222702992524, 0.4466302661318069, 0.4490378292710899, 0.45144539241037296, 0.4538529555496559, 0.4562605186889389, 0.45866808182822183, 0.46107564496750486, 0.4634832081067878])

julia> adapt_spec(D65_illuminant(), SPECENV, :zero, :cubic, :clamped, 0.0, 0.0)
LSpec(Real[390.0, 391.0, 392.0, 393.0, 394.0, 395.0, 396.0, 397.0, 398.0, 399.0  …  821.0, 822.0, 823.0, 824.0, 825.0, 826.0, 827.0, 828.0, 829.0, 830.0], Real[54.666490682108055, 57.4776549221071, 60.288819162106144, 63.099983402105195, 65.91114764210424, 68.72231188210328, 71.53347612210233, 74.34464036210137, 77.15580460210042, 79.96696884209946  …  57.72152419756936, 58.00867916043931, 58.29583412330925, 58.5829890861792, 58.870144049049145, 59.15729901191909, 59.44445397478904, 59.73160893765898, 60.01876390052893, 0.0])
```
"""
function adapt_spec(spec::Spectrum, specenv::SpecEnvironment = SPECENV, extraptype::Symbol = specenv.ex, interporder...)
    # get environment variables
    lmin=specenv.λmin
    dlam=specenv.Δλ
    lmax=specenv.λmax
    xrange = lmin:lmax
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
            throw(DomainError(interporder[2],"Cubic interpolation style does not exist!"))
        end
    elseif interporder[1] == :hermite
        if length(interporder) == 1
            spl = hermitespline(λ, s, :kruger)
        elseif length(interporder) == 2
            spl = hermitespline(λ, s, interporder[2])
        else
            spl = hermitespline(λ, s, interporder[2], interporder[3])
        end
    else throw(DomainError(interporder[1], "Interpolation type does not exist!"))
    end
    espl = extrapolate(spl, xrange, extraptype)
    x, y = interp(espl,(lmin:dlam:lmax))

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
    shift_spec(spec::Spectrum,Δλ)

Returns spectrum of same type, shifted by Δλ
"""
function shift_spec(spec::Spectrum, Δλ)
    if isa(spec, LSpec)
        return luminance_spec(spec.λ .+ Δλ, spec.l)
    elseif isa(spec, LSpec)
        return reflectance_spec(spec.λ .+ λ, spec.r)
    end
end


"""
    shift_colormatch(cmf::ConeFund,conetype::Symbol,Δλ)

returns cone fundamental with shifted cone response function `l`, `m`, or `s`.

cone types: `:l`, `:m`, `:s`

Result: `CMatch`
"""
function shift_cone(conefund::ConeFund, conetype::Symbol,Δλ::Real)
    if conetype == :l
        a = conefund.l
    elseif conetype == :m
        a = conefund.m
    elseif conetype == :s
        a = conefund.s
    else
        throw(DomainError(conetype, "Cone type does not exist."))
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
    shift_colormatch(cmf::CMatch, conetype::Symbol, Δλ)

returns cone fundamental associated with the given CMF, with shifted cone response function `l`, `m`, or `s`

cone types: `:l`, `:m`, `:s`

Result: `CMatch`
"""
function shift_cone(cmf::CMatch, conetype::Symbol, Δλ::Real)
    isa(cmf, CIE31) ? conefund = :lms31 :
    isa(cmf, CIE64) ? conefund = :lms64 :
    isa(cmf, CIE12_2) ? conefund = :lms06_2 :
    isa(cmf, CIE12_10) ? conefund = :lms06_10 :
    throw(DomainError(cmf, "CMF can’t be converted to cone fundamental."))
    shift_cone(conefund, conetype, Δλ)
end


"""
    deactivate_cone(cmf::ConeFund, conetype::Symbol)

returns cone fundamental either `l`, `m`, or `s` cone function deactivated.

cone types: `:l`, `:m`, `:s`

Result: `CMatch`
"""
function deactivate_cone(cmf, conetype::Symbol)
    isa(cmf, SpectralVis.CMatch) ? cmf=conefund(cmf) : nothing

    conetype in (:l, :m, :s) ? nothing : throw(DomainError(conetype,"Cone type does not exist."))
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
    deactivate_cone(conetype::Symbol

returns cone fundamental either `l`, `m`, or `s` cone function deactivated.

cone types: `:l`, `:m`, `:s`

Result: `CMatch`
"""
function deactivate_cone(conetype::Symbol)
    deactivate_cone(SPECENV.cmf, conetype)
end


"""
    spline_extrap(Spl, env=SPECENV)

extrapolation of a spline according to spectral environment.
"""
function spec_extrapolate(spec::Spectrum, env=SPECENV)
    
    SSpline.splextrapolate(spec, env.λmin:env.λmax, env.ex)
end