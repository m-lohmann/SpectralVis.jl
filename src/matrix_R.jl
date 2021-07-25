"""
    matrixA(match::ConeFund = conefund(SPECENV.cmf), type::Symbol = :standard)

Creates matrix A from a cone fundamental for Cohen’s matrix R calculations.

Available types:

- :protanopia
- :deuteranopia
- :tritanopia
- :standard

# Examples:

```jldoctest
julia> matrixA(conefund(SPECENV.cmf))
441×3 Matrix{Float64}:
 0.0108549   0.00218811  0.028312
 0.0131472   0.00265254  0.0343045
 0.0159195   0.00321355  0.0415584
 0.0192642   0.00388931  0.0503177
[...]
 2.6301e-6   1.56603e-6  0.0
 2.48078e-6  1.47742e-6  0.0
 2.34056e-6  1.39418e-6  0.0
 2.20894e-6  1.31601e-6  0.0
```
"""
function matrixA(match::ConeFund = conefund(SPECENV.cmf), type::Symbol = :standard)
    type == :protanopia ? [match.m match.s] :
    type == :deuteranopia ? [match.l match.s] :
    type == :tritanopia ? [match.l match.m] :
    type == :standard ? [match.l match.m match.s] :
    throw(DomainError(type, "Type does not exist."))
end


"""
    matrixR(match::ConeFund = conefund(SPECENV.cmf), type::Symbol = :standard)

Creates Cohen’s matrix R from a given CMF. For available types, see `matrixA`.

# Examples:

```jldoctest
julia> matrixR(conefund(SPECENV.cmf), :deuteranopia)
441×441 Matrix{Float64}:
 9.97123e-7   1.20808e-6   1.4634e-6    1.77166e-6   …  4.61275e-11  4.35087e-11  4.10494e-11  3.8741e-11
 1.20808e-6   1.46367e-6   1.77301e-6   2.14648e-6      5.57733e-11  5.26069e-11  4.96333e-11  4.68422e-11
 1.4634e-6    1.77301e-6   2.14773e-6   2.60013e-6      6.73948e-11  6.35686e-11  5.99755e-11  5.66027e-11
[...]
 4.35087e-11  5.26069e-11  6.35686e-11  7.6741e-11      5.56939e-14  5.2532e-14   4.95627e-14  4.67755e-14
 4.10494e-11  4.96333e-11  5.99755e-11  7.24034e-11     5.25459e-14  4.95627e-14  4.67613e-14  4.41316e-14
 3.8741e-11   4.68422e-11  5.66027e-11  6.83317e-11  …  4.95909e-14  4.67755e-14  4.41316e-14  4.16498e-14
```
"""
function matrixR(match::ConeFund = conefund(SPECENV.cmf), type::Symbol = :standard)
    A = matrixA(match, type)
    A * ((A' * A)^-1) * A'
end


"""
    fundamental_metamer(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf),type::Symbol = :standard)

Creates fundamental metamer of a spectrum according to Cohen’s matrix R method.

# Examples:

```jldoctest
```
"""
function fundamental_metamer(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf),type::Symbol = :standard)
    # radiometric function N*
    N = illum * rad
    Nstar = matrixR(match, type) * N.l
    # fundamental metamer
    luminance_spec(illum.λ, Nstar)
end


"""
    metameric_black(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf), type::Symbol = :standard)

Creates metameric black  according to Cohen’s matrix R method.

# Examples

```jldoctest
```
"""
function metameric_black(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf), type::Symbol = :standard)
    N = illum * rad
    Nstar = matrixR(match, type) * N.l
    luminance_spec(N.λ, N.l .- Nstar)
end

"""
    cohen_pair(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf), type::Symbol = :standard)

Returns a pair of Cohen’s fundamental metamer and metameric black according to a light stimulus.

# Examples

```jldoctest
```
"""
function cohen_pair(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf), type::Symbol = :standard)
    fundamental_metamer(illum, rad, match, type), metameric_black(illum, rad, match, type)
end

"""
    tristimulus(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf), type::Symbol = :standard)

Creates tristimulus values resulting from radiometric function/stimulus reaching the eye, according to Cohen’s matrix R method.

# Examples:

```
julia> tristimulus(D65_illuminant(), adapt_spec(agfait(100), SPECENV, :zero, :cubic, :natural))
3-element Vector{Any}:
 2827.9824977740263
 4605.154579468038
 6719.982399962246
 ````
"""
function tristimulus(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf), type::Symbol = :standard)
    matrixA(match, type)' * (illum * rad).l
end