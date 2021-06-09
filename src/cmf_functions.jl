"""
`cmf(match::Symbol)`

Returns the full multispectral matching functions based on the CMF data in `cmf_tables.jl`

possible values for `table`:

Color matching functions:

`:cie31`, CIE1931 2° observer

`:cie64`, CIE1964 10° observer

`:cie31_j`, CIE1931 observer with corrections by Judd

`:cie31_jv`, CIE1964 observer wtih correction by Judd and Vos

`:cie12_2`, CIE2012 2° observer (current CIE 2° standard observer)

`:cie12_10`, CIE2012 10° observer (current CIE 10° standard observer)

Result: `::CMatch`

Example:

```
julia> cmf(:cie12_2)
CIE12_2(Real[390.0, 391.0, 392.0, 393.0, 394.0, 395.0, 396.0, 397.0, 398.0, 399.0  …  821.0, 822.0, 823.0, 824.0, 825.0, 826.0, 827.0, 828.0, 829.0, 830.0], Real[0.003769647, 0.004532416, 0.005446553, 0.006538868, 0.007839699, 0.009382967, 0.01120608, 0.01334965, 0.0158569, 0.01877286  …  2.986206e-6, 2.814999e-6, 2.653663e-6, 2.501725e-6, 2.358723e-6, 2.224206e-6, 2.097737e-6, 1.978894e-6, 1.867268e-6, 1.762465e-6], Real[0.0004146161, 0.0005028333, 0.0006084991, 0.0007344436, 0.0008837389, 0.001059646, 0.001265532, 0.001504753, 0.001780493, 0.002095572  …  1.190771e-6, 1.123031e-6, 1.059151e-6, 9.989507e-7, 9.422514e-7, 8.888804e-7, 8.38669e-7, 7.914539e-7, 7.47077e-7, 7.05386e-7], Real[0.0184726, 0.02221101, 0.02669819, 0.03206937, 0.03847832, 0.04609784, 0.05511953, 0.06575257, 0.07822113, 0.09276013  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
```
"""
function cmf(match::Symbol)
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
`cmf(conefund::ConeFund)`

Returns the full multispectral color matching functions based on the cone fundamental data in `cmf_tables.jl`.
Useful to convert (altered) cone fundamental functions back to color matching functions, e.g. for simulations of color anomalous observers with missing or shifted cone responses.

Possible values for `conefund`:

Cone fundamentals:

`LMS31`, CIE1931 2° observer cone fundamentals

`LMS64`, CIE1964 10° observer cone fundamentals

`LMS06_2`, CIE2012 2° observer (current CIE 2° standard observer) cone fundamentals

`LMS06_10`, CIE2012 10° observer (current CIE 10° standard observer) cone fundamentals

Result: `::CMatch`

Example:

```
julia> cmf(conefund(:cie12_10))
CIE12_10(Real[390.0, 391.0, 392.0, 393.0, 394.0, 395.0, 396.0, 397.0, 398.0, 399.0  …  821.0, 822.0, 823.0, 824.0, 825.0, 826.0, 827.0, 828.0, 829.0, 830.0], Real[0.0001205700118214772, 0.00015063103540534432, 0.00018705601478443535, 0.0002308215774282965, 0.00028292144443875793, 0.0003443106018741202, 0.00041582779281903906, 0.0004980934122537238, 0.0005913809398804743, 0.0006954621391347265  …  4.3662543031186134e-7, 4.12144883394201e-7, 3.890286652785583e-7, 3.6721520387003444e-7, 3.466439443120568e-7, 3.2725557075822546e-7, 3.0899218723525594e-7, 2.917974725047203e-7, 2.756167996138985e-7, 2.603973363518496e-7], Real[0.0007855615176120651, 0.0009560192387959539, 0.0011628772539846474, 0.0014131356701289842, 0.001714817061254599, 0.002076999434157783, 0.002509805142537243, 0.0030243290560010936, 0.003632487246688484, 0.00434676726132004  …  -4.6694635698267887e-7, -4.3968103000222326e-7, -4.1402974336791557e-7, -3.899118235563144e-7, -3.6724871838890953e-7, -3.45964204802527e-7, -3.2598454416170116e-7, -3.072386126489415e-7, -2.8965797484586137e-7, -2.731769580875523e-7], Real[0.00286119835466309, 0.003466799139560444, 0.0041998691496162015, 0.005085075596582751, 0.0061509334396954605, 0.007430071912048903, 0.00895939583379961, 0.010780088746948505, 0.012937395576635658, 0.015480114358540253  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
```
"""
function cmf(conefund::ConeFund)
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
`conefund(g::Symbol)`

Returns the CIE cone fundamentals according to the requested lms function.

possible values for `g`:

Color matching functions:

`:lms31`, CIE1931 2° observer

`:lms64`, CIE1964 10° observer

`:lms06_2`, CIE2012 2° observer (current CIE 2° standard observer)

`:lms06_10`, CIE2012 10° observer (current CIE 10° standard observer)

Result: `::ConeFund`

Example:

```julia> conefund(:cie64)
LMS64(Real[360, 361, 362, 363, 364, 365, 366, 367, 368, 369  …  821, 822, 823, 824, 825, 826, 827, 828, 829, 830], Real[1.5474770176000004e-8, 2.3435133003999998e-8, 3.5282213430000004e-8, 5.279935677e-8, 7.853802415999999e-8, 1.1613832994000001e-7, 1.7071046132e-7, 2.4942340307000005e-7, 3.6226118590000006e-7, 5.229156914e-7  …  1.50120948786e-6, 1.41548601031e-6, 1.33491975574e-6, 1.2590809576099999e-6, 1.18766263632e-6, 1.1204298364800001e-6, 1.05697758436e-6, 9.970957173800001e-7, 9.4059768866e-7, 8.8718596488e-7], Real[1.1650974096000002e-8, 1.765815032200001e-8, 2.6607607210000008e-8, 3.984577229000001e-8, 5.931756049000006e-8, 8.779134071000002e-8, 1.2917026990000004e-7, 1.889333277600002e-7, 2.747232299e-7, 3.9711453990000034e-7  …  1.4800105646000022e-7, 1.4006370806000022e-7, 1.3259639104e-7, 1.2551467226000012e-7, 1.188358375200001e-7, 1.1252715688000002e-7, 1.0654040486000005e-7, 1.0087905918000013e-7, 9.550348586000019e-8, 9.041372602000008e-8], Real[2.6254861521599995e-7, 3.9783569906400005e-7, 5.9926433583e-7, 8.9737299537e-7, 1.33582414266e-6, 1.97674092444e-6, 2.90781067752e-6, 4.252050635369999e-6, 6.1809577839e-6, 8.9313330444e-6  …  1.6431038225549302e-9, 1.5874204339435827e-9, 1.5337507581763896e-9, 1.4820175592425727e-9, 1.4321467274333274e-9, 1.384067146347377e-9, 1.3377105658218067e-9, 1.2930114805124651e-9, 1.2499070138616995e-9, 1.208336807203753e-9])```
"""
function conefund(g::Symbol)
    if g == :cie64
        lms = convmat(g) * [CMF1964[:,2], CMF1964[:,3], CMF1964[:,4]]
        @inbounds for l in 161:471
            lms[3][l] = 10^(10402.1 / (371+l) - 21.27185)
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
        DomainError(g, "Color Matching function does not exist.")
    end
end


"""
`conefund(g::CMatch)`

Returns the CIE cone fundamentals associated with a CMF.

possible values for `g`:

Color matching functions:

`CIE31`, CIE1931 2° observer

`CIE64`, CIE1964 10° observer

`CIE12_2`, CIE2012 2° observer (current CIE 2° standard observer)

`CIE12_10`, CIE2012 10° observer (current CIE 10° standard observer)

Result: `ConeFund`

Example:

```
julia> conefund(cmf(:cie31))
LMS31(Real[360, 361, 362, 363, 364, 365, 366, 367, 368, 369  …  821, 822, 823, 824, 825, 826, 827, 828, 829, 830], Real[6.209077859e-6, 6.950775712086998e-6, 7.782164998607999e-6, 8.714501534971998e-6, 9.759041964014999e-6, 1.0927043755000009e-5, 1.2236811374512996e-5, 1.3709833373471998e-5, 1.5362198583388008e-5, 1.7209990877209986e-5  …  1.2572205131590001e-6, 1.1720537600220001e-6, 1.092659269044e-6, 1.018669137999e-6, 9.49712749223e-7, 8.85404490185e-7, 8.25426637979e-7, 7.695171980960001e-7, 7.174137037130001e-7, 6.688536880070001e-7], Real[3.286537174000006e-6, 3.718334052682001e-6, 4.21018448518802e-6, 4.7680497604920245e-6, 5.397892374490006e-6, 6.105676030000002e-6, 6.902824445918012e-6, 7.804940504792016e-6, 8.824139384168021e-6, 9.97252902006001e-6  …  1.1110657480000018e-8, 1.0358115206999963e-8, 9.656160445999999e-9, 9.002947271000182e-9, 8.393440107000083e-9, 7.825536825000076e-9, 7.295401576000151e-9, 6.800656496000079e-9, 6.339785955000058e-9, 5.9112743230000735e-9], Real[0.00029730115098900004, 0.00033397836836417696, 0.00037530821429416806, 0.000421836725208012, 0.00047410993751506505, 0.000532673887605, 0.000598681980606423, 0.0006733004168505121, 0.0007570932105165479, 0.00085062437590191  …  7.866314394900001e-8, 7.3334330712e-8, 6.836670794400001e-8, 6.3737172699e-8, 5.942264052300001e-8, 5.5398906285000006e-8, 5.1646151529000004e-8, 4.814798721600001e-8, 4.488794319300001e-8, 4.1849549307000004e-8])
```
"""
function conefund(g::CMatch)
    isa(g, CIE31) ? conefund(:cie31) :
    isa(g, CIE64) ? conefund(:cie64) :
    isa(g, CIE12_2) ? conefund(:cie12_2) :
    isa(g, CIE12_10) ? conefund(:cie12_10) : DomainError(g, "Cone fundamental for this type does not exist.")
end


"""
`convmat(g::Symbol)`

Returns the conversion matrix to convert CMFs to their associated cone fundamentals (LMS).

Result: 3 × 3 matrix

Example:

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
    g == :lms31 ? convmat(:cie31)^-1 : DomainError(g, "Cone fundamentals don’t exist.")
end

"""
`colorvisiondeficiency(deftype::Symbol, Δλ::Real = 0.0)

Returns the cone fundamentals for a color deficient observer of a given type.

Allowed types:

    `:protanope`
    `:deuteranope`
    `:tritanope`
    `:protanomalous`
    `:deuteranomalous`
    `:tritanomalous`
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
`colorvisiondeficiency(model::Symbol, deftype::Symbol, c::Spectrum, illum::LSpec = D65_illuminant() , shift::Real = 0.0)`

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


end

cvd = colorvisiondeficiency