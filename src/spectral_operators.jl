#####################
# Spectral operators
#####################
# Operators for spectral and color calculations
# For spectral calculations operations are based on the physically plausible order, like
#
# light source → reflectance (light bounced off a surface)
# light source → transmission (filtered light)
# transmission → transmission (combination of two filters)


############
# * operator
############
# always results in a spectrum of type LSpec or TSpec
#
# This operator is used for chaining illumination, reflection, and transmission spectra.
#

#=
+ operator : spectral mixing
* operator : Spectral chaining of illumination, refl, transm.
× operator : “color of” operator, for whitepoints etc.
=#


"""
    *(a::LSpec, b::RSpec)

results in a luminance spectrum `LSpec` due to an illuminant spectrum reflected by a reflectance spectrum.

Result: `LSpec`
"""
function *(a::LSpec,b::RSpec)
    luminance_spec(a.λ, a.l .* b.r)
end

*(a::LSpec, b::RSpec, c...) = *((a * b), c...)


"""
    *(a::LSpec, a::TSpec)

results in a luminance spectrum `LSpec` due to an illuminant filtered by a transmission spectrum.
"""
function *(a::LSpec,b::TSpec)
    luminance_spec(a.λ, a.l .* b.t.^b.x)
end

*(a::LSpec, b::TSpec, c...) = *((a * b), c...)

"""
    *(a::RSpec, b::RSpec)

Interreflection between two reflective surfaces

# Example:
```jldoctest
julia> macbeth(:Macbeth_chart1, :red) * macbeth(:Macbeth_chart1, :orange)
RSpec(Real[380.0, 390.0, 400.0, 410.0, 420.0, 430.0, 440.0, 450.0, 460.0, 470.0  …  640.0, 650.0, 660.0, 670.0, 680.0, 690.0, 700.0, 710.0, 720.0, 730.0], Real[0.002597, 0.002544, 0.0024909999999999997, 0.0024909999999999997, 0.0024909999999999997, 0.002538, 0.002538, 0.002484, 0.0024749999999999998, 0.00252  …  0.376929, 0.394878, 0.40763199999999994, 0.42066499999999996, 0.43686499999999995, 0.4553, 0.472696, 0.48322000000000004, 0.486576, 0.49293200000000004])
```
"""
function *(a::RSpec, b::RSpec)
    reflectance_spec(a.λ, a.r .* b.r)
end

*(a::RSpec, b::RSpec, c...) = *((a * b), c...)


"""
    *(a::TSpec, b::TSpec)

Stacking of two filters.

Results in a transmission spectrum `TSpec` due to the combination of two transmissive spectra using Bouguer’s/Beer’s Law.

"""
function *(a::TSpec, b::TSpec)
    transmittance_spec(a.λ, a.t.^a.x .* b.t.^b.x, 1.0)
end

*(a::TSpec, b::TSpec, c...) = *((a * b), c...)



############
# + operator
############
#
# mixing of two reflectance spectra
#
# always results in a reflectance spectrum
#

"""
    +(a::LSpec, b::LSpec)

Combination of two luminance spectra. Additive mixture.

# Examples:

```jldoctest
julia> D_series_illuminant(6504) + D_series_illuminant(4010)
LSpec(Real[390.0, 391.0, 392.0, 393.0, 394.0, 395.0, 396.0, 397.0, 398.0, 399.0  …  821.0,
822.0, 823.0, 824.0, 825.0, 826.0, 827.0, 828.0, 829.0, 830.0], Real[71.28837977644169,
75.09766988566693, 78.90695999489216, 82.7162501041174, 86.52554021334264, 90.33483032256788,
94.14412043179311, 97.95341054101836, 101.7627006502436, 105.57199075946883  … 148.07280275201228,
148.84652207565884, 149.6202413993054, 150.39396072295196, 151.16768004659852, 151.94139937024508,
152.7151186938916, 153.48883801753817, 154.26255734118473, 155.0362766648313])
```
"""
function +(a::LSpec, b::LSpec)
    luminance_spec(a.λ, a.l .+ b.l)
end

+(a::LSpec, b::LSpec, c...) = +((a + b), c...)

"""
    +(a::RSpec, b::RSpec, ratio=0.5)

Linear combination of two reflectance spectra at a given ratio `r * a / (1 - r) * b`.

Warning: This is *not* a physically realistic colorant mixing method!

# Examples

```jldoctest
```
"""
function +(a::RSpec, b::RSpec, ratio = 0.5)
    if 0 ≤ ratio ≤ 1.0
        return reflectance_spec(a.λ, (ratio .* a.r .+ (1.0 - ratio) .* b.r))
    else throw(DomainError(ratio, "Expecting 0.0 ≤ ratio ≤ 1.0"))
    end
end

+(a::RSpec, b::RSpec, c...) = +((a + b), c...)

############
# × operator
############
#
# always results in a color of type ::Color.XYZ
#
# ×(l::LSpec,cmf::CMatch)
# light > color matching function (white point of a light source)
#
"""
    ×(l::LSpec, cmf::CMatch)

Create white point of a light source in `XYZ` color space.

# Examples:

```jldoctest
```
"""
function ×(l::LSpec, cmf::CMatch)
    y=sum(l.l .* cmf.y)
    Colors.XYZ(sum(l.l .* cmf.x)/y, 1.0, sum(l.l .* cmf.z)/y)
end

# ×(l::LSpec, r::RSpec, cmf::CMatch)
# 
# conversion from spectra to XYZ
"""
    *(l::LSpec, r::RSpec, cmf::CMatch)

Returns `XYZ` color of an illuminant spectrum reflected off a surface.

# Examples:

```jldoctest
```
"""
function *(l::LSpec, r::RSpec, cmf::CMatch)
    wm= (l.l .* cmf.y)
    refl = l.l .* r.r
    Colors.XYZ(sum(refl .* cmf.x)/sum(wm), sum(refl .* cmf.y)/sum(wm), sum(refl .* cmf.z)/sum(wm))
end

function ×(l::LSpec, w::LSpec, cmf::CMatch)
    wm= (l.l .* cmf.y)
    refl = l.l .* w.l
    Colors.XYZ(sum(refl .* cmf.x)/sum(wm), sum(refl .* cmf.y)/sum(wm), sum(refl .* cmf.z)/sum(wm))
end



"""
    *(l::LSpec, t::TSpec, cmf::CMatch)

Returns the `XYZ` color of an illuminant transmitted through a filter.

# Examples:

```jldoctest
```
"""
function *(l::LSpec, t::TSpec, cmf::CMatch)
    wm= (l.l .* cmf.y)
    refl = l.l .* t.t
    Colors.XYZ(sum(refl .* cmf.x) / sum(wm), sum(refl .* cmf.y) / sum(wm), sum(refl .* cmf.z) / sum(wm))
end

"""
    (a::Array{Real,2}, c::ConeFund)

Convert cone fundamentals to CMFs.
"""
function *(a::Array{Real,2}, c::ConeFund)
    if typeof(c) in (LMS31, LMS64, LMS06_2, LMS06_10)
        mat = a * [c.l, c.m, c.s]
    else
        DomainError(c, "Cone fundamental does not exist")
    end
    if size(a) != (3,3)
        DimensionMismatch("Expecting a 3×3 matrix for the first argument.")
    end

    if isa(c,LMS31)
        CIE31(c.λ, mat[1], mat[2], mat[3])
    elseif isa(c,LMS64)
        CIE64(c.λ, mat[1], mat[2], mat[3])
    elseif isa(c,LMS06_2)
        CIE12_2(c.λ, mat[1], mat[2], mat[3])
    elseif isa(c,LMS06_10)
        CIE12_10(c.λ, mat[1], mat[2], mat[3])
    end
end


# Julia infix operators
# * / ÷ % & ⋅ ∘ × \ ∩ ∧ ⊗ ⊘ ⊙ ⊚ ⊛ ⊠ ⊡ ⊓ ∗ ∙ ∤ ⅋ ≀ ⊼ ⋄ ⋆ ⋇ ⋉ ⋊ ⋋ ⋌ ⋏ ⋒ ⟑ ⦸ ⦼ ⦾ ⦿ ⧶ ⧷ ⨇ ⨰ ⨱ ⨲ ⨳ ⨴ ⨵ ⨶ ⨷ ⨸ ⨻ ⨼ ⨽ ⩀ ⩃ ⩄ ⩋ ⩍ ⩎ ⩑ ⩓ ⩕ ⩘ ⩚ ⩜ ⩞ ⩟ ⩠ ⫛ ⊍ ▷ ⨝ ⟕ ⟖ ⟗