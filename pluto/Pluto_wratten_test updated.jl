### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ ec1ac6cc-fa4f-424b-87af-cd4bc6a50b8f
import Pkg;Pkg.add(path="c:/users/4vektor/.julia/dev/SpectralVis")

# ╔═╡ 7cec7fd7-ab69-4b1e-9c0b-7fdcf0c7ed15
using Revise

# ╔═╡ 688ea582-aed8-11eb-1da6-5f19687aaac8
using Plots, SpectralVis, PlutoUI, Colors

# ╔═╡ 2f81fae3-ab8f-4be3-b023-1ed12e393592
html"""<style>
main {
    max-width: 75%;
    margin-left: 1%;
    margin-right: 25% !important;
}
"""

# ╔═╡ 7fe6b71d-f7ee-4cab-b83a-5c198f1be670
gr()

# ╔═╡ 17bbdfe4-b5bd-4e40-88b6-163b10873b5f
begin
	env = set_specenv()
	env.ex = :zero
end

# ╔═╡ d5909d18-85ad-4caa-9ea5-fce116ecca09
md"Wratten filter number"

# ╔═╡ d96d3c21-a402-42df-ab10-d1948d9337f4
#@bind FILT Slider(1:131)
@bind FILT html"<input type='range' style='width: 500px' min='1' max='131' step='1'>"

# ╔═╡ 6cddd9cb-530c-4487-a340-cb123823a993
FILT

# ╔═╡ 55e846b9-2123-448d-bbc6-83ee4c5109a7
@bind MB Slider(1:127, default = 1)

# ╔═╡ df067659-c5b7-47f6-a881-1cc202cecbf6
md"Use metameric black from $MB:"

# ╔═╡ 1f39485f-fc8e-4d8a-9178-0bca54f8bbf1
@bind FACT Slider(-2.0:0.1:2.0, default = 0.0)

# ╔═╡ f1d48cce-a989-429b-9ec0-f3406dddf9bc
md"Factor for metameric black: $FACT"

# ╔═╡ a8b2389f-45f0-4080-a00a-5491f36d3c16
begin
	T = 6504 # D65 CCT
	#illum = normalize_spec(D_series_illuminant(T),1.0)
	illum = normalize_spec(blackbody_illuminant(SPECENV,T),1.0)
	#illum = LSpec(collect(390:830),ones(830-389))
	wrat10 = wratten_filter(FILT)
	#wrat20 = wratten_filter(MB)
	
	wc = tristimulus(illum, wrat10)./100
	#wb = tristimulus(illum, wrat20)./100
	
	plot(ylimits=(-0.1,1.21), size = (900,350),legend=:outertopright, title = "Filter and metameric filter", xaxis = "wavelength [nm]", yaxis = "transmittance")
	
	# filter colorization:
	filt = XYZ(wc[1],wc[2],wc[3])
	# alternative fund. met. colorization:
	#altblack = XYZ(wb[1],wb[2],wb[3])	

	
	# fundamental metamer of filter 1
	#meta = fundamental_metamer(illum, wrat10)

	# original metameric black of filter 1
	#bla = metameric_black(illum, wrat10)
	#alternative metameric black of filter 2
	#mbla = metameric_black(illum,wrat20)

	scatter!(wrat10.λ,wrat10.t, color = filt, linewidth = 1.0, label = "wratten filter")
	#plot!(meta.λ,meta.l, color = funda, linewidth = 2.0, style = :dash, label = "fund. met.")
	#plot!(bla.λ,bla.l, color = :black, label = "metameric black")
	#plot!(mbla.λ,mbla.l, color = altblack, linewidth = 2, label = "altern. metameric black")
	#plot!(meta.λ,wrat10.t.+mbla.l.*1, linewidth = 3.0, color = altblack ,style = :dash, label = "wratten filt. + black * $(round(FACT, digits=1))")
end

# ╔═╡ 465b2e9b-d551-4413-a803-7e5b8358b13d
XYZ(wc[1],wc[2],wc[3])

# ╔═╡ Cell order:
# ╠═2f81fae3-ab8f-4be3-b023-1ed12e393592
# ╠═ec1ac6cc-fa4f-424b-87af-cd4bc6a50b8f
# ╠═688ea582-aed8-11eb-1da6-5f19687aaac8
# ╠═7cec7fd7-ab69-4b1e-9c0b-7fdcf0c7ed15
# ╠═7fe6b71d-f7ee-4cab-b83a-5c198f1be670
# ╠═17bbdfe4-b5bd-4e40-88b6-163b10873b5f
# ╟─d5909d18-85ad-4caa-9ea5-fce116ecca09
# ╟─6cddd9cb-530c-4487-a340-cb123823a993
# ╠═d96d3c21-a402-42df-ab10-d1948d9337f4
# ╟─df067659-c5b7-47f6-a881-1cc202cecbf6
# ╠═55e846b9-2123-448d-bbc6-83ee4c5109a7
# ╟─f1d48cce-a989-429b-9ec0-f3406dddf9bc
# ╠═1f39485f-fc8e-4d8a-9178-0bca54f8bbf1
# ╠═465b2e9b-d551-4413-a803-7e5b8358b13d
# ╠═a8b2389f-45f0-4080-a00a-5491f36d3c16
