#####################
# Spectral operations
#####################

# luminance, reflectance
function ×(l::LSpec,r::RSpec)
    LSpec(l.λ, l.l .* r.r)
end

function ×(r::RSpec,l::LSpec)
    LSpec(l.λ, r.r .* l.l)
end

function ×(l::LSpec,f::TSpec)
    LSpec(l.λ, l.l .* f.t.^f.x)
end

function ×(f1::TSpec,f2::TSpec)
    TSpec(f1.λ, f1.t.^f1.x .* f2.t.^f2.x,1.0)
end

function ∘(l::RSpec, r::RSpec)
    RSpec(l.λ,l.r .* r.r)
end

# conversion from spectra to XYZ
#
# reflected spectrum = luminance spectrum + reflectance spectrum
# X,Y,Z = sum(r.*cmf.x),sum(r.*cmf.y),sum(r.*cmf.z)

*(r::RSpec, cmf::CMatch) = Colors.XYZ(sum(r.r .* cmf.x)/sum(cmf.x), sum(r.r .* cmf.y)/sum(cmf.y), sum(r.r .* cmf.z)/sum(cmf.z))

*(l::LSpec, cmf::CMatch) = Colors.XYZ(sum(l.l .* cmf.x)/sum(cmf.x), sum(l.l .* cmf.y)/sum(cmf.y), sum(l.l .* cmf.z)/sum(cmf.z))