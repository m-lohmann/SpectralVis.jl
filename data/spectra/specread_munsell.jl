"""
`munsell_matt_specs()`

Returns an array containing all 1269 munsell matt spectra, measured from 380 to 800 nm in 1 nm steps.
"""
function munsell_matt_specs()
    filename = "munsell_matt.dat"
    fp=@__DIR__
    cd(fp)
    cd("..\\spectra")
    sfile=readlines(filename)
    map(x->parse(Float64,x),sfile)
end

"""
`munsell_spec(idx::Int, speclist)`

Returns reflectance spectrum of the Munsell dataset at index `idx`.
Possible indices go from 1 to 1269

# Example

```jldoctest
julia> munsell_spec(437, speclist)
RSpec(Real[380, 381, 382, 383, 384, 385, 386, 387, 388, 389  …  791, 792, 793, 794, 795, 796, 797, 798, 799, 800], Real[0.1184, 0.1208, 0.124, 0.1301, 0.1349, 0.1431, 0.1498, 0.1579, 0.1631, 0.1731  …  0.3355, 0.3364, 0.3345, 0.3337, 0.3327, 0.3348, 0.3392, 0.3377, 0.335, 0.3351])
```
"""
function munsell_spec(idx::Int, speclist = munsell_specs())
    n=421
    0 < idx < 1270 ? (i=(idx-1)*n+1) : throw(DomainError(idx, "Index is outside the range of 1 ≤ idx ≤ 1269."))
    y=speclist[i:i+n-1]
    RSpec(collect(380:800),y)
end

function munsell_spec(munsellcolor::AbstractString)
    idx = get(munsell_dict(), munsellcolor, 9999)
    ifelse(idx == 9999, throw(DomainError(idx, "Munsell Color does not exist")), munsell_spec(idx, munsell_specs()))
end

function spec_color(col::AbstractString,colordict::AbstractString)
    ind = get(munsell_dict(), col, "Color key $(col) does not exist")
    if haskey(td,col)
        return spec_idx(ind, munsell_specs())
    else throw(DomainError(ind, "Color key does not exist"))
    end
end

function munsell_dict()
    d = Dict()
    n=length(munsell_keys)
    for i in 1:n
        push!(d, munsell_keys[i] => i)
    end
    d
end

function plotmunsell(index)
    λ=collect(380:800)
    n=421
    plot(λ, zeros(n))
    plot!(λ, spec_idx(index, munsell_specs())[i:i+n-1])
end

# The full set of 1269 munsell color names
const munsell_keys=[
    "2.5R 9/2";
    "2.5R 8/2";
    "2.5R 7/2";
    "2.5R 6/2";
    "2.5R 5/2";
    "2.5R 4/2";
    "2.5R 3/2";
    "2.5R 2.5/2";
    "2.5R 8/4";
    "2.5R 7/4";
    "2.5R 6/4";
    "2.5R 5/4";
    "2.5R 4/4";
    "2.5R 3/4";
    "2.5R 7/6";
    "2.5R 6/6";
    "2.5R 5/6";
    "2.5R 4/6";
    "2.5R 3/6";
    "2.5R 7/8";
    "2.5R 6/8";
    "2.5R 5/8";
    "2.5R 4/8";
    "2.5R 7/10";
    "2.5R 6/10";
    "2.5R 5/10";
    "2.5R 4/10";
    "2.5R 6/12";
    "2.5R 5/12";
    "2.5R 4/12";
    "5R 9/1";
    "5R 8/1";
    "5R 7/1";
    "5R 6/1";
    "5R 5/1";
    "5R 4/1";
    "5R 3/1";
    "5R 2.5/1";
    "5R 9/2";
    "5R 8/2";
    "5R 7/2";
    "5R 6/2";
    "5R 5/2";
    "5R 4/2";
    "5R 3/2";
    "5R 2.5/2";
    "5R 8/4";
    "5R 7/4";
    "5R 6/4";
    "5R 5/4";
    "5R 4/4";
    "5R 3/4";
    "5R 7/6";
    "5R 6/6";
    "5R 5/6";
    "5R 4/6";
    "5R 3/6";
    "5R 7/8";
    "5R 6/8";
    "5R 5/8";
    "5R 4/8";
    "5R 7/10";
    "5R 6/10";
    "5R 5/10";
    "5R 4/10";
    "5R 6/12";
    "5R 5/12";
    "5R 4/12";
    "5R 6/14";
    "5R 5/14";
    "5R 4/14";
    "7.5R 9/2";
    "7.5R 8/2";
    "7.5R 7/2";
    "7.5R 6/2";
    "7.5R 5/2";
    "7.5R 4/2";
    "7.5R 3/2";
    "7.5R 2.5/2";
    "7.5R 8/4";
    "7.5R 7/4";
    "7.5R 6/4";
    "7.5R 5/4";
    "7.5R 4/4";
    "7.5R 3/4";
    "7.5R 7/6";
    "7.5R 6/6";
    "7.5R 5/6";
    "7.5R 4/6";
    "7.5R 3/6";
    "7.5R 7/8";
    "7.5R 6/8";
    "7.5R 5/8";
    "7.5R 4/8";
    "7.5R 7/10";
    "7.5R 6/10";
    "7.5R 5/10";
    "7.5R 4/10";
    "7.5R 6/12";
    "7.5R 5/12";
    "7.5R 4/12";
    "10R 9/1";
    "10R 8/1";
    "10R 7/1";
    "10R 6/1";
    "10R 5/1";
    "10R 4/1";
    "10R 3/1";
    "10R 2.5/1";
    "10R 9/2";
    "10R 8/2";
    "10R 7/2";
    "10R 6/2";
    "10R 5/2";
    "10R 4/2";
    "10R 3/2";
    "10R 2.5/2";
    "10R 8/4";
    "10R 7/4";
    "10R 6/4";
    "10R 5/4";
    "10R 4/4";
    "10R 3/4";
    "10R 8/6";
    "10R 7/6";
    "10R 6/6";
    "10R 5/6";
    "10R 4/6";
    "10R 8/8";
    "10R 7/8";
    "10R 6/8";
    "10R 5/8";
    "10R 4/8";
    "10R 7/10";
    "10R 6/10";
    "10R 5/10";
    "10R 7/12";
    "10R 6/12";
    "10R 5/12";
    "2.5YR 9/2";
    "2.5YR 8/2";
    "2.5YR 7/2";
    "2.5YR 6/2";
    "2.5YR 5/2";
    "2.5YR 4/2";
    "2.5YR 3/2";
    "2.5YR 2.5/2";
    "2.5YR 8/4";
    "2.5YR 7/4";
    "2.5YR 6/4";
    "2.5YR 5/4";
    "2.5YR 4/4";
    "2.5YR 8/6";
    "2.5YR 7/6";
    "2.5YR 6/6";
    "2.5YR 5/6";
    "2.5YR 4/6";
    "2.5YR 8/8";
    "2.5YR 7/8";
    "2.5YR 6/8";
    "2.5YR 5/8";
    "2.5YR 4/8";
    "2.5YR 7/10";
    "2.5YR 6/10";
    "2.5YR 5/10";
    "2.5YR 7/12";
    "2.5YR 6/12";
    "2.5YR 6/14";
    "5YR 9/1";
    "5YR 8/1";
    "5YR 7/1";
    "5YR 6/1";
    "5YR 5/1";
    "5YR 4/1";
    "5YR 3/1";
    "5YR 2.5/1";
    "5YR 9/2";
    "5YR 8/2";
    "5YR 7/2";
    "5YR 6/2";
    "5YR 5/2";
    "5YR 4/2";
    "5YR 3/2";
    "5YR 9/4";
    "5YR 8/4";
    "5YR 7/4";
    "5YR 6/4";
    "5YR 5/4";
    "5YR 4/4";
    "5YR 8/6";
    "5YR 7/6";
    "5YR 6/6";
    "5YR 5/6";
    "5YR 4/6";
    "5YR 8/8";
    "5YR 7/8";
    "5YR 6/8";
    "5YR 5/8";
    "5YR 7/10";
    "5YR 6/10";
    "5YR 7/12";
    "5YR 6/12";
    "7.5YR 9/2";
    "7.5YR 8/2";
    "7.5YR 7/2";
    "7.5YR 6/2";
    "7.5YR 5/2";
    "7.5YR 4/2";
    "7.5YR 3/2";
    "7.5YR 9/4";
    "7.5YR 8/4";
    "7.5YR 7/4";
    "7.5YR 6/4";
    "7.5YR 5/4";
    "7.5YR 4/4";
    "7.5YR 8/6";
    "7.5YR 7/6";
    "7.5YR 6/6";
    "7.5YR 5/6";
    "7.5YR 4/6";
    "7.5YR 8/8";
    "7.5YR 7/8";
    "7.5YR 6/8";
    "7.5YR 5/8";
    "7.5YR 8/10";
    "7.5YR 7/10";
    "7.5YR 6/10";
    "7.5YR 7/12";
    "10YR 9/1";
    "10YR 8/1";
    "10YR 7/1";
    "10YR 6/1";
    "10YR 5/1";
    "10YR 4/1";
    "10YR 3/1";
    "10YR 2.5/1";
    "10YR 9/2";
    "10YR 8/2";
    "10YR 7/2";
    "10YR 6/2";
    "10YR 5/2";
    "10YR 4/2";
    "10YR 3/2";
    "10YR 9/4";
    "10YR 8/4";
    "10YR 7/4";
    "10YR 6/4";
    "10YR 5/4";
    "10YR 4/4";
    "10YR 8/6";
    "10YR 7/6";
    "10YR 6/6";
    "10YR 5/6";
    "10YR 8/8";
    "10YR 7/8";
    "10YR 6/8";
    "10YR 5/8";
    "10YR 8/10";
    "10YR 7/10";
    "10YR 6/10";
    "10YR 7/12";
    "2.5Y 9/2";
    "2.5Y 8.5/2";
    "2.5Y 8/2";
    "2.5Y 7/2";
    "2.5Y 6/2";
    "2.5Y 5/2";
    "2.5Y 4/2";
    "2.5Y 3/2";
    "2.5Y 9/4";
    "2.5Y 8.5/4";
    "2.5Y 8/4";
    "2.5Y 7/4";
    "2.5Y 6/4";
    "2.5Y 5/4";
    "2.5Y 4/4";
    "2.5Y 9/6";
    "2.5Y 8.5/6";
    "2.5Y 8/6";
    "2.5Y 7/6";
    "2.5Y 6/6";
    "2.5Y 5/6";
    "2.5Y 8.5/8";
    "2.5Y 8/8";
    "2.5Y 7/8";
    "2.5Y 6/8";
    "2.5Y 8.5/10";
    "2.5Y 8/10";
    "2.5Y 7/10";
    "2.5Y 8/12";
    "2.5Y 7/12";
    "5Y 9/1";
    "5Y 8.5/1";
    "5Y 8/1";
    "5Y 7/1";
    "5Y 6/1";
    "5Y 5/1";
    "5Y 4/1";
    "5Y 3/1";
    "5Y 2.5/1";
    "5Y 9/2";
    "5Y 8.5/2";
    "5Y 8/2";
    "5Y 7/2";
    "5Y 6/2";
    "5Y 5/2";
    "5Y 4/2";
    "5Y 3/2";
    "5Y 9/4";
    "5Y 8.5/4";
    "5Y 8/4";
    "5Y 7/4";
    "5Y 6/4";
    "5Y 5/4";
    "5Y 4/4";
    "5Y 9/6";
    "5Y 8.5/6";
    "5Y 8/6";
    "5Y 7/6";
    "5Y 6/6";
    "5Y 5/6";
    "5Y 9/8";
    "5Y 8.5/8";
    "5Y 8/8";
    "5Y 7/8";
    "5Y 6/8";
    "5Y 8.5/10";
    "5Y 8/10";
    "5Y 7/10";
    "5Y 8.5/12";
    "5Y 8/12";
    "5Y 7/12";
    "7.5Y 9/2";
    "7.5Y 8.5/2";
    "7.5Y 8/2";
    "7.5Y 7/2";
    "7.5Y 6/2";
    "7.5Y 5/2";
    "7.5Y 4/2";
    "7.5Y 3/2";
    "7.5Y 9/4";
    "7.5Y 8.5/4";
    "7.5Y 8/4";
    "7.5Y 7/4";
    "7.5Y 6/4";
    "7.5Y 5/4";
    "7.5Y 4/4";
    "7.5Y 9/6";
    "7.5Y 8.5/6";
    "7.5Y 8/6";
    "7.5Y 7/6";
    "7.5Y 6/6";
    "7.5Y 5/6";
    "7.5Y 9/8";
    "7.5Y 8.5/8";
    "7.5Y 8/8";
    "7.5Y 7/8";
    "7.5Y 6/8";
    "7.5Y 9/10";
    "7.5Y 8.5/10";
    "7.5Y 8/10";
    "7.5Y 7/10";
    "7.5Y 8.5/12";
    "7.5Y 8/12";
    "10Y 9/1";
    "10Y 8.5/1";
    "10Y 8/1";
    "10Y 7/1";
    "10Y 6/1";
    "10Y 5/1";
    "10Y 4/1";
    "10Y 3/1";
    "10Y 2.5/1";
    "10Y 9/2";
    "10Y 8.5/2";
    "10Y 8/2";
    "10Y 7/2";
    "10Y 6/2";
    "10Y 5/2";
    "10Y 4/2";
    "10Y 3/2";
    "10Y 9/4";
    "10Y 8.5/4";
    "10Y 8/4";
    "10Y 7/4";
    "10Y 6/4";
    "10Y 5/4";
    "10Y 4/4";
    "10Y 9/6";
    "10Y 8.5/6";
    "10Y 8/6";
    "10Y 7/6";
    "10Y 6/6";
    "10Y 5/6";
    "10Y 9/8";
    "10Y 8.5/8";
    "10Y 8/8";
    "10Y 7/8";
    "10Y 6/8";
    "10Y 9/10";
    "10Y 8.5/10";
    "10Y 8/10";
    "10Y 7/10";
    "10Y 8/12";
    "2.5GY 9/2";
    "2.5GY 8.5/2";
    "2.5GY 8/2";
    "2.5GY 7/2";
    "2.5GY 6/2";
    "2.5GY 5/2";
    "2.5GY 4/2";
    "2.5GY 3/2";
    "2.5GY 9/4";
    "2.5GY 8.5/4";
    "2.5GY 8/4";
    "2.5GY 7/4";
    "2.5GY 6/4";
    "2.5GY 5/4";
    "2.5GY 4/4";
    "2.5GY 9/6";
    "2.5GY 8.5/6";
    "2.5GY 8/6";
    "2.5GY 7/6";
    "2.5GY 6/6";
    "2.5GY 5/6";
    "2.5GY 9/8";
    "2.5GY 8.5/8";
    "2.5GY 8/8";
    "2.5GY 7/8";
    "2.5GY 6/8";
    "2.5GY 8.5/10";
    "2.5GY 8/10";
    "2.5GY 7/10";
    "5GY 9/1";
    "5GY 8.5/1";
    "5GY 8/1";
    "5GY 7/1";
    "5GY 6/1";
    "5GY 5/1";
    "5GY 4/1";
    "5GY 3/1";
    "5GY 2.5/1";
    "5GY 9/2";
    "5GY 8.5/2";
    "5GY 8/2";
    "5GY 7/2";
    "5GY 6/2";
    "5GY 5/2";
    "5GY 4/2";
    "5GY 3/2";
    "5GY 9/4";
    "5GY 8.5/4";
    "5GY 8/4";
    "5GY 7/4";
    "5GY 6/4";
    "5GY 5/4";
    "5GY 4/4";
    "5GY 9/6";
    "5GY 8.5/6";
    "5GY 8/6";
    "5GY 7/6";
    "5GY 6/6";
    "5GY 5/6";
    "5GY 8.5/8";
    "5GY 8/8";
    "5GY 7/8";
    "5GY 6/8";
    "5GY 5/8";
    "5GY 8.5/10";
    "5GY 8/10";
    "7.5GY 9/2";
    "7.5GY 8.5/2";
    "7.5GY 8/2";
    "7.5GY 7/2";
    "7.5GY 6/2";
    "7.5GY 5/2";
    "7.5GY 4/2";
    "7.5GY 3/2";
    "7.5GY 9/4";
    "7.5GY 8.5/4";
    "7.5GY 8/4";
    "7.5GY 7/4";
    "7.5GY 6/4";
    "7.5GY 5/4";
    "7.5GY 4/4";
    "7.5GY 8.5/6";
    "7.5GY 8/6";
    "7.5GY 7/6";
    "7.5GY 6/6";
    "7.5GY 5/6";
    "7.5GY 8/8";
    "7.5GY 7/8";
    "7.5GY 6/8";
    "7.5GY 5/8";
    "7.5GY 7/10";
    "7.5GY 6/10";
    "10GY 9/1";
    "10GY 8.5/1";
    "10GY 8/1";
    "10GY 7/1";
    "10GY 6/1";
    "10GY 5/1";
    "10GY 4/1";
    "10GY 3/1";
    "10GY 2.5/1";
    "10GY 9/2";
    "10GY 8.5/2";
    "10GY 8/2";
    "10GY 7/2";
    "10GY 6/2";
    "10GY 5/2";
    "10GY 4/2";
    "10GY 3/2";
    "10GY 2.5/2";
    "10GY 9/4";
    "10GY 8.5/4";
    "10GY 8/4";
    "10GY 7/4";
    "10GY 6/4";
    "10GY 5/4";
    "10GY 4/4";
    "10GY 8.5/6";
    "10GY 8/6";
    "10GY 7/6";
    "10GY 6/6";
    "10GY 5/6";
    "10GY 7/8";
    "10GY 6/8";
    "10GY 5/8";
    "10GY 7/10";
    "10GY 6/10";
    "2.5G 9/2";
    "2.5G 8/2";
    "2.5G 7/2";
    "2.5G 6/2";
    "2.5G 5/2";
    "2.5G 4/2";
    "2.5G 3/2";
    "2.5G 2.5/2";
    "2.5G 8/4";
    "2.5G 7/4";
    "2.5G 6/4";
    "2.5G 5/4";
    "2.5G 4/4";
    "2.5G 3/4";
    "2.5G 8/6";
    "2.5G 7/6";
    "2.5G 6/6";
    "2.5G 5/6";
    "2.5G 4/6";
    "2.5G 7/8";
    "2.5G 6/8";
    "2.5G 5/8";
    "2.5G 7/10";
    "2.5G 6/10";
    "2.5G 5/10";
    "2.5G 6/12";
    "5G 9/1";
    "5G 8/1";
    "5G 7/1";
    "5G 6/1";
    "5G 5/1";
    "5G 4/1";
    "5G 3/1";
    "5G 2.5/1";
    "5G 9/2";
    "5G 8/2";
    "5G 7/2";
    "5G 6/2";
    "5G 5/2";
    "5G 4/2";
    "5G 3/2";
    "5G 2.5/2";
    "5G 8/4";
    "5G 7/4";
    "5G 6/4";
    "5G 5/4";
    "5G 4/4";
    "5G 3/4";
    "5G 8/6";
    "5G 7/6";
    "5G 6/6";
    "5G 5/6";
    "5G 4/6";
    "5G 7/8";
    "5G 6/8";
    "5G 5/8";
    "5G 4/8";
    "5G 7/10";
    "5G 6/10";
    "7.5G 9/2";
    "7.5G 8/2";
    "7.5G 7/2";
    "7.5G 6/2";
    "7.5G 5/2";
    "7.5G 4/2";
    "7.5G 3/2";
    "7.5G 2.5/2";
    "7.5G 8/4";
    "7.5G 7/4";
    "7.5G 6/4";
    "7.5G 5/4";
    "7.5G 4/4";
    "7.5G 3/4";
    "7.5G 8/6";
    "7.5G 7/6";
    "7.5G 6/6";
    "7.5G 5/6";
    "7.5G 4/6";
    "7.5G 7/8";
    "7.5G 6/8";
    "7.5G 5/8";
    "7.5G 4/8";
    "7.5G 7/10";
    "7.5G 6/10";
    "10G 9/1";
    "10G 8/1";
    "10G 7/1";
    "10G 6/1";
    "10G 5/1";
    "10G 4/1";
    "10G 3/1";
    "10G 2.5/1";
    "10G 9/2";
    "10G 8/2";
    "10G 7/2";
    "10G 6/2";
    "10G 5/2";
    "10G 4/2";
    "10G 3/2";
    "10G 2.5/2";
    "10G 8/4";
    "10G 7/4";
    "10G 6/4";
    "10G 5/4";
    "10G 4/4";
    "10G 3/4";
    "10G 7/6";
    "10G 6/6";
    "10G 5/6";
    "10G 4/6";
    "10G 7/8";
    "10G 6/8";
    "10G 5/8";
    "10G 4/8";
    "10G 6/10";
    "2.5BG 9/2";
    "2.5BG 8/2";
    "2.5BG 7/2";
    "2.5BG 6/2";
    "2.5BG 5/2";
    "2.5BG 4/2";
    "2.5BG 3/2";
    "2.5BG 2.5/2";
    "2.5BG 8/4";
    "2.5BG 7/4";
    "2.5BG 6/4";
    "2.5BG 5/4";
    "2.5BG 4/4";
    "2.5BG 3/4";
    "2.5BG 7/6";
    "2.5BG 6/6";
    "2.5BG 5/6";
    "2.5BG 4/6";
    "2.5BG 3/6";
    "2.5BG 7/8";
    "2.5BG 6/8";
    "2.5BG 5/8";
    "2.5BG 4/8";
    "2.5BG 6/10";
    "5BG 9/1";
    "5BG 8/1";
    "5BG 7/1";
    "5BG 6/1";
    "5BG 5/1";
    "5BG 4/1";
    "5BG 3/1";
    "5BG 2.5/1";
    "5BG 9/2";
    "5BG 8/2";
    "5BG 7/2";
    "5BG 6/2";
    "5BG 5/2";
    "5BG 4/2";
    "5BG 3/2";
    "5BG 2.5/2";
    "5BG 8/4";
    "5BG 7/4";
    "5BG 6/4";
    "5BG 5/4";
    "5BG 4/4";
    "5BG 3/4";
    "5BG 7/6";
    "5BG 6/6";
    "5BG 5/6";
    "5BG 4/6";
    "5BG 7/8";
    "5BG 6/8";
    "5BG 5/8";
    "5BG 4/8";
    "7.5BG 9/2";
    "7.5BG 8/2";
    "7.5BG 7/2";
    "7.5BG 6/2";
    "7.5BG 5/2";
    "7.5BG 4/2";
    "7.5BG 3/2";
    "7.5BG 2.5/2";
    "7.5BG 8/4";
    "7.5BG 7/4";
    "7.5BG 6/4";
    "7.5BG 5/4";
    "7.5BG 4/4";
    "7.5BG 3/4";
    "7.5BG 7/6";
    "7.5BG 6/6";
    "7.5BG 5/6";
    "7.5BG 4/6";
    "7.5BG 7/8";
    "7.5BG 6/8";
    "7.5BG 5/8";
    "7.5BG 4/8";
    "10BG 9/1";
    "10BG 8/1";
    "10BG 7/1";
    "10BG 6/1";
    "10BG 5/1";
    "10BG 4/1";
    "10BG 3/1";
    "10BG 2.5/1";
    "10BG 9/2";
    "10BG 8/2";
    "10BG 7/2";
    "10BG 6/2";
    "10BG 5/2";
    "10BG 4/2";
    "10BG 3/2";
    "10BG 2.5/2";
    "10BG 8/4";
    "10BG 7/4";
    "10BG 6/4";
    "10BG 5/4";
    "10BG 4/4";
    "10BG 3/4";
    "10BG 7/6";
    "10BG 6/6";
    "10BG 5/6";
    "10BG 4/6";
    "10BG 7/8";
    "10BG 6/8";
    "10BG 5/8";
    "10BG 4/8";
    "2.5B 9/2";
    "2.5B 8/2";
    "2.5B 7/2";
    "2.5B 6/2";
    "2.5B 5/2";
    "2.5B 4/2";
    "2.5B 3/2";
    "2.5B 2.5/2";
    "2.5B 8/4";
    "2.5B 7/4";
    "2.5B 6/4";
    "2.5B 5/4";
    "2.5B 4/4";
    "2.5B 3/4";
    "2.5B 7/6";
    "2.5B 6/6";
    "2.5B 5/6";
    "2.5B 4/6";
    "2.5B 7/8";
    "2.5B 6/8";
    "2.5B 5/8";
    "2.5B 4/8";
    "5B 9/1";
    "5B 8/1";
    "5B 7/1";
    "5B 6/1";
    "5B 5/1";
    "5B 4/1";
    "5B 3/1";
    "5B 2.5/1";
    "5B 9/2";
    "5B 8/2";
    "5B 7/2";
    "5B 6/2";
    "5B 5/2";
    "5B 4/2";
    "5B 3/2";
    "5B 2.5/2";
    "5B 8/4";
    "5B 7/4";
    "5B 6/4";
    "5B 5/4";
    "5B 4/4";
    "5B 3/4";
    "5B 7/6";
    "5B 6/6";
    "5B 5/6";
    "5B 4/6";
    "5B 3/6";
    "5B 7/8";
    "5B 6/8";
    "5B 5/8";
    "5B 4/8";
    "7.5B 9/2";
    "7.5B 8/2";
    "7.5B 7/2";
    "7.5B 6/2";
    "7.5B 5/2";
    "7.5B 4/2";
    "7.5B 3/2";
    "7.5B 2.5/2";
    "7.5B 8/4";
    "7.5B 7/4";
    "7.5B 6/4";
    "7.5B 5/4";
    "7.5B 4/4";
    "7.5B 3/4";
    "7.5B 7/6";
    "7.5B 6/6";
    "7.5B 5/6";
    "7.5B 4/6";
    "7.5B 3/6";
    "7.5B 7/8";
    "7.5B 6/8";
    "7.5B 5/8";
    "7.5B 4/8";
    "7.5B 6/10";
    "7.5B 5/10";
    "10B 9/1";
    "10B 8/1";
    "10B 7/1";
    "10B 6/1";
    "10B 5/1";
    "10B 4/1";
    "10B 3/1";
    "10B 2.5/1";
    "10B 9/2";
    "10B 8/2";
    "10B 7/2";
    "10B 6/2";
    "10B 5/2";
    "10B 4/2";
    "10B 3/2";
    "10B 2.5/2";
    "10B 8/4";
    "10B 7/4";
    "10B 6/4";
    "10B 5/4";
    "10B 4/4";
    "10B 3/4";
    "10B 2.5/4";
    "10B 7/6";
    "10B 6/6";
    "10B 5/6";
    "10B 4/6";
    "10B 3/6";
    "10B 7/8";
    "10B 6/8";
    "10B 5/8";
    "10B 4/8";
    "10B 6/10";
    "10B 5/10";
    "2.5PB 9/2";
    "2.5PB 8/2";
    "2.5PB 7/2";
    "2.5PB 6/2";
    "2.5PB 5/2";
    "2.5PB 4/2";
    "2.5PB 3/2";
    "2.5PB 2.5/2";
    "2.5PB 8/4";
    "2.5PB 7/4";
    "2.5PB 6/4";
    "2.5PB 5/4";
    "2.5PB 4/4";
    "2.5PB 3/4";
    "2.5PB 2.5/4";
    "2.5PB 8/6";
    "2.5PB 7/6";
    "2.5PB 6/6";
    "2.5PB 5/6";
    "2.5PB 4/6";
    "2.5PB 3/6";
    "2.5PB 7/8";
    "2.5PB 6/8";
    "2.5PB 5/8";
    "2.5PB 4/8";
    "2.5PB 6/10";
    "2.5PB 5/10";
    "2.5PB 4/10";
    "5PB 9/1";
    "5PB 8/1";
    "5PB 7/1";
    "5PB 6/1";
    "5PB 5/1";
    "5PB 4/1";
    "5PB 3/1";
    "5PB 2.5/1";
    "5PB 9/2";
    "5PB 8/2";
    "5PB 7/2";
    "5PB 6/2";
    "5PB 5/2";
    "5PB 4/2";
    "5PB 3/2";
    "5PB 2.5/2";
    "5PB 8/4";
    "5PB 7/4";
    "5PB 6/4";
    "5PB 5/4";
    "5PB 4/4";
    "5PB 3/4";
    "5PB 2.5/4";
    "5PB 8/6";
    "5PB 7/6";
    "5PB 6/6";
    "5PB 5/6";
    "5PB 4/6";
    "5PB 3/6";
    "5PB 7/8";
    "5PB 6/8";
    "5PB 5/8";
    "5PB 4/8";
    "5PB 3/8";
    "5PB 6/10";
    "5PB 5/10";
    "5PB 4/10";
    "5PB 5/12";
    "5PB 4/12";
    "7.5PB 9/2";
    "7.5PB 8/2";
    "7.5PB 7/2";
    "7.5PB 6/2";
    "7.5PB 5/2";
    "7.5PB 4/2";
    "7.5PB 3/2";
    "7.5PB 2.5/2";
    "7.5PB 8/4";
    "7.5PB 7/4";
    "7.5PB 6/4";
    "7.5PB 5/4";
    "7.5PB 4/4";
    "7.5PB 3/4";
    "7.5PB 2.5/4";
    "7.5PB 8/6";
    "7.5PB 7/6";
    "7.5PB 6/6";
    "7.5PB 5/6";
    "7.5PB 4/6";
    "7.5PB 3/6";
    "7.5PB 2.5/6";
    "7.5PB 7/8";
    "7.5PB 6/8";
    "7.5PB 5/8";
    "7.5PB 4/8";
    "7.5PB 3/8";
    "7.5PB 6/10";
    "7.5PB 5/10";
    "7.5PB 4/10";
    "7.5PB 3/10";
    "7.5PB 5/12";
    "7.5PB 4/12";
    "10PB 9/1";
    "10PB 8/1";
    "10PB 7/1";
    "10PB 6/1";
    "10PB 5/1";
    "10PB 4/1";
    "10PB 3/1";
    "10PB 2.5/1";
    "10PB 9/2";
    "10PB 8/2";
    "10PB 7/2";
    "10PB 6/2";
    "10PB 5/2";
    "10PB 4/2";
    "10PB 3/2";
    "10PB 2.5/2";
    "10PB 8/4";
    "10PB 7/4";
    "10PB 6/4";
    "10PB 5/4";
    "10PB 4/4";
    "10PB 3/4";
    "10PB 2.5/4";
    "10PB 7/6";
    "10PB 6/6";
    "10PB 5/6";
    "10PB 4/6";
    "10PB 3/6";
    "10PB 2.5/6";
    "10PB 7/8";
    "10PB 6/8";
    "10PB 5/8";
    "10PB 4/8";
    "10PB 3/8";
    "10PB 6/10";
    "10PB 5/10";
    "10PB 4/10";
    "2.5P 9/2";
    "2.5P 8/2";
    "2.5P 7/2";
    "2.5P 6/2";
    "2.5P 5/2";
    "2.5P 4/2";
    "2.5P 3/2";
    "2.5P 2.5/2";
    "2.5P 8/4";
    "2.5P 7/4";
    "2.5P 6/4";
    "2.5P 5/4";
    "2.5P 4/4";
    "2.5P 3/4";
    "2.5P 2.5/4";
    "2.5P 7/6";
    "2.5P 6/6";
    "2.5P 5/6";
    "2.5P 4/6";
    "2.5P 3/6";
    "2.5P 7/8";
    "2.5P 6/8";
    "2.5P 5/8";
    "2.5P 4/8";
    "2.5P 3/8";
    "2.5P 6/10";
    "2.5P 5/10";
    "2.5P 4/10";
    "5P 9/1";
    "5P 8/1";
    "5P 7/1";
    "5P 6/1";
    "5P 5/1";
    "5P 4/1";
    "5P 3/1";
    "5P 2.5/1";
    "5P 9/2";
    "5P 8/2";
    "5P 7/2";
    "5P 6/2";
    "5P 5/2";
    "5P 4/2";
    "5P 3/2";
    "5P 2.5/2";
    "5P 8/4";
    "5P 7/4";
    "5P 6/4";
    "5P 5/4";
    "5P 4/4";
    "5P 3/4";
    "5P 2.5/4";
    "5P 7/6";
    "5P 6/6";
    "5P 5/6";
    "5P 4/6";
    "5P 3/6";
    "5P 2.5/6";
    "5P 7/8";
    "5P 6/8";
    "5P 5/8";
    "5P 4/8";
    "5P 3/8";
    "5P 5/10";
    "5P 4/10";
    "7.5P 9/2";
    "7.5P 8/2";
    "7.5P 7/2";
    "7.5P 6/2";
    "7.5P 5/2";
    "7.5P 4/2";
    "7.5P 3/2";
    "7.5P 2.5/2";
    "7.5P 8/4";
    "7.5P 7/4";
    "7.5P 6/4";
    "7.5P 5/4";
    "7.5P 4/4";
    "7.5P 3/4";
    "7.5P 2.5/4";
    "7.5P 8/6";
    "7.5P 7/6";
    "7.5P 6/6";
    "7.5P 5/6";
    "7.5P 4/6";
    "7.5P 3/6";
    "7.5P 7/8";
    "7.5P 6/8";
    "7.5P 5/8";
    "7.5P 4/8";
    "7.5P 3/8";
    "7.5P 6/10";
    "7.5P 5/10";
    "7.5P 4/10";
    "10P 9/1";
    "10P 8/1";
    "10P 7/1";
    "10P 6/1";
    "10P 5/1";
    "10P 4/1";
    "10P 3/1";
    "10P 2.5/1";
    "10P 9/2";
    "10P 8/2";
    "10P 7/2";
    "10P 6/2";
    "10P 5/2";
    "10P 4/2";
    "10P 3/2";
    "10P 2.5/2";
    "10P 8/4";
    "10P 7/4";
    "10P 6/4";
    "10P 5/4";
    "10P 4/4";
    "10P 3/4";
    "10P 2.5/4";
    "10P 8/6";
    "10P 7/6";
    "10P 6/6";
    "10P 5/6";
    "10P 4/6";
    "10P 3/6";
    "10P 7/8";
    "10P 6/8";
    "10P 5/8";
    "10P 4/8";
    "10P 3/8";
    "10P 6/10";
    "10P 5/10";
    "10P 4/10";
    "10P 5/12";
    "2.5RP 9/2";
    "2.5RP 8/2";
    "2.5RP 7/2";
    "2.5RP 6/2";
    "2.5RP 5/2";
    "2.5RP 4/2";
    "2.5RP 3/2";
    "2.5RP 2.5/2";
    "2.5RP 8/4";
    "2.5RP 7/4";
    "2.5RP 6/4";
    "2.5RP 5/4";
    "2.5RP 4/4";
    "2.5RP 3/4";
    "2.5RP 2.5/4";
    "2.5RP 8/6";
    "2.5RP 7/6";
    "2.5RP 6/6";
    "2.5RP 5/6";
    "2.5RP 4/6";
    "2.5RP 3/6";
    "2.5RP 7/8";
    "2.5RP 6/8";
    "2.5RP 5/8";
    "2.5RP 4/8";
    "2.5RP 7/10";
    "2.5RP 6/10";
    "2.5RP 5/10";
    "2.5RP 4/10";
    "2.5RP 6/12";
    "2.5RP 5/12";
    "5RP 9/1";
    "5RP 8/1";
    "5RP 7/1";
    "5RP 6/1";
    "5RP 5/1";
    "5RP 4/1";
    "5RP 3/1";
    "5RP 2.5/1";
    "5RP 9/2";
    "5RP 8/2";
    "5RP 7/2";
    "5RP 6/2";
    "5RP 5/2";
    "5RP 4/2";
    "5RP 3/2";
    "5RP 2.5/2";
    "5RP 8/4";
    "5RP 7/4";
    "5RP 6/4";
    "5RP 5/4";
    "5RP 4/4";
    "5RP 3/4";
    "5RP 2.5/4";
    "5RP 8/6";
    "5RP 7/6";
    "5RP 6/6";
    "5RP 5/6";
    "5RP 4/6";
    "5RP 3/6";
    "5RP 7/8";
    "5RP 6/8";
    "5RP 5/8";
    "5RP 4/8";
    "5RP 6/10";
    "5RP 5/10";
    "5RP 4/10";
    "5RP 5/12";
    "5RP 4/12";
    "7.5RP 9/2";
    "7.5RP 8/2";
    "7.5RP 7/2";
    "7.5RP 6/2";
    "7.5RP 5/2";
    "7.5RP 4/2";
    "7.5RP 3/2";
    "7.5RP 2.5/2";
    "7.5RP 8/4";
    "7.5RP 7/4";
    "7.5RP 6/4";
    "7.5RP 5/4";
    "7.5RP 4/4";
    "7.5RP 3/4";
    "7.5RP 2.5/4";
    "7.5RP 8/6";
    "7.5RP 7/6";
    "7.5RP 6/6";
    "7.5RP 5/6";
    "7.5RP 4/6";
    "7.5RP 3/6";
    "7.5RP 7/8";
    "7.5RP 6/8";
    "7.5RP 5/8";
    "7.5RP 4/8";
    "7.5RP 6/10";
    "7.5RP 5/10";
    "7.5RP 4/10";
    "7.5RP 5/12";
    "7.5RP 4/12";
    "10RP 9/1";
    "10RP 8/1";
    "10RP 7/1";
    "10RP 6/1";
    "10RP 5/1";
    "10RP 4/1";
    "10RP 3/1";
    "10RP 2.5/1";
    "10RP 9/2";
    "10RP 8/2";
    "10RP 7/2";
    "10RP 6/2";
    "10RP 5/2";
    "10RP 4/2";
    "10RP 3/2";
    "10RP 2.5/2";
    "10RP 8/4";
    "10RP 7/4";
    "10RP 6/4";
    "10RP 5/4";
    "10RP 4/4";
    "10RP 3/4";
    "10RP 2.5/4";
    "10RP 8/6";
    "10RP 7/6";
    "10RP 6/6";
    "10RP 5/6";
    "10RP 4/6";
    "10RP 3/6";
    "10RP 7/8";
    "10RP 6/8";
    "10RP 5/8";
    "10RP 4/8";
    "10RP 6/10";
    "10RP 5/10";
    "10RP 4/10";
    "10RP 5/12";
    "10RP 4/12"]
