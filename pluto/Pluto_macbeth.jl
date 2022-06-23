### A Pluto.jl notebook ###
# v0.19.4

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

# ╔═╡ d2abcb88-551d-408e-a91c-df75bab86b1d
import Pkg

# ╔═╡ 42365ff1-b3c1-4274-9ab3-4cecab55f14b
Pkg.add("PlutoUI")

# ╔═╡ e6ec51dc-4ac7-4ab5-96ce-a40c6c78fbf4
Pkg.add(path = "c:/Users/4vektor/.julia/dev/SSPline")


# ╔═╡ 8365b3e1-fd95-45cd-81b7-3a9aa2155296
Pkg.add(path = "c:/Users/4vektor/.julia/dev/SpectralVis")

# ╔═╡ f8c56346-91d2-4996-927e-c43828d1adb3
Pkg.add("GLMakie")

# ╔═╡ 37080ff2-a3b7-11eb-3634-af524d492479
using PlutoUI

# ╔═╡ 1fc56f02-306a-459c-a120-e5a5d3639ea0
using GLMakie

# ╔═╡ b72d8d6b-4a7e-4cd0-a0af-5ac8e51aa993
using SSpline

# ╔═╡ d2f759bf-2f78-403f-989e-a35b2e2c7a84
using SpectralVis

# ╔═╡ 201148e9-e528-435e-afc8-9e4390e2729d
#plotlyjs()
#plotly()
pyplot()

# ╔═╡ 22394b49-4e75-444e-b19f-1bfc637dbe98
md"Cell width:"

# ╔═╡ e62085f0-b38a-43cc-a277-0504da926958
html"""<style>main {max-width: 950px;}</style>"""


# ╔═╡ 9e05057a-216a-44eb-95cc-b15b46fc2d3d
md"Color matching function defined in the spectral environment SPECENV:"

# ╔═╡ 54e4792f-0294-4c58-931b-4c3a5ac624ed
begin
	#SPECENV.cmf= cmf(:cie12_2)
	#SPECENV.cmf = cmf(shift_colormatch(conefund(:cie12_10),:l,0))
	cmfunc = SPECENV.cmf
	env = SPECENV
end

# ╔═╡ e8a8bfda-adbd-4a91-8f6e-fb2c4a9f591f
isa(cmfunc, SpectralVis.CIE12_2)

# ╔═╡ 07f523c0-dda4-4e52-b13b-840a8de69648
shift_colormatch(conefund(:cie12_2),:l,0.0)

# ╔═╡ 28c0b9e7-9faa-4814-8e1d-5c67a58dfe14
md"Cubic spline interpolation and extrapolations to mach the CMF range:"

# ╔═╡ 54dfc832-dcc2-463c-9be9-ba785f0fec30
md"colorpatch:"

# ╔═╡ 455c4526-1dd0-461d-a40d-d4c9be7b9c2c
md"##### Definitions of source and destination white points and illuminant spectra:"

# ╔═╡ d96a11d2-6321-4b88-9798-9809533a734f
md"Definitions of Macbeth Chart ground truth, source, and destination colors according to user choice of CCT and CAT:"

# ╔═╡ 27c3f7c1-afc6-4095-86a2-85c4651ab75d
md"Color Checker patch spectrum:"

# ╔═╡ d128b785-6a9b-48c0-973a-4acfd24fa97c
md"""## Macbeth Color Checker
All colors are shown in sRGB color space. **Warning**: color patch **Cyan** (3rd row, rightmost column) is just outside of sRGB color gamut. Even ground truth color in the outer ring will display a slight error."""

# ╔═╡ bab11da2-681f-41a8-ae66-c73b6acaf38b
md"""* **Outer ring**: spectral ground truth color at whitepoint D65 (sRGB white point)

* **Inner circle**: color transformed from source CCT to D65 using selected CAT
"""

# ╔═╡ 4c97e960-4c8c-4b34-9ce4-c20b0aa1f764
md"Associate source selection with selection tables:"

# ╔═╡ b69148f5-789e-4e95-8f3b-c78ed71de534
md"Color Adaptation Transform, source illuminant, chart type"

# ╔═╡ 798d5450-00fd-4f18-a962-56374e3e0fcc
@bind CAT Select(["xyzscaling" => "XYZ scaling", "vonkries" => "vonKries scaling", "sharp" =>"Sharp transform", "bradford" => "Bradford transform", "fairchild" => "Fairchild transform", "cat02" => "CAT02 transform", "hpe" => "Hunt-Pointer-Estevez", "bestof20" => "Süsstrunk"], default="cat02")

# ╔═╡ 5d02b2c6-03e4-451a-90ba-5eb2b29d890b
@bind specsource Select(["a" => "CIE Standard Illuminant A", "b" => "CIE Standard Illuminant B", "c" => "CIE Standard Illuminant C", "d" => "CIE D series", "f" => "CIE F series", "gd" => "CIE Gas Discharge series", "bb"  => "Blackbody"], default = "d")

# ╔═╡ 67483e9c-984f-40a1-a68d-71e819ba92d4
begin
	if specsource == "d"
		selection = PlutoUI.Select(["4000" => "D40", "5000" => "D50", "5500" => "D55", "6500" => "D65", "7500" => "D75", "9300" => "D93", "10000" => "D100", "15000" => "D150", "17500" => "D175", "20000" => "D200", "22500" => "D225", "25000" => "D250"], default = "4000")
	elseif specsource == "bb"
		selection = PlutoUI.Select(["800" => "800 K", "900" => "900 K", "1000" => "1000 K", "1250" => "1250 K","1500" => "1500 K", "2856" => "2856 K (Ill. A, tungsten filament)", "4000" => "4000 K", "5000" => "5000 K", "5500" => "5500 K", "6500" => "6500 K", "7500" => "7500 K", "9300" => "9300 K", "10000" => "10,000 K", "15000" => "15,000 K", "17500" => "17,500 K", "20000" => "20,000 K", "22500" => "22,500 K", "25000" => "25,000 K", "50000" => "50,000 K", "75000" => "75,000 K", "100000" => "100,000 K"], default = "5000")
	elseif specsource == "a"
		selection = PlutoUI.Select(["2856" => "2856 K"], default = "2856")
	elseif specsource == "b"
		selection = PlutoUI.Select(["4874" => "4874 K"], default = "4874")
	elseif specsource == "c"
		selection = PlutoUI.Select(["6774" => "6774 K"], default = "6774")
	elseif specsource == "f"
		selection = PlutoUI.Slider(1:12; default = 2, show_value = true)
	elseif specsource == "gd"
		selection = PlutoUI.Slider(1:7; default = 1, show_value = true)
	end
	nothing
end

# ╔═╡ e59483cc-5366-40cb-8086-381915eb3531
@bind sourcetemp selection

# ╔═╡ c71b58d4-a969-4153-ade5-3ee27044b482
begin
	typeof(sourcetemp) == String ? (stemp = parse(Int,sourcetemp)) : (stemp = sourcetemp)
	cels = round(stemp-273.15,digits=2)
	adapt = Symbol(CAT)
	if specsource == "d"
		sWP = D_series_whitepoint(SPECENV,stemp)
		dWP = D_series_whitepoint(SPECENV,6504.0)
		source = normalized_D_series(SPECENV,stemp)
		dest = normalized_D_series(SPECENV,6504.0)
	elseif specsource == "bb"
		sWP = blackbody_whitepoint(SPECENV,stemp)
		dWP = D_series_whitepoint(SPECENV,6504.0)
		source = normalize_spec(blackbody_illuminant(SPECENV,stemp),1.0)
		dest = normalized_D_series(SPECENV,6504.0)
	elseif specsource == "a"
		sWP = blackbody_whitepoint(SPECENV,2856)
		dWP = D_series_whitepoint(SPECENV,6504.0)
		source = normalize_spec(blackbody_illuminant(SPECENV,2856),1.0)
		dest = normalized_D_series(SPECENV,6504.0)
	elseif specsource == "b"
		sWP = ×(illuminant_B(),SPECENV.cmf)
		dWP = D_series_whitepoint(SPECENV,6504.0)
		source = hardlimit_spec(normalize_spec(illuminant_B(),1.0))
		dest = normalized_D_series(SPECENV,6504.0)
	elseif specsource == "c"
		sWP = ×(illuminant_C(),SPECENV.cmf)
		dWP = D_series_whitepoint(SPECENV,6504.0)
		source = hardlimit_spec(normalize_spec(illuminant_C(),1.0))
		dest = normalized_D_series(SPECENV,6504.0)
	elseif specsource == "f"
		sWP = ×(F_series_illuminant(sourcetemp),SPECENV.cmf)
		dWP = D_series_whitepoint(SPECENV,6504.0)
		source = normalize_spec(F_series_illuminant(sourcetemp),1.0)
		dest = normalized_D_series(SPECENV,6504.0)
	elseif specsource == "gd"
		sWP = ×(gas_discharge_illuminant(sourcetemp),SPECENV.cmf)
		dWP = D_series_whitepoint(SPECENV,6504.0)
		source = normalize_spec(gas_discharge_illuminant(sourcetemp),1.0)
		dest = normalized_D_series(SPECENV,6504.0)
	end
end

# ╔═╡ e99970e1-5b00-42d0-a464-51cded141acf
md"Source CCT: $stemp K / $cels °C"

# ╔═╡ 12ec8fb8-47f4-498a-9df3-6616b6db87a0
@bind chartselect PlutoUI.Slider(1:3)

# ╔═╡ fd90db92-cd97-4157-bb02-70512f7f2ff4
charttype = PlutoUI.Symbol("Macbeth_chart"*string(chartselect))

# ╔═╡ e94743af-b474-4801-ac3e-53703c4ab56b
begin
	groundtruth_patches=Array{Any}(undef,24)
	groundtruth_specs = Array{Any}(undef,24)
	source_patches=Array{Any}(undef,24)
	dest_patches=Array{Any}(undef,24)
	@inbounds for i in 1:24
		macbeth_colorpatch= macbeth(charttype,i)
		cpspline2=cubicspline(macbeth_colorpatch.λ,macbeth_colorpatch.r,:natural)
		cpextr2=extrap(cpspline2,SPECENV.λmin:SPECENV.λmax,:linear)
    	λ2,s2 = interp(cpextr2,(390.0:1.0:830.0))
    	colorpatch2=RSpec(λ2,s2)
		groundtruth_patches[i]= ×(dest, colorpatch2, cmfunc)
		groundtruth_specs[i] = colorpatch2
		source_patches[i]= ×(source, colorpatch2, cmfunc)
		dest_patches[i]= chromatic_adaptation(×(source, colorpatch2, cmfunc), sWP, dWP, Symbol(CAT))
	end
end

# ╔═╡ 261ebe67-9f43-455e-ab37-51f254d26e67
begin
	xcoord=zeros(24)
	ycoord=zeros(24)
	for i=1:24
		row,col=divrem(i-1,6).+(1,1)
		xcoord[i]=col
		ycoord[i]=4.1-row
	end
	layout = (1,2)
	
	#gtru = #GLMakie.Scatter(xcoord,ycoord,color=groundtruth_patches,markersize=40,markerstrokewidth=0,markershape= :circle, aspect_ratio=:equal)
	GLMakie.scatterlines(xcoord,ycoord, color = groundtruth_patches)
	adap = GLMakie.scatter!(xcoord,ycoord,color=dest_patches,markersize=24,markerstrokewidth=0,markershape= :circle, aspect_ratio=:equal)
	#GLMakie.plot(adap, xrange=(0.2,6.8),yrange=(-0.4,3.6),background=Lab(25,0,0),foreground=Lab(25,0,0),ticks=false,legend=false,size=(820*0.8,560*0.8))
end

# ╔═╡ 28f92850-856b-4539-8ef8-111b3ca06313
md"Spectrum of color patch and light source:"

# ╔═╡ fa59297b-e992-4285-8295-b5c8273d8a9d
md"Patch Array initialization"

# ╔═╡ c3370bb8-b574-4c82-a1a2-5cbe04e3da29
md"Color shift from pre-adaptation to adaptation with applied CAT vs. ground truth"

# ╔═╡ 5e8c03cc-c67a-445e-b775-b339b0beba03
md"""
|Src. WP | dest. WP | src. color | dest. color | ground truth color|
|:---|:---:|:---:|:---:|:---:|
rel. to D65 | D65 WP | rel. to D65 | rel. to D65"""

# ╔═╡ 57ac1b78-5d10-4ff4-b30b-430cc111f925
md"Patch color:"

# ╔═╡ 6eafc330-c225-4f26-8a17-561467a8be13
begin
	colordict=["1" => "dark skin", "2" => "light skin", "3" => "blue sky", "4" => "foliage", "5" => "blue flower", "6" => "bluish green", "7" => "orange", "8" => "purplish blue", "9" => "moderate red", "10" => "purple", "11" => "yellow green", "12" => "orange yellow", "13" => "blue", "14" => "green", "15" => "red", "16" => "yellow", "17" => "magenta", "18" => "cyan", "19" => "white 9.5", "20" => "neutral 8", "21" => "neutral 6.5", "22" => "neutral 5", "23" => "neutral 3.5", "24" => "black 2"]
@bind patch Select(colordict, default = "1")
end

# ╔═╡ f9c57d5c-b947-445f-b479-91515cd473b8
mbcolorpatch= macbeth(:Macbeth_chart2,parse(Int,patch))

# ╔═╡ e9951abb-915a-4799-8ed7-5c97490e8c8e
begin
	cpspline=cubicspline(mbcolorpatch.λ,mbcolorpatch.r,:natural)
	cpextr=extrap(cpspline,390.0:830.0,:linear)
    l,s = interp(cpextr,(390.0:1.0:830.0))
    colorpatch=RSpec(l,s)
end

# ╔═╡ 4d5584ab-2ed2-4831-8b5e-9c766a59c4a5
begin
	index=parse(Int,patch)
	groundtruth=groundtruth_patches[index]
	sourcecolor=source_patches[index]
	destcolor=dest_patches[index]
end

# ╔═╡ 0e8135ab-8592-4e9a-b0db-41b83c5fccaf
md"""
________________________$[sWP,dWP,sourcecolor,destcolor,groundtruth]
"""

# ╔═╡ 4c35d989-97fe-47cf-8db2-1218e4055072
begin
	gt = convert(DIN99o,groundtruth)
	sc = convert(DIN99o,sourcecolor)
	dc = convert(DIN99o,destcolor)
	#GLMakie.scatterlines([0],[0],legend = :outertopright, ratio = 1.0, xaxis="a*99",yaxis="b*99", title="Color coordinates in DIN99o color space", size = (800,450))
	#scatter(zeros(10),zeros(10), color=Lab(50,0,0),markersize=2, shape = :hexagon,  label="neutral axis",legend=:outertopleft, aspect_ratio= :equal,background=Lab(20,0,0))
	GLMakie.scatter!([sc.a],[sc.b], color = sourcecolor,markersize=9, shape = :diamond, label="source color")
	GLMakie.scatter!([gt.a],[gt.b], color=groundtruth,markersize=10, markershape = :hexagon, label="ground truth")
	GLMakie.scatter!([dc.a],[dc.b], color = destcolor,markersize=8, shape = :circle, label="destination color")
	GLMakie.quiver!([sc.a],[sc.b],quiver=([dc.a-sc.a],[dc.b-sc.b]),arrowsize=1,marker=:none,color=:black)
end

# ╔═╡ 0855f0cc-2e79-4916-a785-87c45aef0f4f
begin
	#scatter(mbf.λ,mbf.r,label="original")
	#scatter!(colorpatch.λ,colorpatch.r,color=groundtruth,markersize=1, label=false)
	GLMakie.plot(source.λ,source.l,color=sWP,linewidth = 4,label="light source $sourcetemp K")
	GLMakie.plot!(groundtruth_specs[index].λ,groundtruth_specs[index].r, size = (700, 350),ylimits = (-0.1,1.5), color=groundtruth, linewidth = 2,label="Color Checker $patch",foreground = DIN99o(100.0,0,0), background=DIN99o(100-gt.l,0,0),legend=:outertopright)
	#scatter!(source.λ,source.l,color=sWP,markersize = 1, label=false)
end

# ╔═╡ df224fbf-e32f-47b0-824b-3ada60992734
begin
	ΔE = round(sqrt((gt.a - dc.a)^2 + (gt.b - dc.b)^2),digits=2)
	nothing
end

# ╔═╡ 91454a50-f4ab-48b8-b9b0-51d0c73fab3b
md"ΔE $(string(typeof(gt))[12:end-9]) = $ΔE"

# ╔═╡ 1202e1dd-d20d-404b-827f-1369ba3a3532
begin
	fund = conefund(:cie12_10)
	#plot(fund.λ,[fund.l,fund.m,fund.s], yscale = :log, markersize = 1)
end

# ╔═╡ 6803db44-a750-4107-b7c9-009f1dfb2876
typeof(conefund(:cie12_2))

# ╔═╡ cbdab8d1-d782-4b69-987c-0661c94180db
convmat(:cie31)

# ╔═╡ 4506b41f-f4b0-42eb-a27d-7e3c1ba9b652
conefund(:cie64)

# ╔═╡ 07df29f9-b7aa-4877-bda6-8e6c32c6d891
md"# MER Caltarget patches"

# ╔═╡ ad9c6ea9-f6c3-415e-bc65-ca817809db8b
begin
	merpatches = Array{Any}(undef,7)
	mersource = Array{Any}(undef,7)
	merdest = Array{Any}(undef,7)
	
	@inbounds for i in 1:7
		merpatch=mer_caltarget(i)
		merspline=spline3(merpatch.λ,merpatch.r,:natural)
		merextr=extrap(merspline,SPECENV.λmin:SPECENV.λmax,:linear)
		λmer,rmer = interp(merextr,(SPECENV.λmin:SPECENV.Δλ:SPECENV.λmax))
		merspec= reflectance_spec(λmer,rmer)
		merpatches[i] = ×(dest, merspec, cmfunc)
		mersource[i] = ×(source, merspec, cmfunc)
		merdest[i] = chromatic_adaptation(×(source, merspec, cmfunc), sWP, dWP, Symbol(CAT))
	end
end

# ╔═╡ Cell order:
# ╠═d2abcb88-551d-408e-a91c-df75bab86b1d
# ╠═42365ff1-b3c1-4274-9ab3-4cecab55f14b
# ╠═e6ec51dc-4ac7-4ab5-96ce-a40c6c78fbf4
# ╠═8365b3e1-fd95-45cd-81b7-3a9aa2155296
# ╠═f8c56346-91d2-4996-927e-c43828d1adb3
# ╠═37080ff2-a3b7-11eb-3634-af524d492479
# ╠═1fc56f02-306a-459c-a120-e5a5d3639ea0
# ╠═b72d8d6b-4a7e-4cd0-a0af-5ac8e51aa993
# ╠═d2f759bf-2f78-403f-989e-a35b2e2c7a84
# ╠═201148e9-e528-435e-afc8-9e4390e2729d
# ╟─22394b49-4e75-444e-b19f-1bfc637dbe98
# ╠═e62085f0-b38a-43cc-a277-0504da926958
# ╟─9e05057a-216a-44eb-95cc-b15b46fc2d3d
# ╠═54e4792f-0294-4c58-931b-4c3a5ac624ed
# ╠═e8a8bfda-adbd-4a91-8f6e-fb2c4a9f591f
# ╠═07f523c0-dda4-4e52-b13b-840a8de69648
# ╟─28c0b9e7-9faa-4814-8e1d-5c67a58dfe14
# ╟─54dfc832-dcc2-463c-9be9-ba785f0fec30
# ╠═e9951abb-915a-4799-8ed7-5c97490e8c8e
# ╟─455c4526-1dd0-461d-a40d-d4c9be7b9c2c
# ╟─c71b58d4-a969-4153-ade5-3ee27044b482
# ╟─d96a11d2-6321-4b88-9798-9809533a734f
# ╠═e94743af-b474-4801-ac3e-53703c4ab56b
# ╟─27c3f7c1-afc6-4095-86a2-85c4651ab75d
# ╠═f9c57d5c-b947-445f-b479-91515cd473b8
# ╟─d128b785-6a9b-48c0-973a-4acfd24fa97c
# ╟─bab11da2-681f-41a8-ae66-c73b6acaf38b
# ╟─4c97e960-4c8c-4b34-9ce4-c20b0aa1f764
# ╟─67483e9c-984f-40a1-a68d-71e819ba92d4
# ╟─b69148f5-789e-4e95-8f3b-c78ed71de534
# ╟─e99970e1-5b00-42d0-a464-51cded141acf
# ╟─798d5450-00fd-4f18-a962-56374e3e0fcc
# ╟─5d02b2c6-03e4-451a-90ba-5eb2b29d890b
# ╟─e59483cc-5366-40cb-8086-381915eb3531
# ╟─fd90db92-cd97-4157-bb02-70512f7f2ff4
# ╟─12ec8fb8-47f4-498a-9df3-6616b6db87a0
# ╟─261ebe67-9f43-455e-ab37-51f254d26e67
# ╟─28f92850-856b-4539-8ef8-111b3ca06313
# ╠═0855f0cc-2e79-4916-a785-87c45aef0f4f
# ╟─fa59297b-e992-4285-8295-b5c8273d8a9d
# ╟─c3370bb8-b574-4c82-a1a2-5cbe04e3da29
# ╟─5e8c03cc-c67a-445e-b775-b339b0beba03
# ╟─0e8135ab-8592-4e9a-b0db-41b83c5fccaf
# ╟─91454a50-f4ab-48b8-b9b0-51d0c73fab3b
# ╟─57ac1b78-5d10-4ff4-b30b-430cc111f925
# ╟─6eafc330-c225-4f26-8a17-561467a8be13
# ╟─4d5584ab-2ed2-4831-8b5e-9c766a59c4a5
# ╟─df224fbf-e32f-47b0-824b-3ada60992734
# ╠═4c35d989-97fe-47cf-8db2-1218e4055072
# ╠═1202e1dd-d20d-404b-827f-1369ba3a3532
# ╠═6803db44-a750-4107-b7c9-009f1dfb2876
# ╠═cbdab8d1-d782-4b69-987c-0661c94180db
# ╠═4506b41f-f4b0-42eb-a27d-7e3c1ba9b652
# ╟─07df29f9-b7aa-4877-bda6-8e6c32c6d891
# ╟─ad9c6ea9-f6c3-415e-bc65-ca817809db8b
