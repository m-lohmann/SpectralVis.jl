__precompile__()
module SpectralVis
    # Write your package code here.
    import Base.convert
    import Base: +, -, *, /, ∘

using Reexport
    @reexport using SSpline, Colors, Plots
    # environment types
    export  SPECENV, SpecEnvironment, set_specenv, set_extrap, set_limits, set_colormatch

    # spectral functions
    export  luminance_spec, reflectance_spec, transmittance_spec, cmfmat, normalize_spec, hardlimit_spec, reinterpolate, mbspec, mbcolor

    # cmf and cone fundamental functions
    export cmf, conefund

    # spectral types
    export  LSpec, RSpec, TSpec

    # multispectral types (CMFs and associated cone fundamentals)
    export  CIE31, LMS31, CIE31_J, CIE31_JV, CIE64, LMS64, CIE12_2, LMS06_2, CIE12_10, LMS06_10, WSYBRG, CMatch, ConeFund, Spectrum, Multispectral

    # special functions
    export  normalize_spec, normalize_D_series, normalize_blackbody, adapt_spec, sconv, d_whitepoint, shift_spec, shift_colormatch, deactivate_cone, conefund, convmat, opponentcolor

    # conversions
    export chromatic_adaptation, coneresponse, INGLING_TSOU, opponentcolor, OCS, mlms_ycc
    
    # spectral operators
    export ×, *
    
    # color matching function tables
    export  CMF1931, CMF1931_J, CMF1931_JV, CMF1964, CMF2012_2, CMF2012_10

    # cone fundamental tables
    export  LMS2006_2, LMS2006_10
    
    # spectra
    export  mars_sky_opportunity, mer_caltarget, pancam_L2, pancam_L3, pancam_Lpancam_L5, pancam_L6, pancam_L7, macbeth, munsell_specs, munsell_spec, munsell_keys,munsell_dict, wratten, wratten_filter, WrattenVis, WrattenIR, Wrattenfilters, mineral_specs, mineral
    
    # spectral generator tables
    export daylight_generator_table, b_c_series_table, f_series_table, gas_discharge_table, water_constants

    # spectral generators
    export  block_spec, led_spec, D_series_generator, D_series_illuminant, normalized_D_series, D_series_whitepoint, blackbody_illuminant, blackbody_whitepoint, D50_illuminant, D55_illuminant, D65_illuminant, D75_illuminant, illuminant_A, illuminant_B, illuminant_C, F_series_illuminant, gas_discharge_illuminant, sinusoidal_spd
    
    # matrix R, fundamental metamers, metameric blacks
    export  tristimulus, matrix_A, matrix_R, fundamental_metamer, metameric_black
    
    # JND/color discrimination ellipse functions
    export ellipses, ellipse_parameters, ellipse, ellipse_a, ellipse_b, ellipse_θ, ellipse_center, ellipse_l0, ellipse_luminance, ellipse_g11, ellipse_g12, ellipse_g13, ellipse_g22, ellipse_g23, draw_ellipses
    
    # ellipse datasets
    export PGN_ellipses, WSS_ellipses, FMC_ellipses, WRB_ellipses, DLM_ellipses, B_ellipses, GF_ellipses, AR_ellipses, GW_ellipses
    
    # visualizations
    export  gamut_vis, gamutslice
    
    # doodles
    export  plottest, locustest, plotmunsell, spec_color, spec_idx, multiline, col, colv, sl, border, polar, getslice, sortslice
    
    include("cmf_tables.jl")
    include("spectral_types.jl")
    include("cmf_functions.jl")
    include("environment_types.jl")
    include("conversions.jl")
    include("spectral_functions.jl")
    include("special_functions.jl")
    include("spectral_generators.jl")
    include("spectral_operators.jl")
    include("readmunsell.jl")
    include("mineral_read.jl")
    include("matrix_R.jl")
    include("ellipse_functions.jl")

    #tables and other data
    include("spectral_generator_tables.jl")

    # Real world spectral data
    const datapath="../data/"
    # MER Pancam data:
    # Mars Sky spectrum measured by Opportunity
    include(datapath*"/spectra/spectrum_MarsSkyOpp.jl")
    # Spirit/Opportunity calibration target spectra
    include(datapath*"spectra/spectrum_MERCaltarget.jl")
    # Pancam color filter spectra
    include(datapath*"/spectra/spectrum_Pancam.jl")
    include(datapath*"/spectra/spectrum_MacBeth.jl")
    include(datapath*"/spectra/spectrum_Wratten.jl")
    # MacAdam ellipses etc.
    include(datapath*"/ellipses/ellipse_datasets.jl")
    # visualizations
    include("visualizations.jl")
    # doodles
    include("locustest.jl")
    include("lmsconversion.jl")
    include("col.jl")
end