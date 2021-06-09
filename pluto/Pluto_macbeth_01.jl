### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 37080ff2-a3b7-11eb-3634-af524d492479
using Plots, SSpline, SpectralVis

# ╔═╡ accd501b-c865-485b-9c8c-4d7b074b22a3
using PlutoUI

# ╔═╡ 201148e9-e528-435e-afc8-9e4390e2729d
#plotlyjs()
plotly()

# ╔═╡ 22394b49-4e75-444e-b19f-1bfc637dbe98
md"Cell width:"

# ╔═╡ e62085f0-b38a-43cc-a277-0504da926958
html"""<style>main {max-width: 950px;}</style>"""


# ╔═╡ 9e05057a-216a-44eb-95cc-b15b46fc2d3d
md"Color matching function defined in the spectral environment SPECENV:"

# ╔═╡ 54e4792f-0294-4c58-931b-4c3a5ac624ed
begin
	#SPECENV.cmf= SpectralVis.colormatch(CMF2012_2)
	cmfunc = SPECENV.cmf
end

# ╔═╡ 28c0b9e7-9faa-4814-8e1d-5c67a58dfe14
md"Cubic spline interpolation and extrapolations to mach the CMF range:"

# ╔═╡ 54dfc832-dcc2-463c-9be9-ba785f0fec30
md"colorpatch:"

# ╔═╡ 455c4526-1dd0-461d-a40d-d4c9be7b9c2c
md"Definitions of source and destination white points and illuminant spectra:"

# ╔═╡ d96a11d2-6321-4b88-9798-9809533a734f
md"Definitions of Macbeth Chart ground truth, source, and destination colors according to user choice of CCT and CAT:"

# ╔═╡ 07df29f9-b7aa-4877-bda6-8e6c32c6d891
md"MER Caltarget patches"

# ╔═╡ 27c3f7c1-afc6-4095-86a2-85c4651ab75d
md"Color Checker patch spectrum:"

# ╔═╡ d128b785-6a9b-48c0-973a-4acfd24fa97c
md"""## Macbeth Color Checker
All colors are shown in sRGB color space. **Warning**: color patch **Cyan** (3rd row, rightmost column) is just outside of sRGB color gamut. Even ground truth color in the outer ring will display a slight error."""

# ╔═╡ bab11da2-681f-41a8-ae66-c73b6acaf38b
md"""* **Outer ring**: spectral ground truth color at whitepoint D65 (sRGB white point)

* **Inner circle**: color transformed from source CCT to D65 using selected CAT
"""

# ╔═╡ 04857ffb-aa2e-4dd8-af49-10bcc22c4356
charttype=:Macbeth_chart2

# ╔═╡ b69148f5-789e-4e95-8f3b-c78ed71de534
md"Color Adaptation Transform:"

# ╔═╡ 798d5450-00fd-4f18-a962-56374e3e0fcc
@bind CAT Select(["xyzscaling" => "XYZ scaling", "vonkries" => "vonKries scaling", "sharp" =>"Sharp transform", "bradford" => "Bradford transform", "fairchild" => "Fairchild transform", "cat02" => "CAT02 transform", "hpe" => "Hunt-Pointer-Estevez", "bestof20" => "Süsstrunk"], default="vonkries")

# ╔═╡ e59483cc-5366-40cb-8086-381915eb3531
@bind sourcetemp Select(["500" => "*D5", "600" => "*D6", "700" => "*D7", "750" => "*D7.5", "800" => "*D8", "900" => "*D9", "1000" => "*D10", "1500" => "*D15", "2000" => "*D20", "2200" => "*D22", "2700" => "*D27", "3400" => "*D34", "4000" => "D40", "5000" => "D50", "5500" => "D55", "6500" => "D65", "7500" => "D75", "9300" => "D93", "10000" => "D100", "15000" => "D150", "17500" => "D175", "20000" => "D200", "22500" => "D225", "25000" => "D250", "30000" => "*D300", "40000" => "*D400", "50000" => "*D500", "75000" => "*D750"], default = "4000")

#@bind sourcetemp Select(["1000"=> 1000,"1500"=> 1500,"1750"=>1750,"2000"=>2000,"2250"=>2250,"2500"=>2500,"2700"=>2700,"3000"=>3000,"3400"=>3400,"3750"=>3750,"4000"=>4000,"4500"=>4500,"5000"=>5000,"5500"=>5500,"6000"=>6000,"6500"=>6500,"7000"=>7000,"9300"=>9300,"10000"=>10000,"15000"=>15000,"20000"=>20000,"25000"=>25000], default = "4000")

# ╔═╡ c71b58d4-a969-4153-ade5-3ee27044b482
begin
	stemp = parse(Int,sourcetemp)
	cels = round(stemp-273.15,digits=2)
	adapt = Symbol(CAT)
	sWP = D_series_whitepoint(SPECENV,stemp)
	dWP = D_series_whitepoint(SPECENV,6504.0)
	source = normalized_D_series(SPECENV,stemp)
	dest = normalized_D_series(SPECENV,6504.0)
	#sWP = blackbody_whitepoint(SPECENV,stemp)
	#dWP = blackbody_whitepoint(SPECENV,6500)
	#source = normalize_blackbody(blackbody_illuminant(SPECENV,stemp))
	#dest = normalize_blackbody(blackbody_illuminant(SPECENV,6500))
	#source = normalize_spec(blackbody_illuminant(SPECENV,stemp),1.0)
	#dest = normalize_spec(blackbody_illuminant(SPECENV,6500),1.0)
end

# ╔═╡ e94743af-b474-4801-ac3e-53703c4ab56b
begin
	groundtruth_patches=Array{Any}(undef,24)
	source_patches=Array{Any}(undef,24)
	dest_patches=Array{Any}(undef,24)
	@inbounds for i in 1:24
		macbeth_colorpatch= macbeth(charttype,i)
		cpspline2=cubicspline(macbeth_colorpatch.λ,macbeth_colorpatch.r,:natural)
		cpextr2=extrap(cpspline2,SPECENV.λmin:SPECENV.λmax,:linear)
    	λ2,s2 = interp(cpextr2,(390.0:1.0:830.0))
    	colorpatch2=RSpec(λ2,s2)
		groundtruth_patches[i]= ×(dest, colorpatch2, cmfunc)
		source_patches[i]= ×(source, colorpatch2, cmfunc)
		dest_patches[i]= chromatic_adaptation(×(source, colorpatch2, cmfunc), sWP, dWP, Symbol(CAT))
	end
end

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

# ╔═╡ e99970e1-5b00-42d0-a464-51cded141acf
md"Source CCT: $stemp K / $cels °C"

# ╔═╡ 261ebe67-9f43-455e-ab37-51f254d26e67
begin
	xcoord=zeros(24)
	ycoord=zeros(24)

	plot(xrange=(0.2,6.8),yrange=(-0.4,3.6),background=Lab(30,0,0),foreground=Lab(26,0,0),ticks=false,legend=false,size=(820,560))
	for i=1:24
		row,col=divrem(i-1,6).+(1,1)
    	xcoord[i]=col
		ycoord[i]=4.1-row
	end
	scatter!(xcoord,ycoord,color=groundtruth_patches,markersize=52,markerstrokewidth=0,markershape= :circle, aspect_ratio=:equal)
	scatter!(xcoord,ycoord,color=dest_patches,markersize=30,markerstrokewidth=0,markershape= :circle, aspect_ratio=:equal)
end

# ╔═╡ fa59297b-e992-4285-8295-b5c8273d8a9d
md"Patch Array initialization"

# ╔═╡ c3370bb8-b574-4c82-a1a2-5cbe04e3da29
md"Color shift from pre-adaptation to adaptation with applied CAT vs. ground truth"

# ╔═╡ 5e8c03cc-c67a-445e-b775-b339b0beba03
md"Source WP | destination WP | source color | destin. color | ground truth color:"

# ╔═╡ e22a766c-1ab4-4f6d-9b38-98bc579f6de9
md"rel. to D65 | D65 whitepoint | relat. to D65 | adapted |"

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
[sWP,dWP,sourcecolor,destcolor,groundtruth]

# ╔═╡ 4c35d989-97fe-47cf-8db2-1218e4055072
begin
	gt = convert(DIN99o,groundtruth)
	sc = convert(DIN99o,sourcecolor)
	dc = convert(DIN99o,destcolor)
	plot(legend = :outertopright, ratio = 1.0, xaxis="a*99",yaxis="b*99", title="Color coordinates in DIN99o color space", size = (800,450))
	#scatter(zeros(10),zeros(10), color=Lab(50,0,0),markersize=2, shape = :hexagon,  label="neutral axis",legend=:outertopleft, aspect_ratio= :equal,background=Lab(20,0,0))
	scatter!([sc.a],[sc.b], color = sourcecolor,markersize=9, shape = :diamond, label="source color")
	scatter!([gt.a],[gt.b], color=groundtruth,markersize=10, markershape = :hexagon, label="ground truth")
	scatter!([dc.a],[dc.b], color = destcolor,markersize=8, shape = :circle, label="destination color")
	quiver!([sc.a],[sc.b],quiver=([dc.a-sc.a],[dc.b-sc.b]),arrowsize=1,marker=:none,color=:black)
end

# ╔═╡ df224fbf-e32f-47b0-824b-3ada60992734
begin
	ΔE = sqrt((gt.a - dc.a)^2 + (gt.b - dc.b)^2)
	nothing
end

# ╔═╡ 91454a50-f4ab-48b8-b9b0-51d0c73fab3b
md"ΔE $(string(typeof(gt))[12:end-9]) = $ΔE"

# ╔═╡ 28f92850-856b-4539-8ef8-111b3ca06313
md"Spectrum of color patch and light source:"

# ╔═╡ 0855f0cc-2e79-4916-a785-87c45aef0f4f
begin
	#scatter(mbf.λ,mbf.r,label="original")
	plot(colorpatch.λ,colorpatch.r, ylimits = (0.0,1.5), color=groundtruth, linewidth = 2,label="Color Checker $patch",background=DIN99o(100-gt.l,0,0),legend=:outertopright)
	#scatter!(colorpatch.λ,colorpatch.r,color=groundtruth,markersize=1, label=false)
	plot!(source.λ,source.l,color=sWP,linewidth = 4,label="light source $sourcetemp K")
	#scatter!(source.λ,source.l,color=sWP,markersize = 1, label=false)
end

# ╔═╡ 25ddb7d2-584b-4fcc-bae4-2cdf68878751
source

# ╔═╡ Cell order:
# ╠═37080ff2-a3b7-11eb-3634-af524d492479
# ╠═accd501b-c865-485b-9c8c-4d7b074b22a3
# ╠═201148e9-e528-435e-afc8-9e4390e2729d
# ╟─22394b49-4e75-444e-b19f-1bfc637dbe98
# ╠═e62085f0-b38a-43cc-a277-0504da926958
# ╟─9e05057a-216a-44eb-95cc-b15b46fc2d3d
# ╠═54e4792f-0294-4c58-931b-4c3a5ac624ed
# ╟─28c0b9e7-9faa-4814-8e1d-5c67a58dfe14
# ╟─54dfc832-dcc2-463c-9be9-ba785f0fec30
# ╟─e9951abb-915a-4799-8ed7-5c97490e8c8e
# ╟─455c4526-1dd0-461d-a40d-d4c9be7b9c2c
# ╟─c71b58d4-a969-4153-ade5-3ee27044b482
# ╟─d96a11d2-6321-4b88-9798-9809533a734f
# ╟─e94743af-b474-4801-ac3e-53703c4ab56b
# ╟─07df29f9-b7aa-4877-bda6-8e6c32c6d891
# ╟─ad9c6ea9-f6c3-415e-bc65-ca817809db8b
# ╟─27c3f7c1-afc6-4095-86a2-85c4651ab75d
# ╟─f9c57d5c-b947-445f-b479-91515cd473b8
# ╟─d128b785-6a9b-48c0-973a-4acfd24fa97c
# ╟─bab11da2-681f-41a8-ae66-c73b6acaf38b
# ╟─04857ffb-aa2e-4dd8-af49-10bcc22c4356
# ╟─b69148f5-789e-4e95-8f3b-c78ed71de534
# ╟─798d5450-00fd-4f18-a962-56374e3e0fcc
# ╟─e99970e1-5b00-42d0-a464-51cded141acf
# ╟─e59483cc-5366-40cb-8086-381915eb3531
# ╟─261ebe67-9f43-455e-ab37-51f254d26e67
# ╟─fa59297b-e992-4285-8295-b5c8273d8a9d
# ╟─c3370bb8-b574-4c82-a1a2-5cbe04e3da29
# ╟─5e8c03cc-c67a-445e-b775-b339b0beba03
# ╟─e22a766c-1ab4-4f6d-9b38-98bc579f6de9
# ╟─0e8135ab-8592-4e9a-b0db-41b83c5fccaf
# ╟─57ac1b78-5d10-4ff4-b30b-430cc111f925
# ╟─6eafc330-c225-4f26-8a17-561467a8be13
# ╟─4d5584ab-2ed2-4831-8b5e-9c766a59c4a5
# ╟─91454a50-f4ab-48b8-b9b0-51d0c73fab3b
# ╟─df224fbf-e32f-47b0-824b-3ada60992734
# ╟─4c35d989-97fe-47cf-8db2-1218e4055072
# ╟─28f92850-856b-4539-8ef8-111b3ca06313
# ╠═0855f0cc-2e79-4916-a785-87c45aef0f4f
# ╟─25ddb7d2-584b-4fcc-bae4-2cdf68878751
