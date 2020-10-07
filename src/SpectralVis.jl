module SpectralVis
    # Write your package code here.
    import Base: convert
    import Base: +, -, *, /

    using Colors

    export luminance_spec, i_luminance_spec,
            reflectance_spec, i_reflectance_spec,
            transmittance_spec, i_transmittance_spec,
            cmf,
            normalize_spec, block_spec, led_spec, led, ghelp,
            MarsSkyOpportunity, caltarget,
            Pancam_L2,Pancam_L3,Pancam_L4,Pancam_L5,Pancam_L6,Pancam_L7,
            CMF31, CMF64, CMF31_J, CMF31_JV, CMF06_2, CMF06_10


    include("types.jl")
    include("spectral_functions.jl")
    include("multispectral_functions_cmf.jl")
    include("special_functions.jl")
    include("spectralops.jl")

    # Color matching function tables
    include("cmf_tables.jl")

    # Real world spectral data
    # MER Pancam data:
    # Mars Sky spectrum measured by Opportunity
    include("spectrum_MarsSkyOpp.jl")
    # Spirit/Opportunity calibration target spectra
    include("spectrum_MERCaltarget.jl")
    # Pancam color filter spectra
    include("spectrum_Pancam.jl")
end