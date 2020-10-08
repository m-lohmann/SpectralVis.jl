# Spectral operations
*(ill::ILSpec,refl::IRSpec) = RSpec(ill.λ,a.l .* b.s)

# conversion from spectra to XYZ
#
# reflected spectrum = luminance spectrum * reflectance spectrum
# X,Y,Z = sum(r.*cmf.x),sum(r.*cmf.y),sum(r.*cmf.z)

function *(refl::IRSpec, cmf::CMatch)
    Colors.XYZ(sum(refl.s .* cmf.x), sum(refl.s .* cmf.y), sum(refl.s .* cmf.z))
end

function *(illum::ILSpec, cmf::CMatch)
    Colors.XYZ(sum(illum.s .* cmf.x), sum(illum.s .* cmf.y), sum(illum.s .* cmf.z))
end