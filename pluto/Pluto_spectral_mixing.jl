### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 45610e71-3ff7-46f6-8863-f926873cd864
using Pkg

# ╔═╡ 4946ce77-2e55-4d0f-ba18-77696f48c806
Pkg.add(path="c:/users/4vektor/.julia/dev/SpectralVis")

# ╔═╡ 4155e7d0-a9f6-11eb-1cf4-ff8e390713db
using SpectralVis

# ╔═╡ 474e20d1-fce7-4d63-95b5-511af903b2a9
using Plots

# ╔═╡ 6f2c7114-2874-4827-b6c6-228bc66e2203


# ╔═╡ e8c93954-54f7-4969-824c-34703328737b
pyplot()

# ╔═╡ 8af080d9-c436-4de7-8443-71b8b658e7dd
function spectralmix(c1, c2)
	reflectance_spec(c1.λ,(c1.r.+c2.r)/2)
end

# ╔═╡ faeb5ddd-37ed-47b3-a2bf-062a2635fa98
env = SPECENV

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
	dill=normalized_D_series(6500)
	dswp=D_series_whitepoint(6500)
	redcol=Colors.convert(Lab,(dill*RSpec(ri[1],ri[2]))×SPECENV.cmf,dswp)
	blucol=Colors.convert(Lab,(dill*RSpec(bi[1],bi[2]))×SPECENV.cmf,dswp)
	mixcol=Colors.convert(Lab,(dill*RSpec(mixi[1],mixi[2]))×SPECENV.cmf,dswp)
	
	scatter([blucol.a mixcol.a redcol.a],[blucol.b mixcol.b redcol.b], color=[blucol mixcol redcol],markersize=10,legend=:outertopright,xlimits=(-55,55),ylimits=(-55,55),aspect_ratio=1)
end

# ╔═╡ 2bddf85b-379a-476d-aefa-d657cb25b6fa
normalized_D_series(6500)*RSpec(ri[1],ri[2])×(env.cmf)

# ╔═╡ bf708eec-143a-4b6a-9f6d-f163134e0724
ri

# ╔═╡ d2fd7469-93a2-4db2-81e2-74ea50ed0cac
dill*RSpec(ri[1],ri[2])

# ╔═╡ 3e946a96-f6ae-4c76-ac5a-fba4968ca6ac
normalized_D_series(6500)

# ╔═╡ 2731a266-3f3e-477e-8382-d47cd6c97129
dill

# ╔═╡ ae0211a8-5958-40e8-a8c1-f72e0929a8fa
LSpec(ri[1],ri[2])×SPECENV.cmf

# ╔═╡ cd316ddd-3e70-4769-8686-b0fd7f034ab4
dill*RSpec(ri[1],ri[2])×SPECENV.cmf

# ╔═╡ 7b21efd3-16ff-4a9c-a6ca-4c8902b0c7a1
dswp

# ╔═╡ deecc0c1-cc04-49d5-aa99-8708f77f6ca1
[blucol,mixcol,redcol]

# ╔═╡ Cell order:
# ╠═45610e71-3ff7-46f6-8863-f926873cd864
# ╠═4946ce77-2e55-4d0f-ba18-77696f48c806
# ╠═6f2c7114-2874-4827-b6c6-228bc66e2203
# ╠═4155e7d0-a9f6-11eb-1cf4-ff8e390713db
# ╠═474e20d1-fce7-4d63-95b5-511af903b2a9
# ╠═e8c93954-54f7-4969-824c-34703328737b
# ╠═8af080d9-c436-4de7-8443-71b8b658e7dd
# ╠═faeb5ddd-37ed-47b3-a2bf-062a2635fa98
# ╠═87eb6bed-da99-46cc-a1fb-30a561026331
# ╠═2bddf85b-379a-476d-aefa-d657cb25b6fa
# ╠═bf708eec-143a-4b6a-9f6d-f163134e0724
# ╠═d2fd7469-93a2-4db2-81e2-74ea50ed0cac
# ╠═3e946a96-f6ae-4c76-ac5a-fba4968ca6ac
# ╠═2731a266-3f3e-477e-8382-d47cd6c97129
# ╠═ae0211a8-5958-40e8-a8c1-f72e0929a8fa
# ╠═cd316ddd-3e70-4769-8686-b0fd7f034ab4
# ╠═7b21efd3-16ff-4a9c-a6ca-4c8902b0c7a1
# ╠═deecc0c1-cc04-49d5-aa99-8708f77f6ca1
