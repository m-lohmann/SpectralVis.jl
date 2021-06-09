### A Pluto.jl notebook ###
# v0.14.2

using Markdown
using InteractiveUtils

# ╔═╡ 44c12b60-97e4-11eb-23f7-eb2bf0847809
using Plots, SSpline, SpectralVis

# ╔═╡ d5fbb184-9eee-41db-8180-1cf5c5b42db7
plotlyjs()

# ╔═╡ 26ffc9f9-e1ec-4187-9eb6-4b0c3fc04223
begin
	x=[10,20,30,40,50]
	y=[19,30,30,15,10]
end

# ╔═╡ 1bb1f1e1-b366-4b31-873b-e4e78d1dca43
marsspec=mars_sky_opportunity()

# ╔═╡ 4f6b10bb-810d-49c4-ab9e-97c935e94504
marsspline=extrap(spline3(marsspec.λ,marsspec.l,:natural),380:830,:linear)

# ╔═╡ e2292549-9f32-427d-aa5b-1b816374caa1
marssky= interp(marsspline,380:1:830)

# ╔═╡ bc9a854d-4fc5-47da-8f09-1e21afe70522
begin
	scatter(marsspec.λ,marsspec.l,markersize=3,yrange=0.0:1.0)
	plot!(marssky[1],marssky[2])
end

# ╔═╡ ae0407ff-283a-4bf8-81ea-f0ac027aab8f
begin
	ms=LSpec(marssky[1],marssky[2])
	mr=RSpec(marssky[1],marssky[2])
end

# ╔═╡ fceaba8b-3c12-4883-8140-0930a75a590e
begin
	two=ms*mr
	three=ms*mr*mr*mr*mr*mr*mr*mr*mr
	plot(ms.λ,ms.l)
	plot!(two.λ,two.l)
	plot!(three.λ,three.l)
end

# ╔═╡ 208ed350-6c4e-40b2-9b3a-0a821b18a778


# ╔═╡ c1485749-eb3b-4f51-8814-416a39e7f5e0
begin
	lin=spline1(x,y)
	linint=interp(lin,10:.5:50)
	cub=spline3(x,y,:natural)
	cubint=interp(cub,10:.5:50)
	cubext=extrap(cub,0:60,:linear)
	extint=interp(cubext,0:.5:60)
end

# ╔═╡ b1299c43-c5a7-434e-8543-1715e23dc33f
begin
	scatter(x,y,color=:black,markersize=3,label="points")
	plot!(linint[1],linint[2],color=:grey,style=:dash,label="linear")
	plot!(cubint[1],cubint[2],color=:cyan,label="cubic nat.")
	plot!(extint[1],extint[2],color=:orange,linestyle=:dash,label="lin. extrap.")
end

# ╔═╡ f536734c-b7c0-4589-9be6-f4abea07faa8
function extrapo(Spl,xrange,extr::Symbol)
    envx=collect(xrange)
    xs=0.0 # start of extrapolatin range
    xe=0.0 # end of extrapolation range
    envx[1] < Spl.x[1] ? xs=envx[1] : xs=Spl.x[1]
    envx[1] < Spl.x[1] ? xs=envx[1] : xs=Spl.x[1]
    envx[end] > Spl.x[end] ? xe=envx[end] : xe=Spl.x[end]
    
    x=copy(Spl.x)
    a=copy(Spl.a)
	nf=nextfloat(Float64(x[end]))
    
    if typeof(Spl) in (LinearSpline, QuadraticSpline, CubicSpline)
        b=copy(Spl.b)
    end
    if typeof(Spl) in (QuadraticSpline, CubicSpline)
        c=copy(Spl.c)
    end
    if typeof(Spl) == CubicSpline
        d=copy(Spl.d)
    end
	if extr == :zero
		if xs < x[1]
			pushfirst!(x,xs)
			pushfirst!(a, 0.0)
			if typeof(Spl) in (LinearSpline, QuadraticSpline, CubicSpline)
				pushfirst!(b,0.0)
			end
			if typeof(Spl) in (QuadraticSpline,CubicSpline)
				pushfirst!(c,0.0)
			end
			if typeof(Spl) == CubicSpline
				pushfirst!(d,0.0)
			end
		end
		if xe ≥ x[end]
			if typeof(Spl) in (LinearSpline, QuadraticSpline, CubicSpline)
				x[end]=nf
				push!(x,xe)
				push!(a,0.0)
				push!(b,0.0)
			end
			if typeof(Spl) in (QuadraticSpline,CubicSpline)
				push!(c,0.0)
			end
			if typeof(Spl) == CubicSpline
				push!(d,0.0)
			end
		end
	elseif extr == :boundary
		de=x[end]-x[end-1]
		if xs < x[1]
			pushfirst!(x,xs)
			pushfirst!(a, a[1])
			if typeof(Spl) in (LinearSpline, QuadraticSpline, CubicSpline)
				pushfirst!(b,0.0)
			end
			if typeof(Spl) in (QuadraticSpline,CubicSpline)
				pushfirst!(c,0.0)
			end
			if typeof(Spl) == CubicSpline
				pushfirst!(d,0.0)
			end
		end
		if xe ≥ x[end]
			if typeof(Spl) == LinearSpline
				push!(a,Spl.b[end]*de+Spl.a[end])
				push!(b,0.0)
				x[end]=nf
			end
			if typeof(Spl) == QuadraticSpline
				push!(a,c[end]*de^2 + b[end]*de + a[end])
				push!(b,0.0)
				push!(c,0.0)
				x[end]=nf
			end
			if typeof(Spl) == CubicSpline
				push!(a,d[end]*de^3 + c[end]*de^2 + b[end]*de + a[end])
				push!(b,0.0)
				push!(c,0.0)
				push!(d,0.0)
				x[end]=nf
			end
		end
		push!(x,xe)
	elseif extr == :linear
		if xs < x[1]
			pushfirst!(x,xs)
			# 
			pushfirst!(a,a[1]+b[1]*(x[1]-x[2]))
			if typeof(Spl) in (LinearSpline, QuadraticSpline, CubicSpline)
				pushfirst!(b,b[1])
			end
			if typeof(Spl) in (QuadraticSpline,CubicSpline)
				pushfirst!(c,0.0)
			end
			if typeof(Spl) == CubicSpline
				pushfirst!(d,0.0)
			end
		end
		if xe ≥ x[end]
			if typeof(Spl) == LinearSpline
				push!(a,a[end]+b[end]*(x[end]-x[end-1]))
				push!(b,b[end])
			end
			if typeof(Spl) == QuadraticSpline
				push!(c,0.0)
			end
			if typeof(Spl) == CubicSpline
				de=x[end]-x[end-1]
				push!(a,d[end]*de^3 + c[end]*de^2 + b[end]*de + a[end])
				push!(b,3*d[end]*de^2 + 2*c[end]*de + b[end])
				push!(c,0.0)
				push!(d,0.0)
				x[end]=nf
			end
		end
		push!(x,xe)
    elseif extr == :quadratic
        if xs < x[1]
            pushfirst!(x,xs)
            if typeof(Spl) in (LinearSpline, QuadraticSpline, CubicSpline)
                pushfirst!(b,x[1]*((a[3]-a[2])+x[2]*(a[1]-b[3])+x[3]*(a[2]-a[1]))/((x[1]-x[2])*(x[1]-x[3])*(x[2]-x[3])))
                pushfirst!(a,a[1]/(b[1]*(x[1]-xs)))
            end
            if typeof(Spl) in (QuadraticSpline, CubicSpline)
                pushfirst!(c,0.0)
            end
            if typeof(Spl) == CubicSpline
                pushfirst!(d,0.0)
            end
        end
        if xe ≥ x[end]
            push!(x,xe)
            if typeof(Spl) in (LinearSpline, QuadraticSpline, CubicSpline)
                push!(b,x[end-2]*((a[end]-a[end-1])+x[end-1]*(a[end-2]-b[end])+x[end]*(a[end-1]-a[end-2]))/((x[end-2]-x[end-1])*(x[end-2]-x[end])*(x[end-1]-x[end])))
                push!(a,a[end]/(b[end]*(x[end]-xs)))
            end
            if typeof(Spl) in (QuadraticSpline, CubicSpline)
                push!(c,0.0)
            end
            if typeof(Spl) == CubicSpline
                push!(d,0.0)
            end
        end
    else error("Extrapolation type $extr does not exist.")
    end
    if typeof(Spl) == NearestNeighborSpline
        NearestNeighborSpline(a,x)
    elseif typeof(Spl) == LinearSpline
        LinearSpline(b,a,x)
    elseif typeof(Spl) == QuadraticSpline
        QuadraticSpline(c,b,a,x)
    else
        CubicSpline(d,c,b,a,x)
    end
end

# ╔═╡ Cell order:
# ╠═44c12b60-97e4-11eb-23f7-eb2bf0847809
# ╠═d5fbb184-9eee-41db-8180-1cf5c5b42db7
# ╠═26ffc9f9-e1ec-4187-9eb6-4b0c3fc04223
# ╠═1bb1f1e1-b366-4b31-873b-e4e78d1dca43
# ╠═4f6b10bb-810d-49c4-ab9e-97c935e94504
# ╠═e2292549-9f32-427d-aa5b-1b816374caa1
# ╠═bc9a854d-4fc5-47da-8f09-1e21afe70522
# ╠═ae0407ff-283a-4bf8-81ea-f0ac027aab8f
# ╠═fceaba8b-3c12-4883-8140-0930a75a590e
# ╠═208ed350-6c4e-40b2-9b3a-0a821b18a778
# ╠═c1485749-eb3b-4f51-8814-416a39e7f5e0
# ╠═b1299c43-c5a7-434e-8543-1715e23dc33f
# ╠═f536734c-b7c0-4589-9be6-f4abea07faa8
