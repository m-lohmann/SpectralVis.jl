### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ 4155e7d0-a9f6-11eb-1cf4-ff8e390713db
using SpectralVis

# ╔═╡ 474e20d1-fce7-4d63-95b5-511af903b2a9
using Plots

# ╔═╡ 8af080d9-c436-4de7-8443-71b8b658e7dd
function spectralmix(c1, c2)
	reflectance_spec(c1.λ,(c1.r.+c2.r)/2)
end

# ╔═╡ 0a4f8542-87a6-4e66-a895-94eaded147c0
set_specenv()

# ╔═╡ faeb5ddd-37ed-47b3-a2bf-062a2635fa98
SPECENV

# ╔═╡ 87eb6bed-da99-46cc-a1fb-30a561026331
begin
	blue=macbeth(:Macbeth_chart2,24)
	red=macbeth(:Macbeth_chart2,19)
	mix=spectralmix(red,blue)
	cmatch = SPECENV.cmf
	rspl = spline3(red.λ,red.r,:natural)
	bspl = spline3(blue.λ,blue.r,:natural)
	pspl = spline3(mix.λ,mix.r,:natural)
	re = extrap(rspl,390:830,:linear)
	be = extrap(bspl,390:830,:linear)
	mixe = extrap(pspl,390:830,:linear)
	ri = interp(re,390:1:830)
	bi = interp(be,390:1:830)
	mixi = interp(mixe,390:1:830)
	dill=D_series_illuminant(6500)
	dswp=D_series_whitepoint(6500)
	redcol=convert(Lab,dill*RSpec(ri[1],ri[2])*SPECENV.cmf,dswp)
	blucol=convert(Lab,dill*RSpec(bi[1],bi[2])*SPECENV.cmf,dswp)
	mixcol=convert(Lab,dill*RSpec(mixi[1],mixi[2])*SPECENV.cmf,dswp)
	
	scatter([blucol.a mixcol.a redcol.a],[blucol.b mixcol.b redcol.b], color=[blucol mixcol redcol],markersize=10,legend=:outertopright,xlimits=(-55,55),ylimits=(-55,55),aspect_ratio=1)
end

# ╔═╡ bf708eec-143a-4b6a-9f6d-f163134e0724
blucol.l

# ╔═╡ cd316ddd-3e70-4769-8686-b0fd7f034ab4
dill*RSpec(ri[1],ri[2])*SPECENV.cmf

# ╔═╡ 7b21efd3-16ff-4a9c-a6ca-4c8902b0c7a1
dswp

# ╔═╡ deecc0c1-cc04-49d5-aa99-8708f77f6ca1
[blucol,mixcol,redcol]

# ╔═╡ Cell order:
# ╠═4155e7d0-a9f6-11eb-1cf4-ff8e390713db
# ╠═474e20d1-fce7-4d63-95b5-511af903b2a9
# ╠═8af080d9-c436-4de7-8443-71b8b658e7dd
# ╠═0a4f8542-87a6-4e66-a895-94eaded147c0
# ╠═faeb5ddd-37ed-47b3-a2bf-062a2635fa98
# ╠═87eb6bed-da99-46cc-a1fb-30a561026331
# ╠═bf708eec-143a-4b6a-9f6d-f163134e0724
# ╠═cd316ddd-3e70-4769-8686-b0fd7f034ab4
# ╠═7b21efd3-16ff-4a9c-a6ca-4c8902b0c7a1
# ╠═deecc0c1-cc04-49d5-aa99-8708f77f6ca1
