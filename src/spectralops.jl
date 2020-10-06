# Spectral operations
*(a::SPD,b::SPD) = RSpec(a.λ,a.s .* b.s)
*(a::SPD,b::STD) = RSpec(a.λ,a.s .* b.t)
*(a::STD,b::SPD) = RSpec(a.λ,a.t .* b.s)
*(a::STD,b::STD) = Rspec(a.λ,a.t .* b.t)