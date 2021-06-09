#####################
# Spectral operators
#####################
# Operators for spectral and color calculations
# For spectral calculations operations are based on the physically plausible order, like
#
# light source > reflectance (light bounced off a surface)
# light source > transmission (filtered light)
# transmission > transmission (combination of two filters)


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
`*(::LSpec, ::RSpec)``

results in a luminance spectrum `LSpec` due to an illuminant spectrum reflected by a reflectance spectrum.

Result: `LSpec`
"""
function *(l::LSpec,r::RSpec)
    LSpec(l.λ, l.l .* r.r)
end


"""
`*(::LSpec, ::TSpec)``

results in a luminance spectrum `LSpec` due to an illuminant filtered by a transmission spectrum.

Result: `LSpec`
"""
function *(l::LSpec,f::TSpec)
    LSpec(l.λ, l.l .* f.t.^f.x)
end

"""
`*(::TSpec, ::TSpec)`

results in a transmission spectrum `TSpec` due to the combination of two transmissive spectra, using Bouguer’s/Beer’s Law. Combination of two filters.

Result: `TSpec`
"""
function *(f1::TSpec,f2::TSpec)
    transmittance_spec(f1.λ, f1.t.^f1.x .* f2.t.^f2.x,1.0)
end

############
# + operator
############
#
# mixing of two reflectance spectra
#
# always results in a reflectance spectrum
#
function +(l::RSpec, r::RSpec, ratio=0.5)
    if 0 < ratio <= 1.0
        return reflectance_spec(l.λ,(ratio.*l.r .+ (1.0-ratio).*r.r))
    else error("Ratio must be between 0.0 and 1.0")
    end
end


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
`×(l::LSpec,cmf::CMatch)`

create white point of a light source in `XYZ` color space.

`light source` -> `CMF`
"""
function ×(l::LSpec,cmf::CMatch)
    y=sum(l.l .* cmf.y)
    Colors.XYZ(sum(l.l .* cmf.x)/y, 1.0, sum(l.l .* cmf.z)/y)
end

# ×(l::LSpec, r::RSpec, cmf::CMatch)
# 
# conversion from spectra to XYZ
"""
`×(l::LSpec, r::RSpec, cmf::CMatch)`

Returns color of Light reflected off a surface.

`light source` > `reflectance` > `CMF` (color of illuminated surface)

Result: `::XYZ`
"""
function ×(l::LSpec, r::RSpec, cmf::CMatch)
    wm= (l.l .* cmf.y)
    refl = l.l .* r.r
    Colors.XYZ(sum(refl .* cmf.x)/sum(wm), sum(refl .* cmf.y)/sum(wm), sum(refl .* cmf.z)/sum(wm))
end


"""
`×(l::LSpec, t::TSpec, cmf::CMatch)`

Returns color of Light transmitted through a filter.

`light source` > `transmittance` > `CMF` (color of filtered light)

Result: `::XYZ`
"""
function ×(l::LSpec, t::TSpec, cmf::CMatch)
    wm= (l.l .* cmf.y)
    refl = l.l .* t.t
    Colors.XYZ(sum(refl .* cmf.x)/sum(wm), sum(refl .* cmf.y)/sum(wm), sum(refl .* cmf.z)/sum(wm))
end


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