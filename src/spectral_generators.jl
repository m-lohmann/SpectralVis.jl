"""
`blockspec(λmin,λmax,Δλ,λs,λe,str=1.0,mode=0)`
regular `block spectrum` initialized to 0.0, with blocks λs..λe = 1.0

`blockspec(λmin,λmax,Δλ,λs,λe,str=1.0,1)`
inversed `block spectrum` initialized to 1.0, with blocks λs..λe = 0.0

"""
function block_spec(λmin,λmax,Δλ,λs,λe,str=1.0,mode=0)
    r= mode == 0 ? (zeros(Float64, Int(1.0+(λmax-λmin)/Δλ))) : (ones(Float64,Int(1.0+(λmax-λmin)/Δλ)))
    for n = λs:Δλ:λe
        r[Int((n-λmin)/Δλ)+1] = mode==0 ? str : 0.0
    end
    λ = collect(λmin:Δλ:λmax)
    reflectance_spec(λ,r)
end


"""
`blockspec(env::SpecEnvironment, λ)`

Zero block spectrum with only wavelength `λ` set to 1.0
Fast version to create highest purity optimal colors. Linear interpolation for intermediate λ values.
"""
function block_spec(env::SpecEnvironment,λ::Real)
    env.λmin ≤ λ ≤ env.λmax ? nothing : DomainError(λ, "Outside of boundaries defined by spectral environment.")
    lam = collect(env.λmin:env.Δλ:env.λmax)
    lo = indexin(floor(Float64(λ)), lam)[1]
    s = zeros(Float64, length(lam))
    hi = lo + 1
    dh = lam[hi] - λ
    dl = λ - lam[lo]
    il = (dl / dh + 1)^-1
    s[lo] = il
    s[hi] = 1 - il
    reflectance_spec(lam, s)
end

"""
`blockspec(λ)`

Zero block spectrum with only wavelength `λ` set to 1.0
Fast version to create highest purity optimal colors.

Spectral limits are taken from the spectral environment.
"""
block_spec(λ::Real) = block_spec(SPECENV, λ)


"""
`led_spec(λmin,λmax,Δλ,λ0,Δλ1_2)`

LED spectrum simulation
λ0 = peak wavelength
Δλ1_2 = half spectral width, width at 50% peak intensity

Result: `LSpec`

Source: Yoshi Ohno (2004), Simulation Analysis of White LED Spectra and Color Rendering,
        Proceedings for CIE Expert Sumposium on LED Light Sources, Tokyo, JA (Accessed May 27, 2021) 
"""
function led_spec(λmin,λmax,Δλ,λ0,Δλ1_2)
    λ = collect(λmin:Δλ:λmax)
    n = length(λ)
    l = zeros(n)
    for i in 1:n
        l[i] = led(λ[i],λ0,Δλ1_2)
    end
    luminance_spec(λ,l)
end

"""
LED function
"""
function led(λ,λ0,Δλ1_2)
    g = exp(-((λ-λ0)/Δλ1_2)^2)
    (g + 2 * g^5)/3
end

"""
`D_series_illuminant(T::Real)`

The relative spectral power distribution (SPD) SD(λ) of a D series illuminant at CCT `T`, from 300 to 830 nm in 5 nm steps. By definition the output spectra are normalized in a way that their luminance is always 100.0 at a wavelength of 560 nm.

`Allowed CCT range: 4000 K ≤ CCT ≤ 25000 K`
"""
function D_series_generator(T::Real)
    #xD,yD = CIE Daylight Locus
    if T < 4000 || T > 25000
        error("CCT must be between 4000 and 25000 K!")
    elseif 4000 ≤ T ≤ 7000
        xD = 0.244063 + 0.09911 * 1000.0 / T + 2.9678 * 1_000_000.0/T^2 - 4.6070 * 1_000_000_000.0/T^3
    elseif 7000 < T ≤ 25000
        xD = 0.237040 + 0.24748*1000.0/T + 1.9018*1_000_000.0/T^2 -2.0064*1000_000_000.0/T^3
    end

    yD = -3.000 * xD^2 + 2.870*xD-0.275
    M  = 0.0241 + 0.2562*xD - 0.7341*yD
    M1 = (-1.3515-1.7703*xD + 5.9114*yD)/M
    M2 = (0.03000 - 31.4424*xD + 30.0717*yD)/M
    S0 = daylight_generator_table[:,2]
    S1 = daylight_generator_table[:,3]
    S2 = daylight_generator_table[:,4]
    SD = S0 .+ M1*S1 .+ M2*S2
    luminance_spec(daylight_generator_table[:,1],SD)
end


"""
`D_series_whitepoint(env::SpecEnv,T::Real)`

produces the white point according to the CIE Daylight Series.

result: `::XYZ`
"""
function D_series_whitepoint(env::SpecEnv,T::Real)
    ×(D_series_illuminant(env,T), env.cmf)
end


"""
`D_series_whitepoint(T::Real)`

produces the white point according to the CIE Daylight Series.

result: `::XYZ`
"""
function D_series_whitepoint(T::Real)
    D_series_whitepoint(SPECENV,T)
end


"""
`D_series_illuminant(env::SpecEnv, T::Real)`

produces CIE Daylight spectrum according to desired CCT.

result: `::LSpec`
"""
function D_series_illuminant(env::SpecEnv, T::Real)
    dlum = D_series_generator(T)
    if dlum.λ[1] < env.λmin || dlum.λ[end] > env.λmax
        extr = extrap(linearspline(dlum.λ,dlum.l),collect(env.λmin:env.Δλ:env.λmax),:linear)
        intr = interp(extr,collect(env.λmin:env.Δλ:env.λmax))
    else
        intr = interp(dlum,collect(env.λmin:env.Δλ:env.λmax))
    end
    luminance_spec(intr[1],intr[2])
end


"""
`D_series_illuminant(T::Real)`

produces CIE Daylight spectrum according to desired CCT.

result: `::LSpec`
"""
function D_series_illuminant(T::Real)
    D_series_illuminant(SPECENV, T)
end

# Selection of standard daytime illuminants using proper CCTs

"""
`D50_illuminant()`

Result: `::LSpec` of D50 illuminant, with a CCT of  5003K
"""
D50_illuminant() = D_series_illuminant(5003)

"""
`D55_illuminant()`

Result: `::LSpec` of D55 illuminant, with a CCT of  5503K
"""
D55_illuminant() = D_series_illuminant(5003)

"""
`D65_illuminant()`

Result: `::LSpec` of D65 illuminant, with a CCT of 6504 K
"""
D65_illuminant() = D_series_illuminant(6504)

"""
`D75_illuminant()`

Result: `::LSpec` of D65 illuminant, with a CCT of 7504 K
"""
D75_illuminant() = D_series_illuminant(7504)

# General standard daytime illuminants with proper CCTs

function D_series_proper_illuminant(T::Real)
    D_series_illuminant(T * (1.4388 / 1.4380))
end

"""
`normalized_D_series_illuminant(T::Real)`

produces CIE Daylight spectrum according to desired CCT, normalized to l=100 at λ=560 nm.

result: `::LSpec`
"""
function normalized_D_series(env::SpecEnv,T::Real)
    nT = normalize_D_series(D_series_generator(T))
    sT = SSpline.cubicspline(nT.λ,nT.l,:natural)
    iT = SSpline.interp(sT, collect(env.λmin:env.Δλ:env.λmax))
    luminance_spec(iT[1], iT[2])
end

"""
`blackbody_illuminant(env::SpecEnv,T::Real)`

produces blackbody spectrum according to desired blackbody temperature in K.

result: `::LSpec`
"""
function blackbody_illuminant(env::SpecEnv,T::Real)
    h = 6.62607015e-34 # [J*s] Planck’s constant
    k = 1.380649e-23   # [J/K] Boltzmann constant
    c = 299792458      # [m/s] Light speed
    wl=collect(env.λmin:env.Δλ:env.λmax)
    il=zeros(length(wl))
    @inbounds for n in 1:length(wl)
        λ = wl * 1e-9
        il[n] = (2 * π * h * c^2) / (λ[n]^5 * (exp(h * c / (λ[n] * k * T)) - 1))
    end
    luminance_spec(wl,il)
end

blackbody_illuminant(T::Real) = blackbody_illuminant(SPECENV, T)

"""
`blackbody_whitepoint(env::SpecEnv, T::Real)`

produces the white point according to desired blackbody temperature in K.

result: `::XYZ`
"""
function blackbody_whitepoint(env::SpecEnv, T::Real)
    ×(normalize_spec(blackbody_illuminant(env, T)), env.cmf)
end


# Illuminant A spectrum
# Source: Dr. H. W. G. Hunt, “Measuring Colour”, third edition
# Appendix 5, “Relative spectral power distributions of illuminants”
"""
`illumiant_A()`

Produces the spectrum of illuminant A, which represents tungsten-filament lighting.
The relative spectral power distribution is equal to a Planckian spectrum at T ≊ 2856 K, which is also its CCT.

CCT according to the *International Practical Temperature Scale* from 1968.

This is the illuminant that should always be used when incandescent lighting is involved.

result: `::LSpec`
"""
illuminant_A() = illuminant_A(SPECENV)


"""
`illumiant_A(env::SpecEnv)`

Produces the spectrum of illuminant A, which represents tungsten-filament lighting, depending on the limits defined by SPECENV.
The relative spectral power distribution is equal to a Planckian spectrum at T ≊ 2856 K, which is also its CCT.

CCT according to the *International Practical Temperature Scale* from 1968.

This is the illuminant that should always be used when incandescent lighting is involved.

result: `::LSpec`
"""
function illumiant_A(env::SpecEnv)
    blackbody_illuminant(env, 1.4388 / 1.4350 * 2848)
end


# CIE Standard Illuminant B
# Source: R. G. W. Hunt: “Measuring Colour”, third edition
# Chapter 4.14, “Standard Illuminants B and C”
"""
`illuminant_B(env::SpecEnv)`

Produces the spectrum of CIE Standard Illuminant B, with a CCT of ≈4874 K.
Originally intended to represent sunlight.
Now obsolete, but according to Hunt the European brewing industry still uses an approximation of this illuminant.

Result: `::LSpec`
"""
function illuminant_B(env::SpecEnv)
    b = b_c_series_table
    bsp = SSpline.cubicspline(b[:,1], b[:,2], :natural)
    bin = SSpline.interp(bsp, collect(env.λmin:env.Δλ:env.λmax))
    luminance_spec(bin[1], bin[2] / 100.0)
end


"""
`illuminant_B()`

Produces the spectrum of CIE Standard Illuminant B, with a CCT of ≈4874 K.
Originally intended to represent sunlight.
Now obsolete, but according to Hunt the European brewing industry still uses an approximation of this illuminant.

Result: `::LSpec`
"""
illuminant_B() = illuminant_B(SPECENV)


# CIE Standard Illuminant C
# Source: R. G. W. Hunt: “Measuring Colour”, third edition
# Chapter 4.14, “Standard Illuminants B and C”
"""
`illuminant_C(env::SpecEnv)`

Produces the spectrum of CIE Standard Illuminant C, with a CCT of ≈6774 K.
Originally intended to represent average daylight.

Result: `::LSpec`

How the CIE Standard Illuminant C is produced:

Standard Source A is combined with a filter made of two 1 cm thick layers, containing two solutions, C₁ and C₂.
The solutions are contained in a double cell that is made of a colorless optical glass.

Solution C₁:
      3.412 g copper sulphate (CuSO<sub>4</sub>·5H₂O)
      3.412 g mannite [C<sub>6</sub>H<sub>8</sub>(OH)<sub>6</sub>]
      30.0 ml pyridine (C<sub>5</sub>H<sub>5</sub>N)
    1000.0 ml distilled water

Solution C₂:
      30.58 g cobalt ammonium sulphate [CoSO<sub>4</sub>·(NH<sub>4</sub>)₂SO<sub>4</sub>·6H₂O]
      22.52 g copper sulphate (CuSO<sub>4</sub>·5H₂O)
      10.0 ml sulphuric acid (density 1.835 g/ml)
    1000.0 ml distilled water
"""
function illuminant_C(env::SpecEnv)
    c = b_c_series_table
    csp = SSpline.cubicspline(c[:,1], c[:,3], :natural)
    cin = SSpline.interp(csp, collect(env.λmin:env.Δλ:env.λmax))
    luminance_spec(cin[1], cin[2] / 100.0)
end


"""
`illuminant_C(env::SpecEnv)`

Produces the spectrum of CIE Standard Illuminant C, with a CCT of ≈6774 K.
Originally intended to represent average daylight.

Result: `::LSpec`

How the CIE Standard Illuminant C is produced:

Standard Source A is combined with a filter made of two 1 cm thick layers, containing two solutions, C₁ and C₂.
The solutions are contained in a double cell that is made of a colorless optical glass.

Solution C₁:
      3.412 g copper sulphate (CuSO<sub>4</sub>·5H₂O)
      3.412 g mannite [C<sub>6</sub>H<sub>8</sub>(OH)<sub>6</sub>]
      30.0 ml pyridine (C<sub>5</sub>H<sub>5</sub>N)
    1000.0 ml distilled water

Solution C₂:
      30.58 g cobalt ammonium sulphate [CoSO<sub>4</sub>·(NH<sub>4</sub>)₂SO<sub>4</sub>·6H₂O]
      22.52 g copper sulphate (CuSO<sub>4</sub>·5H₂O)
      10.0 ml sulphuric acid (density 1.835 g/ml)
    1000.0 ml distilled water
"""
illuminant_C() = illuminant_C(SPECENV)


"""
`F_series_illuminant(type::Symbol)`

Spectral power distribution of representative fluorescent lamps from 380 to 780 nm in 5 nm steps.

Available types:

    `:f1`, `:f2`, ... , `:f11`, `:f12`

    `F2`, `F7`, and `F11` should be preferred over the other dirstributions as long as the choice in each of these three groups is not important or critical.

*For wavelength outside the `380 nm ... 780 nm` range the SPDs should be set to zero.*

Result: `::LSpec`

These are not CIE Standard Illuminants. They were compiled by the CIE as a representative collection of practical fluorescent lamps. The 12 lamps in this collection can be grouped in 3 groups:

`normal`:       two semi-broad band emmisions of antimony and manganese activations in calcium halo-phosphate phosphor.
    **CRI**   F1: 76     `*F2`: 64      F3: 57      F4: 51      F5: 72      F6: 59

`broad-band`:   enhanced color rendering properties in comparison to the `normal` group, mostly by using multiple phosphors. Flatter spectral distributions with a wider spectral range.
    **CRI:** `*F7:` 90    F8: 95      F9: 90

`three-band`:   three narrow-band emissions in the red, green, and blue spectral regions. The narrow-band emissions are produced by ternary compositions of rare-earth phosphors.
    **CRI:**    F10: 81     `*F11`: 83      F12: 83
"""
function F_series_illuminant(type::Symbol)
    n = parse(Int,string(a)[2:end])
    F_series_illuminant(SPECENV, n)
end


"""
`F_series_illuminant(n::Int)`

Return F series illuminant **Fn** for `n` from 1 to 12.

Result: `::LSpec`
"""
function F_series_illuminant(env::SpecEnv, n::Int)
    if 0 < n < 13
        c = luminance_spec(f_series_table[:,1], f_series_table[:,n+1])
        csp = SSpline.spline1(c.λ, c.l)
        cin = SSpline.interp(csp, collect(env.λmin:env.Δλ:env.λmax))
        luminance_spec(cin[1], cin[2])
    else
        DomainError("F series illuminant #$n outside the range 1 ≤ n ≤ 12.")
    end
end

F_series_illuminant(n::Int) = F_series_illuminant(SPECENV, n)


"""
`gas_discharge_illuminant(type::Symbol)`

SPDs of common gas discharge lamps.

available types:

`:lps`:   Low pressure sodium
`:hps`:   High pressure sodium
`:mb`:    High pressure mercury
`:mbf`:   High pressure mercury with red-emitting phosphor coating, better CRI than MB
`:mbtf`:  High pressure mercury with red-emitting phopsphor coating and tungsten filament ballast, better CRI
`:hmi`:   High pressure mercury with metal halides. Medium arc, iodides, typical stadium lighting, was used in television to supplement daylight
`:xenon`: Xenon, used in film projectors in cinemas, floodlighting, in lighthouses, for accelerated fading tests, flash photography, lighting fluorescent materials

Result: `::LSpec`
"""
function gas_discharge_illuminant(type::Symbol)
    ifelse(type == :lps,  gas_discharge_illuminant(SPECENV, 1),
    ifelse(type == :hps,  gas_discharge_illuminant(SPECENV, 2),
    ifelse(type == :mb,   gas_discharge_illuminant(SPECENV, 3),
    ifelse(type == :mbf,  gas_discharge_illuminant(SPECENV, 4),
    iflese(type == :mbtf, gas_discharge_illuminant(SPECENV, 5),
    iflese(type == :hmi,  gas_discharge_illuminant(SPECENV, 6),
    ifelse(type == :xenon,gas_discharge_illuminant(SPECENV, 7),
    DomainError("Lamp type $type does not exist!"))))))))
end

gas_discharge_illuminant(n::Int) = gas_discharge_illuminant(SPECENV, n)

"""
`gas_discharge_illuminant(n::Int)`

Returns gas discharge type illuminant of index `n` for n from 1 to 7.

Result: `::LSpec`
"""
function gas_discharge_illuminant(env::SpecEnv, n::Int)
    if 0 < n < 8
        c = luminance_spec(gas_discharge_table[:,1], gas_discharge_table[:,n+1])
        csp = SSpline.linearspline(c.λ, c.l)
        cin = SSpline.interp(csp, collect(env.λmin:env.Δλ:env.λmax))
        luminance_spec(cin[1], cin[2])
    else
        DomainError("Gas discharge illuminant #$n outside the range 1 ≤ n ≤ 7.")
    end
end


"""
`sinusoidal_spd(freq::Real, modfac::Real = 1.0, ampl::Real = 1.0, phase::Real, r = (SPECENV.λmin:SPECENV.Δλ:SPECENV.λmax))`
"""
function sinusoidal_spd(stype::Symbol, freq::Real, modfac::Real = 1.0, ampl::Real = 1.0, phase::Real = 0.0, r = (SPECENV.λmin:SPECENV.Δλ:SPECENV.λmax))
    if 0 ≤ ampl ≤ 1.0
        if 0 ≤ modfac ≤ 1.0
            c = 0.5 .* ampl .* (1 .+ modfac * sin.(2π * freq .* (collect(r) .- r[1]) .+ phase))
            if stype == :l
                return luminance_spec(collect(r), c)
            elseif stype == :r
                return reflectance_spec(collect(r),c)
            else
                throw(DomainError(stype, "Only :l and :r allowed."))
            end
        else
            throw(DomainError(modfac, "Expecting a value 0 ≤ modfac ≤ 1.0."))
        end
    else
        throw(DomainError(ampl, "Expecting a value 0 ≤ ampl ≤ 1.0."))
    end
end
















#=
    Sources:
    George M. Hale and Marvin R. Querry, “Optical Constants of Water in the 200-nm to 200-μm Wavelength Region”, Appl. Opt. 12/1973, https://doi.org/10.1364/AO.12.000555

    W.G. Zijlstra, A. Buursma, W.P. Meeuwsen-van der Roest, “Absorption spectra of human fetal and adult oxyhemoglobin, de-oxyhemoglobin, carboxyhemoglobin, and methemoglobin”, Clin. Chem. 37 (1991) 1633/1638

    I.S. Saidi, “Transcutaneous optical measurement of hyperbilirubinemia in neonates”, PhD thesis, Rice University, Houston, TX, 1992

=#
"""
`skin_simulation()`

Skin optics Simulation
"""
function skin_simulation()


end

function μa(layer,λ)
    #=  FHB: volume fraction of hemoglobin
        FRBC: volume fratcion of erythrocytes in total volume of all blood cells
        Ht: hemotocrit
        assumption: hemoglobin is contained in the erythrocytes only

        absorption coefficients:
        μaHb

    =#
    μS = abscoeff(layer)[1]
    g = abscoeff(layer)[2]
    n = abscoeff(layer)[3]
    CBlood = abscoeff(layer)[4]
    S = abscoeff(layer)[5]
    Ht = abscoeff(layer)[6]
    FHb = abscoeff(layer)[7]
    FRBC = abscoeff(layer)[8]
    CH₂O = abscoeff(layer)[9]
    
    γ = FHb * FRBC * Ht

    

    μalayer = (1-S) * γ * Cblood * μaHb + S * γ * CBlood * μaHbO₂(λ) +
              (1- γ * CBlood) * CH₂O * μaH₂O(λ) +
              (1- γ * CBlood) * (1-CH₂O) * μaOther(λ)
    μalayer
end

function abscoeff(layer::Int)
    ABSORPTIONCOEFF[layer,:]
end

# absorption coefficient matrix for the 7 skin layers
#   μs    g     n   CBlood  S    Ht   FHb   FRBC  CH₂O
const ABSORPTIONCOEFF =
   [100  0.86  1.50  0.00  0.0  0.00  0.00  0.00  0.05;
     45  0.80  1.34  0.00  0.0  0.00  0.00  0.00  0.20;
     30  0.90  1.40  0.04  0.6  0.45  0.99  0.25  0.50;
     35  0.95  1.39  0.30  0.6  0.45  0.99  0.25  0.60;
     25  0.80  1.40  0.04  0.6  0.45  0.99  0.25  0.70;
     30  0.95  1.38  0.10  0.6  0.45  0.99  0.25  0.70;
      5  0.75  1.44  0.05  0.6  0.45  0.99  0.25  0.70]

function μaOther(λ)
    7.87e7 * λ^(-3.255)
end

function μaStratum(λ)
    (0.1 - 8.3e-4 * λ) + 0.125 * μaOther(λ)
end

function μalivingepidermis(λ)
    (0.5e10 * λ^(-3.33)) * (1 - CH₂O) + CH₂O * μaH₂O
end

function μaH₂O(λ)
    WATERCONST
    absorption(k,λ)
end

# if λ in nm, multiply by 1e7 to get absorption in cm^-1
function absorption(k,λ)
    4 * π * k / λ
end