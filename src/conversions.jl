function convert(g::CMatch,mf::ConeFund)
    xyz,ret = cmfmat(mf)*[mf.l,mf.m,mf.s]
    ret!=g ? error("Can’t convert $mf to $g") : nothing
    ret(mf.λ, xyz[1],xyz[2],xyz[3])
end

function cmfmat(g)
    if typeof(g)==LMS06_2
        return [1.94735469 -1.41445123 0.36476327;
                0.68990272  0.34832189 0.00000000;
                0.00000000  0.00000000 1.93485343],CIE12_2
    elseif typeof(g)==LMS06_10
        return [1.93986443 -1.34664359 0.43044935;
                0.69283932  0.34967567 0.00000000;
                0.00000000  0.00000000 2.14687945],CIE12_10
    else
    end
end