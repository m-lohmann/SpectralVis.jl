__precompile__()
module SpectralVis
    # Write your package code here.
    import Base.convert
    import Base: +, -, *, /

using Reexport
    @reexport using SSpline, Colors, Base#, Plots
    # environment types
    export  SPECENV, SpecEnvironment, set_specenv, set_extrap, set_limits, set_colormatch,

    # spectral functions
    luminance_spec, reflectance_spec, transmittance_spec, cmfmat, normalize_spec, hardlimit_spec, reinterpolate, mbspec, mbcolor,

    # cmf and cone fundamental functions
    cmfunc, conefund, colorvisiondeficiency, vybrg,

    # spectral types
    LSpec, RSpec, TSpec,

    # multispectral types (CMFs and associated cone fundamentals)
    CIE31, LMS31, CIE31_J, CIE31_JV, CIE64, LMS64, CIE12_2, LMS06_2, CIE12_10, LMS06_10, VYBRG, CMatch, ConeFund, COpp, Spectrum, Multispectral,

    # special functions
    normalize_spec, normalize_D_series, normalize_blackbody, adapt_spec, sconv, d_whitepoint, shift_spec, shift_cone, deactivate_cone, conefund, convmat,

    # conversions
    chromatic_adaptation, coneresponse, INGLING_TSOU, inglingtsou_opponent, OCS, mlms_ycc,
    
    # spectral operators
    ×, *, +,
    
    # color matching function tables
    CMF1931, CMF1931_J, CMF1931_JV, CMF1964, CMF2012_2, CMF2012_10,

    # cone fundamental tables
    LMS2006_2, LMS2006_10,
    
    # spectra
    mars_sky_opportunity, mer_caltarget, pancam, pancam_L2, pancam_L3, pancam_L4, pancam_L5, pancam_L6, pancam_L7, macbeth, munsell_specs, munsell_spec, munsell_keys,munsell_dict, wratten, wratten_filter, WrattenVis, WrattenIR, Wrattenfilters, mineral_specs, mineral, agfait_specs, agfait, vantablack,
    
    # spectral generator tables
    daylight_generator_table, b_c_series_table, f_series_table, gas_discharge_table, water_constants,

    # spectral generators
    block_spec, led_spec, D_series_generator, D_series_illuminant, normalized_D_series, D_series_whitepoint, blackbody_illuminant, blackbody_whitepoint, D40_illuminant, D50_illuminant, D55_illuminant, D65_illuminant, D75_illuminant, D93_illuminant, illuminant_A, illuminant_B, illuminant_C, F_series_illuminant, gas_discharge_illuminant, sinusoidal_spd,
    
    # matrix R, fundamental metamers, metameric blacks
    tristimulus, matrixA, matrixR, fundamental_metamer, metameric_black, cohen_pair,
    
    # JND/color discrimination ellipse functions
    ellipses, ellipse_parameters, ellipse, ellipse_a, ellipse_b, ellipse_θ, ellipse_center, ellipse_l0, ellipse_luminance, ellipse_g11, ellipse_g12, ellipse_g13, ellipse_g22, ellipse_g23, draw_ellipses,
    
    # ellipse datasets
    PGN_ellipses, WSS_ellipses, FMC_ellipses, WRB_ellipses, DLM_ellipses, B_ellipses, GF_ellipses, AR_ellipses, GW_ellipses,
    
    # visualizations
    gamut_vis, gamutslice,
    
    # doodles
    plottest, locustest, plotmunsell, spec_color, spec_idx, multiline, col, colv, sl, border, polar, getslice, sortslice
    
    include("cmf_tables.jl")
    include("spectral_types.jl")
    include("cmf_functions.jl")
    include("environment_types.jl")
    include("conversions.jl")
    include("spectral_functions.jl")
    include("special_functions.jl")
    include("spectral_generators.jl")
    include("spectral_operators.jl")
    include("matrix_R.jl")
    include("ellipse_functions.jl")

    #tables and other data
    include("spectral_generator_tables.jl")

    const dirpath = joinpath(dirname(pathof(SpectralVis)))
    const datapath = joinpath(dirpath[1:end-3],"data")
    const specpath = joinpath(datapath,"spectra")
    const ellipsepath = joinpath(datapath,"ellipses")

    # MER Pancam data:
    # Mars Sky spectrum measured by Opportunity
    include(joinpath(specpath,"spectrum_MarsSkyOpp.jl"))
    # Spirit/Opportunity calibration target spectra
    include(joinpath(specpath,"spectrum_MERCaltarget.jl"))
    # Pancam color filter spectra
    include(joinpath(specpath,"spectrum_Pancam.jl"))
    include(joinpath(specpath,"spectrum_MacBeth.jl"))
    include(joinpath(specpath,"spectrum_Wratten.jl"))
    # Other spectra and reading functions
    include(joinpath(specpath,"specread_munsell.jl"))
    include(joinpath(specpath,"specread_mineral.jl"))
    include(joinpath(specpath,"specread_agfait.jl"))
    # MacAdam ellipses etc.
    include(joinpath(ellipsepath,"ellipse_datasets.jl"))
    # visualizations
    include("visualizations.jl")
    # doodles
    include("locustest.jl")
    include("lmsconversion.jl")
    include("col.jl")
    @info ("\n\nWelcome to SpectralVis!\n\n")
    @info ("Spectral environmant SPECENV set to default values:\n")
    @info ("λmin                   : $(SPECENV.λmin)")
    @info ("λmax                   : $(SPECENV.λmax)")
    @info ("Δλ                     : $(SPECENV.Δλ)")
    @info ("Color matching function: $(typeof(SPECENV.cmf))")
    @info ("Extrapolation mode     : $(SPECENV.ex)")
end