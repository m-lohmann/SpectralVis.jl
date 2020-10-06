module SpectralVis
# Write your package code here.
import Base: convert
import Base: +, -, *, /

export 

include("types.jl")
include("spectralfunctions.jl")
include("spectralops.jl")

# Color matching function tables
include("cmf_tables.jl")

# Real world pectrdal data
include("spectrum_MarsSkyOpp.jl")
include("spectrum_MERCaltarget.jl")
include("spectrum_Pancam.jl")
end
