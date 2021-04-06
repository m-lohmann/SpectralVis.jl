function plotmunsell(specs)
    λ=collect(380:800)
    n=421
    plot(λ,zeros(n))
    for i in 1:n:140#length(specs)-n-1
        plot!(λ,specs[i:i+n-1])
    end
end

function munsell_specs()
    sfile=readlines("../spectra/munsell.dat")
    specs=map(x->parse(Float64,x),sfile)
end

function spec_idx(idx::Int,spec)
    n=421
    i=(idx-1)*n+1
    y=spec[i:i+n-1]
    RSpec(collect(380:800),y)
end

function spec_color(col::AbstractString,colordict::AbstractString)
    if colordict=="munsell"
        td = munselldict()
        spec = munsell_specs()
    end
    ind=get(td,col,"Color key $(col) does not exist")
    if haskey(td,col)
        return spec_idx(ind,spec)
    else error("Color key $(col) does not exist")
    end
end