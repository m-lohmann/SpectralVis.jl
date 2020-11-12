### A Pluto.jl notebook ###
# v0.12.9

using Markdown
using InteractiveUtils

# ╔═╡ 08af84c0-2456-11eb-326c-2d675ca197af
using SpectralVis

# ╔═╡ 57a60da0-2461-11eb-07df-2b3ab48a6675
using Colors

# ╔═╡ 9ff8ea50-2461-11eb-3143-d1b38243f297
using Plots; pyplot()

# ╔═╡ 14f2d870-245d-11eb-1fe3-779aa49070f1
using SSpline

# ╔═╡ 78adafde-247e-11eb-12e1-ddea99d50711
md"# A quick tour of the `SpectralVis` and `SSpline` packages"

# ╔═╡ dbfc1410-2456-11eb-1274-7d1786793c6e
md"## First, let’s get the basic stuff out of way:"

# ╔═╡ f444ebf0-2460-11eb-2ed3-c5db8e304e95
md"We need to get a few packages to deal with spectra"

# ╔═╡ 1cb25910-2461-11eb-1f85-a9ed9362e326
md"**SpectralVis** contains (almost) everything you need for spectral calculations, spectral data, etc."

# ╔═╡ 5dacb780-2461-11eb-277d-e7226385a5ec
md"The **Colors** package is also needed"

# ╔═╡ 79763630-2461-11eb-0b0d-15b00898c512
md"We also would like to do some plots, so we also use the **Plots** package with the **PyPlot** frontend."

# ╔═╡ 0d1268b0-2461-11eb-15a9-87ca552b10c5
md"Then we need the spectral spline package **SSplines.jl**, which is a specialized spline package for spectral calculations. Apart from specialized functionality, it’s also faster than the **Interpolations.jl** package."

# ╔═╡ 1afb7e20-245d-11eb-1ca8-9da92491cd50
md"Now we’re ready to have some fun!"

# ╔═╡ 0881c790-2462-11eb-05e1-9113e664ec28
md"First, let’s create a light source! We have several options for these."

# ╔═╡ 2f7258b0-2462-11eb-31a2-8da7d9fb1dca
md"One option is to create a black body illuminant. Let’s say our light source is a black body radiator at a temperature of 6500K. We want to create an illuminant in the visual range of wavelength, say between 390 and 830 nm, with a resolution of 1 nm:"

# ╔═╡ 5216c132-2462-11eb-11ef-259ba512e80a
bb6500K = blackbody_illuminant(6500,390,1,830)

# ╔═╡ ad2414b2-2462-11eb-3ea5-955a5a918a30
typeof(bb6500K)

# ╔═╡ d99b2330-2462-11eb-2bee-6b79c56cf0cf
bb6500K.λ

# ╔═╡ e34ef68e-2462-11eb-394c-5712ac9de6da
bb6500K.l

# ╔═╡ e8969630-2462-11eb-3c02-996a99d88691
md"As you can see the ILSpec object has two members: λ and l.

`λ` contains the sampled wavelengths in *nm*, `l` contains the sampled *luminance* at the sampled wavelengths. For reflectance spectra of type `IRSpec`, these are `λ` and `r` (reflectance)."

# ╔═╡ f24e2d8e-2477-11eb-3a27-dfebdfc43440
md"Let’s plot the spectrum of our light source:"

# ╔═╡ 0c6bf812-2478-11eb-14ea-57c6522324f3
plot(bb6500K.λ,bb6500K.l,labels=false)

# ╔═╡ 2c7f7c80-2478-11eb-1728-a1ab0b5ef106
md"Whoa! The luminance values are crazy high! That’s because of the units `[J/m³/s]`. It’s easy to mitigate that. Let’s normalize this spectrum to a peak value of 1.0:"

# ╔═╡ 00a64130-2463-11eb-1ed2-29a671508315
bb65=normalize_spec(bb6500K)

# ╔═╡ 0edd04a0-2463-11eb-0a29-c50a447572d8
md"Let’s check the result:"

# ╔═╡ 18b5ec30-2463-11eb-1f50-9b9fc218273e
bb65.l

# ╔═╡ 1e781300-2463-11eb-2b3e-ff33d0043b07
md"Let’s have a look at the spectrum in a graph:"

# ╔═╡ 369a82b0-2463-11eb-06c0-a79be68e16a6
plot(bb65.λ,bb65.l,labels=false)

# ╔═╡ 47f2352e-2463-11eb-3976-d77c1624e204
md"That looks much better! It’s convenient and common practice in color metrics to normalize illuminants to a value of 1."

# ╔═╡ 60fc2740-247a-11eb-031a-8bef9409f862
md"Another method, which is very useful, is using a CIE Daylight generator, which creates a daylight spectrum according to the CIE daylight standard. It produces a daylight spectrum, like *D65* or *D50*, according to a so-called *correlated color temperature*, also abbreviated as *CCT*. In our case we want a daylight with a CCT of 6500K, which is commonly abbreviated as *D65*:"

# ╔═╡ fdfa8220-2462-11eb-0cf8-c188ac491781
d6500=D_series_illuminant(6500)

# ╔═╡ 89f88560-2463-11eb-38be-eb669b15ab60
md"Before we plot this D65 spectrum, let’s normalize it as well. The standard CIE daylight function generates spectra that are normalized to 100.0 at a wavelength of 555 nm, and the peak luminance is even higher."

# ╔═╡ 97598240-2463-11eb-0ec9-0be99eea414d
d65=normalize_spec(d6500)

# ╔═╡ d0a02310-2463-11eb-2788-5dcb718cf9cb
md"Now we can plot it:"

# ╔═╡ d811596e-2463-11eb-0de0-792feca7ffa0
plot!(d65.λ,d65.l,labels=false)

# ╔═╡ e8a8a220-2463-11eb-2a70-cd5fbe573691
md"Voilá! Looking good!"

# ╔═╡ fe2f5850-2463-11eb-29a7-93f2db686897
md"But we’d like both spectra to have the *same wavelength range*. And both should also have the *same spectral resolution*. The *d65* spectrum has a resolution of only 5 nm. Let’s change that!"

# ╔═╡ 4232ff20-2464-11eb-14d4-c79999ab77bf
md"Here, the *SSpline* package comes into play. Let’s use it to adapt the resolution and range of the *d65* spectrum:"

# ╔═╡ 69e30fb0-2464-11eb-0066-d15aa8c969e3
md"## Spline functions"

# ╔═╡ 9b44a9b0-2464-11eb-138b-0d9775344d9f
md"First, we create a spline object. The Daylight illuminant generator creates linearly interpolated values, so we only need a linear spline object:"

# ╔═╡ c1a3a930-2464-11eb-1bef-996a6b7468f5
d65spl = linearspline(d65.λ,d65.l)

# ╔═╡ c77141b0-2464-11eb-1efa-a73f2a72b3b0
md"As a result, we get an object of type *LinearSpline*. It contains all the spline coefficients at the knots of the spline, and the knots themselves."

# ╔═╡ 07995c00-2465-11eb-125c-b5a167e0fc90
md"Now we want to interpolate this spline at certain values. For the black body illuminant we used the range `390:1:830`, and these are going to be our new `λ` values for the D65 illuminant as well:"

# ╔═╡ 385b81b0-2465-11eb-151f-878bb717e157
λ=collect(390.0:1.0:830.0)

# ╔═╡ a57b2320-247b-11eb-17d1-9fd1ecce6ed5
md"Now we create the new, interpolated values with the `interp` function. The function returns two vectors, one for the `λ` values, one for the luminance values:"

# ╔═╡ 492e25b0-2465-11eb-36eb-491d2c186e8b
lam,s=interp(d65spl,λ)

# ╔═╡ e54233b0-2465-11eb-1f8d-2f087aa4d31e
md"Now all that’s left is creating a new *Spectrum* type object containing these values. In our case we need to creat a luminance spectrum, because we want to create a light source:"

# ╔═╡ 0c92e630-2466-11eb-20c4-9fe8bede9360
d65f=ILSpec(lam,s)

# ╔═╡ 1d179140-2466-11eb-2d71-11e9622e355b
md"What does it look like in the graph?"

# ╔═╡ cb75ef1e-2466-11eb-26b4-d58a8167559c
begin
	plot(d65f.λ,d65f.l, linestyle=:dash, labels=false)
	plot!(bb65.λ,bb65.l,linestyle=:solid, labels=false)
end

# ╔═╡ ddff1cc0-2466-11eb-0709-1baba5e3fca6
md"Excellent!"

# ╔═╡ 0e233640-247e-11eb-193a-ed5ab087c968
md"## Back to Spectra"

# ╔═╡ f9023e30-2466-11eb-346f-8380306e6ab3
md"There are nother ways to generate spectra. The function `led_spec` simulates the spectrum of a light emitting diode:"

# ╔═╡ b9028080-2473-11eb-3bc2-91cb08806a45
led=led_spec(390,830,1,455,30)

# ╔═╡ dde6edf0-2473-11eb-2671-2b1f152e2ced
md"Creates an LED spectrum in the range 390:1:830 nm, with the *peak wavelength* at 455 nm, and the *half spectral width* (bandwidth at 50% of peak intensity) of 30 nm. Let’s have a look at the spectrum:"

# ╔═╡ 62d4c690-2474-11eb-2665-c724b32a74f4
plot!(led.λ,led.l,linestyle=:solid, labels=false)

# ╔═╡ 7bd22cf0-2474-11eb-0266-8bb6aeb08b46
md"And last, but not least, there is a method to create a special kind of spectrum, the so-called *block spectrum*. This type of spectrum is the theoretical extreme of spectra that can be produced. Physically, these do not exist, but they are very useful, if not essential, in researching e.g. the gamuts, which means the range of all theoretically producible colors of color spaces:"

# ╔═╡ f95f7100-2474-11eb-3072-f1d2fdb0ba57
bspec=block_spec(390,830,1,501,533,1.0,0)

# ╔═╡ 23b4ff10-2475-11eb-3324-176b6bc48b81
plot!(bspec.λ,bspec.r,color=:orange, labels=false)

# ╔═╡ 3c46d260-2475-11eb-0204-c3da17762579
md"As you can see, this kind of spectrum only has the values 0.0 or 1.0. This creates the theoretically most saturated colors of any given bandwidth. Block spectra exist as two different types. **Type 1**, which you can see above, creates the purest possible colors with a single center wavelength. Type 1 block spectra are zero everywhere except in the block defined by min und max values.

### Usage:

`block_spec(λmin,λmax,Δλ,λs,λe,str=1.0,mode=0)`

`λmin, λmax, Δλ`: range and resolution of spectrum

`λs,λe`: range of block peak

`str=1.0`: strength of block, default=1.0. Setting this to other values can be useful in certain cases.

`mode=0`: mode for single peak block spectrum, default = 0
"

# ╔═╡ b3ee6870-247d-11eb-0587-ef4e7989be87
md"Type 1 block spectra create the inverse of type 0 block spectra. They are 1 (or a defined maximum value) everywhere except between the defined min and max values:"

# ╔═╡ bbd38ff0-2475-11eb-30e6-939c1fae753f
bspec0=block_spec(390,830,1,410,570,1.0,1)

# ╔═╡ 0c572270-2476-11eb-0972-89e9f7f99f3d
plot!(bspec0.λ,bspec0.r,color=:black,linestyle=:dot, labels=false)

# ╔═╡ Cell order:
# ╟─78adafde-247e-11eb-12e1-ddea99d50711
# ╟─dbfc1410-2456-11eb-1274-7d1786793c6e
# ╟─f444ebf0-2460-11eb-2ed3-c5db8e304e95
# ╟─1cb25910-2461-11eb-1f85-a9ed9362e326
# ╠═08af84c0-2456-11eb-326c-2d675ca197af
# ╟─5dacb780-2461-11eb-277d-e7226385a5ec
# ╠═57a60da0-2461-11eb-07df-2b3ab48a6675
# ╟─79763630-2461-11eb-0b0d-15b00898c512
# ╠═9ff8ea50-2461-11eb-3143-d1b38243f297
# ╟─0d1268b0-2461-11eb-15a9-87ca552b10c5
# ╠═14f2d870-245d-11eb-1fe3-779aa49070f1
# ╟─1afb7e20-245d-11eb-1ca8-9da92491cd50
# ╟─0881c790-2462-11eb-05e1-9113e664ec28
# ╟─2f7258b0-2462-11eb-31a2-8da7d9fb1dca
# ╠═5216c132-2462-11eb-11ef-259ba512e80a
# ╠═ad2414b2-2462-11eb-3ea5-955a5a918a30
# ╠═d99b2330-2462-11eb-2bee-6b79c56cf0cf
# ╠═e34ef68e-2462-11eb-394c-5712ac9de6da
# ╟─e8969630-2462-11eb-3c02-996a99d88691
# ╟─f24e2d8e-2477-11eb-3a27-dfebdfc43440
# ╠═0c6bf812-2478-11eb-14ea-57c6522324f3
# ╟─2c7f7c80-2478-11eb-1728-a1ab0b5ef106
# ╠═00a64130-2463-11eb-1ed2-29a671508315
# ╟─0edd04a0-2463-11eb-0a29-c50a447572d8
# ╠═18b5ec30-2463-11eb-1f50-9b9fc218273e
# ╟─1e781300-2463-11eb-2b3e-ff33d0043b07
# ╠═369a82b0-2463-11eb-06c0-a79be68e16a6
# ╟─47f2352e-2463-11eb-3976-d77c1624e204
# ╟─60fc2740-247a-11eb-031a-8bef9409f862
# ╠═fdfa8220-2462-11eb-0cf8-c188ac491781
# ╟─89f88560-2463-11eb-38be-eb669b15ab60
# ╠═97598240-2463-11eb-0ec9-0be99eea414d
# ╟─d0a02310-2463-11eb-2788-5dcb718cf9cb
# ╠═d811596e-2463-11eb-0de0-792feca7ffa0
# ╟─e8a8a220-2463-11eb-2a70-cd5fbe573691
# ╟─fe2f5850-2463-11eb-29a7-93f2db686897
# ╟─4232ff20-2464-11eb-14d4-c79999ab77bf
# ╟─69e30fb0-2464-11eb-0066-d15aa8c969e3
# ╟─9b44a9b0-2464-11eb-138b-0d9775344d9f
# ╠═c1a3a930-2464-11eb-1bef-996a6b7468f5
# ╟─c77141b0-2464-11eb-1efa-a73f2a72b3b0
# ╟─07995c00-2465-11eb-125c-b5a167e0fc90
# ╠═385b81b0-2465-11eb-151f-878bb717e157
# ╟─a57b2320-247b-11eb-17d1-9fd1ecce6ed5
# ╠═492e25b0-2465-11eb-36eb-491d2c186e8b
# ╟─e54233b0-2465-11eb-1f8d-2f087aa4d31e
# ╠═0c92e630-2466-11eb-20c4-9fe8bede9360
# ╟─1d179140-2466-11eb-2d71-11e9622e355b
# ╠═cb75ef1e-2466-11eb-26b4-d58a8167559c
# ╟─ddff1cc0-2466-11eb-0709-1baba5e3fca6
# ╟─0e233640-247e-11eb-193a-ed5ab087c968
# ╟─f9023e30-2466-11eb-346f-8380306e6ab3
# ╠═b9028080-2473-11eb-3bc2-91cb08806a45
# ╟─dde6edf0-2473-11eb-2671-2b1f152e2ced
# ╠═62d4c690-2474-11eb-2665-c724b32a74f4
# ╟─7bd22cf0-2474-11eb-0266-8bb6aeb08b46
# ╠═f95f7100-2474-11eb-3072-f1d2fdb0ba57
# ╠═23b4ff10-2475-11eb-3324-176b6bc48b81
# ╟─3c46d260-2475-11eb-0204-c3da17762579
# ╟─b3ee6870-247d-11eb-0587-ef4e7989be87
# ╠═bbd38ff0-2475-11eb-30e6-939c1fae753f
# ╠═0c572270-2476-11eb-0972-89e9f7f99f3d
