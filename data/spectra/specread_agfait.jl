#=
The Agfa ColorReference is designed according to the IT8.7 standard.

The spectral reflectance of samples were measured with Minolta spectro-
photometer with option SCE (Specular component excluded). The CM-2002
utilizes d/8 (diffuse illumination/8o viewing) geometry which conforms to
ISO and DIN standards (and also to CIE d/0 recommendations).

Measuring equipment: Minolta spectrofotometer CM-2002.
Wavelength interval: 400 nm - 700 nm.
Wavelength resolution: 10 nm.

Measurer: ela@ee.oulu.fi (University of Oulu, Electrical Eng.Dept)

Further information: ela@ee.oulu.fi (University of Oulu, Electrical Eng.Dept)

References: 

   AgfaFotoreference, Trademark of Agfa-Gevaert A.G.,
   Septestraat 27 2640 Mortsel - Belgium,1992. 
=#
"""
`agfait_specs()`
"""
function agfait_specs()
    filename = "agfait872.dat"
    fp=@__DIR__
    cd(fp)
    cd("..\\spectra")
    readlines(filename)
end

"""
`agfait(idx::Int)`

Returns the reflectance spectrum of the selected Agfait872 color patch.
Spectral data are from 400 to 700 nm in 10 nm steps.

1st group: 1-264

2nd group: Neutral scale samples (265-286)

3rd group:

* black sample (287)
* white sample (288)
* Minolta white calibration sample (289)

# Examples
```jldoctest
julia> agfait(123)
RSpec(Real[400.0, 410.0, 420.0, 430.0, 440.0, 450.0, 460.0, 470.0, 480.0, 490.0  …  610.0, 620.0, 630.0, 640.0, 650.0, 660.0, 670.0, 680.0, 690.0, 700.0], Real[0.1282, 0.3004, 0.4806, 0.5796, 0.6429, 0.6818000000000001, 0.7078, 0.7159, 0.7071999999999999, 0.6896  …  0.259, 0.2318, 0.21309999999999998, 0.2, 0.1932, 0.19210000000000002, 0.19699999999999998, 0.2095, 0.2311, 0.2594])

julia> agfait(0)
ERROR: DomainError with 0:
Color index out of range. Expecting 0 ≤ index ≤ 289.
```

Measurer: ela@ee.oulu.fi (University of Oulu, Electrical Eng.Dept)
"""
function agfait(idx::Int)
    if 1 ≤ idx ≤ 289
        file = agfait_specs()
        start = 119 * (idx - 1) + 2
        lam = collect(400.0:10.0:700.0)
        spd = map(x -> (parse(Float64, x) / 100.0), file[start:start+30])
        reflectance_spec(lam, spd)
    else
        throw(DomainError(idx, "Color index out of range. Expecting 0 ≤ index ≤ 289."))
    end
end