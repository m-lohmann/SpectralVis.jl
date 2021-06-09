### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ 08af84c0-2456-11eb-326c-2d675ca197af
using SpectralVis

# ╔═╡ 57a60da0-2461-11eb-07df-2b3ab48a6675
using Colors

# ╔═╡ 9ff8ea50-2461-11eb-3143-d1b38243f297
using Plots; plotly()

# ╔═╡ 14f2d870-245d-11eb-1fe3-779aa49070f1
using SSpline

# ╔═╡ f07cef7e-014a-4d59-8e31-4d394391adda
begin
	#import DarkMode
    #DarkMode.enable(theme="material-palenight", cm_config=Dict("tabSize" => 4))
	#DarkMode.enable()
    #DarkMode.Toolbox(theme="default")
	html"""<style> main {max-width: 900px;}"""
end

# ╔═╡ 78adafde-247e-11eb-12e1-ddea99d50711
md"# A quick tour of the `SpectralVis` and `SSpline` packages"

# ╔═╡ a8bb86de-29be-474d-94e6-1a03f9afe70f
md"## First, let’s get the basic stuff out of the way:"

# ╔═╡ f444ebf0-2460-11eb-2ed3-c5db8e304e95
md"We need to get a few packages to deal with spectra"

# ╔═╡ 1cb25910-2461-11eb-1f85-a9ed9362e326
md"**SpectralVis** contains (almost) everything you need for spectral calculations, spectral data, etc."

# ╔═╡ 5dacb780-2461-11eb-277d-e7226385a5ec
md"The **Colors** package is also needed"

# ╔═╡ 79763630-2461-11eb-0b0d-15b00898c512
md"We also would like to do some plots, so we also use the **Plots** package with the **PyPlot** backend."

# ╔═╡ 0d1268b0-2461-11eb-15a9-87ca552b10c5
md"Then we need the spectral spline package **SSpline**, which is a specialized spline package for spectral calculations. Apart from specialized functionality, it’s also faster than the **Interpolations** package."

# ╔═╡ 1afb7e20-245d-11eb-1ca8-9da92491cd50
md"Now we’re ready to have some fun!"

# ╔═╡ d04f4ee1-2609-4355-9846-5e155557d709
md"## Spectral environments"

# ╔═╡ 7d8d8c1e-ed75-472f-b08b-a93c29ab588c
md"""
The package `SpectralVis` automatically creates a *spectral environment* which defines the necessary parameters to work with spectra. These parameters are stored in the mutable struct `SPECENV` and can be requested and changed to suit the necessary requirements.

The fields contained in `SPECENV` are:

`λmin`: minimum wavelength, ideally identical with λmin of `cmf`, default: 390.0 nm

`Δλ`: wavelength stepwidth, default: 1.0 nm

`λmax`: maximum wavelength, ideally identical with λmax of `cmf`, default: 830.0 nm

`cmf`: Color matching function (CMF) of type `CMatch`, default: `CIE12_10` (CIE 2012 10° observer)
	
options: `CIE31` (CIE1931 2° observer), `CIE31_J` (CIE1931 2° observer with Judd-correction), `CIE31_JV` (Judd-Vos-correction, `CIE64` (CIE1964 10° observer), `CIE12_2` (CIE2012 2° observer), `CIE12_10` (CIE2012 10° observer)

`ex`: extrapolation type, with the options `:zero`, `:none`, `:boundary`, `:linear`, `:quadratic` (not yet implemented). Default: `:linear`
"""

# ╔═╡ f5760d98-77e3-4847-bb79-97f45b50b7da
env = SPECENV

# ╔═╡ 0881c790-2462-11eb-05e1-9113e664ec28
md"First, let’s create a light source! We have several options for these."

# ╔═╡ 2f7258b0-2462-11eb-31a2-8da7d9fb1dca
md"One option is to create a black body illuminant. Let’s say our light source is a black body radiator at a temperature of 6500K. We want to create an illuminant in the visual range of wavelength, say between 390 and 830 nm, with a resolution of 1 nm:"

# ╔═╡ 5216c132-2462-11eb-11ef-259ba512e80a
bb6500K = blackbody_illuminant(env,6500)

# ╔═╡ 60284748-a78f-4dfa-9927-18ad85bdf5d0
md"What is the type of the spectrum?"

# ╔═╡ ad2414b2-2462-11eb-3ea5-955a5a918a30
typeof(bb6500K)

# ╔═╡ 27bae2a1-2dc1-4a75-84ed-d329ce62abea
md"`LSpec` stands for Luminance Spectrum. We are dealing with a light source."

# ╔═╡ 437e5e6d-1469-4767-a0a9-8fed5ecf6250
md"Show the wavelengths at which this spectrum is sampled:"

# ╔═╡ d99b2330-2462-11eb-2bee-6b79c56cf0cf
bb6500K.λ

# ╔═╡ 7db83947-d5dd-4a3a-9f63-efe1da7eb26c
md"And the sampled luminance values:"

# ╔═╡ e34ef68e-2462-11eb-394c-5712ac9de6da
bb6500K.l

# ╔═╡ e8969630-2462-11eb-3c02-996a99d88691
md"So, the `LSpec` struct has two fields: λ and l.

`λ` contains the sampled wavelengths in *nm*, `l` contains the sampled *luminance* at the sampled wavelengths. For reflectance spectra of type `RSpec`, these are `λ` and `r` (reflectance)."

# ╔═╡ f24e2d8e-2477-11eb-3a27-dfebdfc43440
md"Let’s plot the spectrum of our light source:"

# ╔═╡ 0c6bf812-2478-11eb-14ea-57c6522324f3
plot(bb6500K.λ,bb6500K.l,labels=false)

# ╔═╡ 2c7f7c80-2478-11eb-1728-a1ab0b5ef106
md"Whoa! The luminance values are crazy high! That’s because of the units `[J/m³/s]`. It’s easy to mitigate that. Let’s normalize this spectrum to a peak value of 1.0. To normalize a spectrum, use the `normalize_spec` function as follows:"

# ╔═╡ 00a64130-2463-11eb-1ed2-29a671508315
bb65=normalize_spec(bb6500K)

# ╔═╡ 1e781300-2463-11eb-2b3e-ff33d0043b07
md"Let’s have a look at the spectrum in a graph:"

# ╔═╡ 369a82b0-2463-11eb-06c0-a79be68e16a6
plot(bb65.λ,bb65.l,labels=false)

# ╔═╡ 47f2352e-2463-11eb-3976-d77c1624e204
md"That looks much better! It’s convenient and common practice in color metrics to normalize illuminants to a peak value of 1."

# ╔═╡ 60fc2740-247a-11eb-031a-8bef9409f862
md"Another useful method is using a CIE Daylight generator, which creates daylight spectra according to the CIE daylight standard. This mimics the spectral distribution of natural daylight spectra. `D_series_illuminant` produces daylight spectra, like *D65* or *D50*, according to a so-called *correlated color temperature*, also abbreviated as *CCT*. To create an illuminant with a CCT of 6500K, similar to the blackbody radiator, use the `D_series_illuminant` function as follows:"

# ╔═╡ fdfa8220-2462-11eb-0cf8-c188ac491781
d6500=D_series_illuminant(6500)

# ╔═╡ 89f88560-2463-11eb-38be-eb669b15ab60
md"Before we plot this D65 spectrum, let’s normalize it as well. The standard CIE daylight function generates spectra that are normalized to a value 100.0 at a wavelength of 560 nm, which results in spectra with a spectral distribution that mimics the proper relative energy output of different D-series illuminants. For our purposes, let’s normalize the D65 spectrum:"

# ╔═╡ 97598240-2463-11eb-0ec9-0be99eea414d
d65=normalize_spec(d6500)

# ╔═╡ d0a02310-2463-11eb-2788-5dcb718cf9cb
md"Now we can plot both spectra for comparison:"

# ╔═╡ d811596e-2463-11eb-0de0-792feca7ffa0
begin
	plot(bb65.λ, bb65.l, linewidth=2, color= :blue, label="black body at 6500K")
	plot!(d65.λ, d65.l, linewidth=2, color= :gold2, label="D65 daylight generator")
end

# ╔═╡ e8a8a220-2463-11eb-2a70-cd5fbe573691
md"Voilá! Looking good!"

# ╔═╡ fe2f5850-2463-11eb-29a7-93f2db686897
md"But we’d like both spectra to have the *same wavelength range*. And both should also have the *same spectral resolution*. The *d65* spectrum has a resolution of only 5 nm. Let’s change that!

For demonstration purposes, we will first take a short detour to the `SSpline` package. Let’s use it to adapt the resolution and range of the *d65* spectrum.
Later, we’ll see a more convenient way to adapt spectra to arbitrary conditions, resolutions, etc.

Now, let’s do it the `SSpline` way first:"

# ╔═╡ 69e30fb0-2464-11eb-0066-d15aa8c969e3
md"## A quick look at the `SSpline` package"

# ╔═╡ 9b44a9b0-2464-11eb-138b-0d9775344d9f
md"First, we create a spline object. The Daylight illuminant generator creates linearly interpolated values, so we don’t need to bother with any fancy spline interpolations in this case. We only need a linear spline:"

# ╔═╡ c1a3a930-2464-11eb-1bef-996a6b7468f5
d65spl = linearspline(d65.λ,d65.l)

# ╔═╡ c77141b0-2464-11eb-1efa-a73f2a72b3b0
md"As a result, we get an object of type `LinearSpline`. It contains all the spline coefficients at the knots of the spline, and the knots themselves:"

# ╔═╡ c5490aa0-254d-11eb-383c-adb08ba2eedf
typeof(d65spl)

# ╔═╡ 07995c00-2465-11eb-125c-b5a167e0fc90
md"Now we want to interpolate this spline at certain values. For the black body illuminant we used the range `390:1:830`, and these are going to be our new `λ` values for the D65 illuminant as well:"

# ╔═╡ 385b81b0-2465-11eb-151f-878bb717e157
λ=collect(390.0:1.0:830.0)

# ╔═╡ a57b2320-247b-11eb-17d1-9fd1ecce6ed5
md"Now we create the new, interpolated values with the `interp` function. The function returns two vectors, one for the `λ` values, one for the luminance values:"

# ╔═╡ 492e25b0-2465-11eb-36eb-491d2c186e8b
lam,s=interp(d65spl,λ)

# ╔═╡ e54233b0-2465-11eb-1f8d-2f087aa4d31e
md"Now all that’s left is creating a new *Spectrum* type object containing these values. In our case we need to create a luminance spectrum because we want the spectrum to be a light source:"

# ╔═╡ 0c92e630-2466-11eb-20c4-9fe8bede9360
d65f=luminance_spec(lam,s)

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
md"There are other ways to generate spectra. The function `led_spec` simulates the spectrum of a light emitting diode:"

# ╔═╡ b9028080-2473-11eb-3bc2-91cb08806a45
led=led_spec(390,830,1,455,30)

# ╔═╡ dde6edf0-2473-11eb-2671-2b1f152e2ced
md"Creates an LED spectrum in the range 390 to 830 nm, with a wavelength step width of 1 nm. The *peak wavelength* is at 455 nm, and the *half spectral width* (bandwidth at 50% of peak intensity) is 30 nm. Let’s have a look at the spectrum:"

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

# ╔═╡ b2a5b300-2505-11eb-1ecc-098dda235b36
md"## Spectral environments, or how to adapt spectral properties"

# ╔═╡ e880d120-255b-11eb-12d4-d945762279a1
md"Let’s define a light source and a reflective surface. We use the spectrum of the Martian sky, as measured by the Opportunity rover, as light source:"

# ╔═╡ 10fbabc0-255c-11eb-0225-fb05d87dd7f2
light = mars_sky_opportunity()

# ╔═╡ 0e81b72c-1f09-4145-bd54-058ae1b7ded9
md"And our reflective surface is the spectrum of the blue patch of the calibration target on the Mars Exploration Rover:"

# ╔═╡ 23f09380-255c-11eb-1d49-89943d828c8c
blue = mer_caltarget(:blue)

# ╔═╡ 3e1e3c80-255c-11eb-23dc-75a55d31786e
begin
	plot(blue.λ,blue.r,color=:blue,label="MER caltarget “blue”")
	plot!(light.λ,light.l,color=:orange,label="Mars Sky Opportunity measurement")
end

# ╔═╡ a9cb5ab0-8b16-11eb-3d10-dfc3953fbe2b
blue

# ╔═╡ f77e81a0-8a72-11eb-1e00-f9266532685f
light

# ╔═╡ 4c3765d0-255c-11eb-3e16-c98892838d0e
md"It’s obvious that both spectra have different ranges and also different and irregular sample points. The surface spectrum even reaches pretty far into the IR region. This can easily be mitigated by adapting both spectra to a set of rules defined by the *spectral environment*.
For that, we need to define a **spectral environment**, which contains all information about the overall valid traits of the spectra we want to work with. This is important to ensure and enable compatibility between spectra etc. which might have different wavelength ranges, resolutions, etc. The function to set up a spectral environment is:

`set_specenv(λmin,Δλ,λmax,extrapolation)`

possible values for extrapolation:

`:zero`, `:constant`, `:linear`, `:quadratic`"

# ╔═╡ 15adccb0-255d-11eb-2b83-c9564c07b62b
md"We want to work in a spectral range that satisfies the latest color matching functions defined by the CIE in 2012, which are defined in a range of 390 nm to 830 nm in steps of 1 nm. Furthermore, for the sake of simplicity, we define that all extrapolated values should be set to zero. Extrapolation is necessary if a spectrum is not defined up to the boundaries (390 / 830 nm)."

# ╔═╡ 1a26c720-255c-11eb-09fe-cb4cd9cafd46
senv=set_specenv();senv.ex=:boundary

# ╔═╡ a2061550-8a70-11eb-1d1c-1b884f18ae48
senv

# ╔═╡ a386f890-255d-11eb-0fae-2326d5d88d34
md"To adapt a spectrum to the environment, use the function

`adapt_spec(spec::Spectrum,specenv::SpecEnvironment,interporder...)`

Valid arguments for `interporder` (order of spline interpolation):

1st order interpolation:

`:linear` for linear splines

2nd order interpolation, not yet implemented:

`:quadratic` for quadratic splines

3rd order interpolation:

`:cubic, :natural` for natural cubic splines (zero curvature at boundaries)

`:cubic, :periodic` for periodic cubic splines (both endpoints must have same value)

`:cubic, :clamped, slope_start, slope_end` for clamped cubic splines with defined slopes at boundaries

`:cubic, :constrained` for cubic constrained splines"

# ╔═╡ 0c5a9a70-255e-11eb-26e0-8f1b434ed385
l=adapt_spec(light,senv,:cubic,:natural)

# ╔═╡ 42a8468e-255e-11eb-0495-5b80974193c4
b=adapt_spec(blue,senv,:cubic,:natural)

# ╔═╡ 59847aa0-255e-11eb-36a6-8f10abd28695
md"Now we can check and compare the original and the adapted versions of the splines. The boxes mark the original irregular spectral samples, the smaller circles mark the resampled spectra as defined in the environment. You can see that for the **blue** spectrum the lower range was extrapolated according to the cubic spline defined by the original knots. Here is a zoomed in version of the two spectra:"

# ╔═╡ cf17c5be-255d-11eb-0cb9-3703acb4ae96
begin
	scatter(blue.λ,blue.r,color=:blue,marker=:square,markersize=6,label="MER caltarget “blue”",legend=:topleft,xlim=(385,430),ylim=(0.1,0.55))
	scatter!(light.λ,light.l,color=:orange,marker=:square,markersize=6,label="Mars Sky Opportunity measurement")
	scatter!(b.λ,b.r,color=:lightblue,linestyle=:dash,markersize=2,label="MER caltarget resampled")
	scatter!(l.λ,l.l,color=:gold,linestyle=:dash,markersize=2,label="Mars Sky Opportunity resampled")
end

# ╔═╡ d5d44030-255f-11eb-1bf2-fbc628979e90
md"Let’s have a look at the opposite end:"

# ╔═╡ c8bd44a0-255f-11eb-06d0-c911969126bf
begin
	scatter(blue.λ,blue.r,color=:blue,marker=:cross,markersize=6,label="MER caltarget “blue”",legend=:bottomleft,xlim=(800,850),ylim=(-0.1,1.0))
	scatter!(light.λ,light.l,color=:orange,marker=:cross,markersize=6,label="Mars Sky Opportunity measurement")
	scatter!(b.λ,b.r,color=:lightblue,linestyle=:dash,markersize=2,label="MER caltarget spec_env")
	scatter!(l.λ,l.l,color=:yellow,linestyle=:dash,markersize=2,label="Mars Sky Opportunity spec_env")
end

# ╔═╡ 9016a8f8-561f-4f0c-bd5e-8e3437a36801
begin
	scatter(blue.λ,blue.r,color=:blue,marker=:square,markersize=3,label="MER caltarget “blue”",legend=:topleft,xlim=(380,840))
	scatter!(light.λ,light.l,color=:orange,marker=:square,markersize=3,label="Mars Sky Opportunity measurement")
	scatter!(b.λ,b.r,color=:lightblue,linestyle=:dash,markersize=1,label="MER caltarget resampled")
	scatter!(l.λ,l.l,color=:gold,linestyle=:dash,markersize=1,label="Mars Sky Opportunity resampled")
end

# ╔═╡ e74f5600-255b-11eb-3a98-718912d58c6c
md"# Spectral operators"

# ╔═╡ d3d88a20-2505-11eb-3fe8-a7183ff72a46
md"We’re actually interested the resulting color and spectrum with a given light source and reflectance. `SpectralVis` contains a few overloaded operators that make this kind of calculation easy. Let’s define a light source and a reflecting surface:"

# ╔═╡ 3d0f5aa0-2506-11eb-3072-3d7840704c25
lightsource = mars_sky_opportunity()


# ╔═╡ 1f18b440-85f3-4e23-bb8d-1c7889c1c7c7
surface = mer_caltarget(:green)

# ╔═╡ c5ff81a0-2506-11eb-305c-8721c7eb5987
green_spl = spline3(surface.λ,surface.r,:natural)

# ╔═╡ 1497e433-4a73-4074-8b7e-228d3f029b50
green_extrap = extrap(green_spl,390:830,:linear)

# ╔═╡ 0b7b056d-0f00-4f82-873f-53825874e76f
green_int = interp(green_extrap,390:1:830)

# ╔═╡ cd636a24-b558-4c33-adca-ece8652b1640
light_spl = spline3(lightsource.λ,lightsource.l,:natural)

# ╔═╡ ad8c32f7-0a8f-4ab0-a088-c688945f96be
light_extrap = extrap(light_spl,390:830,:linear)

# ╔═╡ 9cc68e94-7008-4af2-bd56-fdaa922de29e
light_int = interp(light_spl,390:830)

# ╔═╡ 924c6ba0-2508-11eb-25d9-8fe5faf11bad
begin
	plot(surface.λ,surface.r,color=:green,label="MER caltarget “green”")
	plot!(lightsource.λ,lightsource.l,color=:orange,label="Mars Sky Opportunity measurement")
	scatter!(green_int[1],green_int[2],color=:cyan,markersize=1)
	scatter!(light_int[1],light_int[2],color=:orange,markerkize=2)
end

# ╔═╡ 32c456b0-2ed2-11eb-2c69-f3989cde9b93
surface.λ

# ╔═╡ 3e9c69a0-2ed2-11eb-3dbf-e7a0ecb05d4c
surface.r

# ╔═╡ 67776940-8b22-11eb-0fa2-3de9f03d6679
lightsource.λ[end]

# ╔═╡ af8d15e0-8b22-11eb-31c9-2be22127eb1d
begin
	senv.λmax=840.0
	senv.ex=:boundary
	adapt_spec(lightsource,senv,:cubic,:natural)
end

# ╔═╡ 6126a56a-681f-4cce-b1f5-5cf6138d51bf
senv

# ╔═╡ 899288cb-714a-4399-a9ab-911b2e0c2c37
extrap(linearspline(lightsource.λ,lightsource.l),390.0:890.0,senv.ex)

# ╔═╡ 8a955ace-2e99-11eb-25dd-e9a7242b4f6c
begin
	lightspec=adapt_spec(lightsource,senv,:linear)
	greenspec=adapt_spec(surface,senv,:cubic,:natural)
end

# ╔═╡ 0f23dce0-89d5-11eb-0b0b-7193920bef8b
begin
	plot(lightspec.λ,lightspec.l,color=:red,style=:dashdot,thickness=3,label="Martian sky (light source)")
	plot!(greenspec.λ,greenspec.r,color=:green,label="MER caltarget green (refl)")
	#plot!(refl.λ,refl.r,color=:black,style=:dashdot,label="reflected light")
	#plot!(greenfilt.λ,greenfilt.t)
end

# ╔═╡ afcd7890-89d5-11eb-30db-4f57ca767fef
begin
	refl=*(greenspec,greenspec)
	#greenf=TSpec(greenspec.λ,greenspec.r,.05)
	#greenfilt=greenf*greenf
end

# ╔═╡ 2c64c8da-779e-4a2d-b1fd-cb739b316a17
begin
	→(s::SpectralVis.Spectrum,Δλ) = shift_spec(s,Δλ)
	←(s::SpectralVis.Spectrum,Δλ) = shift_spec(s,-Δλ)
end

# ╔═╡ 66307660-89da-11eb-0576-8d571268e6dd
plot(led.λ,led.l)

# ╔═╡ c5e0d2c5-1f93-4475-b8ae-8a40d35f3db5
begin
	d65s=→(d65,23.3)
	plot(d65s.λ,d65s.l)
	plot!(d65.λ,d65.l)
end

# ╔═╡ 983b7c23-29fb-452d-beba-2aec2b8abe22
cm=cmf(LMS2006_10)

# ╔═╡ 0213f1eb-4cbe-4aa1-b8c1-4a469836723a
begin
	long=cm.l
	mid=cm.m
	short=cm.s
end

# ╔═╡ 70626740-a681-4da3-956c-1ee4c4badcdb
begin
	plot(cm.λ,cm.l,yrange=(0.000001,1.1),color=:red)
	plot!(cm.λ,cm.m,color=:green)
	plot!(cm.λ,cm.s,color=:blue)
end

# ╔═╡ 7fd0091a-640d-4df0-aabe-646c5f8742e0
source=D_series_luminance(6500)

# ╔═╡ 37dac578-8fc2-4c04-87d6-81b4822fc7ed
Macbeth_color_chart

# ╔═╡ 5e6acbc7-f548-4b5b-8774-443a92e06db8
begin
	cc = env.cmf
	#dd = shift_colormatch(cc, :l, -20)
	plot(cc.λ, cc.l, color = :red)
	plot!(cc.λ, cc.m, color = :green)
	plot!(cc.λ, cc.s, color = :blue)
end

# ╔═╡ Cell order:
# ╠═f07cef7e-014a-4d59-8e31-4d394391adda
# ╟─78adafde-247e-11eb-12e1-ddea99d50711
# ╟─a8bb86de-29be-474d-94e6-1a03f9afe70f
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
# ╟─d04f4ee1-2609-4355-9846-5e155557d709
# ╟─7d8d8c1e-ed75-472f-b08b-a93c29ab588c
# ╠═f5760d98-77e3-4847-bb79-97f45b50b7da
# ╟─0881c790-2462-11eb-05e1-9113e664ec28
# ╟─2f7258b0-2462-11eb-31a2-8da7d9fb1dca
# ╠═5216c132-2462-11eb-11ef-259ba512e80a
# ╟─60284748-a78f-4dfa-9927-18ad85bdf5d0
# ╠═ad2414b2-2462-11eb-3ea5-955a5a918a30
# ╟─27bae2a1-2dc1-4a75-84ed-d329ce62abea
# ╟─437e5e6d-1469-4767-a0a9-8fed5ecf6250
# ╠═d99b2330-2462-11eb-2bee-6b79c56cf0cf
# ╟─7db83947-d5dd-4a3a-9f63-efe1da7eb26c
# ╠═e34ef68e-2462-11eb-394c-5712ac9de6da
# ╟─e8969630-2462-11eb-3c02-996a99d88691
# ╟─f24e2d8e-2477-11eb-3a27-dfebdfc43440
# ╠═0c6bf812-2478-11eb-14ea-57c6522324f3
# ╟─2c7f7c80-2478-11eb-1728-a1ab0b5ef106
# ╠═00a64130-2463-11eb-1ed2-29a671508315
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
# ╟─69e30fb0-2464-11eb-0066-d15aa8c969e3
# ╟─9b44a9b0-2464-11eb-138b-0d9775344d9f
# ╠═c1a3a930-2464-11eb-1bef-996a6b7468f5
# ╟─c77141b0-2464-11eb-1efa-a73f2a72b3b0
# ╠═c5490aa0-254d-11eb-383c-adb08ba2eedf
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
# ╟─b2a5b300-2505-11eb-1ecc-098dda235b36
# ╠═e880d120-255b-11eb-12d4-d945762279a1
# ╠═10fbabc0-255c-11eb-0225-fb05d87dd7f2
# ╟─0e81b72c-1f09-4145-bd54-058ae1b7ded9
# ╠═23f09380-255c-11eb-1d49-89943d828c8c
# ╠═3e1e3c80-255c-11eb-23dc-75a55d31786e
# ╠═a9cb5ab0-8b16-11eb-3d10-dfc3953fbe2b
# ╠═f77e81a0-8a72-11eb-1e00-f9266532685f
# ╟─4c3765d0-255c-11eb-3e16-c98892838d0e
# ╟─15adccb0-255d-11eb-2b83-c9564c07b62b
# ╠═1a26c720-255c-11eb-09fe-cb4cd9cafd46
# ╠═a2061550-8a70-11eb-1d1c-1b884f18ae48
# ╟─a386f890-255d-11eb-0fae-2326d5d88d34
# ╠═0c5a9a70-255e-11eb-26e0-8f1b434ed385
# ╠═42a8468e-255e-11eb-0495-5b80974193c4
# ╟─59847aa0-255e-11eb-36a6-8f10abd28695
# ╠═cf17c5be-255d-11eb-0cb9-3703acb4ae96
# ╟─d5d44030-255f-11eb-1bf2-fbc628979e90
# ╠═c8bd44a0-255f-11eb-06d0-c911969126bf
# ╠═9016a8f8-561f-4f0c-bd5e-8e3437a36801
# ╟─e74f5600-255b-11eb-3a98-718912d58c6c
# ╟─d3d88a20-2505-11eb-3fe8-a7183ff72a46
# ╠═3d0f5aa0-2506-11eb-3072-3d7840704c25
# ╠═1f18b440-85f3-4e23-bb8d-1c7889c1c7c7
# ╠═c5ff81a0-2506-11eb-305c-8721c7eb5987
# ╠═1497e433-4a73-4074-8b7e-228d3f029b50
# ╠═0b7b056d-0f00-4f82-873f-53825874e76f
# ╠═cd636a24-b558-4c33-adca-ece8652b1640
# ╠═ad8c32f7-0a8f-4ab0-a088-c688945f96be
# ╠═9cc68e94-7008-4af2-bd56-fdaa922de29e
# ╠═924c6ba0-2508-11eb-25d9-8fe5faf11bad
# ╠═32c456b0-2ed2-11eb-2c69-f3989cde9b93
# ╠═3e9c69a0-2ed2-11eb-3dbf-e7a0ecb05d4c
# ╠═67776940-8b22-11eb-0fa2-3de9f03d6679
# ╠═af8d15e0-8b22-11eb-31c9-2be22127eb1d
# ╠═6126a56a-681f-4cce-b1f5-5cf6138d51bf
# ╠═899288cb-714a-4399-a9ab-911b2e0c2c37
# ╠═8a955ace-2e99-11eb-25dd-e9a7242b4f6c
# ╠═0f23dce0-89d5-11eb-0b0b-7193920bef8b
# ╠═afcd7890-89d5-11eb-30db-4f57ca767fef
# ╠═2c64c8da-779e-4a2d-b1fd-cb739b316a17
# ╠═66307660-89da-11eb-0576-8d571268e6dd
# ╠═c5e0d2c5-1f93-4475-b8ae-8a40d35f3db5
# ╠═983b7c23-29fb-452d-beba-2aec2b8abe22
# ╠═0213f1eb-4cbe-4aa1-b8c1-4a469836723a
# ╠═70626740-a681-4da3-956c-1ee4c4badcdb
# ╠═7fd0091a-640d-4df0-aabe-646c5f8742e0
# ╠═37dac578-8fc2-4c04-87d6-81b4822fc7ed
# ╠═5e6acbc7-f548-4b5b-8774-443a92e06db8
