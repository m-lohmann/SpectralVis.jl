### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ 60b53bf6-dfa2-4fc5-b725-9e4239f7132c
using Colors, SpectralVis

# ╔═╡ 23835930-c0e0-11eb-21a7-49aedc5bc4b0
md"CIE1960 UCS"

# ╔═╡ 148c4957-ed02-4023-841f-9c5e82a6f796
plotly()

# ╔═╡ 144388e1-7642-4aba-b402-04a2114d9268
function cie60(c::XYZ)
	U = 2 * c.x / 3
	V = c.y
	W = 0.5 * (-c.x + 3c.y + c.z)
	u = U / (U+V+W)
	v = V / (U+V+W)
	u,v
end

# ╔═╡ f55e9217-f9b6-43e5-b29e-aa532f4adb5c
cie60(XYZ(.1, .5, .1))

# ╔═╡ 50a68b35-6e4d-4cd2-bf77-7aff52afeb83
begin
	temp = 6500
	meg = 1e7
	inv = meg / temp
	
	range = map(x -> 10000000/x, collect(10:500:100000))
	vals = collect(range)
	u = zeros(length(vals))
	v = zeros(length(vals))
	
	for k in 1:length(vals)
		t = vals[k]
		wp = blackbody_whitepoint(SPECENV,t)
		a,b = cie60(wp)
		u[k] = a
		v[k] = b
	end
		
	plot(xlimits=(0.15,0.25))
	scatter!(u,v,ratio = 1.0, color = :orange, markersize = 2, label = "knots")
	
		spl = cubicspline(u,v,:natural)
	sin = interp(spl,u[1]:0.001:u[end])
	plot!(sin[1],sin[2], color = :red, label = "spline")
	
	fine = map(x -> x, collect(100:10:20000))
	f = zeros(length(fine))
	g = zeros(length(fine))
	
	for l in 1:length(fine)
		te = fine[l]
		wpo = blackbody_whitepoint(SPECENV,te)
		c,d = cie60(wpo)
		f[l] = c
		g[l] = d
	end
			
	scatter!(f,g, color = :green, markersize = 1, markerstyle = :cross, label="truth")
end

# ╔═╡ ef6cd9f0-8416-472a-a4bb-43d5265d5757


# ╔═╡ acf3ed94-54cc-408f-bdae-c2eb16c9bbb7
range

# ╔═╡ b09c644b-449f-4756-aa82-c9aeb6e2265c
length(range)

# ╔═╡ Cell order:
# ╟─23835930-c0e0-11eb-21a7-49aedc5bc4b0
# ╠═60b53bf6-dfa2-4fc5-b725-9e4239f7132c
# ╠═148c4957-ed02-4023-841f-9c5e82a6f796
# ╠═144388e1-7642-4aba-b402-04a2114d9268
# ╠═f55e9217-f9b6-43e5-b29e-aa532f4adb5c
# ╠═50a68b35-6e4d-4cd2-bf77-7aff52afeb83
# ╠═ef6cd9f0-8416-472a-a4bb-43d5265d5757
# ╠═acf3ed94-54cc-408f-bdae-c2eb16c9bbb7
# ╠═b09c644b-449f-4756-aa82-c9aeb6e2265c
