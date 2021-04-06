function mer_caltarget(color::Symbol)
   color == :white  ? RSpec(MER_caltarget_white[:,1],MER_caltarget_white[:,2]) :
   color == :grey   ? RSpec(MER_caltarget_grey[:,1],MER_caltarget_grey[:,2]) :
   color == :black  ? RSpec(MER_caltarget_black[:,1],MER_caltarget_black[:,2]) :
   color == :yellow ? RSpec(MER_caltarget_yellow[:,1],MER_caltarget_yellow[:,2]) :
   color == :red    ? RSpec(MER_caltarget_red[:,1],MER_caltarget_red[:,2]) :
   color == :green  ? RSpec(MER_caltarget_green[:,1],MER_caltarget_green[:,2]) :
   color == :blue   ? RSpec(MER_caltarget_blue[:,1],MER_caltarget_blue[:,2]) : error("Nonexistent MER calibration target color.")
end

const MER_caltarget_yellow=
   [400.0	      0.052336;
    430.841121	   0.059813;
    478.504673	   0.069782;
    491.121495	   0.079751;
    502.336449	   0.08972;
    514.953271	   0.114642;
    524.766355	   0.142056;
    530.373832	   0.161994;
    535.981308	   0.186916;
    538.006231	   0.195777;
    543.925234	   0.231499;
    550.0	      0.265282;
    556.074766	   0.301004;
    561.993769	   0.332572;
    568.068536	   0.358048;
    573.987539	   0.373555;
    580.062305	   0.381585;
    585.981308	   0.387124;
    592.056075	   0.386847;
    597.975078	   0.383801;
    604.049844	   0.377155;
    609.968847	   0.374663;
    616.043614	   0.370786;
    621.962617	   0.368294;
    628.037383	   0.365247;
    633.956386	   0.364694;
    640.031153	   0.361648;
    645.950156	   0.360263;
    652.024922	   0.363863;
    657.943925	   0.364694;
    664.018692	   0.364971;
    669.937695	   0.371616;
    676.012461	   0.377432;
    693.925234	   0.3982;
    700.0	      0.404292;
    706.074766	   0.415092;
    711.993769	   0.425337;
    718.068536	   0.433091;
    723.987539	   0.440568;
    730.062305	   0.449706;
    735.981308	   0.459121;
    742.056075	   0.462167;
    747.975078	   0.46549;
    754.049844	   0.467982;
    759.968847	   0.468259;
    766.043614	   0.462721;
    771.962617	   0.459121;
    778.037383	   0.452198;
    783.956386	   0.448044;
    807.943925	   0.414815;
    814.018692	   0.40983;
    819.937695	   0.400969;
    826.012461	   0.394323;
    831.931464	   0.388785;
    838.006231	   0.381862;
    843.925234	   0.376324;
    850.0	      0.37134;
    856.074766	   0.366078;
    861.993769	   0.362201;
    868.068536	   0.358602;
    873.987539	   0.358602;
    880.062305	   0.355832;
    885.981308	   0.352233;
    892.056075	   0.351956;
    897.975078	   0.351679;
    904.049844	   0.349463;
    909.968847	   0.350294;
    916.043614	   0.351679;
    921.962617	   0.352786;
    928.037383	   0.352786;
    933.956386	   0.356386;
    940.031153	   0.356663;
    945.950156	   0.359709;
    952.024922	   0.361648;
    957.943925	   0.363863;
    964.018692	   0.366632;
    976.012461	   0.372447;
    981.931464	   0.376047;
    988.006231	   0.377985;
    993.925234	   0.381862;
   1000.0	      0.38657;
   1012.616822	   0.393769;
   1021.028037	   0.398754;
   1047.663551	   0.42866]

const MER_caltarget_red=
   [400.0         0.047352;
    433.64486	   0.049844;
    444.859813	   0.049844;
    450.46729	   0.052336;
    457.476636	   0.049844;
    463.084112	   0.054829;
    465.88785	   0.054829;
    468.691589	   0.052336;
    530.373832	   0.054829;
    544.392523	   0.057321;
    551.401869	   0.062305;
    557.009346	   0.06729;
    561.214953	   0.069782;
    566.82243	   0.079751;
    573.831776	   0.097196;
    585.046729	   0.129595;
    597.663551	   0.161994;
    604.672897	   0.179439;
    610.280374	   0.181931;
    615.88785	   0.184424;
    618.691589	   0.186916;
    625.700935	   0.189408;
    629.906542	   0.1919;
    634.11215	   0.189408;
    642.523364	   0.194393;
    646.728972	   0.199377;
    657.943925	   0.201869;
    667.757009	   0.206854;
    678.971963	   0.219315;
    683.17757	   0.224299;
    685.981308	   0.224299;
    691.588785	   0.231776;
    704.205607	   0.249221;
    708.411215	   0.256698;
    712.616822	   0.261682;
    719.626168	   0.266667;
    725.233645	   0.276636;
    737.850467	   0.279128;
    746.261682	   0.276636;
    757.476636	   0.264174;
    760.280374	   0.264174;
    764.485981	   0.261682;
    772.897196	   0.249221;
    778.504673	   0.241745;
    781.308411	   0.241745;
    792.523364	   0.226791;
    803.738318	   0.216822;
    814.953271	   0.206854;
    820.560748	   0.201869;
    828.971963	   0.199377;
    841.588785	   0.194393;
    862.616822	   0.1919;
    885.046729	   0.194393;
    890.654206	   0.199377;
    894.859813	   0.199377;
    899.065421	   0.196885;
    908.878505	   0.206854;
    913.084112	   0.206854;
    920.093458	   0.216822;
    924.299065	   0.216822;
    938.317757	   0.234268;
    943.925234	   0.239252;
    946.728972	   0.249221;
    955.140187	   0.256698;
    959.345794	   0.269159;
    970.560748	   0.289097;
    977.570093	   0.30405;
    985.981308	   0.321495;
    992.990654	   0.343925;
    998.598131	   0.353894;
   1001.401869	   0.358879;
   1005.607477	   0.37134;
   1014.018692	   0.383801;
   1018.224299	   0.391277;
   1028.037383	   0.413707;
   1033.64486	   0.42866;
   1037.850467	   0.436137;
   1047.663551	   0.45109]

const MER_caltarget_green=
   [400.0	      0.099688;
    406.074766	   0.102735;
    411.993769	   0.096642;
    418.068536	   0.089997;
    423.987539	   0.079751;
    430.062305	   0.072274;
    442.056075	   0.06369;
    459.968847	   0.063967;
    466.043614	   0.064244;
    471.962617	   0.065351;
    483.956386	   0.072828;
    490.031153	   0.076982;
    495.950156	   0.081689;
    502.024922	   0.088335;
    507.943925	   0.099135;
    514.018692	   0.118795;
    519.937695	   0.147594;
    526.012461	   0.166424;
    531.931464	   0.17224;
    538.006231	   0.168086;
    543.925234	   0.156179;
    550.0	      0.140948;
    556.074766	   0.12378;
    561.993769	   0.10855;
    568.068536	   0.094704;
    573.987539	   0.088889;
    580.062305	   0.083904;
    585.981308	   0.081689;
    592.056075	   0.081412;
    597.975078	   0.080582;
    604.049844	   0.081689;
    609.968847	   0.081966;
    616.043614	   0.084181;
    621.962617	   0.088889;
    628.037383	   0.093319;
    633.956386	   0.098858;
    640.031153	   0.105781;
    645.950156	   0.111596;
    652.024922	   0.119349;
    669.937695	   0.142333;
    676.012461	   0.15064;
    681.931464	   0.157286;
    688.006231	   0.16504;
    693.925234	   0.174178;
    700.0	      0.181101;
    706.074766	   0.190239;
    711.993769	   0.204638;
    718.068536	   0.220422;
    723.987539	   0.239806;
    730.062305	   0.255867;
    735.981308	   0.28965;
    742.056075	   0.306819;
    747.975078	   0.332572;
    754.049844	   0.358048;
    759.968847	   0.379093;
    766.043614	   0.396816;
    771.962617	   0.409553;
    778.037383	   0.422291;
    783.956386	   0.426445;
    790.031153	   0.432537;
    795.950156	   0.435583;
    802.024922	   0.436414;
    807.943925	   0.43946;
    814.018692	   0.441398;
    819.937695	   0.442229;
    826.012461	   0.442783;
    831.931464	   0.44306;
    838.006231	   0.444444;
    843.925234	   0.445552;
    850.0	      0.445829;
    856.074766	   0.445829;
    861.993769	   0.445829;
    868.068536	   0.446106;
    873.987539	   0.448321;
    880.062305	   0.448875;
    885.981308	   0.448875;
    892.056075	   0.448321;
    897.975078	   0.446383;
    904.049844	   0.446106;
    909.968847	   0.448321;
    916.043614	   0.449152;
    921.962617	   0.45109;
    928.037383	   0.454136;
    933.956386	   0.453306;
    940.031153	   0.452198;
    945.950156	   0.454136;
    952.024922	   0.454413;
    957.943925	   0.454967;
    964.018692	   0.454967;
    969.937695	   0.451367;
    976.012461	   0.45469;
    981.931464	   0.453859;
    988.006231	   0.453859;
    993.925234	   0.452752;
   1000.0	      0.45469;
   1006.074766	   0.450813;
   1018.068536	   0.45109;
   1023.987539	   0.450537;
   1030.062305	   0.451644;
   1035.981308	   0.452475;
   1042.056075	   0.452752;
   1047.663551	   0.453583]

const MER_caltarget_blue=
   [400.0	      0.173624;
    406.074766	   0.18027;
    411.993769	   0.206854;
    418.068536	   0.222084;
    423.987539	   0.234545;
    430.062305	   0.246452;
    435.981308	   0.253375;
    442.056075	   0.253375;
    447.975078	   0.253375;
    454.049844	   0.252821;
    459.968847	   0.25116;
    466.043614	   0.241468;
    471.962617	   0.223745;
    478.037383	   0.209069;
    483.956386	   0.227345;
    490.031153	   0.233714;
    495.950156	   0.218761;
    502.024922	   0.178055;
    507.943925	   0.138456;
    519.937695	   0.080028;
    526.012461	   0.067013;
    531.931464	   0.062028;
    550.0	      0.050675;
    556.074766	   0.050398;
    561.993769	   0.049844;
    568.068536	   0.049844;
    573.987539	   0.049844;
    580.062305	   0.049844;
    585.981308	   0.049844;
    592.056075	   0.049567;
    597.975078	   0.049567;
    604.049844	   0.049567;
    609.968847	   0.049567;
    616.043614	   0.049567;
    621.962617	   0.050952;
    628.037383	   0.052613;
    633.956386	   0.055659;
    640.031153	   0.061198;
    645.950156	   0.070059;
    652.024922	   0.085566;
    657.943925	   0.10855;
    676.012461	   0.271097;
    681.931464	   0.342818;
    688.006231	   0.449983;
    693.925234	   0.539979;
    700.0	      0.594808;
    706.074766	   0.63856;
    711.993769	   0.667636;
    718.068536	   0.684804;
    723.987539	   0.695327;
    730.062305	   0.698927;
    735.981308	   0.706127;
    742.056075	   0.706957;
    747.975078	   0.711665;
    754.049844	   0.716096;
    759.968847	   0.716649;
    766.043614	   0.716649;
    771.962617	   0.716096;
    778.037383	   0.71748;
    783.956386	   0.718865;
    790.031153	   0.719142;
    795.950156	   0.717757;
    802.024922	   0.716926;
    807.943925	   0.716649;
    814.018692	   0.716096;
    819.937695	   0.717757;
    826.012461	   0.716372;
    831.931464	   0.716372;
    838.006231	   0.714988;
    843.925234	   0.707511;
    850.0	      0.706957;
    856.074766	   0.704465;
    861.993769	   0.703911;
    868.068536	   0.699481;
    873.987539	   0.695604;
    880.062305	   0.694496;
    885.981308	   0.689235;
    892.056075	   0.675666;
    897.975078	   0.652129;
    904.049844	   0.639668;
    909.968847	   0.656282;
    916.043614	   0.671236;
    921.962617	   0.674005;
    928.037383	   0.672343;
    933.956386	   0.665697;
    940.031153	   0.659882;
    945.950156	   0.653236;
    952.024922	   0.642991;
    957.943925	   0.63136;
    964.018692	   0.620838;
    969.937695	   0.606715;
    976.012461	   0.58567;
    981.931464	   0.570717;
    988.006231	   0.554379;
    993.925234	   0.530564;
   1000.0	      0.510903;
   1006.074766	   0.484874;
   1018.068536	   0.433645;
   1035.981308	   0.36857;
   1042.056075	   0.34974;
   1047.663551	   0.331464]

const MER_caltarget_white=
   [400.0	      0.272222;
    402.790698	   0.311111;
    408.372093	   0.35;
    412.55814	   0.386728;
    416.744186	   0.414815;
    419.534884	   0.425617;
    425.116279	   0.43642;
    433.488372	   0.458025;
    448.837209	   0.483951;
    461.395349	   0.507716;
    479.534884	   0.531481;
    497.674419	   0.550926;
    514.418605	   0.557407;
    521.395349	   0.563889;
    531.162791	   0.566049;
    549.302326	   0.574691;
    564.651163	   0.574691;
    578.604651	   0.576852;
    589.767442	   0.574691;
    593.953488	   0.572531;
    598.139535	   0.576852;
    619.069767	   0.572531;
    631.627907	   0.57037;
    640.0	      0.57037;
    648.372093	   0.566049;
    667.906977	   0.563889;
    681.860465	   0.559568;
    697.209302	   0.559568;
    709.767442	   0.555247;
    720.930233	   0.553086;
    730.697674	   0.550926;
    734.883721	   0.550926;
    743.255814	   0.548765;
    762.790698	   0.544444;
    771.162791	   0.542284;
    776.744186	   0.542284;
    785.116279	   0.537963;
    790.697674	   0.540123;
    794.883721	   0.540123;
    811.627907	   0.533642;
    828.372093	   0.531481;
    840.930233	   0.529321;
    850.697674	   0.52284;
    884.186047	   0.518519;
    891.162791	   0.514198;
    899.534884	   0.512037;
    910.697674	   0.512037;
    919.069767	   0.514198;
    935.813953	   0.512037;
    949.767442	   0.509877;
    955.348837	   0.505556;
    967.906977	   0.505556;
    984.651163	   0.501235;
   1000.0	      0.496914;
   1012.55814	   0.494753;
   1020.930233	   0.490432;
   1030.697674	   0.492593;
   1047.44186	   0.490432]

const MER_caltarget_grey=
   [400.0         0.239815;
    404.186047	   0.259259;
    411.162791	   0.295988;
    416.744186	   0.315432;
    433.488372	   0.337037;
    453.023256	   0.356481;
    469.767442	   0.375926;
    483.72093	   0.375926;
    506.046512	   0.384568;
    539.534884	   0.384568;
    563.255814	   0.382407;
    584.186047	   0.378086;
    598.139535	   0.375926;
    617.674419	   0.367284;
    630.232558	   0.365123;
    644.186047	   0.365123;
    651.162791	   0.360802;
    672.093023	   0.354321;
    686.046512	   0.35;
    702.790698	   0.345679;
    726.511628	   0.337037;
    740.465116	   0.337037;
    747.44186	   0.332716;
    760.0         0.328395;
    780.930233	   0.326235;
    800.465116	   0.319753;
    814.418605	   0.319753;
    836.744186	   0.313272;
    856.27907	   0.30679;
    868.837209	   0.30463;
    892.55814	   0.300309;
    926.046512	   0.289506;
    946.976744	   0.285185;
    969.302326	   0.280864;
    979.069767	   0.280864;
   1000.0         0.276543;
   1012.55814	   0.270062;
   1022.325581	   0.270062;
   1033.488372	   0.267901;
   1048.837209	   0.267901]

const MER_caltarget_black=
   [400.0     	   0.168519;
    408.372093	   0.17284;
    430.697674	   0.183642;
    439.069767	   0.187963;
    461.395349	   0.190123;
    469.767442	   0.190123;
    493.488372	   0.190123;
    501.860465	   0.187963;
    522.790698	   0.185802;
    533.953488	   0.183642;
    553.488372	   0.181481;
    564.651163	   0.181481;
    584.186047	   0.17716;
    595.348837	   0.17716;
    613.488372	   0.17284;
    626.046512	   0.170679;
    642.790698	   0.166358;
    672.093023	   0.162037;
    701.395349	   0.155556;
    730.697674	   0.151235;
    760.0         0.151235;
    790.697674	   0.144753;
    821.395349	   0.142593;
    829.767442	   0.138272;
    849.302326	   0.138272;
    877.209302	   0.138272;
    888.372093	   0.133951;
    905.116279	   0.133951;
    935.813953	   0.13179;
    966.511628	   0.13179;
    995.813953	   0.127469;
   1025.116279	   0.120988;
   1034.883721	   0.127469;
   1048.837209	   0.12963]
