-- Generated Watkins Glen visual installer: watkins_glen_scenery_000.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_scenery_000"
local KIND = "scenery"
local SOURCE_HASH = "d1d3ddb78508e900c438d68ed0faf3ae5c05927e9c2d0bb427be9a2c152348c4"
local GEOMETRIES = {
    {name="G000_press_box01_0_0",center=Vector3.new(1108.828595,128.029282,1062.174112),opacity=1.0,blend=true,texture="press_box01"},
    {name="G001_tower01_1_0",center=Vector3.new(1299.442693,118.356768,1178.086189),opacity=1.0,blend=true,texture="tower01"},
    {name="G002_redbridge_2_0",center=Vector3.new(1238.965101,103.272484,351.379481),opacity=1.0,blend=true,texture="redbridge"},
    {name="G003_grand_red_3_0",center=Vector3.new(1206.432366,84.496625,1942.26651),opacity=1.0,blend=true,texture="frst_front"},
    {name="G004_grand_green_4_0",center=Vector3.new(1243.514384,104.139482,1479.472342),opacity=1.0,blend=true,texture="frst_front"},
    {name="G005_grand_conc01_5_0",center=Vector3.new(141.550096,12.380588,2758.395768),opacity=1.0,blend=true,texture="frst_con1"},
    {name="G006_grand_conc02_6_0",center=Vector3.new(239.947748,12.380588,2784.316),opacity=1.0,blend=true,texture="frst_con2"},
    {name="G007_grand_conc03_7_0",center=Vector3.new(45.640341,12.380588,2727.036559),opacity=1.0,blend=true,texture="frst_con3"},
    {name="G008_tree01_8_0",center=Vector3.new(1168.658794,108.928573,179.724746),opacity=1.0,blend=true,texture="tree01"},
    {name="G009_grand_geen02_9_0",center=Vector3.new(1220.745545,32.217429,2897.938609),opacity=1.0,blend=true,texture="frst_green02"},
    {name="G010_grand_geen03_10_0",center=Vector3.new(-676.644852,102.930068,1279.766829),opacity=1.0,blend=true,texture="frst_green02"},
    {name="G011_build_37_11_0",center=Vector3.new(-304.294257,96.322553,1701.464167),opacity=1.0,blend=true,texture="build_37"},
    {name="G012_grand_silver_12_0",center=Vector3.new(1247.949033,97.931713,-14.165551),opacity=1.0,blend=true,texture="frst_gray"},
    {name="G013_grand_yell_13_0",center=Vector3.new(1229.457443,98.782339,1633.243988),opacity=1.0,blend=true,texture="frst_front"},
    {name="G014_build_37a_14_0",center=Vector3.new(59.714202,65.873232,1962.569101),opacity=1.0,blend=true,texture="build_37a"},
    {name="G015_grand_oran_15_0",center=Vector3.new(1214.43135,92.353763,1784.573683),opacity=1.0,blend=true,texture="frst_front"},
    {name="G016_tree_group1_16_0",center=Vector3.new(1383.008388,54.74659,2920.080784),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G017_tree_group1_16_1",center=Vector3.new(1368.61153,22.500018,2910.989966),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G018_tree_group1_17_0",center=Vector3.new(1436.958235,59.282826,2695.627484),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G019_tree_group1_17_1",center=Vector3.new(1422.561376,27.199805,2685.975269),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G020_flagbox_18_0",center=Vector3.new(1237.212113,110.586,1099.135805),opacity=1.0,blend=true,texture="st_box"},
    {name="G021_tree_group2_19_0",center=Vector3.new(-591.225429,56.352097,2334.095201),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G022_tree_group2_19_1",center=Vector3.new(-576.274159,23.699907,2327.794728),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G023_grand_gray_20_0",center=Vector3.new(1290.852771,108.288854,990.962343),opacity=1.0,blend=true,texture="frst_gray"},
    {name="G024_grand_gray_21_0",center=Vector3.new(1260.021734,107.574573,1316.15493),opacity=1.0,blend=true,texture="frst_gray"},
    {name="G025_pitg_center_22_0",center=Vector3.new(1035.471212,95.994445,1522.381147),opacity=1.0,blend=true,texture="frst_pit"},
    {name="G026_pitg_center_22_1",center=Vector3.new(1028.728561,97.941848,1521.975897),opacity=1.0,blend=true,texture="frst_pit"},
    {name="G027_tree_group3_23_0",center=Vector3.new(-384.040565,38.137812,2654.957937),opacity=1.0,blend=true,texture="trees_group3c"},
    {name="G028_tree_group3_23_1",center=Vector3.new(-372.743915,5.504521,2645.068698),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G029_tree_group1_24_0",center=Vector3.new(-668.720248,78.34827,2051.451346),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G030_tree_group1_24_1",center=Vector3.new(-653.0554,45.432071,2052.397079),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G031_tree_group3_25_0",center=Vector3.new(-839.423095,106.903178,1737.73022),opacity=1.0,blend=true,texture="trees_group3c"},
    {name="G032_tree_group3_25_1",center=Vector3.new(-828.651525,74.061722,1727.944796),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G033_tree01_26_0",center=Vector3.new(1377.75839,112.500002,1625.170832),opacity=1.0,blend=true,texture="tree01"},
    {name="G034_tree07_27_0",center=Vector3.new(1304.181505,108.928573,1696.981785),opacity=1.0,blend=true,texture="tree07"},
    {name="G035_tree07_28_0",center=Vector3.new(1294.816453,83.928573,2162.412345),opacity=1.0,blend=true,texture="tree07"},
    {name="G036_tree02_29_0",center=Vector3.new(1352.541153,93.210588,2156.826063),opacity=1.0,blend=true,texture="tree04"},
    {name="G037_tree01_30_0",center=Vector3.new(1283.740729,51.785716,2651.937734),opacity=1.0,blend=true,texture="tree01"},
    {name="G038_tower02_31_0",center=Vector3.new(-828.962904,126.984606,1112.628357),opacity=1.0,blend=true,texture="tower02"},
    {name="G039_tree_group1_32_0",center=Vector3.new(-1207.645383,135.557673,937.659248),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G040_tree_group1_32_1",center=Vector3.new(-1191.367432,103.157338,933.792024),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G041_tree_group2_33_0",center=Vector3.new(-1304.484343,140.079507,610.311667),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G042_tree_group2_33_1",center=Vector3.new(-1287.639964,107.759146,611.344738),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G043_tree_group3_34_0",center=Vector3.new(-1323.558408,143.712001,211.430008),opacity=1.0,blend=true,texture="trees_group3c"},
    {name="G044_tree_group3_34_1",center=Vector3.new(-1307.942925,111.367232,212.004943),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G045_tree_group1_35_0",center=Vector3.new(-1326.926585,148.136803,-171.885366),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G046_tree_group1_35_1",center=Vector3.new(-1310.203368,115.781558,-170.087503),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G047_tree_group2_36_0",center=Vector3.new(-1346.616732,151.865225,-549.668919),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G048_tree_group2_36_1",center=Vector3.new(-1329.973855,119.544865,-546.880791),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G049_tree_group3_37_0",center=Vector3.new(-1361.032122,152.456228,-958.287416),opacity=1.0,blend=true,texture="trees_group3c"},
    {name="G050_tree_group3_37_1",center=Vector3.new(-1345.481874,120.195318,-955.497909),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G051_tree_group1_38_0",center=Vector3.new(-1436.923869,152.246584,-1346.593114),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G052_tree_group1_38_1",center=Vector3.new(-1420.015877,120.000012,-1348.588335),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G053_tree_group2_39_0",center=Vector3.new(-1456.058757,152.603735,-1777.191135),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G054_tree_group2_39_1",center=Vector3.new(-1439.319523,120.357163,-1774.138268),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G055_tree_group3_40_0",center=Vector3.new(-1505.280492,152.246584,-2098.062896),opacity=1.0,blend=true,texture="trees_group3c"},
    {name="G056_tree_group3_40_1",center=Vector3.new(-1490.346534,120.000012,-2092.820073),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G057_tree_group1_41_0",center=Vector3.new(-1476.846384,152.27208,-2416.21703),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G058_tree_group1_41_1",center=Vector3.new(-1461.442069,120.041406,-2408.892425),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G059_tree_group2_42_0",center=Vector3.new(-1423.025496,150.859041,-2664.949952),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G060_tree_group2_42_1",center=Vector3.new(-1408.339804,118.767355,-2655.794145),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G061_tree_group3_43_0",center=Vector3.new(-1118.555428,140.973176,-3008.209334),opacity=1.0,blend=true,texture="trees_group3c"},
    {name="G062_tree_group3_43_1",center=Vector3.new(-1115.019711,108.906083,-2992.412145),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G063_tree_group1_44_0",center=Vector3.new(-764.857471,134.901076,-3082.787672),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G064_tree_group1_44_1",center=Vector3.new(-768.657622,102.801257,-3065.908018),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G065_tree01_45_0",center=Vector3.new(-1322.519531,146.428573,-772.719937),opacity=1.0,blend=true,texture="tree01"},
    {name="G066_tree07_46_0",center=Vector3.new(-1313.220019,139.285716,-3.372707),opacity=1.0,blend=true,texture="tree07"},
    {name="G067_tree_group1_47_0",center=Vector3.new(-70.280758,123.414818,-1930.577713),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G068_tree_group1_47_1",center=Vector3.new(-58.524936,91.014482,-1942.484101),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G069_tree07_48_0",center=Vector3.new(-1465.484252,147.85715,-1578.870983),opacity=1.0,blend=true,texture="tree07"},
    {name="G070_tree01_49_0",center=Vector3.new(-1436.035887,144.642859,-1996.444049),opacity=1.0,blend=true,texture="tree01"},
    {name="G071_tree02_50_0",center=Vector3.new(-1355.251071,155.710588,-1181.322943),opacity=1.0,blend=true,texture="tree04"},
    {name="G072_tree07_51_0",center=Vector3.new(239.1025,94.642859,1580.073329),opacity=1.0,blend=true,texture="tree07"},
    {name="G073_tree07_52_0",center=Vector3.new(116.077151,123.214287,-858.038221),opacity=1.0,blend=true,texture="tree07"},
    {name="G074_tree_group01_sh_53_0",center=Vector3.new(-203.015762,130.026654,-1901.029517),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G075_tree_group01_sh_53_1",center=Vector3.new(-220.758493,97.733348,-1899.722078),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G076_tree_group03_sh_54_0",center=Vector3.new(-134.011237,131.532301,-1698.919642),opacity=1.0,blend=true,texture="trees_group3c"},
    {name="G077_tree_group03_sh_54_1",center=Vector3.new(-153.405573,99.285729,-1695.928307),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G078_tree_group02_sh_55_0",center=Vector3.new(-157.095928,121.681687,-2297.854266),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G079_tree_group02_sh_55_1",center=Vector3.new(-173.199893,87.897926,-2287.531075),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G080_tower04_56_0",center=Vector3.new(-198.689477,108.206893,-1674.448701),opacity=1.0,blend=true,texture="tower04"},
    {name="G081_tree_group02_sh_57_0",center=Vector3.new(-353.485497,130.81802,-2640.835465),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G082_tree_group02_sh_57_1",center=Vector3.new(-373.957384,98.571448,-2633.88563),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G083_tree_group02_sh_58_0",center=Vector3.new(-450.577961,132.24659,-2958.157294),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G084_tree_group02_sh_58_1",center=Vector3.new(-470.658073,100.000018,-2950.145537),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G085_tree01_59_0",center=Vector3.new(-614.304897,123.214287,-2336.435734),opacity=1.0,blend=true,texture="tree01"},
    {name="G086_tree02_60_0",center=Vector3.new(-529.416215,141.424874,-2136.209574),opacity=1.0,blend=true,texture="tree04"},
    {name="G087_tree07_61_0",center=Vector3.new(-480.787989,133.928573,-1801.664334),opacity=1.0,blend=true,texture="tree07"},
    {name="G088_tower03_62_0",center=Vector3.new(-1313.258471,143.637751,-2870.766059),opacity=1.0,blend=true,texture="tower03"},
    {name="G089_pit_garage_63_0",center=Vector3.new(636.944283,103.334873,646.381596),opacity=1.0,blend=false,texture="garage"},
    {name="G090_red_house_64_0",center=Vector3.new(1049.902957,101.607767,807.158444),opacity=1.0,blend=false,texture="build_red"},
    {name="G091_tree01_65_0",center=Vector3.new(1091.875744,119.642859,757.815723),opacity=1.0,blend=true,texture="tree01"},
    {name="G092_tree07_66_0",center=Vector3.new(1021.23983,119.642859,502.847016),opacity=1.0,blend=true,texture="tree07"},
    {name="G093_tree02_67_0",center=Vector3.new(888.106884,130.710588,462.82794),opacity=1.0,blend=true,texture="tree04"},
    {name="G094_bboards06a_68_0",center=Vector3.new(-11.798539,6.894303,2671.874658),opacity=1.0,blend=true,texture="bilboards_group01"},
    {name="G095_bboards06b_69_0",center=Vector3.new(-111.076659,7.596054,2634.005956),opacity=1.0,blend=true,texture="bilboards_group02"},
    {name="G096_score02_a_70_0",center=Vector3.new(-554.332645,37.582285,2353.087266),opacity=1.0,blend=true,texture="score_02a"},
    {name="G097_score02_a_70_1",center=Vector3.new(-554.28178,57.341072,2353.133065),opacity=1.0,blend=true,texture="score_02a"},
    {name="G098_tree17_71_0",center=Vector3.new(-456.545502,136.152443,-1578.260972),opacity=1.0,blend=true,texture="tree17"},
    {name="G099_tree16_72_0",center=Vector3.new(-246.152835,136.003893,-1250.631314),opacity=1.0,blend=true,texture="tree16"},
    {name="G100_tree18_73_0",center=Vector3.new(-221.608907,138.027269,-1111.196247),opacity=1.0,blend=true,texture="tree18"},
    {name="G101_s_winston_74_0",center=Vector3.new(-329.647256,101.223107,-2485.517022),opacity=1.0,blend=true,texture="bilboards_05"},
    {name="G102_b_winston_75_0",center=Vector3.new(524.455152,108.234589,1106.137359),opacity=1.0,blend=false,texture="bilboards_04"},
    {name="G103_score02_a_76_0",center=Vector3.new(970.408848,80.439428,2234.592271),opacity=1.0,blend=true,texture="score_02a"},
    {name="G104_score02_a_76_1",center=Vector3.new(970.408848,100.198214,2234.535217),opacity=1.0,blend=true,texture="score_02a"},
    {name="G105_tree17_77_0",center=Vector3.new(1092.80687,120.795303,686.488484),opacity=1.0,blend=true,texture="tree17"},
    {name="G106_tree16_78_0",center=Vector3.new(1275.527705,103.861036,1823.070276),opacity=1.0,blend=true,texture="tree16"},
    {name="G107_tree18_79_0",center=Vector3.new(1164.072998,111.420124,247.013083),opacity=1.0,blend=true,texture="tree18"},
    {name="G108_tree17_80_0",center=Vector3.new(-286.736809,127.93816,-2708.073555),opacity=1.0,blend=true,texture="tree17"},
    {name="G109_tree16_81_0",center=Vector3.new(-298.051767,125.646751,-2462.780313),opacity=1.0,blend=true,texture="tree16"},
    {name="G110_house_04_82_0",center=Vector3.new(101.302503,8.939493,2560.38464),opacity=1.0,blend=false,texture="house_04"},
    {name="G111_bboard01a_83_0",center=Vector3.new(1306.597639,97.930608,595.653705),opacity=1.0,blend=true,texture="bilboards_group01"},
    {name="G112_tree_group02_sh_84_0",center=Vector3.new(1374.130387,120.658525,314.969532),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G113_tree_group02_sh_84_1",center=Vector3.new(1352.855708,88.350031,311.681202),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G114_tree_group01_sh_85_0",center=Vector3.new(1342.297816,125.173956,675.67085),opacity=1.0,blend=true,texture="trees_group1a"},
    {name="G115_tree_group01_sh_85_1",center=Vector3.new(1325.080064,92.760402,672.16561),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G116_tree18_86_0",center=Vector3.new(1308.197883,119.991551,618.167958),opacity=1.0,blend=true,texture="tree18"},
    {name="G117_tree02_87_0",center=Vector3.new(1302.879173,128.924874,736.830659),opacity=1.0,blend=true,texture="tree04"},
    {name="G118_tree_group04_88_0",center=Vector3.new(996.904874,124.787615,630.540405),opacity=1.0,blend=true,texture="trees_group4c"},
    {name="G119_tree_group04_88_1",center=Vector3.new(1012.617673,92.693692,622.431805),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G120_tree_group_ltd_89_0",center=Vector3.new(1478.46686,110.818018,-58.113846),opacity=1.0,blend=true,texture="trees_group2a"},
    {name="G121_tree_group_ltd_89_1",center=Vector3.new(1466.013607,78.571446,-44.152599),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G122_tree16_90_0",center=Vector3.new(1426.12046,111.003893,47.610367),opacity=1.0,blend=true,texture="tree16"},
    {name="G123_bud_building_91_0",center=Vector3.new(-1152.991205,141.785717,-1291.2743),opacity=1.0,blend=true,texture="bud"},
    {name="G124_bboards06b_92_0",center=Vector3.new(-1001.02516,106.170838,1151.281498),opacity=1.0,blend=true,texture="bilboards_group02"},
    {name="G125_bboard01c_93_0",center=Vector3.new(-1141.727069,135.902613,-1321.671061),opacity=1.0,blend=true,texture="bilboards_group01"},
    {name="G126_tree16_94_0",center=Vector3.new(-1140.431394,147.789604,-1216.292896),opacity=1.0,blend=true,texture="tree16"},
    {name="G127_tree_group04sh_95_0",center=Vector3.new(-1107.472497,152.246584,-1116.877885),opacity=1.0,blend=true,texture="trees_group4c"},
    {name="G128_tree_group04sh_95_1",center=Vector3.new(-1129.235157,120.000012,-1114.865514),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G129_tree17_96_0",center=Vector3.new(-1113.840853,147.581017,-1268.883309),opacity=1.0,blend=true,texture="tree17"},
    {name="G130_tree02_97_0",center=Vector3.new(-1099.628999,157.496303,-892.735121),opacity=1.0,blend=true,texture="tree04"},
    {name="G131_zippo_tower_98_0",center=Vector3.new(-1161.865834,136.026291,-2361.177117),opacity=1.0,blend=false,texture="zippo"},
    {name="G132_bboard01d_99_0",center=Vector3.new(1095.416378,95.188321,-44.107653),opacity=1.0,blend=true,texture="bilboards_group01"},
    {name="G133_house_32_100_0",center=Vector3.new(-587.832167,41.343438,2269.301485),opacity=1.0,blend=true,texture="house_32"},
    {name="G134_tree07_101_0",center=Vector3.new(-1017.430846,116.07143,1510.760224),opacity=1.0,blend=true,texture="tree07"},
    {name="G135_tree01_102_0",center=Vector3.new(-1092.793552,119.642859,1344.51573),opacity=1.0,blend=true,texture="tree01"},
    {name="G136_tree18_103_0",center=Vector3.new(-1140.720877,129.277267,1129.66621),opacity=1.0,blend=true,texture="tree18"},
    {name="G137_bboard01b_104_0",center=Vector3.new(-1136.826031,113.045464,-2544.688154),opacity=1.0,blend=true,texture="bilboards_group01"},
    {name="G138_m_winston_105_0",center=Vector3.new(350.089011,100.718712,-99.52281),opacity=1.0,blend=false,texture="bilboards_04"},
    {name="G139_tree02_106_0",center=Vector3.new(287.876257,127.13916,-108.943871),opacity=1.0,blend=true,texture="tree04"},
    {name="G140_tree18_107_0",center=Vector3.new(384.916667,119.277269,-157.68345),opacity=1.0,blend=true,texture="tree18"},
    {name="G141_tree_group04sh_108_0",center=Vector3.new(527.326211,121.532304,-190.813597),opacity=1.0,blend=true,texture="trees_group4c"},
    {name="G142_tree_group04sh_108_1",center=Vector3.new(524.392422,89.285732,-169.15575),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G143_tree16_109_0",center=Vector3.new(106.812908,125.289607,-504.456182),opacity=1.0,blend=true,texture="tree16"},
    {name="G144_tree17_110_0",center=Vector3.new(276.262473,120.795303,-180.500134),opacity=1.0,blend=true,texture="tree17"},
    {name="G145_tree02_111_0",center=Vector3.new(733.231735,127.13916,-150.34213),opacity=1.0,blend=true,texture="tree04"},
    {name="G146_tree_group04sh_112_0",center=Vector3.new(1433.593837,129.746587,950.630167),opacity=1.0,blend=true,texture="trees_group4c"},
    {name="G147_tree_group04sh_112_1",center=Vector3.new(1422.430897,97.500015,969.419601),opacity=1.0,blend=true,texture="tree_shadow"},
    {name="G148_tree18_113_0",center=Vector3.new(1304.5909,124.99155,863.802129),opacity=1.0,blend=true,texture="tree18"},
    {name="G149_tree02_114_0",center=Vector3.new(1184.543283,59.282017,3043.74167),opacity=1.0,blend=true,texture="tree04"},
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
