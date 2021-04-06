abstract type SpecEnv end #global settings for spectral calculations

mutable struct SpecEnvironment <: SpecEnv
    λmin::Real
    Δλ::Real
    λmax::Real
    ex::Symbol
    function SpecEnvironment(λmin,Δλ,λmax,ex)
        new(λmin,Δλ,λmax,ex)
    end
end

"""
`set_specenv(λmin=390.0,Δλ=1.0,λmax=830.0,extrapolate= :zero)`

Initializes the environment to standard values:

λmin = 380.0 nm
λmax = 830.0 nm
Δλ   =   1.0 nm
extr = "zero"
"""
function set_specenv(λmin=390.0,Δλ=1.0,λmax=830.0,ex= :zero)
    SpecEnvironment(λmin,Δλ,λmax,ex)
end

SPECENV=set_specenv()

"""
`set_extrapolation(env::SpecEnvironment,extrapolation::Symbol)`

Sets the extrapolation mode of the environment `env` to one of the available extrapolation settings:

`:none` or `:zero`: out of range values are zero.

`:constant`: out of range values are set to λmin and λmax, respectively.

`:linear`: out of range values are linearly extrapolated through the first/last two data points.

`:parabolic`: out fo range values are extrapolated with a parabola through the first/last three datapoints. *Recommended extrapolation method according to D.L. MacAdams* in "Color Measurement", chapter 5.4 *"Truncations"*.
"""
function set_extrap(env::SpecEnvironment,extrapolation::Symbol)
    extrapolation == :none || :zero ? env.ex=:none : # sets out of range values to zero
    extrapolation == :boundary ? env.ex= :boundary : #sets out of range values to λmin and λxtrapolationmax, respectively
    extrapolation == :linear ? env.ex= :linear : # linear extrapolation through the first/last two data points
    extrapolation == :parabolic ? env.ex= :parabolic : # parabolic runout, through the first/last 3 data points
    error("Extrapolation mode does not exist!")
end

function set_extrap(extrapolation::Symbol)
    set_extrap(SPECENV,extrapolation)
end

"""
`set_limits(env::SpecEnvironment, λmin::Real,Δλ::Real,λmax::Real)`

sets the wavelength limits and resolution of the spectral environment
"""
function set_limits(env::SpecEnvironment, λmin::Real,Δλ::Real,λmax::Real)
    env.λmin = λmin
    env.Δλ = Δλ
    env.λmax = λmax
end

function set_limits(λmin::Real,Δλ::Real,λmax::Real)
    set_limits(SPECENV, λmin, Δλ, λmax)
end