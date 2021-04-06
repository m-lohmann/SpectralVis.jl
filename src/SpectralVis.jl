__precompile__()
module SpectralVis
    # Write your package code here.
    import Base.convert
    import Base: +, -, *, /

    using Reexport
    @reexport using SSpline, Colors, Plots

    export  set_specenv, set_extrapolation, 
            # spectral operators
            ×,
            # spectral functions
            luminance_spec,
            reflectance_spec,
            transmittance_spec,
            cmf, cmfmat, normalize_spec, hardlimit_spec,
            reinterpolate,
            # environment types
            SPECENV, SpecEnvironment,
            set_specenv, set_extrapolation, set_limits, set_extrap,
            # spectral types
            LSpec, RSpec, TSpec,
            # special functions
            normalize_spec, adapt_spec, sconv, d_whitepoint, spline_extrap, shift_spec,
            # color matching function tables
            CMF1931, CMF1931_J, CMF1931_JV,
            CMF1964,
            CMF2012_2, CMF2012_10,
            # cone fundamentals
            LMS2006_2, LMS2006_10,
            # multispectral types (CMFs)
            CIE31, CIE31_J, CIE31_JV,
            CIE64,
            CIE12_2, CIE12_10,
            LMS06_2, LMS06_10,
            # spectra
            mars_sky_opportunity, mer_caltarget,
            pancam_L2, pancam_L3, pancam_Lpancam_L5, pancam_L6, pancam_L7,
            # spectral generators
            daylight_generator_table, block_spec, led_spec, led,
            D_series_illuminant, D_series_whitepoint, D_series_luminance, blackbody_illuminant, blackbody_whitepoint,
            # visualizations
            gamut_vis, gamutslice,
            # doodles
            plottest, locustest,
            plotmunsell, spec_color, spec_idx, munsell_specs, munsell_keys, munselldict, 
            multiline, col, colv, sl, border, polar, getslice, sortslice

    include("spectral_types.jl")
    include("multispectral_types.jl")
    include("environment_types.jl")
    include("conversions.jl")
    include("spectral_functions.jl")
    include("cmf_functions.jl")
    include("special_functions.jl")
    include("spectral_generators.jl")
    include("spectral_operators.jl")
    include("../spectra/munsell_index.jl")
    include("readmunsell.jl")

    #tables and other data
    include("cmf_tables.jl")
    include("spectral_generator_tables.jl")

    # Real world spectral data
    specpath="../spectra/"
    # MER Pancam data:
    # Mars Sky spectrum measured by Opportunity
    include(specpath*"spectrum_MarsSkyOpp.jl")
    # Spirit/Opportunity calibration target spectra
    include(specpath*"spectrum_MERCaltarget.jl")
    # Pancam color filter spectra
    include(specpath*"spectrum_Pancam.jl")
    include(specpath*"spectrum_MacBeth.jl")
    # visualizations
    include("visualizations.jl")
    # doodles
    include("locustest.jl")
    include("lmsconversion.jl")
    include("col.jl")
end