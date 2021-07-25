### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 1683dfda-924d-48df-a512-3ae220545877
using Plots,SpectralVis

# ╔═╡ 15d67460-cc53-11eb-1d73-89e8d0bfb651
#using PackageCompiler;create_sysimage(:Plots, sysimage_path="sys_plots.so", precompile_execution_file="precompile_plots.jl")

# ╔═╡ 27c29b29-875a-48cc-9c3a-601429da7dc8
begin
	env = SPECENV
	html"""<style>main {max-width: 900px;}</style>"""
end

# ╔═╡ 576dfcef-d2de-4e4c-a8ad-4756730559f8
illum = D65_illuminant()

# ╔═╡ c291aa08-6965-463f-b5ff-5956a386361f
begin
	cfund = conefund(env.cmf)
	cfdef = shift_cone(cfund, :l, -5.0)
	#cfdef = deactivate_cone(cfund, :m)
	newcmf = cmfunc(cfdef)
	oldcmf = env.cmf
	oldr = matrixR(conefund(oldcmf))
	newr = matrixR(conefund(newcmf))
end

# ╔═╡ ecf55fa6-4aec-4fab-be55-1df606e1111b
#begin
#	plot(oldcmf.λ, [oldcmf.x, oldcmf.y, oldcmf.z], color = :black)
#	plot!(newcmf.λ, [newcmf.x, newcmf.y, newcmf.z], color = :green)
#end

# ╔═╡ 03c6c696-1ffe-444a-bd36-dd6684c2ef75
begin
	lev = 8
end

# ╔═╡ 7d169a7b-3554-46ad-a97e-9a7337a05cae
function deficiency(deftype::Symbol, c::Spectrum, illum::LSpec = D65_illuminant() , shift::Real = 0.0)
    cflms = conefund(SPECENV.cmf)
    if deftype == :protanopia
        #Acvd.l = zeros(length(Acvd.l))
		cvd = deactivate_cone(cflms, :l)
    elseif deftype == :deuteranopia
        cvd = deactivate_cone(cflms, :m)
    elseif deftype == :tritanopia
        cvd = deactivate_cone(cflms, :s)
    elseif deftype == :protanomaly
        cvd = shift_cone(cflms, :l, shift)
    elseif deftype == :deuteranomaly
        cvd = shift_cone(cflms, :m, shift)
    elseif deftype == :tritanomaly
        cvd = shift_cone(cflms, :s, shift)
    else
        DomainError(deftype, "Color anomaly type does not exist.")
    end
	#Acvd = matrixA(cvd)
	#col = adapt_spec(c, env, env.ex, :cubic, :natural)
	#Clms = fundamental_metamer(D65_illuminant(), col, conefund(env.cmf))
	#cf = conefund(env.cmf)
	#Rlms = matrix_R(cf)
	#t = typeof(cf)
	#Rcvd = matrix_R(cvd)
	cvd
end

# ╔═╡ b1822d4e-6e83-4044-87da-ba2d578e5a7c
begin
	defi = :protanopia
	col = adapt_spec(agfait(113), env, :linear, :cubic, :natural)
	cvd = deficiency(defi, col, D65_illuminant())
	acvd = matrixA(cvd)
	cf = conefund(env.cmf)
	clms = fundamental_metamer(D65_illuminant(), col, cf)
	rlms = matrixR(cf)
	t = typeof(cf)
	rcvd = matrixR(cvd, defi)
end

# ╔═╡ 0b3183e7-a866-4632-b79e-3022fdfeff0b
begin
	#p1 = contour(oldr, ratio = 1.0, levels = lev, fill = 0, zlimits = (-0.01,0.025))
	p2 = wireframe(collect(1:441), collect(1:441),rcvd, ratio = 1.0)
	plot(p2, size = (900,600))
end

# ╔═╡ 36e9c976-ac66-4330-9ce1-051281980eaf
begin
	match = env.cmf
	Acvd = conefund(match)
	typeof(Acvd)(Acvd.λ, zeros(length(Acvd.λ)), Acvd.m, Acvd.s)
	
end

# ╔═╡ Cell order:
# ╠═15d67460-cc53-11eb-1d73-89e8d0bfb651
# ╠═1683dfda-924d-48df-a512-3ae220545877
# ╠═27c29b29-875a-48cc-9c3a-601429da7dc8
# ╠═576dfcef-d2de-4e4c-a8ad-4756730559f8
# ╠═c291aa08-6965-463f-b5ff-5956a386361f
# ╠═ecf55fa6-4aec-4fab-be55-1df606e1111b
# ╠═03c6c696-1ffe-444a-bd36-dd6684c2ef75
# ╠═0b3183e7-a866-4632-b79e-3022fdfeff0b
# ╟─7d169a7b-3554-46ad-a97e-9a7337a05cae
# ╠═b1822d4e-6e83-4044-87da-ba2d578e5a7c
# ╠═36e9c976-ac66-4330-9ce1-051281980eaf
