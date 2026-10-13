-- Generated Watkins Glen visual installer: watkins_glen_scenery_001.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_scenery_001"
local KIND = "scenery"
local SOURCE_HASH = "9e2998294d767038540216a8bc827537de4439d05708142ef7752b3988abf714"
local GEOMETRIES = {
    {name="G000_tree16_115_0",center=Vector3.new(1149.428455,46.718178,3064.936367),opacity=1.0,blend=true,texture="tree16"},
    {name="G001_tree07_116_0",center=Vector3.new(887.004431,44.642859,3143.005152),opacity=1.0,blend=true,texture="tree07"},
    {name="G002_tree_group_ltd_117_0",center=Vector3.new(-4.673621,130.460875,-1153.85993),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G003_tree_group_ltd_117_1",center=Vector3.new(-22.680856,98.214303,-1158.933051),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G004_tree02_118_0",center=Vector3.new(-61.284247,134.282017,-1290.88107),opacity=1.0,blend=true,texture="tree04"},
    {name="G005_tree18_119_0",center=Vector3.new(-34.02691,127.491552,-956.498707),opacity=1.0,blend=true,texture="tree18"},
    {name="G006_house_45_120_0",center=Vector3.new(-133.303894,106.593462,-187.809399),opacity=1.0,blend=false,texture="build_45"},
    {name="G007_pyramid_121_0",center=Vector3.new(-111.571727,113.850158,-83.934675),opacity=1.0,blend=true,texture="pyramid"},
    {name="G008_out_hill01_122_0",center=Vector3.new(645.254244,-26.004712,3487.565489),opacity=1.0,blend=true,texture="hill02"},
    {name="G009_grand_loop1_123_0",center=Vector3.new(-1325.678935,132.217429,-1784.97402),opacity=1.0,blend=true,texture="frst_gray"},
    {name="G010_grand_loop2_124_0",center=Vector3.new(-883.517159,132.217429,-1832.069397),opacity=1.0,blend=true,texture="frst_gray"},
    {name="G011_grand_geen04_125_0",center=Vector3.new(-13.17739,107.217429,-21.578255),opacity=1.0,blend=true,texture="frst_green02"},
    {name="G012_big_pole01_126_0",center=Vector3.new(-1144.638035,125.757071,-2893.105766),opacity=1.0,blend=true,texture="fen_d"},
    {name="G013_tree17_127_0",center=Vector3.new(-1341.855516,144.009588,-2751.641195),opacity=1.0,blend=true,texture="tree17"},
    {name="G014_tree16_128_0",center=Vector3.new(-1252.133307,139.575321,-2906.45605),opacity=1.0,blend=true,texture="tree16"},
    {name="G015_tree18_129_0",center=Vector3.new(-553.349212,128.562978,-3022.491663),opacity=1.0,blend=true,texture="tree18"},
    {name="G016_tree16_130_0",center=Vector3.new(-230.271643,122.432467,-2105.571234),opacity=1.0,blend=true,texture="tree16"},
    {name="G017_tree_group03_sh_131_0",center=Vector3.new(80.697734,114.389447,-1991.225466),opacity=1.0,blend=true,texture="trees_group3c"},
    {name="G018_tree_group03_sh_131_1",center=Vector3.new(63.1771,82.142875,-1982.387085),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G019_tree_group3_132_0",center=Vector3.new(-1428.716315,175.103733,510.320746),opacity=1.0,blend=true,texture="trees_group3c"},
    {name="G020_tree_group3_132_1",center=Vector3.new(-1413.197884,142.857161,513.434116),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G021_tree_group1_133_0",center=Vector3.new(-1573.218212,185.818018,-2519.186497),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G022_tree_group1_133_1",center=Vector3.new(-1557.14532,153.571446,-2513.566827),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G023_tree02_134_0",center=Vector3.new(-1543.598175,180.710588,-2369.515384),opacity=1.0,blend=true,texture="tree04"},
    {name="G024_tree_group2_135_0",center=Vector3.new(-920.215252,152.103737,-1301.026889),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G025_tree_group2_135_1",center=Vector3.new(-927.315958,119.857165,-1316.490935),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G026_commerce01_136_0",center=Vector3.new(504.251161,103.268233,-70.607897),opacity=1.0,blend=true,texture="commerce01"},
    {name="G027_mark_group01_137_0",center=Vector3.new(-1244.285728,123.008893,-1045.144517),opacity=1.0,blend=true,texture="b_markers"},
    {name="G028_tree_group1_138_0",center=Vector3.new(211.706853,122.246592,-1730.071676),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G029_tree_group1_138_1",center=Vector3.new(218.433887,90.00002,-1745.713427),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G030_commerce02_139_0",center=Vector3.new(-1184.05814,121.342625,-2432.283119),opacity=1.0,blend=true,texture="b_markers"},
    {name="G031_commerce03_140_0",center=Vector3.new(82.022024,99.654937,-334.331159),opacity=1.0,blend=true,texture="b_markers"},
    {name="G032_markerg02_141_0",center=Vector3.new(1145.464135,43.340231,2438.041613),opacity=1.0,blend=true,texture="b_markers"},
    {name="G033_markerg03_142_0",center=Vector3.new(-36.870303,101.061265,-400.084519),opacity=1.0,blend=true,texture="b_markers"},
    {name="G034_house_32_143_0",center=Vector3.new(-269.788004,93.222628,1453.864189),opacity=1.0,blend=true,texture="house_32"},
    {name="G035_tower03_144_0",center=Vector3.new(1285.748727,52.209178,3120.601981),opacity=1.0,blend=true,texture="tower03"},
    {name="G036_tree_group03_sh_145_0",center=Vector3.new(230.218996,130.460875,-648.819812),opacity=1.0,blend=true,texture="trees_group3c"},
    {name="G037_tree_group03_sh_145_1",center=Vector3.new(212.466896,98.214303,-657.184783),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G038_tree_group04sh_146_0",center=Vector3.new(182.364529,129.43047,-363.707701),opacity=1.0,blend=true,texture="trees_group4c"},
    {name="G039_tree_group04sh_146_1",center=Vector3.new(163.2385,97.329914,-352.696695),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G040_tree_group_ltd_147_0",center=Vector3.new(1417.808169,127.158318,1372.640231),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G041_tree_group_ltd_147_1",center=Vector3.new(1399.197789,95.134061,1368.404847),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G042_tree_group01_sh_148_0",center=Vector3.new(1361.672098,103.772136,1950.347235),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G043_tree_group01_sh_148_1",center=Vector3.new(1343.271375,72.116462,1946.02196),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G044_tree_group_dtl_149_0",center=Vector3.new(1356.694341,79.13301,2353.682111),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G045_tree_group_dtl_149_1",center=Vector3.new(1337.655323,47.678629,2341.226919),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G046_grand_new_150_0",center=Vector3.new(855.12506,27.215781,3058.009168),opacity=1.0,blend=true,texture="frst_new"},
    {name="G047_pole_group01_151_0",center=Vector3.new(1203.149833,99.529621,1621.823269),opacity=1.0,blend=true,texture="fen_d"},
    {name="G048_pole01_152_0",center=Vector3.new(1094.981998,103.571429,298.55179),opacity=1.0,blend=true,texture="fen_d"},
    {name="G049_pole01_153_0",center=Vector3.new(379.606897,17.857143,2827.57298),opacity=1.0,blend=true,texture="fen_d"},
    {name="G050_pole01_154_0",center=Vector3.new(515.206496,17.857143,2849.129944),opacity=1.0,blend=true,texture="fen_d"},
    {name="G051_pole01_155_0",center=Vector3.new(-677.219894,109.999997,1332.847075),opacity=1.0,blend=true,texture="fen_d"},
    {name="G052_pole01_156_0",center=Vector3.new(-729.14204,109.999997,1282.849505),opacity=1.0,blend=true,texture="fen_d"},
    {name="G053_pole01_157_0",center=Vector3.new(-975.857068,118.928569,-2628.202374),opacity=1.0,blend=true,texture="fen_d"},
    {name="G054_pole01_158_0",center=Vector3.new(-577.172947,110.714286,-2471.558367),opacity=1.0,blend=true,texture="fen_d"},
    {name="G055_pole01_159_0",center=Vector3.new(-419.896793,128.571429,-1770.884801),opacity=1.0,blend=true,texture="fen_d"},
    {name="G056_pole01_160_0",center=Vector3.new(-270.502921,128.571429,-1056.927041),opacity=1.0,blend=true,texture="fen_d"},
    {name="G057_pole_group03_161_0",center=Vector3.new(1059.21854,40.376321,2922.538556),opacity=1.0,blend=true,texture="fen_d"},
    {name="G058_pole_group04_162_0",center=Vector3.new(157.584358,18.987857,2720.863018),opacity=1.0,blend=true,texture="fen_d"},
    {name="G059_pole_group02_163_0",center=Vector3.new(1053.409125,104.110432,1531.901353),opacity=1.0,blend=true,texture="fen_d"},
    {name="G060_flagger_sf_l_164_0",center=Vector3.new(1218.228834,115.889991,1097.7516),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G061_flagger_sf_l_164_1",center=Vector3.new(1217.896049,118.9769,1097.722867),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G062_vc_light_165_0",center=Vector3.new(-426.412277,46.019053,2115.466704),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G063_vc_light_166_0",center=Vector3.new(-826.366376,101.019052,1260.012359),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G064_vc_light_167_0",center=Vector3.new(-1213.427261,127.090485,-1422.128418),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G065_vc_light_168_0",center=Vector3.new(-1299.467155,126.376196,-2415.655255),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G066_flagger_stopgo_0_169_0",center=Vector3.new(1040.811051,50.838864,2326.993641),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G067_flagger_stopgo_0_169_1",center=Vector3.new(1039.358737,51.281128,2327.288372),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G068_flagger_stopgo_0_169_2",center=Vector3.new(1038.86488,51.786041,2327.080604),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G069_flagger_stopgo_0_169_3",center=Vector3.new(1036.309654,50.198164,2327.127192),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G070_flagger_stopgo_0_169_4",center=Vector3.new(1036.663112,50.655343,2327.120071),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G071_flagger_stopgo_0_169_5",center=Vector3.new(1036.384606,50.008955,2327.122164),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G072_flagger_stopgo_0_169_6",center=Vector3.new(1036.666485,51.155873,2327.370435),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G073_flagger_stopgo_0_169_7",center=Vector3.new(1036.976745,51.533239,2327.102877),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G074_flagger_stopgo_0_169_8",center=Vector3.new(1037.65766,52.332159,2327.018904),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G075_flagger_stopgo_0_169_9",center=Vector3.new(1037.901394,52.783399,2326.855999),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G076_flagger_stopgo_0_169_10",center=Vector3.new(1038.289512,49.932693,2327.409998),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G077_flagger_stopgo_0_169_11",center=Vector3.new(1037.779507,50.222722,2327.052002),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G078_flagger_stopgo_0_169_12",center=Vector3.new(1037.742783,50.582564,2327.436128),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G079_flagger_stopgo_0_169_13",center=Vector3.new(1037.838273,51.520996,2327.082271),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G080_flagger_stopgo_0_169_14",center=Vector3.new(1039.280358,51.318689,2327.294187),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G081_flagger_stopgo_0_169_15",center=Vector3.new(1039.652508,51.399707,2327.073537),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G082_flagger_stopgo_0_169_16",center=Vector3.new(1040.15158,51.041506,2327.180784),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G083_flagger_stopgo_0_169_17",center=Vector3.new(1037.826017,46.914141,2327.316117),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G084_flagger_stopgo_0_169_18",center=Vector3.new(1038.209971,47.030331,2326.880416),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G085_flagger_stopgo_0_169_19",center=Vector3.new(1037.173812,46.911302,2326.444326),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G086_flagger_stopgo_0_169_20",center=Vector3.new(1037.451202,47.03111,2326.880415),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G087_flagger_stopgo_0_169_21",center=Vector3.new(1037.812191,47.101136,2327.419508),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G088_flagger_stopgo_0_169_22",center=Vector3.new(1038.213098,47.911501,2326.98252),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G089_flagger_stopgo_0_169_23",center=Vector3.new(1037.848646,48.631353,2326.952349),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G090_flagger_stopgo_0_169_24",center=Vector3.new(1038.165612,49.516631,2327.022181),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G091_flagger_stopgo_0_169_25",center=Vector3.new(1037.044658,47.032443,2327.424756),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G092_flagger_stopgo_0_169_26",center=Vector3.new(1037.448086,47.912312,2326.983465),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G093_flagger_stopgo_0_169_27",center=Vector3.new(1037.013532,48.644122,2327.019238),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G094_flagger_stopgo_0_169_28",center=Vector3.new(1037.523479,49.515393,2327.022166),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G095_flagger_stopgo_0_169_29",center=Vector3.new(1037.623683,50.357144,2327.092384),opacity=1.0,blend=false,texture="untextured"},
    {name="G096_flagger_stopgo_0_169_30",center=Vector3.new(1040.949491,50.876846,2326.750025),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G097_flagger_stopgo_0_169_31",center=Vector3.new(1043.052463,51.018353,2327.168379),opacity=1.0,blend=false,texture="stopgo"},
    {name="G098_flagger_stopgo_0_169_32",center=Vector3.new(1041.273032,50.986909,2327.248026),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G099_flagger_stopgo_0_169_33",center=Vector3.new(1043.052462,51.018353,2327.168379),opacity=1.0,blend=false,texture="stopgo"},
    {name="G100_flagger_pit_0_170_0",center=Vector3.new(1224.472703,86.766933,271.302281),opacity=1.0,blend=false,texture="series_flagger"},
    {name="G101_tree17_171_0",center=Vector3.new(-195.1928,131.509588,-1048.021732),opacity=1.0,blend=true,texture="tree17"},
    {name="G102_tree17_172_0",center=Vector3.new(-190.056505,131.509588,-987.873837),opacity=1.0,blend=true,texture="tree17"},
    {name="G103_tree07_173_0",center=Vector3.new(-297.549248,137.500002,-1185.229383),opacity=1.0,blend=true,texture="tree07"},
    {name="G104_tree01_174_0",center=Vector3.new(-285.387105,133.928573,-1013.389971),opacity=1.0,blend=true,texture="tree01"},
    {name="G105_truck_group_175_0",center=Vector3.new(857.210424,101.015928,627.431814),opacity=1.0,blend=false,texture="truck_group"},
    {name="G106_truck_group_176_0",center=Vector3.new(643.813806,97.444499,423.38314),opacity=1.0,blend=false,texture="truck_group"},
    {name="G107_truck_group_177_0",center=Vector3.new(471.62376,96.544238,652.913983),opacity=1.0,blend=false,texture="truck_group"},
    {name="G108_trailer_178_0",center=Vector3.new(-795.13355,95.526922,1551.010692),opacity=1.0,blend=false,texture="trailer"},
    {name="G109_peop_01_179_0",center=Vector3.new(-624.125254,63.912821,1883.759818),opacity=1.0,blend=true,texture="people_pit"},
    {name="G110_peop_02_180_0",center=Vector3.new(-389.576576,109.635946,-1670.316055),opacity=1.0,blend=true,texture="people_pit"},
    {name="G111_trailer01_181_0",center=Vector3.new(-809.668839,96.241204,1532.73293),opacity=1.0,blend=false,texture="trailer01"},
    {name="G112_peop_03_182_0",center=Vector3.new(-1139.23045,123.066569,-2202.996379),opacity=1.0,blend=true,texture="people_pit"},
    {name="G113_peop_04_183_0",center=Vector3.new(1211.398138,65.169087,1953.435414),opacity=1.0,blend=true,texture="people_pit"},
    {name="G114_peop_05_184_0",center=Vector3.new(1051.89773,84.129039,1616.008377),opacity=1.0,blend=true,texture="people_pit"},
    {name="G115_tree_group_dtl_185_0",center=Vector3.new(-933.248895,152.246584,-818.80789),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G116_tree_group_dtl_185_1",center=Vector3.new(-948.599353,120.000012,-803.591766),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G117_tree_group04sh_186_0",center=Vector3.new(-492.114456,142.960875,-1182.375659),opacity=1.0,blend=true,texture="trees_group4c"},
    {name="G118_tree_group04sh_186_1",center=Vector3.new(-471.245961,110.714303,-1188.868828),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G119_truck_led_187_0",center=Vector3.new(1070.934653,110.299014,1159.290971),opacity=1.0,blend=false,texture="truck_led01"},
    {name="G120_tree19_188_0",center=Vector3.new(-180.113436,23.088821,2611.551789),opacity=1.0,blend=true,texture="tree16"},
    {name="G121_bus_189_0",center=Vector3.new(561.8613,15.284743,2637.159506),opacity=1.0,blend=false,texture="bus"},
    {name="G122_trailer_190_0",center=Vector3.new(598.583676,16.268679,2628.331691),opacity=1.0,blend=false,texture="trailer"},
    {name="G123_trailer01_191_0",center=Vector3.new(520.411852,13.768679,2635.455478),opacity=1.0,blend=false,texture="trailer01"},
    {name="G124_trailer_192_0",center=Vector3.new(-824.298614,102.033451,-2561.428429),opacity=1.0,blend=false,texture="trailer"},
    {name="G125_trailer01_193_0",center=Vector3.new(-890.324786,102.542058,-2572.658729),opacity=1.0,blend=false,texture="trailer01"},
    {name="G126_bus_194_0",center=Vector3.new(-507.545199,109.962038,-2229.947371),opacity=1.0,blend=false,texture="bus"},
    {name="G127_trailer01_195_0",center=Vector3.new(-408.490886,116.625822,-1805.086106),opacity=1.0,blend=false,texture="trailer01"},
    {name="G128_m_van1_196_0",center=Vector3.new(-803.312999,100.06121,-2618.203455),opacity=1.0,blend=false,texture="m_van1"},
    {name="G129_car1_197_0",center=Vector3.new(-620.884475,103.486753,-2431.669278),opacity=1.0,blend=false,texture="car1"},
    {name="G130_car3_198_0",center=Vector3.new(-641.593269,103.84389,-2455.054208),opacity=1.0,blend=false,texture="car3"},
    {name="G131_suv_199_0",center=Vector3.new(-664.036112,104.308586,-2475.455521),opacity=1.0,blend=false,texture="suv"},
    {name="G132_car2_200_0",center=Vector3.new(-311.888815,61.485738,1867.56136),opacity=1.0,blend=false,texture="car2"},
    {name="G133_suv_201_0",center=Vector3.new(-293.828149,61.183517,1866.578624),opacity=1.0,blend=false,texture="suv"},
    {name="G134_m_van1_202_0",center=Vector3.new(-273.052488,61.84081,1865.852503),opacity=1.0,blend=false,texture="m_van1"},
    {name="G135_m_van6_203_0",center=Vector3.new(-250.017232,61.540656,1869.548928),opacity=1.0,blend=false,texture="m_van6"},
    {name="G136_m_van4_204_0",center=Vector3.new(-327.987812,62.535493,1866.701974),opacity=1.0,blend=false,texture="m_van4"},
    {name="G137_vehicle_group_205_0",center=Vector3.new(785.384598,78.077802,1829.389697),opacity=1.0,blend=true,texture="vehicle_group"},
    {name="G138_bus_206_0",center=Vector3.new(-313.272114,80.676321,1581.63609),opacity=1.0,blend=false,texture="bus"},
    {name="G139_trailer_207_0",center=Vector3.new(-364.747703,81.926225,1578.821423),opacity=1.0,blend=false,texture="trailer"},
    {name="G140_peop_03_208_0",center=Vector3.new(875.229834,90.566575,-68.10459),opacity=1.0,blend=true,texture="people_pit"},
    {name="G141_trailer_209_0",center=Vector3.new(755.236496,93.054392,-126.466718),opacity=1.0,blend=false,texture="trailer"},
    {name="G142_trailer01_210_0",center=Vector3.new(789.511052,93.054392,-124.15902),opacity=1.0,blend=false,texture="trailer01"},
    {name="G143_trailer01_211_0",center=Vector3.new(824.096048,93.054392,-122.754243),opacity=1.0,blend=false,texture="trailer01"},
    {name="G144_m_van6_212_0",center=Vector3.new(851.973007,90.380016,-102.884059),opacity=1.0,blend=false,texture="m_van6"},
    {name="G145_suv_213_0",center=Vector3.new(877.306581,90.380016,-102.154532),opacity=1.0,blend=false,texture="suv"},
    {name="G146_trailer_214_0",center=Vector3.new(-1055.498056,125.554393,-852.350293),opacity=1.0,blend=false,texture="trailer"},
    {name="G147_m_van2_215_0",center=Vector3.new(-1071.110764,122.880018,-824.521384),opacity=1.0,blend=false,texture="m_van2"},
    {name="G148_m_van4_216_0",center=Vector3.new(-1046.124612,113.62664,769.152916),opacity=1.0,blend=false,texture="m_van4"},
    {name="G149_m_van1_217_0",center=Vector3.new(-1042.550737,114.40168,723.659894),opacity=1.0,blend=false,texture="m_van1"},
}
local root = workspace:FindFirstChild("NR2003WatkinsGlen")
assert(not root or root:IsA("Model"), "Workspace.NR2003WatkinsGlen must be a Model")
local existing = root and root:FindFirstChild(PACKAGE)
-- Check this before Selection: a selected wrapper can also contain markers
-- belonging to another, still-uninstalled chunk after a partial master run.
if existing and existing:GetAttribute("NR2003SourceHash") == SOURCE_HASH then
    for _, g in ipairs(GEOMETRIES) do
        local p = existing:FindFirstChild(g.name, true)
        assert(p and p:IsA("MeshPart"), "Installed chunk is missing " .. g.name)
    end
    print(PACKAGE .. " already installed and calibrated")
    return
end
local selected = Selection:Get()
local function completeImport(item)
    if not item or not (item:IsA("Model") or item:IsA("Folder")) or item == root then return false end
    local markerCounts = {NR2003_MARKER_O=0, NR2003_MARKER_X=0, NR2003_MARKER_Y=0, NR2003_MARKER_Z=0}
    for _, p in ipairs(item:GetDescendants()) do
        if p:IsA("BasePart") and markerCounts[p.Name] then markerCounts[p.Name] += 1 end
    end
    for _, count in pairs(markerCounts) do if count ~= 1 then return false end end
    for _, g in ipairs(GEOMETRIES) do
        local p = item:FindFirstChild(g.name, true)
        if not p or not p:IsA("MeshPart") then return false end
    end
    return true
end
local named = workspace:FindFirstChild(PACKAGE)
local src = completeImport(named) and named or nil
if not src then
    for _, item in ipairs(selected) do
        local candidate = item:FindFirstChild(PACKAGE, true)
        if completeImport(candidate) then src = candidate; break end
        if completeImport(item) then src = item; break end
    end
end
-- Studio can append a suffix when an empty, history-reverted import still
-- occupies PACKAGE. Resolve a complete chunk by its content, not its label.
if not src then
    local candidates = {}
    for _, item in ipairs(workspace:GetDescendants()) do
        if completeImport(item) then table.insert(candidates, item) end
    end
    local innermost = {}
    for _, candidate in ipairs(candidates) do
        local containsCandidate = false
        for _, other in ipairs(candidates) do
            if other ~= candidate and other:IsDescendantOf(candidate) then containsCandidate = true; break end
        end
        if not containsCandidate then table.insert(innermost, candidate) end
    end
    assert(#innermost <= 1, "More than one complete import for " .. PACKAGE .. "; select the intended chunk model")
    src = innermost[1]
end
assert(src and (src:IsA("Model") or src:IsA("Folder")), "Import " .. PACKAGE .. ".glb, or select its imported model")
assert(src ~= root, "Select the imported chunk, not the complete track model")
local function marker(name)
    local p = src:FindFirstChild(name, true)
    assert(p and p:IsA("BasePart"), "Missing calibration marker " .. name .. "; import the complete GLB")
    return p
end
local markers = {marker("NR2003_MARKER_O"), marker("NR2003_MARKER_X"), marker("NR2003_MARKER_Y"), marker("NR2003_MARKER_Z")}
local origin = markers[1].Position
local ex, ey, ez = (markers[2].Position-origin)/4, (markers[3].Position-origin)/4, (markers[4].Position-origin)/4
local k = ex.Magnitude
assert(k > 1e-6, "Degenerate calibration markers")
local qx, qy, qz = ex/k, ey/k, ez/k
local error = math.max(math.abs(qx:Dot(qy)), math.abs(qy:Dot(qz)), math.abs(qz:Dot(qx)),
    math.abs(ey.Magnitude/k-1), math.abs(ez.Magnitude/k-1), math.abs(qx:Cross(qy):Dot(qz)-1))
assert(error < 1e-3, "Importer applied a nonuniform or reflected transform; calibration error " .. error)
-- Marker tetrahedron bounding-box centre is 1/4 of its 0.25-stud edge offset.
local offset = 0.0625
local importedFrame = CFrame.fromMatrix(origin-(qx+qy+qz)*offset*k, qx, qy, qz)
local prepared = {}
local missingTextures = 0
for _, g in ipairs(GEOMETRIES) do
    local p = src:FindFirstChild(g.name, true)
    assert(p and p:IsA("MeshPart"), "Missing imported MeshPart " .. g.name)
    local cf = importedFrame:ToObjectSpace(p.CFrame)
    local centre = cf.Position/k
    assert((centre-g.center).Magnitude < 0.15,
        "Geometry centre differs from original for " .. g.name .. "; disable importer per-object recentering")
    local appearance = p:FindFirstChildOfClass("SurfaceAppearance")
    if g.texture ~= "untextured" and not appearance and p.TextureID == "" then missingTextures += 1 end
    table.insert(prepared, {part=p, geometry=g, cf=CFrame.new(centre)*(cf-cf.Position), size=p.Size/k})
end
-- Every marker and geometry was validated before editing the place.
local backup = storage:FindFirstChild("NR2003Backup_TrackVisuals")
if not backup then backup = Instance.new("Folder"); backup.Name = "NR2003Backup_TrackVisuals"; backup.Parent = storage end
if not root then root = Instance.new("Model"); root.Name = "NR2003WatkinsGlen"; root.WorldPivot = CFrame.identity; root.Parent = workspace end
if existing and existing ~= src then existing.Name = PACKAGE .. "_" .. os.time(); existing.Parent = backup end
local installed = Instance.new("Model")
installed.Name = PACKAGE
installed.WorldPivot = CFrame.identity
for _, item in ipairs(prepared) do
    local p, g = item.part, item.geometry
    p.Anchored = true
    p.CanCollide = false
    -- The existing car client's chase camera queries terrain for clearance.
    -- Vehicle contacts continue to use the recovered NR2003 world exclusively.
    p.CanQuery = (KIND == "terrain")
    p:SetAttribute("NR2003TerrainQuery", KIND == "terrain")
    p.CanTouch = false
    p.Size = item.size
    p.CFrame = item.cf
    p.Transparency = 1-g.opacity
    p.CastShadow = true
    p.DoubleSided = true
    local appearance = p:FindFirstChildOfClass("SurfaceAppearance")
    if not appearance and g.blend and p.TextureID ~= "" then
        appearance = Instance.new("SurfaceAppearance")
        appearance.ColorMap = p.TextureID
        appearance.Parent = p
    end
    if appearance then appearance.AlphaMode = g.blend and Enum.AlphaMode.Transparency or Enum.AlphaMode.Overlay end
    p.Parent = installed
end
-- Keep original marker meshes and their Node parents intact. Destroying them
-- can break Studio/Team Create history replay with a locked Parent = NULL.
-- The whole remainder lives in ServerStorage, outside the rendered world.
src.Name = PACKAGE .. "_ImportRemainder_" .. os.time()
src.Parent = backup
installed:SetAttribute("NR2003SourceHash", SOURCE_HASH)
installed:SetAttribute("NR2003OriginalScale", k)
installed:SetAttribute("NR2003VisualKind", KIND)
installed.Parent = root
root.WorldPivot = CFrame.identity
root:SetAttribute("TrackOriginEnabled", true)
root:SetAttribute("NR2003MetresPerStud", 0.28)
print(string.format("Installed %s: %d original mesh parts; importer scale %.9g undone; collision disabled", PACKAGE, #prepared, k))
if missingTextures > 0 then warn(missingTextures .. " parts have no imported texture; check Asset Manager image moderation") end
print("Track origin is CFrame.identity. The place has not been saved.")
