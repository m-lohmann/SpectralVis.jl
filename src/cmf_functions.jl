"""
    cmfunc(match::Symbol)

Returns the full multispectral matching functions based on the CMF data in `cmf_tables.jl`

Possible `match` symbols:

* `:cie31`, CIE1931 2° observer
* `:cie64`, CIE1964 10° observer
* `:cie31_j`, CIE1931 observer with corrections by Judd
* `:cie31_jv`, CIE1964 observer wtih correction by Judd and Vos
* `:cie12_2`, CIE2012 2° observer (current CIE 2° standard observer)
* `:cie12_10`, CIE2012 10° observer (current CIE 10° standard observer)

# Example

```jldoctest
julia> cmfunc(:cie12_2)
CIE12_2(Real[390.0, 391.0, 392.0, 393.0, 394.0, 395.0, 396.0, 397.0, 398.0, 399.0  …  821.0, 822.0, 823.0, 824.0, 825.0, 826.0, 827.0, 828.0, 829.0, 830.0], Real[0.003769647, 0.004532416, 0.005446553, 0.006538868, 0.007839699, 0.009382967, 0.01120608, 0.01334965, 0.0158569, 0.01877286  …  2.986206e-6, 2.814999e-6, 2.653663e-6, 2.501725e-6, 2.358723e-6, 2.224206e-6, 2.097737e-6, 1.978894e-6, 1.867268e-6, 1.762465e-6], Real[0.0004146161, 0.0005028333, 0.0006084991, 0.0007344436, 0.0008837389, 0.001059646, 0.001265532, 0.001504753, 0.001780493, 0.002095572  …  1.190771e-6, 1.123031e-6, 1.059151e-6, 9.989507e-7, 9.422514e-7, 8.888804e-7, 8.38669e-7, 7.914539e-7, 7.47077e-7, 7.05386e-7], Real[0.0184726, 0.02221101, 0.02669819, 0.03206937, 0.03847832, 0.04609784, 0.05511953, 0.06575257, 0.07822113, 0.09276013  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
```
"""
function cmfunc(match::Symbol)
    if match in (:cie31, :cie64, :cie12_2, :cie12_10, :cie12_2, :cie12_10)
        if match == :cie31
            CIE31(CMF1931[:, 1], CMF1931[:, 2], CMF1931[:, 3], CMF1931[:, 4])
        elseif match == :cie64
            CIE64(CMF1964[:, 1], CMF1964[:, 2], CMF1964[:, 3], CMF1964[:, 4])
        elseif match == :cie31_j
            CIE31_J(CMF1931_J[:, 1], CMF1931_J[:, 2], CMF1931_J[:, 3], CMF1931_J[:, 4])
        elseif match == :cie31_jv
            CIE31_JV(CMF1931_JV[:, 1], CMF1931_JV[:, 2], CMF1931_JV[:, 3], CMF1931_JV[:, 4])
        elseif match == :cie12_2
            CIE12_2(CMF2012_2[:, 1], CMF2012_2[:, 2],CMF2012_2[:, 3], CMF2012_2[:, 4])
        elseif match == :cie12_10
            CIE12_10(CMF2012_10[:, 1], CMF2012_10[:, 2], CMF2012_10[:, 3], CMF2012_10[:, 4])
        end
    else
        DomainError(match, "Expecting :cie31, :cie64, :cie12_2, or :cie12_10")
    end
end


"""
    cmfunc(conefund::ConeFund)

Returns the full multispectral color matching functions based on the cone fundamental data in `cmf_tables.jl`.
Useful to convert (altered) cone fundamental functions back to color matching functions, e.g. for simulations of color anomalous observers with missing or shifted cone responses.

Possible `conefund` types:

* `LMS31`, CIE1931 2° observer cone fundamentals
* `LMS64`, CIE1964 10° observer cone fundamentals
* `LMS06_2`, CIE2012 2° observer (current CIE 2° standard observer) cone fundamentals
* `LMS06_10`, CIE2012 10° observer (current CIE 10° standard observer) cone fundamentals

# Example

```jldoctest
julia> cmfunc(conefund(:cie12_10))
CIE12_10(Real[390.0, 391.0, 392.0, 393.0, 394.0, 395.0, 396.0, 397.0, 398.0, 399.0  …  821.0, 822.0, 823.0, 824.0, 825.0, 826.0, 827.0, 828.0, 829.0, 830.0], Real[0.0001205700118214772, 0.00015063103540534432, 0.00018705601478443535, 0.0002308215774282965, 0.00028292144443875793, [...], 0.010780088746948505, 0.012937395576635658, 0.015480114358540253  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
```
"""
function cmfunc(conefund::ConeFund)
    if typeof(conefund) in (LMS31, LMS64, LMS06_2, LMS06_10)
        if isa(conefund, LMS31)
            ncmf = convmat(:cie31)^-1 * [conefund.l, conefund.m, conefund.s]
            CIE31(conefund.λ, ncmf[1], ncmf[2], ncmf[3])
        elseif isa(conefund, LMS64)
            ncmf = convmat(:cie64)^-1 * [conefund.l, conefund.m, conefund.s]
            CIE64(conefund.λ, ncmf[1], ncmf[2], ncmf[3])
        elseif isa(conefund, LMS06_2)
            ncmf = convmat(:cie12_2)^-1 * [conefund.l, conefund.m, conefund.s]
            CIE12_2(conefund.λ, ncmf[1], ncmf[2], ncmf[3])
        elseif isa(conefund, LMS06_10)
            ncmf = convmat(:cie12_10)^-1 * [conefund.l, conefund.m, conefund.s]
            CIE12_10(conefund.λ, ncmf[1], ncmf[2], ncmf[3])
        end
    else
        DomainError(conefund, "Expecting cone fundamentals of type `LMS31`, `LMS64`, `LMS06_2`, or `LMS06_10`")
    end
end


"""
    conefund(g::Symbol)

Returns the CIE cone fundamentals according to the requested lms function.

Possible symbols for `g`:

* `:lms31`, CIE1931 2° observer
* `:lms64`, CIE1964 10° observer
* `:lms06_2`, CIE2012 2° observer (current CIE 2° standard observer)
* `:lms06_10`, CIE2012 10° observer (current CIE 10° standard observer)

# Example

```jldoctest
julia> conefund(:cie64)
LMS64(Real[360, 361, 362, 363, 364, 365, 366, 367, 368, 369  …  821, 822, 823, 824, 825, 826, 827, 828, 829, 830], Real[1.5474770176000004e-8, 2.3435133003999998e-8, 3.5282213430000004e-8, [...], 1.4321467274333274e-9, 1.384067146347377e-9, 1.3377105658218067e-9, 1.2930114805124651e-9, 1.2499070138616995e-9, 1.208336807203753e-9])
```
"""
function conefund(g::Symbol)
    if g == :cie64
        lms = convmat(g) * [CMF1964[:,2], CMF1964[:,3], CMF1964[:,4]]
        @inbounds for l in 161:471
            lms[3][l] = 10^(10402.1 / (371 + l) - 21.27185)
        end
        return LMS64(collect(360:830),lms[1],lms[2],lms[3])
    elseif g == :cie31
        lms = convmat(g) * [CMF1931[:,2], CMF1931[:,3], CMF1931[:,4]]
        return LMS31(collect(360:830), lms[1], lms[2], lms[3])
    elseif g == :cie12_2
        return LMS06_2(LMS2006_2[:, 1], LMS2006_2[:, 2], LMS2006_2[:, 3], LMS2006_2[:, 4])
    elseif g == :cie12_10
        return LMS06_10(LMS2006_10[:, 1], LMS2006_10[:, 2], LMS2006_10[:, 3], LMS2006_10[:, 4])
    else
        throw(DomainError(g, "Color Matching function does not exist."))
    end
end


"""
    conefund(g::CMatch)

Returns the CIE cone fundamentals associated with a CMF.

Possible types for `g`:

* `CIE31`, CIE1931 2° observer
* `CIE64`, CIE1964 10° observer
* `CIE12_2`, CIE2012 2° observer (current CIE 2° standard observer)
* `CIE12_10`, CIE2012 10° observer (current CIE 10° standard observer)

# Example

```jldoctest
julia> conefund(cmfunc(:cie31))
LMS31(Real[360, 361, 362, 363, 364, 365, 366, 367, 368, 369  …  821, 822, 823, 824, 825, 826, 827, 828, 829, 830], Real[6.209077859e-6, 6.950775712086998e-6, 7.782164998607999e-6, [...], 5.5398906285000006e-8, 5.1646151529000004e-8, 4.814798721600001e-8, 4.488794319300001e-8, 4.1849549307000004e-8])
```
"""
function conefund(g::CMatch)
    if g isa CIE31
        conefund(:cie31)
    elseif g isa CIE64
        conefund(:cie64)
    elseif g isa CIE12_2
        c = convmat(:cie12_2) * [g.x, g.y, g.z]
        LMS06_2(g.λ, c[1], c[2], c[3])
    elseif g isa CIE12_10
        c = convmat(:cie12_10) * [g.x, g.y, g.z]
        LMS06_10(g.λ, c[1], c[2], c[3])
    else
        throw(DomainError(g, "Cone fundamental for this type does not exist."))
    end
end


"""
    convmat(g::Symbol)

Returns the conversion matrix to convert CMFs to their associated cone fundamentals (LMS).

Result: 3 × 3 matrix

# Example

`convmat(:cie12_10)`

```3×3 Matrix{Float64}:
 1.93986   -1.34664   0.430449
 0.692839   0.349676  0.0
 0.0        0.0       2.14688```
"""
function convmat(g::Symbol)
    if g == :cie12_2
               [1.94735469 -1.41445123 0.36476327;
                0.68990272  0.34832189 0.00000000;
                0.00000000  0.00000000 1.93485343]
    elseif g == :cie12_10
               [1.93986443 -1.34664359 0.43044935;
                0.69283932  0.34967567 0.00000000;
                0.00000000  0.00000000 2.14687945]
    elseif g == :cie64
               [0.236157  0.826427  -0.045710;
               -0.431117  1.206922   0.090020;
                0.040557 -0.019683   0.48195]
    elseif g == :cie31
               [0.236157  0.826427  -0.045710;
               -0.431117  1.206922   0.090020;
                0.040557 -0.019683   0.48195]
    else throw(DomainError(g, "Color matching function can’t be converted"))
    end
end

function invconvmat(g::Symbol)
    g == :lms06_2 ? convmat(:cie12_2)^-1 :
    g == :lms06_10 ? convmat(:cie12_10)^-1 :
    g == :lms64 ? convmat(:cie64)^-1 :
    g == :lms31 ? convmat(:cie31)^-1 : throw(DomainError(g, "Cone fundamentals don’t exist."))
end


"""
    colorvisiondeficiency(deftype::Symbol, Δλ::Real = 0.0)

Returns the cone fundamentals for a color deficient observer of a given type.

Allowed types:

* `:protanope`
* `:deuteranope`
* `:tritanope`
* `:protanomalous`
* `:deuteranomalous`
* `:tritanomalous`
"""
function colorvisiondeficiency(model::Symbol, deftype::Symbol, shift::Real = 0.0)
    # color primaries SPDs of RBB color space


    # transform RGB triples to opponent colors
    WSR = ρWS * sum(φR .* WS .* SPECENV.Δλ)
    WSG = ρWS * sum(φG .* WS .* SPECENV.Δλ)
    WSB = ρWS * sum(φB .* WS .* SPECENV.Δλ)
    YBR = ρYB * sum(φR .* YB .* SPECENV.Δλ)
    YBG = ρYB * sum(φG .* YB .* SPECENV.Δλ)
    YBB = ρYB * sum(φB .* YB .* SPECENV.Δλ)
    RGR = ρRG * sum(φR .* RG .* SPECENV.Δλ)
    RGG = ρRG * sum(φG .* RG .* SPECENV.Δλ)
    RGB = ρRG * sum(φB .* RG .* SPECENV.Δλ)
    # map RGB to opponent-color space for anomalous observer
    Γ = [WSR WSG WSB;
         YBR YBG YBB;
         RGR RGG RGB]
    # map RGB to opponent-color space for normal observer
    Γn= []
end


"""
    colorvisiondeficiency(model::Symbol, deftype::Symbol, c::Spectrum, illum::LSpec = D65_illuminant() , shift::Real = 0.0)

color vision deficiency simulation using Jozef Cohen’s matrix-R method.
"""
function colorvisiondeficiency(model::Symbol, deftype::Symbol, c::Spectrum, illum::LSpec = D65_illuminant() , shift::Real = 0.0)
    cflms = conefund(SPECENV.cmf)
    if deftype == :protanopia
        Acvd = conefund(match)
        Acvd.l = zeros(length(Acvd.l))
    elseif deftype == :deuteranopia
        Acvd = conefund(match)
        Acvd.m = zeros(length(Acvd.m))
    elseif deftype == :tritanopia
        Acvd = conefund(match)
        Acvd.s = zeros(length(Acvd.s))
    elseif deftype == :protanomaly
        Acvd = shift_colormatch(conefund(match),:l,shift)
    elseif deftype == :deuteranomaly
        Acvd = shift_colormatch(conefund(match),:m,shift)
    elseif deftype == :tritanomaly
        Acvd = shift_colormatch(conefund(match),:s,shift)
    else
        DomainError(deftype, "Color anomaly type does not exist.")
    end

    Clms = fundamental_metamer(illum, c, cflms)
    Ccvd = fundamental_metamer(illum, c, Acvd)
    # B = metameric_black(illum, c, cf)
    # Rlms = matrix_R(cf)
    # Rcvd = matrix_R(Acvd)
    diff = tristimulus(illum::LSpec, rad::Spectrum, match = conefund(SPECENV.cmf))
    env = SPECENV
    λc = collect(env.λmin:env.Δλ:env.λmax)
    Wee = luminance_spec(λc, ones(Float64,length(λc)))
    eeClms = matrix_R(cflms)
    Alms = matrix_A(cflms)
    Pinv = Alms * (Alms' * Alms)^-1
    ycrcb = mlms_ycc() * Alms * eeClms

end

cvd = colorvisiondeficiency


"""
    vybrg(conefund::ConeFund = conefund(SPECENV.cmf))

Returns the Ingling-Tsou opponent color functions based on the cone fundamental functios.

# Example

```jldoctest
julia> c = conefund(:cie12_2); vybrg(c)
VYBRG(Real[390.0, 391.0, 392.0, 393.0, 394.0, 395.0, 396.0, 397.0, 398.0, 399.0  …  821.0, 822.0, 823.0, 824.0, 825.0, 826.0, 827.0, 828.0, 829.0, 830.0], Real[0.0003963417152, 0.0004807961832, 0.0005820062634, [...], 1.4450193672e-6, 1.3620748624e-6, 1.2840832415999998e-6,] 1.2107868407999998e-6, 1.1419364999999999e-6, 1.0772919015999998e-6, 1.0166218466399999e-6])
```
"""
function vybrg(conefund::ConeFund = conefund(SPECENV.cmf))
    inglingtsou_opponent(conefund)
end