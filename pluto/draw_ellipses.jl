### A Pluto.jl notebook ###
# v0.19.5

using Markdown
using InteractiveUtils

# ╔═╡ 119df1b5-0503-4d27-b074-ac4ee7ae3b14
begin
using Pkg
Pkg.add(path="c:\\Users\\4vektor\\.julia\\dev\\SpectralVis\\")
	using SpectralVis
end

# ╔═╡ e61b7190-bb53-11eb-0fc2-c5fb8589c6ab
using Plots

# ╔═╡ 28b64763-ae5c-434a-b4fb-2aa91da6a2d7
html"""<style> main {max-width: 950px;}"""

# ╔═╡ d8844676-d76d-418d-8311-f9c6409eaa14
md"""

Available ellipse datasets:

* PGN_ellipses, field size **2°** at 48 cd/m² on white surround (24 cd/m², 42°)
* WSS_ellipses, field size **1°** on dark surround, colors shown as **short 0.063 s long flashes**
* FMC_ellipses, field size **2°** at 48 cd/m² on white surround (24 cd/m², 42°)
* WRB_ellipses, field size **2°** at varying luminances on dark surround
* DLM_ellipses, field size **2°** at varying luminances on dark surround
* 12B_ellipses, field size **10°** at varying luminances on white (8.9 cd/m²), **average of 12 observers**
* GF_ellipses, two hexagonal fields of **3°** each (12 cd/m²) on white surround: (6 cd/m², 40°), 32 years old
* AR_ellipses, two hexagonal fields of **3°** each (12 cd/m²) on white surround: (6 cd/m², 40°), 27 years old
* GW_ellipses, two hexagonal fields of **3°** each (12 cd/m²) on white surround: (6 cd/m², 40°), 42 years old
"""

# ╔═╡ 4a60320a-4f48-4d6d-8549-ee5014c424a6
draw_ellipses()

# ╔═╡ 721827c8-f47e-485d-9d36-c06e861ba8ea
begin
	plot(title = "Color Matching Ellipses from various datasets, 3 times enlarged", legend = :topright, xlimits = (0, 0.75), ylimits = (0, 0.75), ratio = 1.0, size = (1200,1200))
	
	scatter!([0.33333],[0.33333], color = :black, shape = :cross, mswidth = 0.0, markersize = 5.0, label = "white point x, y = (1/3, 1/3)")
	
	φ = 3
	pgn = draw_ellipses(PGN_ellipses,φ)
	wss = draw_ellipses(WSS_ellipses,φ#=/4.5=#) # factor given by paper
	dlm = draw_ellipses(DLM_ellipses,φ)
	fmc = draw_ellipses(FMC_ellipses,φ)
	b   = draw_ellipses(B_ellipses,φ)
	ar  = draw_ellipses(AR_ellipses,φ)
	gf  = draw_ellipses(GF_ellipses,φ)
	gw  = draw_ellipses(GW_ellipses,φ)
	wrb = draw_ellipses(WRB_ellipses,φ#=*1.6=#) # factor given by paper
	
	for e in 1:length(b)
		plot!(b[e][1],b[e][2],color = :lightblue3, label = false)
	end
	for e in 1:length(ar)
		plot!(ar[e][1],ar[e][2],color = :blue, label = false)
		plot!(gf[e][1],gf[e][2],color = :violet, label = false)
		plot!(gw[e][1],gw[e][2],color = :green3, label = false)
	end
	for e in 1:length(pgn)
		plot!(pgn[e][1],pgn[e][2], color = :black, label= false)
		plot!(wss[e][1],wss[e][2], color = :grey, style = :dot, label= false)
		plot!(dlm[e][1],dlm[e][2], color = :red, label= false)
		plot!(fmc[e][1],fmc[e][2], color = :gold3, label= false)
		plot!(wrb[e][1],wrb[e][2], color = :orange, markersize = 1.0,label = false)
	end
	plot!([0.0,1.0],[1.0,0.0],color = :black, label = false) # limit to the right
	# labels
	plot!([0],[0],color = :black, label = "PGN, 2° (48 cd/m²) on 42° white (24 cd/m²)")
	plot!([0],[0],color = :lightblue3, label = "12B, 10° at varying luminances on white (8.9 cd/m²)")
	plot!([0],[0],color = :blue, label = "AR, 3°+3° hex (12 cd/m²) on 40° white (6 cd/m²)")
	plot!([0],[0],color = :violet, label = "GF, 3°+3° hex (12 cd/m²) on 40° white (6 cd/m²)")
	plot!([0],[0],color = :green3, label = "GW, 3°+3° hex (12 cd/m²) on 40° white (6 cd/m²)")
	plot!([0],[0],color = :grey, style = :dot, label = "WSS, 1° on dark, 0.063 s flashes")
	plot!([0],[0],color = :red, label = "DLM, 2° on dark surround, varying lumin.")
	plot!([0],[0],color = :gold3, label = "FMC, optimized for fit with PNG, 2° (48 cd/m²) on 42° (24 cd/m²)")
	plot!([0],[0],color = :orange, label = "WRB, 2° on dark surround, varying lumin.")
	
	plot!()
	#draw_ellipses(WRB_ellipses, :red)
	#draw_ellipses(DLM_ellipses, :cyan)
	#draw_ellipses(B_ellipses, :orange)
	#draw_ellipses(GF_ellipses, :skyblue)
	
end

# ╔═╡ 5a223002-a072-45da-9a6a-ad4fdcc8aefb
gw

# ╔═╡ 861a38c3-92f6-4b3a-9a19-eca15e5d7018
#savefig("Color Matching Ellipses from various datasets, 3 times enlarged")

# ╔═╡ Cell order:
# ╠═e61b7190-bb53-11eb-0fc2-c5fb8589c6ab
# ╠═119df1b5-0503-4d27-b074-ac4ee7ae3b14
# ╠═28b64763-ae5c-434a-b4fb-2aa91da6a2d7
# ╟─d8844676-d76d-418d-8311-f9c6409eaa14
# ╠═4a60320a-4f48-4d6d-8549-ee5014c424a6
# ╠═721827c8-f47e-485d-9d36-c06e861ba8ea
# ╠═5a223002-a072-45da-9a6a-ad4fdcc8aefb
# ╠═861a38c3-92f6-4b3a-9a19-eca15e5d7018
