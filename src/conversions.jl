
"""
`chromatic_adaptation(sourcecolor::Color, sourceWP::Color, destWP::Color,response::Symbol = :bradford)`

Adapt source color according to given source white point and destination white point. Default cone response is `:bradford`.
Default destination white point is `D65`.
"""
function chromatic_adaptation(sourcecolor::Color, sourceWP::Color, destWP::Color,response::Symbol=:bradford)
    MA=coneresponse(response)
    ργβ_S=MA*[sourceWP.x,sourceWP.y,sourceWP.z]
    ργβ_D=MA*[destWP.x,destWP.y,destWP.z]
    cd=MA^-1 *[ργβ_D[1]/ργβ_S[1] 0.0               0.0;
                    0.0               ργβ_D[2]/ργβ_S[2] 0.0;
                    0.0               0.0               ργβ_D[3]/ργβ_S[3]] * MA * [sourcecolor.x, sourcecolor.y, sourcecolor.z]
    # destination color
    Colors.XYZ(cd[1],cd[2],cd[3])
end


"""
`coneresponse(response::Symbol)`

Return cone response matrix according to chromatic adaptation transform `response`.

Available transforms:

`:xyzscaling` Simplest (and worst) method.

`:vonkries`

`:bradford` Linearized Bradfod transform. Diagonal Matrix Transform (DMT)-type vonKries-Ives transform.

`:sharp` Sharp Adaptation Transform. First described by Finlayson et al.

`:fairchild`

`:cat97s` CIECAM97s adaptation transform

`:cat02` Default transform. Developed for the CIECAM02 color appearance model.

`:hpe` Hunt-Pointer-Estevez transform

`:bestof20` by Sabine Süsstrunk: [`Computing Chromatic Adaptation`](https://core.ac.uk/download/pdf/147990632.pdf), PhD thesis, 2005, page 104.

Sharpened linear cone response matrix optimized for white-point independence, gamut coverage,and hue constancy. Delivers better results than `:cat02` in most cases. Adde for experimental purposes.
"""
function coneresponse(response::Symbol = :cat02)
    if response == :xyzscaling
        MA = [1.0 0.0 0.0;
              0.0 1.0 0.0;
              0.0 0.0 1.0]
    elseif response == :vonkries
        MA = [ 0.4002400  0.7076000 -0.0808100;
              -0.2263000  1.1653200  0.0457000;
               0.0000000  0.0000000  0.9182200]
    elseif response == :bradford
        MA = [ 0.8951000  0.2664000 -0.1614000;
              -0.7502000  1.7135000  0.0367000;
               0.0389000 -0.0685000  1.0296000]
    elseif response == :sharp
        MA = [1.2694 -0.0988 -0.1706;
             -0.8364  1.8006  0.03570;
              0.0297 -0.0315  1.0018]
    elseif response == :fairchild
        MA = [0.8562 0.3372 -0.1934;
             -0.8360 1.8327  0.00330;
              0.0357 -0.0469 1.0112]
    elseif response == :cat97s
        MA = [0.8562  0.3372 -0.1934;
             -0.8360  1.8327  0.0033;
              0.0357 -0.0469  1.0112]
    elseif response == :cat02
        MA = [0.7328  0.4296 -0.1624;
             -0.7036  1.6974  0.0061;
              0.0030  0.0136  0.9834]
    elseif response == :hpe
        MA = [0.3897  0.6890 -0.0787;
             -0.2298  1.1834  0.0464;
              0.0     0.0     1.0]
    elseif response == :bestof20
        MA = [1.6351 -0.4071 -0.2280;
             -0.8044  1.7798  0.0246;
              0.0000  0.0152  0.9848]
    else
        DomainError(response, "Cone response matrix does not exist.")
    end
    MA
end


"""
`const INGLING_TSOU`

Ingling and Tsou’s suprathreshold transformation matrix.
Converts l,m,s cone fundamentals to color opponent space (Vλ, r-g, y-b) / (WS(λ), YB(λ), RG(λ))
"""
const INGLING_TSOU=
    [0.600  0.400  0.000;
     0.240  0.105 -0.700;
     1.200 -1.600 0.400]

"""
`opponentcolor(conefund::ConeFund)`

Converts cone fundamentals to color opponent channels using the Ingling-Tsou transformation matrix.

Result: `::Type{WSYRGB}`
"""
function opponentcolor(conefund::ConeFund)
    it = INGLING_TSOU * conefund
    WSYBRG(conefund.λ, it[1], it[2], it[3])
end

"""
`const OCS`

Combination of M_XYZ→YCC from Kotera with M_LMS→XYZ of CIECAM02 
"""
const OCS =
    [0.489  0.134  0.378;
     1.004 -0.790 -0.214;
     0.034 -0.472  0.437]

function mlms_ycc()
    OCS
end

const KOTERA =
    [0.593247  -0.0750709   0.482816;
     0.743587  -0.652887   -0.0907655;
    -0.181412  -0.23549     0.415879]