"""
`matrix_A(match::ConeFund = conefund(SPECENV.cmf))`

creates matrix A for Cohen’s matrix R calculations

result: `N×3 Matrix{Float64}`, with N = number of samples in the CMFs
"""
function matrix_A(match::ConeFund = conefund(SPECENV.cmf))
    [match.l match.m match.s]
end


"""
`matrix_R(match::ConeFund = conefund(SPECENV.cmf))`

creates Cohen’s matrix R

result: `N×N Matrix{Float64}`, with N = number of samples in the CMFs
"""
function matrix_R(match::ConeFund = conefund(SPECENV.cmf))
    A = matrix_A(match)
    A * ((A' * A)^-1) * A'
end


"""
`fundamental_metamer(illum::LSpec,rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf))`

creates fundamental metamer according to Cohen’s matrix R method.

Result: `LSpec`
"""
function fundamental_metamer(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf))
    # radiometric function N*
    N = illum * rad
    Nstar = matrix_R(match) * N.l
    # fundamental metamer
    luminance_spec(illum.λ, Nstar)
end


"""
`metameric_black(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf))`

creates metameric black  according to Cohen’s matrix R method.

Result: `LSpec`
"""
function metameric_black(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf))
    N = illum * rad
    Nstar = matrix_R(match) * N.l
    luminance_spec(N.λ, N.l .- Nstar)
end

"""
`cohen_pair(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf))`

returns a pair of Cohen’s fundamental metamer and metameric black according to a light stimulus.

Result: tuple (`LSpec`, `LSpec`)
"""
function cohen_pair(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf))
    fundamental_metamer(illum, rad, match), metameric_black(illum, rad, match)
end

"""
`tristimulus(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf))`

creates tristimulus values resulting from radiometric function/stimulus reaching the eye, according to Cohen’s matrix R method.

result: 3×1 Matrix{Float64}
"""
function tristimulus(illum::LSpec, rad::Spectrum, match::ConeFund = conefund(SPECENV.cmf))
    matrix_A(match)' * (illum * rad).l
end