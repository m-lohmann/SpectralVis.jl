"""
    mineral_specs(mineral::Symbol)

Reads and returns the spectral data of a chosen mineral.

Available `mineral` types:
* `:augite`
* `:goethite`
* `:hematite`
* `:pigeonite`
"""
function mineral_specs(mineral::Symbol)
    mineral == :augite ? filename = "Augite.spec" :
    mineral == :goethite ? filename = "Goethite.spec" :
    mineral == :hematite ? filename = "Hematite.spec" :
    mineral == :pigeonite ? filename = "Pigeonite.spec" : nothing
    fp=@__DIR__
    cd(fp)
    cd("..\\spectra")
    sfile=readlines(filename)
    map(x->parse(Float64, x), sfile)
end


"""
    mineral(mineral::Symbol, spectable = mineral_specs(mineral))

Returns reflectance spectrum of chosen mineral.

Allowed names for `mineral`: `:augite`, `:goethite`, `:hematite`, `:pigeonite`
"""
function mineral(mineral::Symbol, spectable = mineral_specs(mineral))
    len = div(length(spectable), 2)
    0 < idx < 1270 ? (i = (idx - 1) * n + 1) : (throw(DomainError(idx, "Index is outside the range of 1 ≤ idx ≤ 1269.")))
    reflectance_spec(list[map(n -> n * 2 - 1, 1:len)], list[map(n -> n * 2, 1:len)])
end