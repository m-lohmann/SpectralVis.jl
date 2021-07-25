abstract type SpecEnv end #global settings for spectral calculations

#=
    Spectral environment
    λmin: lower wavelength boundary for all spectral calculations
            default: 380.0 nm, suitable for the 2012 CIE CMFs
    Δλ : wavelength stepwidth
            default: 1.0 nm, suitable for the 2012 CIE CMFs
    λmax: upper wavelength boundery for all spectral calculations
            default: 830.0 nm, suitable for the 2012 CIE CMFs
    cmf: color matching function used for all spectral calculations
            default: CMF2012_10 (CIE2012 color matching function for a 10° observer)
    ex: extrapolation mode for spectra that have a smaller range than the environment settings
            default: :linear (linear extrapolation)
=#
mutable struct SpecEnvironment <: SpecEnv
    λmin::Real
    Δλ::Real
    λmax::Real
    cmf
    ex::Symbol
    function SpecEnvironment(λmin,Δλ,λmax,cmf,ex)
        new(λmin,Δλ,λmax,cmf,ex)
    end
end

"""
`set_specenv(λmin=390.0,Δλ=1.0,λmax=830.0,extrapolate= :zero)`

Initializes the spectral environment to standard values:

λmin = 380.0 nm
λmax = 830.0 nm
Δλ   =   1.0 nm
cmf  = cmfunc(:cie12_10)
ex = :linear
"""
function set_specenv(λmin = 390.0, Δλ = 1.0, λmax = 830.0, cmf = cmfunc(:cie12_10), ex = :linear)
    SpecEnvironment(λmin,Δλ,λmax,cmf,ex)
end

# Set spectral environment to default settings
SPECENV=set_specenv()

"""
`set_extrap(env::SpecEnvironment,extrapolation::Symbol)`

Sets the extrapolation mode of the environment `env` to one of the available extrapolation settings:

`:none` or `:zero`: out of range values are zero.

`:constant`: out of range values are set to λmin and λmax, respectively.

`:linear`: out of range values are linearly extrapolated through the first/last two data points.

`:parabolic`: out fo range values are extrapolated with a parabola through the first/last three datapoints. *Recommended extrapolation method according to D.L. MacAdams* in "Color Measurement", chapter 5.4 *"Truncations"*.
"""
function set_extrap(env::SpecEnvironment,extrapolation::Symbol)
    extrapolation in (:none, :boundary, :linear, :parabolic) ? env.ex = extrapolation :
    extrapolation == :zero ? set_extrap(env, :none) : throw(DomainError(extrapolation,"Extrapolation mode does not exist!"))
end


"""
`set_extrap(extrapolation::Symbol)`

Sets the extrapolation mode of the environment `env` to one of the available extrapolation settings:

`:none` or `:zero`: out of range values are zero.

`:constant`: out of range values are set to λmin and λmax, respectively.

`:linear`: out of range values are linearly extrapolated through the first/last two data points.

`:parabolic`: out fo range values are extrapolated with a parabola through the first/last three datapoints. *Recommended extrapolation method according to D.L. MacAdams* in "Color Measurement", chapter 5.4 *"Truncations"*.
"""
function set_extrap(extrapolation::Symbol)
    set_extrap(SPECENV, extrapolation)
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


"""
`set_limits(λmin::Real,Δλ::Real,λmax::Real)`

sets the wavelength limits and resolution of the spectral environment
"""
function set_limits(λmin::Real,Δλ::Real,λmax::Real)
    set_limits(SPECENV, λmin, Δλ, λmax)
end


"""
`set_colormatch(env::SpecEnvironment, colormatch::CMatch)`

Sets the color matching function (CMF) used in a defined spectral environment.

Available CMFs:

`:cie31`, `:cie31_j`, `:cie31_jv`, `:cie64`, `:cie12_2`, `:cie12_10`, `:lms06_2`, `:lms06_10`
"""
function set_colormatch(env::SpecEnvironment, colormatch::Symbol)
    env.cmf = create_cmf(colormatch)
end


"""
`set_colormatch(colormatch::CMatch)`

Sets the color matching function (CMF) used in the spectral environment.

Available CMFs:

`:cie31`, `:cie31_j`, `:cie31_jv`, `:cie64`, `:cie12_2`, `:cie12_10`, `:lms06_2`, `:lms06_10`
"""
function set_colormatch(colormatch::Symbol)
    set_colormatch(SPECENV, colormatch)
end
