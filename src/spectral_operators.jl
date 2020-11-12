#####################
# Spectral operations
#####################

# luminance, reflectance
*(l::ILSpec,r::IRSpec) = IRSpec(l.λ, l.l .* r.r)
*(r::IRSpec,l::ILSpec) = IRSpec(l.λ, r.r .* l.l)

# luminance 
#*(l::ILSpec, r::IRSpec, filt::ITSpec) = IRSpec(l.λ,l.l .* r.r .* filt.t.^filt.x)

#luminance through filter
*(l::ILSpec,f::ITSpec) = ILSpec(l.λ, l.l .* f.t.^f.x)

#combine two filters, filter through filter
*(f1::ITSpec,f2::ITSpec) = ITSpec(f1.λ, f1.t.^f1.x .* f2.t.^f2.x,1.0)

# conversion from spectra to XYZ
#
# reflected spectrum = luminance spectrum + reflectance spectrum
# X,Y,Z = sum(r.*cmf.x),sum(r.*cmf.y),sum(r.*cmf.z)

*(r::IRSpec, cmf::CMatch) = Colors.XYZ(sum(r.r .* cmf.x)/sum(cmf.x), sum(r.r .* cmf.y)/sum(cmf.y), sum(r.r .* cmf.z)/sum(cmf.z))

*(l::ILSpec, cmf::CMatch) = Colors.XYZ(sum(l.l .* cmf.x)/sum(cmf.x), sum(l.l .* cmf.y)/sum(cmf.y), sum(l.l .* cmf.z)/sum(cmf.z))
