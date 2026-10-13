-- Generated Watkins Glen visual installer: watkins_glen_walls_005.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_walls_005"
local KIND = "walls"
local SOURCE_HASH = "56b5c90cf9962ca7169f34694a434e485412f7583fef83bb9de62a2977441074"
local GEOMETRIES = {
    {name="G000_wall_054_03_00_0",center=Vector3.new(-1283.215714,121.202067,-2046.93658),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G001_wall_054_03_00_1",center=Vector3.new(-1285.001319,122.630637,-2046.915763),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G002_wall_054_04_00_0",center=Vector3.new(-1287.067522,121.684211,-2046.891676),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G003_wall_054_04_00_1",center=Vector3.new(-1287.24605,123.594924,-2046.889605),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G004_wall_054_04_00_2",center=Vector3.new(-1287.424632,121.684211,-2046.887534),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G005_wall_055_00_00_0",center=Vector3.new(-1035.637883,126.269204,-2092.469352),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G006_wall_055_00_00_2",center=Vector3.new(-1035.994993,126.269545,-2092.46521),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G007_wall_profile_055_00_00_0",center=Vector3.new(-1036.523873,133.412913,-2092.458997),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G008_wall_profile_055_00_00_2",center=Vector3.new(-1036.880984,133.413247,-2092.454856),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G009_wall_profile_top_055_00_",center=Vector3.new(-1037.594387,134.306785,-2092.446463),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G010_wall_055_01_00_0",center=Vector3.new(-1043.353598,121.937261,-2092.379434),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G011_wall_055_01_00_1",center=Vector3.new(-1043.530328,123.848145,-2092.377363),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G012_wall_055_01_00_2",center=Vector3.new(-1043.710709,121.937602,-2092.375292),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G013_wall_055_02_00_1",center=Vector3.new(-1045.494788,122.885738,-2092.354366),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G014_wall_055_02_00_2",center=Vector3.new(-1047.281756,121.458864,-2092.333548),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G015_wall_055_03_00_0",center=Vector3.new(-1283.90928,121.204274,-2089.573887),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G016_wall_055_03_00_1",center=Vector3.new(-1285.694885,122.632844,-2089.55307),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G017_wall_055_04_00_0",center=Vector3.new(-1287.752696,121.686418,-2089.529092),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G018_wall_055_04_00_1",center=Vector3.new(-1287.931279,123.597131,-2089.527021),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G019_wall_055_04_00_2",center=Vector3.new(-1288.109807,121.686418,-2089.52495),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G020_wall_056_00_00_0",center=Vector3.new(-1076.04757,126.301745,-2122.169386),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G021_wall_056_00_00_2",center=Vector3.new(-1076.404626,126.302079,-2122.165135),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G022_wall_profile_056_00_00_0",center=Vector3.new(-1076.933725,133.445426,-2122.159031),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G023_wall_profile_056_00_00_2",center=Vector3.new(-1077.290835,133.445767,-2122.154781),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G024_wall_profile_top_056_00_",center=Vector3.new(-1078.004238,134.339305,-2122.146497),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G025_wall_056_01_00_0",center=Vector3.new(-1083.123125,121.969128,-2122.08677),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G026_wall_056_01_00_1",center=Vector3.new(-1083.299909,123.880005,-2122.084808),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G027_wall_056_01_00_2",center=Vector3.new(-1083.480181,121.969461,-2122.082629),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G028_wall_056_02_00_1",center=Vector3.new(-1085.266876,122.91755,-2122.061811),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G029_wall_056_02_00_2",center=Vector3.new(-1087.053844,121.49069,-2122.040994),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G030_wall_056_03_00_0",center=Vector3.new(-1284.377234,121.204642,-2119.739641),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G031_wall_056_03_00_1",center=Vector3.new(-1286.16284,122.633212,-2119.718824),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G032_wall_056_04_00_0",center=Vector3.new(-1288.420214,121.686786,-2119.692557),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G033_wall_056_04_00_1",center=Vector3.new(-1288.598742,123.597499,-2119.690486),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G034_wall_056_04_00_2",center=Vector3.new(-1288.777324,121.686786,-2119.688416),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G035_wall_057_00_00_0",center=Vector3.new(-1094.458553,126.322215,-2135.514396),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G036_wall_057_00_00_2",center=Vector3.new(-1094.815663,126.322556,-2135.510254),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G037_wall_profile_057_00_00_0",center=Vector3.new(-1095.344325,133.465937,-2135.504041),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G038_wall_profile_057_00_00_2",center=Vector3.new(-1095.70149,133.466271,-2135.4999),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G039_wall_profile_top_057_00_",center=Vector3.new(-1096.414893,134.359789,-2135.491507),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G040_wall_057_01_00_0",center=Vector3.new(-1100.324903,121.988501,-2135.445949),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G041_wall_057_01_00_1",center=Vector3.new(-1100.501578,123.899392,-2135.443878),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G042_wall_057_01_00_2",center=Vector3.new(-1100.682013,121.988848,-2135.441807),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G043_wall_057_02_00_1",center=Vector3.new(-1102.440153,122.936991,-2135.421208),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G044_wall_057_02_00_2",center=Vector3.new(-1104.227121,121.510083,-2135.400391),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G045_wall_057_03_00_0",center=Vector3.new(-1284.517397,121.20469,-2133.297729),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G046_wall_057_03_00_1",center=Vector3.new(-1286.303002,122.63326,-2133.276912),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G047_wall_057_04_00_0",center=Vector3.new(-1288.650077,121.686833,-2133.249555),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G048_wall_057_04_00_1",center=Vector3.new(-1288.828605,123.597547,-2133.247484),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G049_wall_057_04_00_2",center=Vector3.new(-1289.007132,121.686833,-2133.245414),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G050_wall_058_00_00_0",center=Vector3.new(-1105.560412,126.34635,-2143.352509),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G051_wall_058_00_00_2",center=Vector3.new(-1105.917576,126.346704,-2143.348258),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G052_wall_profile_058_00_00_0",center=Vector3.new(-1106.445966,133.490099,-2143.342154),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G053_wall_profile_058_00_00_2",center=Vector3.new(-1106.803077,133.49046,-2143.337904),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G054_wall_profile_top_058_00_",center=Vector3.new(-1107.516425,134.384012,-2143.32962),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G055_wall_058_01_00_0",center=Vector3.new(-1109.863499,122.011355,-2143.302264),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G056_wall_058_01_00_1",center=Vector3.new(-1110.04012,123.922253,-2143.300193),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G057_wall_058_01_00_2",center=Vector3.new(-1110.220555,122.011716,-2143.298122),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G058_wall_058_02_00_1",center=Vector3.new(-1111.980002,122.959934,-2143.277522),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G059_wall_058_02_00_2",center=Vector3.new(-1113.767079,121.533115,-2143.256705),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G060_wall_058_03_00_0",center=Vector3.new(-1284.657669,121.204676,-2141.263689),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G061_wall_058_03_00_1",center=Vector3.new(-1286.443274,122.633246,-2141.242872),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G062_wall_058_04_00_0",center=Vector3.new(-1288.735907,121.68682,-2141.216169),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G063_wall_058_04_00_1",center=Vector3.new(-1288.914435,123.597533,-2141.214098),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G064_wall_058_04_00_2",center=Vector3.new(-1289.092963,121.68682,-2141.212027),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G065_wall_059_00_00_0",center=Vector3.new(-1110.457012,126.356881,-2146.867044),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G066_wall_059_00_00_2",center=Vector3.new(-1110.814067,126.357242,-2146.862902),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G067_wall_profile_059_00_00_0",center=Vector3.new(-1111.342512,133.500637,-2146.856689),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G068_wall_profile_059_00_00_2",center=Vector3.new(-1111.699622,133.500992,-2146.852548),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G069_wall_profile_top_059_00_",center=Vector3.new(-1112.41297,134.394571,-2146.844264),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G070_wall_059_01_00_0",center=Vector3.new(-1114.205551,122.021409,-2146.823338),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G071_wall_059_01_00_1",center=Vector3.new(-1114.382172,123.932307,-2146.821267),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G072_wall_059_01_00_2",center=Vector3.new(-1114.562716,122.021777,-2146.819196),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G073_wall_059_02_00_1",center=Vector3.new(-1116.327722,122.970002,-2146.798597),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G074_wall_059_02_00_2",center=Vector3.new(-1118.114798,121.543251,-2146.77778),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G075_wall_059_03_00_0",center=Vector3.new(-1284.749385,121.204662,-2144.834355),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G076_wall_059_03_00_1",center=Vector3.new(-1286.534991,122.633232,-2144.813538),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G077_wall_059_04_00_0",center=Vector3.new(-1288.774436,121.686806,-2144.787489),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G078_wall_059_04_00_1",center=Vector3.new(-1288.953018,123.59752,-2144.785418),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G079_wall_059_04_00_2",center=Vector3.new(-1289.131546,121.686806,-2144.783347),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G080_wall_060_00_00_0",center=Vector3.new(-1115.190234,126.361247,-2150.383541),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G081_wall_060_00_00_2",center=Vector3.new(-1115.547344,126.361615,-2150.37929),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G082_wall_profile_060_00_00_0",center=Vector3.new(-1116.075734,133.505004,-2150.373295),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G083_wall_profile_060_00_00_2",center=Vector3.new(-1116.432898,133.505365,-2150.369045),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G084_wall_profile_top_060_00_",center=Vector3.new(-1117.146192,134.398944,-2150.360761),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G085_wall_060_01_00_0",center=Vector3.new(-1118.598775,122.025435,-2150.343868),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G086_wall_060_01_00_1",center=Vector3.new(-1118.775395,123.936326,-2150.341797),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G087_wall_060_01_00_2",center=Vector3.new(-1118.955939,122.025796,-2150.339617),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G088_wall_060_02_00_1",center=Vector3.new(-1120.716095,122.974014,-2150.319127),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G089_wall_060_02_00_2",center=Vector3.new(-1122.503117,121.547263,-2150.2982),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G090_wall_060_03_00_0",center=Vector3.new(-1284.79478,121.204642,-2148.405566),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G091_wall_060_03_00_1",center=Vector3.new(-1286.580385,122.633212,-2148.384748),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G092_wall_060_04_00_0",center=Vector3.new(-1288.812964,121.686786,-2148.358699),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G093_wall_060_04_00_1",center=Vector3.new(-1288.991547,123.597499,-2148.356628),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G094_wall_060_04_00_2",center=Vector3.new(-1289.170129,121.686786,-2148.354558),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G095_wall_061_00_00_0",center=Vector3.new(-1124.279349,126.356513,-2157.788195),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G096_wall_061_00_00_2",center=Vector3.new(-1124.636514,126.356867,-2157.784053),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G097_wall_profile_061_00_00_0",center=Vector3.new(-1125.165449,133.500269,-2157.777841),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G098_wall_profile_061_00_00_2",center=Vector3.new(-1125.522614,133.500617,-2157.773699),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G099_wall_profile_top_061_00_",center=Vector3.new(-1126.235907,134.394142,-2157.765307),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G100_wall_061_01_00_0",center=Vector3.new(-1127.672849,122.020544,-2157.748522),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G101_wall_061_01_00_1",center=Vector3.new(-1127.849633,123.931435,-2157.74656),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G102_wall_061_01_00_2",center=Vector3.new(-1128.02996,122.020892,-2157.74438),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G103_wall_061_02_00_1",center=Vector3.new(-1129.801668,122.969123,-2157.723781),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G104_wall_061_02_00_2",center=Vector3.new(-1131.588582,121.542229,-2157.702964),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G105_wall_061_03_00_0",center=Vector3.new(-1284.889167,121.204594,-2155.91507),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G106_wall_061_03_00_1",center=Vector3.new(-1286.674772,122.633164,-2155.894252),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G107_wall_061_04_00_0",center=Vector3.new(-1288.893945,121.686738,-2155.868421),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G108_wall_061_04_00_1",center=Vector3.new(-1289.072473,123.597452,-2155.86635),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G109_wall_061_04_00_2",center=Vector3.new(-1289.251055,121.686738,-2155.864171),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G110_wall_062_00_00_0",center=Vector3.new(-1158.36307,126.271718,-2186.601802),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G111_wall_062_00_00_2",center=Vector3.new(-1158.72018,126.271956,-2186.597552),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G112_wall_profile_062_00_00_0",center=Vector3.new(-1159.252875,133.415399,-2186.591448),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G113_wall_profile_062_00_00_2",center=Vector3.new(-1159.609931,133.415638,-2186.587197),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G114_wall_profile_top_062_00_",center=Vector3.new(-1160.323334,134.308795,-2186.578914),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G115_wall_062_01_00_0",center=Vector3.new(-1162.870298,121.935361,-2186.549268),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G116_wall_062_01_00_1",center=Vector3.new(-1163.048063,123.846238,-2186.547198),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G117_wall_062_01_00_2",center=Vector3.new(-1163.227463,121.935599,-2186.545127),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G118_wall_062_02_00_1",center=Vector3.new(-1165.008327,122.883674,-2186.524309),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G119_wall_062_02_00_2",center=Vector3.new(-1166.794532,121.45586,-2186.503492),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G120_wall_062_03_00_0",center=Vector3.new(-1285.321917,121.204274,-2185.121155),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G121_wall_062_03_00_1",center=Vector3.new(-1287.107522,122.632844,-2185.100337),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G122_wall_062_04_00_0",center=Vector3.new(-1289.208821,121.686418,-2185.075923),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G123_wall_062_04_00_1",center=Vector3.new(-1289.387403,123.597131,-2185.073744),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G124_wall_062_04_00_2",center=Vector3.new(-1289.565931,121.686418,-2185.071673),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G125_wall_063_00_00_0",center=Vector3.new(-1196.20176,126.108674,-2227.844456),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G126_wall_063_00_00_2",center=Vector3.new(-1196.558871,126.108749,-2227.840315),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G127_wall_profile_063_00_00_0",center=Vector3.new(-1197.094563,133.251905,-2227.834102),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G128_wall_profile_063_00_00_2",center=Vector3.new(-1197.451673,133.25198,-2227.82996),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G129_wall_profile_top_063_00_",center=Vector3.new(-1198.165567,134.144838,-2227.821568),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G130_wall_063_01_00_0",center=Vector3.new(-1200.667572,121.770525,-2227.792467),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G131_wall_063_01_00_1",center=Vector3.new(-1200.846154,123.681314,-2227.790397),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G132_wall_063_01_00_2",center=Vector3.new(-1201.024737,121.7706,-2227.788326),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G133_wall_063_02_00_1",center=Vector3.new(-1202.81214,122.717782,-2227.767399),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G134_wall_063_02_00_2",center=Vector3.new(-1204.597691,121.289212,-2227.746582),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G135_wall_063_03_00_0",center=Vector3.new(-1285.815539,121.203681,-2226.799338),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G136_wall_063_03_00_1",center=Vector3.new(-1287.601144,122.632251,-2226.778521),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G137_wall_063_04_00_0",center=Vector3.new(-1289.658138,121.685825,-2226.754543),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G138_wall_063_04_00_1",center=Vector3.new(-1289.83672,123.596539,-2226.752472),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G139_wall_063_04_00_2",center=Vector3.new(-1290.015302,121.685825,-2226.750401),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G140_wall_064_00_00_0",center=Vector3.new(-1216.847883,126.024457,-2264.363425),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G141_wall_064_00_00_2",center=Vector3.new(-1217.204993,126.024457,-2264.359283),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G142_wall_profile_064_00_00_0",center=Vector3.new(-1217.740631,133.167315,-2264.352962),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G143_wall_profile_064_00_00_2",center=Vector3.new(-1218.097796,133.167315,-2264.34882),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G144_wall_profile_top_064_00_",center=Vector3.new(-1218.812016,134.060172,-2264.340537),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G145_wall_064_01_00_0",center=Vector3.new(-1219.820186,121.685171,-2264.328766),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G146_wall_064_01_00_1",center=Vector3.new(-1219.998768,123.595885,-2264.326695),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G147_wall_064_01_00_2",center=Vector3.new(-1220.177351,121.685171,-2264.324624),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G148_wall_064_02_00_0",center=Vector3.new(-1220.164544,121.203027,-2264.324733),opacity=1.0,blend=false,texture="trackmat__tires"},
    {name="G149_wall_064_02_00_1",center=Vector3.new(-1221.950095,122.631598,-2264.303916),opacity=1.0,blend=false,texture="trackmat__tires_top"},
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
