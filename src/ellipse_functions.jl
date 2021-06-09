"""
`ellipse_parameters(dataset, index::Int)`

Gives the entire set of ellipse parameters for a dataset at a given index.
"""
ellipse_parameters(dataset, index::Int) = dataset[index,:]


"""
`ellipse_a(dataset, index::Int)`

Gives the major axis parameter `a` for a dataset at a given index.
"""
function ellipse_a(dataset, index::Int)
    dataset[index,end-1]
end


"""
`ellipse_b(dataset, index::Int)`

Gives the minor axis parameter `b` for a dataset at a given index.
"""
function ellipse_b(dataset, index::Int)
    dataset[index,end]
end


"""
`ellipse_b(dataset, index::Int)`

Gives the axis tilt parameter `θ` for a dataset at a given index.
"""
function ellipse_θ(dataset, index::Int)
    dataset[index,end-2]
end

"""
`ellipse_center(dataset, index::Int)`

Gives the pair of coordinates `x0, y0` of the ellipse center for a dataset at a given index.
"""
function ellipse_center(dataset, index::Int)
    dataset[index,1], dataset[index,2]
end

function ellipse_l0(dataset, index::Int)
    if dataset in (WRB_ellipses, DLM_ellipses, B_ellipses)
        dataset[index,3]
    else
        error("Dataset does not contain info about l0.")
    end
end


"""
`ellipse_g11(dataset, index::Int)`

Gives the ellipse parameter `g11` at a given index.
"""
function ellipse_g11(dataset, index::Int)
    # θ is the tilt of the ellipse
    θ = ellipse_θ(dataset, index)
    cosd(θ)^2/ellipse_a(dataset, index) + sind(θ)^2/ellipse_b(dataset, index)^2
end

"""
`ellipse_g12(dataset, index::Int)`

Gives the ellipse parameter `g12` at a given index.
"""
function ellipse_g12(dataset, index::Int)
    θ = ellipse_θ(dataset, index)
    sind(θ) * cosd(θ) * (1.0/ellipse_a(dataset, index)^2 - 1/ellipse_b(dataset, index)^2)
end

"""
`ellipse_g22(dataset, index::Int)`

Gives the ellipse parameter `g22` at a given index.
"""
function ellipse_g22(dataset, index::Int)
    θ = ellipse_θ(dataset, index)
    sind(θ)^2/ellipse_a(dataset, index)^2 + cosd(θ)/ellipse_b(dataset, index)^2
end

"""
`ellipse_g23(dataset, index::Int)`

Gives the ellipse parameter `g23` at a given index.
"""
function ellipse_g23(dataset, index::Int)

end

"""
`ellipse_g33(dataset, index::Int)`

Gives the ellipse parameter `g33` at a given index.
"""
function ellispe_g33(dataset, index::Int)

end

"""
`ellipse_g13(dataset, index::Int)`

Gives the ellipse parameter `g13` at a given index.
"""
function ellispe_g13(dataset, index::Int)

end

"""
`ellipse_luminance(dataset,index::Int)`

Gives the luminance in cd/m² of a given test color
"""
function ellipse_luminance(dataset, index::Int)
    if dataset in (WRB_ellipses, DLM_ellipses, B_ellipses)
        10^(5 * ellipse_l0(dataset, index))
    else error("Dataset $dataset does not contain l0/luminance information for test colors")
    end
end

"""
`draw_ellipses(dataset)`

Draws all ellipses of a chosen dataset.
"""
function draw_ellipses(dataset,sizefactor)
    ellcoll = []
    @inbounds for ind = 1:size(dataset)[1]
        a = ellipse_a(dataset, ind)
        b = ellipse_b(dataset, ind)
        θ = ellipse_θ(dataset, ind)
        x0, y0 = ellipse_center(dataset, ind)
        ell = ellipse(x0, y0, sizefactor*a, sizefactor*b, θ/180 * π)
        push!(ellcoll, ell)
    end
    ellcoll
end

# 3d ellipse
#  ds^2 = g11(x-x0)^2 + g22(y-y0)^2 + g33(l-l0)^2
# +2 * g12(x-x0)(y-y0) + 2 * g13(x-x0)(l-l0) + 2 * g23(y-y0)(l-l0)
# with ds^2 = 7.81, corresponding to χ^2 value for 3 degrees of freedom,
# ellipsoid contains on average 95% of any random set of color matches

"""
`ellipse(u, v, a, b, theta)`

Create coordinate vectors of an ellipse with center coordinates `u`, `v`, major axis `a`, minor axis `b`, and tilt angle `θ`.

Result: `x::Vector, y::vector`
"""
function ellipse(u, v, a, b, theta)
    n = 40
    x = zeros(n+1)
    y = zeros(n+1)
    @inbounds for i in 1:1:n+1
        t = i * (2π)/n
        e = a * sin(t)
        f = b * cos(t)
        x[i] = e * cos(theta) - f * sin(theta) + u
        y[i] = e * sin(theta) + f * cos(theta) + v
    end
    x, y
end