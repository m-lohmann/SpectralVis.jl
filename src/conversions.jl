
"""
    chromatic_adaptation(sourcecolor::Color, sourceWP::Color, destWP::Color = D_series_whitepoint(6504), response::Symbol = :cat02)

Adapt source color according to given source white point and destination white point. 
Default destination white point is `D65`. Default cone response is `:cat02`.

# Examples
```jldoctest
julia> chromatic_adaptation(XYZ(0.1, 0.7, 0.05), D_series_whitepoint(4000))
XYZ{Float64}(0.04957926027638688,0.7081276413719826,0.09614857166385628)

julia> chromatic_adaptation(XYZ(0.1, 0.7, 0.05), D_series_whitepoint(4000), D_series_whitepoint(7500), :bradford)
XYZ{Float64}(0.0513224358507469,0.7251796437072336,0.06113763051342081)
```
"""
function chromatic_adaptation(sourcecolor::Color, sourceWP::Color, destWP::Color = D_series_whitepoint(6504), response::Symbol = :cat02)
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
    coneresponse(response::Symbol)

Return cone response matrix according to chromatic adaptation transform `response`.

Available transforms:

* `:xyzscaling` Simplest (and worst) method.
* `:vonkries`
* `:bradford` Linearized Bradfod transform. Diagonal Matrix Transform (DMT)-type vonKries-Ives transform.
* `:sharp` Sharp Adaptation Transform. First described by Finlayson et al.
* `:fairchild`
* `:cat97s` CIECAM97s adaptation transform
* `:cat02` Default transform. Developed for the CIECAM02 color appearance model.
* `:hpe` Hunt-Pointer-Estevez transform
* `:bestof20` by *Sabine Süsstrunk*: [Computing Chromatic Adaptation](https://core.ac.uk/download/pdf/147990632.pdf), PhD thesis, 2005, page 104. Sharpened linear cone response matrix optimized for white-point independence, gamut coverage, and hue constancy. Delivers better results than `:cat02` in most cases. Added for experimental purposes.

# Examples

```jldoctest
julia> coneresponse(:xyzscaling)
3×3 Matrix{Float64}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0

julia> coneresponse(:bradford)
3×3 Matrix{Float64}:
  0.8951   0.2664  -0.1614
 -0.7502   1.7135   0.0367
  0.0389  -0.0685   1.0296

julia> coneresponse(:bestof20)
3×3 Matrix{Float64}:
  1.6351  -0.4071  -0.228
 -0.8044   1.7798   0.0246
  0.0      0.0152   0.9848
```
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
        throw(DomainError(response, "Cone response matrix does not exist."))
    end
    MA
end


"""
    const INGLING_TSOU

Ingling and Tsou’s suprathreshold transformation matrix.
Converts l,m,s cone fundamentals to color opponent space (Vλ, r-g, y-b) / (WS(λ), YB(λ), RG(λ))
"""
const INGLING_TSOU=
    [0.600  0.400  0.000;
     0.240  0.105 -0.700;
     1.200 -1.600 0.400]

"""
    inglingtsou_opponent(conefund::ConeFund)

Converts cone fundamentals to color opponent channels using the Ingling-Tsou transformation matrix.

Signal flow of the two-stage model of human color vision:

        L              M                    S   photoreceptor
        ┃              ┃                    ┃      stage
        ┃              ┃     ┏━━━━━━━━━━━━━━┫      (CMFs)
        ┃  ┏━━━━━━━━━━━╋━━━━━┃━━━━━━━━━┓    ┃
        ┃  ┃           ┃     ┃         ┃    ┃
     ┏━━┻━━┃━━━━━┳━━━━━┃━━━━━┃━━━━┓    ┃    ┃
     ┃     ┃     ┃     ┃     ┃    ┃    ┃    ┃
     ┃     ┃     ┃     ┃     ┃    ┃    ┃    ┃
     ┃     ┃     ┃     ┃     ┃    ┃    ┃    ┃       
    0.6   0.4  0.24  0.105  0.7  1.2  1.6  0.4   factors
     ║     ║     ║     ║     ║    ║    ║    ║
     ╚══╦══╝     ╚═════╬═════╝    ╚════╬════╝
        ║              ║               ║
        ║              ║               ║
     L  +  M     L  +  M  -  S    L  - M +  S     opponent
        ║              ║               ║           stage
        Vλ            y-b             r-g

    lightness     yellow-blue       red-green

# Example

```jldoctest
julia> inglingtsou_opponent(conefund(SPECENV.cmf))
VYBRG(Real[390.0, 391.0, 392.0, 393.0, 394.0, 395.0, 396.0, 397.0, 398.0, 399.0  …  821.0, 822.0, 823.0, 824.0, 825.0, 826.0, 827.0, 828.0, 829.0, 830.0], Real[0.0003878623982, 0.0004737047352, 0.000577319691, 0.0007018085474, 0.0008506078488000001, 0.0010274557607999999, 0.001236329446, 0.0014813467259999998, 0.001766625772, 0.0020960976039999996  …  9.411752703999999e-7, 8.876810727999999e-7, 8.372313131999999e-7, 7.896833636e-7, 7.448974792000001e-7, 7.027372568e-7, 6.630699992e-7, 6.257670254799999e-7, 5.9070389244e-7, 5.5776058904e-7], Real[-0.004164411112444999, -0.00504460427438, -0.006110193693075, -0.007397180969524999, -0.00894723637031, -0.010808111330739998, -0.013033902761799998, -0.01568509182405, -0.018828265622099997, -0.02253541766325  …  3.6881237642999995e-7, 3.4782318591e-7, 3.2803082274e-7, 3.0937903046999996e-7, 2.9181270796499996e-7, 2.7527808831e-7, 2.5972288066499997e-7, 2.450963909835e-7, 2.31349607448e-7, 2.18435275848e-7], Real[0.0023730382284000004, 0.0028717459496, 0.003474333342, 0.00420068739, 0.0050737833632, 0.0061199115808, 0.007368828876, 0.008853794675999999, 0.010611444512, 0.012681445520000003  …  1.5481949744e-6, 1.4590315327999997e-6, 1.3750428792e-6, 1.2959784376e-6, 1.2215934872e-6, 1.1516498848e-6, 1.0859166232e-6, 1.02417030368e-6, 9.661954418399999e-7, 9.117847518400001e-7])
```
"""
function inglingtsou_opponent(conefund::ConeFund)
    it = INGLING_TSOU * [conefund.l, conefund.m, conefund.s]
    VYBRG(conefund.λ, it[1], it[2], it[3])
end

#=
0 	1 	2 	3 	4 	5 	6 	7 	8 	9 	A 	B 	C 	D 	E 	F
U+250x 	─ 	━ 	│ 	┃ 	┄ 	┅ 	┆ 	┇ 	┈ 	┉ 	┊ 	┋ 	┌ 	┍ 	┎ 	┏
U+251x 	┐ 	┑ 	┒ 	┓ 	└ 	┕ 	┖ 	┗ 	┘ 	┙ 	┚ 	┛ 	├ 	┝ 	┞ 	┟
U+252x 	┠ 	┡ 	┢ 	┣ 	┤ 	┥ 	┦ 	┧ 	┨ 	┩ 	┪ 	┫ 	┬ 	┭ 	┮ 	┯
U+253x 	┰ 	┱ 	┲ 	┳ 	┴ 	┵ 	┶ 	┷ 	┸ 	┹ 	┺ 	┻ 	┼ 	┽ 	┾ 	┿
U+254x 	╀ 	╁ 	╂ 	╃ 	╄ 	╅ 	╆ 	╇ 	╈ 	╉ 	╊ 	╋ 	╌ 	╍ 	╎ 	╏
U+255x 	═ 	║ 	╒ 	╓ 	╔ 	╕ 	╖ 	╗ 	╘ 	╙ 	╚ 	╛ 	╜ 	╝ 	╞ 	╟
U+256x 	╠ 	╡ 	╢ 	╣ 	╤ 	╥ 	╦ 	╧ 	╨ 	╩ 	╪ 	╫ 	╬ 	╭ 	╮ 	╯
U+257x 	╰ 	╱ 	╲ 	╳ 	╴ 	╵ 	╶ 	╷ 	╸ 	╹ 	╺ 	╻ 	╼ 	╽ 	╾ 	╿ 
=#




"""
    const OCS

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

const IPT =
    [0.4000  0.4000  0.2000;
     4.4550 -4.8510  0.3960;
     0.8056  0.3572 -1.1628]

const IPTinv =
    [1.8501 -1.1383  0.2385;
     0.3668  0.6439 -0.0107;
     0.0000  0.0000  1.0889]


function IPTforward(cfund::ConeFund)
    cfund.l ≥ 0 ? (Lp = cfund.l^0.43) :
    cfund.l < 0 ? (Lp = -(-cfund.l)^0.43) :
    cfund.m ≥ 0 ? (Mp = cfund.m^0.43) :
    cfund.m < 0 ? (Mp = -(-cfund.m)^0.43) :
    cfund.s ≥ 0 ? (Sp = cfund.s^0.43) :
    cfund.s < 0 ? (Sp = -(-cfund.s)^0.43) : nothing

    IPT * [Lp Mp Sp]
end

function IPTinverse(iptcol)
    lmsp = IPTinv * iptcol
    lmsp.l ≥ 0 ? l = lmsp.l^2.3256 :
    lmsp.l < 0 ? l = -(-lmsp.l)^2.3256 :
    lmsp.M ≥ 0 ? m = lmsp.m^2.3256 :
    lmsp.m < 0 ? m = -(-lmsp.m)^2.3256 :
    lmsp.s ≥ 0 ? s = lmsp.s^2.3256 :
    lmsp.s < 0 ? s = -(-lmsp.m)^2.3256 : nothing

    xyz = inv(IPT) * [l m s]
    Colors.XYZ(xyz[1], xyz[2], xyz[3])
end