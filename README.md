# SpectralVis

[![Build Status](https://travis-ci.com/m-lohmann/SpectralVis.jl.svg?branch=master)](https://travis-ci.com/m-lohmann/SpectralVis.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/m-lohmann/SpectralVis.jl?svg=true)](https://ci.appveyor.com/project/m-lohmann/SpectralVis-jl)
[![Coverage](https://codecov.io/gh/m-lohmann/SpectralVis.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/m-lohmann/SpectralVis.jl)
[![Coverage](https://coveralls.io/repos/github/m-lohmann/SpectralVis.jl/badge.svg?branch=master)](https://coveralls.io/github/m-lohmann/SpectralVis.jl?branch=master)

## Usage

```julia
julia> using SpectralVis
```

## Content

* [Introduction](https://github.com/m-lohmann/SpectralVis.jl#introduction)
* [Type Tree](https://github.com/m-lohmann/SpectralVis.jl#Type_Tree)
* [Spectral datasets](https://github.com/m-lohmann/SpectralVis.jl#Spectral_datasets)

## Introduction

## Type tree

Type tree structure of the SpectralVis module:

Spectral types:

```julia
Spectrum
│
├─ Multispectral
│  │
│  ├─ CMatch
│  │  ├─ CIE12_10
│  │  ├─ CIE12_2
│  │  ├─ CIE31
│  │  ├─ CIE31_J
│  │  ├─ CIE64
│  │  └─ CIE64_JV
│  │
│  └─ ConeFund
│     ├─ LMS31
│     └─ LMS64
│     ├─ LMS06_2
│     └─ LMS06_10
│
├─ SPD
│  ├─ LSpec
│  └─ RSpec
│
└─ STD
   └─ TSpec
```

### Multispectral type subtree

The subtree `Multispectral` contains all types that include more than only one spectral power distribution of any sort. At the moment only subtypes of `CMatch` (color matching functions) and `ConeFund` (cone fundamental functions) are part of this subtree.

```julia
├─ Multispectral
   │
   ├─ CMatch
   │  ├─ CIE12_10
   │  ├─ CIE12_2
   │  ├─ CIE31
   │  ├─ CIE31_J
   │  ├─ CIE64
   │  └─ CIE64_JV
   │
   └─ ConeFund
      ├─ LMS31
      └─ LMS64
      ├─ LMS06_2
      └─ LMS06_10
```


### `SPD` (spectral power distribution) subtree

The branch `SPD` contains all spectral types that include only a single **s**pectral **p**ower **d**istribution. This includes both reflectance and luminance spectra.
The first letter describes the type of the SPD, either reflectance `R`(RSpec) or luminance `L` (LSpec) spectra.

```julia
└─ SPD
   ├─ LSpec
   └─ RSpec
```


### STD type subtree

The STD subtree (spectral transmission distribution) contains the special concrete subtype `TSpec` for transmission spectra.

```julia
└─ STD
   └─ TSpec
```


## Spectral datasets

The *SpectralVis* module also contains a large collection of spectral datasets for a wide variety of applications.

Currently, the following datasets are available:

### MacBeth color checker spectra

File:           `spectrum_MacBeth.jl`

Function call:
* `macbeth(colorchart::Symbol, color::Symbol)` 
* `macbeth(colorchart::Symbol, num::Int)`

allowed arguments

* color::Symbol: `:darkskin`, `:lightskin`, `:bluesky`, `:foliage`, `:blueflower`, `:bluishgreen`, `:orange`, `:purplishblue`, `:moderatered`, `:purple`, `:yellowgreen`, `:orangeyellow`, `:blue`, `:green`, `:red`, `:yellow`, `:magenta`, `:cyan`, `:white95`, `:neutral8`, `:neutral65`, `:neutral5`, `:neutral35`, `:black2`
* color::Int: `1` ... `24`
* colorchart: `:Macbeth_chart1`, `:Macbeth_chart2`, `:Macbeth_chart3`

Datasets:
* `const Macbeth_chart1`, BabelColor Color Checker spectra, mean values of 20 different color checker measurements
* `const Macbeth_chart2`
* `const Macbeth_chart3`, Data from from *Noboru Ohta, Alan R. Robertson, “Colorimetry: Fundamentals and Applications”, (May 2006), DOI:10.1002/0470094745*

Object type:    `RSpec`

### Mars sky spectrum

File:          `spectrum_MarsSkyOpp.jl`

Function call: `mars_sky_opportunity()`

Object type:   `LSpec`

Dataset:       `const MarsSkyOpp`

This dataset contains the spectral power distribution of the martion sky, as measured by the Opportunity Mars rover Pancam (panoramic camera).

### MER (Mars Exploration Rover) Caltarget (calibration target) spectra

File:           `spectrum_MERCaltarget.jl`

Function call:  `mer_caltarget(color::Symbol)`

Object type:    `RSpec`

Dataset:        `const MER_caltarget_<color_name>`

Call this function with one of the 7 color names to get the respective spectrum.

Available color names are:

```julia
:white
:grey
:black
:yellow
:red
:green
:blue
```

Example:

```julia
julia> mer_caltarget(:yellow)
SpectralVis.IRSpec(Real[400.0, 430.841121, 478.504673, 491.121495, 502.336449, 514.953271, 524.766355, 530.373832, 535.981308, 538.006231  …  957.943925, 964.018692, 976.012461, 981.931464, 988.006231, 993.925234, 1000.0, 1012.616822, 1021.028037, 1047.663551], Real[0.052336, 0.059813, 0.069782, 0.079751, 0.08972, 0.114642, 0.142056, 0.161994, 0.186916, 0.195777  …  0.363863, 0.366632, 0.372447, 0.376047, 0.377985, 0.381862, 0.38657, 0.393769, 0.398754, 0.42866])
```

### MER Pancam (panoramic camera) filter spectra

File:           `spectrum_Pancam.jl`

Function call:  `pancam_L<filter number>`

Object type:    `LSpec` (preliminary type, will be changed to `TSpec`)

Dataset:        `const Pancam_L<filter number>`

Call this function with one of the Pancam (panoramic camera) filter numbers `2...7` to get the respective narrow band filter spectrum.

The filter 

Example:

```julia
julia> pancam_L4()
SpectralVis.RSpec(Real[580.0, 584.670912951168, 588.067940552017, 590.615711252654, 593.588110403397, 595.711252653928, 596.985138004246, 597.409766454352, 598.259023354565, 600.382165605096  …  610.148619957537, 611.847133757962, 612.696390658174, 613.970276008493, 616.093418259023, 618.216560509554, 619.915074309979, 622.462845010616, 625.010615711253, 630.106157112527], Real[0.0, 0.0105932203389831, 0.0444915254237288, 0.152542372881356, 0.563559322033898, 0.930084745762712, 0.98728813559322, 0.997881355932203, 1.0, 0.991525423728814  …  0.629237288135593, 0.425847457627119, 0.298728813559322, 0.199152542372881, 0.103813559322034, 0.0593220338983051, 0.0338983050847458, 0.0169491525423729, 0.00635593220338983, 0.0])
```
