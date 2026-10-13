-- Generated Watkins Glen visual installer: watkins_glen_walls_003.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_walls_003"
local KIND = "walls"
local SOURCE_HASH = "eda9ee51e7e13cc499010fe7569969bf7408e350536bc4efb6291cdc3f430858"
local GEOMETRIES = {
    {name="G000_wall_025_01_00_0",center=Vector3.new(-754.942594,92.462066,1408.677891),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G001_wall_025_01_00_1",center=Vector3.new(-755.063057,94.372797,1408.821869),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G002_wall_025_01_00_2",center=Vector3.new(-755.168697,92.462982,1408.953694),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G003_wall_025_02_00_0",center=Vector3.new(-759.395163,96.642164,1414.171655),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G004_wall_025_02_00_2",center=Vector3.new(-759.621239,96.643077,1414.447457),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G005_wall_profile_025_02_00_0",center=Vector3.new(-759.378733,102.832409,1414.127459),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G006_wall_profile_025_02_00_0",center=Vector3.new(-759.250259,103.308443,1413.968931),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G007_wall_profile_025_02_00_0",center=Vector3.new(-758.826201,104.259825,1413.44708),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G008_wall_profile_025_02_00_2",center=Vector3.new(-759.604836,102.833326,1414.403261),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G009_wall_profile_025_02_00_2",center=Vector3.new(-759.476362,103.309355,1414.244734),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G010_wall_profile_025_02_00_2",center=Vector3.new(-759.052277,104.260741,1413.722828),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G011_wall_profile_top_025_02_",center=Vector3.new(-758.607565,104.85253,1413.183376),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G012_wall_026_00_00_0",center=Vector3.new(-784.753881,100.965415,1279.582432),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G013_wall_026_00_01_2",center=Vector3.new(-869.04523,102.968471,1188.603319),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G014_wall_026_01_00_0",center=Vector3.new(-898.518072,98.100288,1160.470309),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G015_wall_026_01_00_1",center=Vector3.new(-898.664774,100.011866,1160.597828),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G016_wall_026_01_00_2",center=Vector3.new(-898.793466,98.101725,1160.690962),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G017_wall_026_02_00_0",center=Vector3.new(-944.0588,98.742236,1196.983501),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G018_wall_026_02_00_1",center=Vector3.new(-944.213731,100.65295,1197.115326),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G019_wall_026_02_00_2",center=Vector3.new(-944.334194,98.742001,1197.204154),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G020_wall_026_03_00_0",center=Vector3.new(-949.391065,102.898284,1201.199559),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G021_wall_026_03_00_2",center=Vector3.new(-949.666459,102.898053,1201.420266),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G022_wall_profile_026_03_00_0",center=Vector3.new(-949.373218,109.088799,1201.19024),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G023_wall_profile_026_03_00_0",center=Vector3.new(-949.225507,109.565244,1201.078796),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G024_wall_profile_026_03_00_0",center=Vector3.new(-948.726191,110.518306,1200.692422),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G025_wall_profile_026_03_00_2",center=Vector3.new(-949.648612,109.088564,1201.410948),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G026_wall_profile_026_03_00_2",center=Vector3.new(-949.50082,109.565013,1201.299504),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G027_wall_profile_026_03_00_2",center=Vector3.new(-949.00153,110.518071,1200.913075),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G028_wall_profile_top_026_03_",center=Vector3.new(-948.445811,111.11349,1200.453132),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G029_wall_027_00_00_0",center=Vector3.new(-1082.347761,102.665155,870.377622),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G030_wall_027_00_00_1",center=Vector3.new(-1082.504599,104.577146,870.461764),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G031_wall_027_00_00_2",center=Vector3.new(-1082.673264,102.667393,870.519393),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G032_wall_027_01_00_0",center=Vector3.new(-1136.117336,105.105196,893.793133),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G033_wall_027_01_00_1",center=Vector3.new(-1136.287907,107.015657,893.881961),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G034_wall_027_01_00_2",center=Vector3.new(-1136.442838,105.104498,893.934849),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G035_wall_027_02_00_0",center=Vector3.new(-1144.254902,109.247674,897.131484),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G036_wall_027_02_00_2",center=Vector3.new(-1144.580405,109.246976,897.273254),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G037_wall_profile_027_02_00_0",center=Vector3.new(-1144.23948,115.438199,897.128241),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G038_wall_profile_027_02_00_0",center=Vector3.new(-1144.054249,115.914886,897.060585),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G039_wall_profile_027_02_00_0",center=Vector3.new(-1143.442917,116.868782,896.820259),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G040_wall_profile_027_02_00_2",center=Vector3.new(-1144.564928,115.437501,897.270012),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G041_wall_profile_027_02_00_2",center=Vector3.new(-1144.379698,115.914192,897.202356),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G042_wall_profile_027_02_00_2",center=Vector3.new(-1143.76842,116.86808,896.962057),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G043_wall_profile_top_027_02_",center=Vector3.new(-1143.134853,117.464467,896.659442),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G044_wall_028_00_00_0",center=Vector3.new(-1169.71114,107.057176,551.637309),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G045_wall_028_00_00_1",center=Vector3.new(-1169.882148,108.968432,551.685919),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G046_wall_028_00_00_2",center=Vector3.new(-1170.06024,107.059227,551.692281),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G047_wall_028_01_00_0",center=Vector3.new(-1226.406806,109.431369,560.706561),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G048_wall_028_01_00_1",center=Vector3.new(-1226.585334,111.341637,560.759449),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G049_wall_028_01_00_2",center=Vector3.new(-1226.755905,109.430562,560.761533),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G050_wall_029_00_00_0",center=Vector3.new(-1201.224681,112.145134,214.41616),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G051_wall_029_00_00_1",center=Vector3.new(-1201.403264,114.055804,214.418149),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G052_wall_029_00_00_2",center=Vector3.new(-1201.581846,112.145839,214.420329),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G053_wall_029_01_00_0",center=Vector3.new(-1258.813858,112.989766,215.087696),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G054_wall_029_01_00_1",center=Vector3.new(-1258.992386,114.900119,215.089781),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G055_wall_029_01_00_2",center=Vector3.new(-1259.170914,112.989405,215.091862),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G056_wall_030_00_00_0",center=Vector3.new(-1204.900088,116.91839,-134.800969),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G057_wall_030_00_00_1",center=Vector3.new(-1205.078615,118.829107,-134.798884),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G058_wall_030_00_00_2",center=Vector3.new(-1205.257198,116.91839,-134.7968),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G059_wall_030_01_00_0",center=Vector3.new(-1263.405827,116.918622,-134.118642),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G060_wall_030_01_00_1",center=Vector3.new(-1263.584409,118.829339,-134.116561),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G061_wall_030_01_00_2",center=Vector3.new(-1263.762937,116.918622,-134.114477),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G062_wall_031_00_00_0",center=Vector3.new(-1210.423224,120.512867,-619.427667),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G063_wall_031_00_00_1",center=Vector3.new(-1210.601752,122.423581,-619.425583),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G064_wall_031_00_00_2",center=Vector3.new(-1210.78028,120.512867,-619.423485),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G065_wall_031_01_00_0",center=Vector3.new(-1268.49011,120.512915,-618.750436),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G066_wall_031_01_00_1",center=Vector3.new(-1268.668692,122.423635,-618.748352),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G067_wall_031_01_00_2",center=Vector3.new(-1268.847275,120.512921,-618.746281),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G068_wall_032_00_00_0",center=Vector3.new(-1215.717316,121.680267,-1170.12825),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G069_wall_032_00_00_1",center=Vector3.new(-1215.895844,123.59098,-1170.126152),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G070_wall_032_00_00_2",center=Vector3.new(-1216.074371,121.680267,-1170.124081),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G071_wall_032_01_00_0",center=Vector3.new(-1275.168555,121.680321,-1169.434874),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G072_wall_032_01_00_1",center=Vector3.new(-1275.347137,123.591035,-1169.432804),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G073_wall_032_01_00_2",center=Vector3.new(-1275.52572,121.680328,-1169.430733),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G074_wall_033_00_00_0",center=Vector3.new(-1217.77104,121.669572,-1441.435405),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G075_wall_033_00_00_1",center=Vector3.new(-1217.949677,123.580272,-1441.433334),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G076_wall_033_00_00_2",center=Vector3.new(-1218.12815,121.669558,-1441.431209),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G077_wall_033_01_00_0",center=Vector3.new(-1279.523305,121.681418,-1440.71519),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G078_wall_033_01_00_1",center=Vector3.new(-1279.701832,123.592131,-1440.71312),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G079_wall_033_01_00_2",center=Vector3.new(-1279.880415,121.681418,-1440.711049),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G080_wall_034_00_00_0",center=Vector3.new(-1205.178016,121.633353,-1455.185263),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G081_wall_034_00_00_1",center=Vector3.new(-1205.35687,123.544039,-1455.183138),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G082_wall_034_00_00_2",center=Vector3.new(-1205.535071,121.633318,-1455.181067),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G083_wall_034_01_00_0",center=Vector3.new(-1279.741669,121.681438,-1454.315676),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G084_wall_034_01_00_1",center=Vector3.new(-1279.920197,123.592152,-1454.313605),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G085_wall_034_01_00_2",center=Vector3.new(-1280.098724,121.681438,-1454.31148),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G086_wall_035_00_00_0",center=Vector3.new(-1187.590899,121.564279,-1465.094049),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G087_wall_035_00_00_1",center=Vector3.new(-1187.770135,123.474925,-1465.091923),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G088_wall_035_00_00_2",center=Vector3.new(-1187.948009,121.564184,-1465.089852),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G089_wall_035_01_00_0",center=Vector3.new(-1279.897363,121.681445,-1464.017541),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G090_wall_035_01_00_1",center=Vector3.new(-1280.075945,123.592159,-1464.015416),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G091_wall_035_01_00_2",center=Vector3.new(-1280.254473,121.681445,-1464.013345),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G092_wall_036_00_00_0",center=Vector3.new(-1179.34761,121.506963,-1469.738988),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G093_wall_036_00_00_1",center=Vector3.new(-1179.52701,123.417595,-1469.736917),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G094_wall_036_00_00_2",center=Vector3.new(-1179.704775,121.506814,-1469.734846),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G095_wall_036_01_00_0",center=Vector3.new(-1279.970387,121.681445,-1468.565478),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G096_wall_036_01_00_1",center=Vector3.new(-1280.148969,123.592159,-1468.563407),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G097_wall_036_01_00_2",center=Vector3.new(-1280.327552,121.681445,-1468.561336),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G098_wall_037_00_00_0",center=Vector3.new(-1172.875541,121.497638,-1473.38622),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G099_wall_037_00_00_1",center=Vector3.new(-1173.05494,123.40827,-1473.38404),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G100_wall_037_00_00_2",center=Vector3.new(-1173.232705,121.497481,-1473.381969),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G101_wall_037_01_00_0",center=Vector3.new(-1280.027771,121.681452,-1472.136525),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G102_wall_037_01_00_1",center=Vector3.new(-1280.206299,123.592166,-1472.134454),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G103_wall_037_01_00_2",center=Vector3.new(-1280.384881,121.681452,-1472.132329),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G104_wall_038_00_00_0",center=Vector3.new(-1159.434836,121.552719,-1480.961445),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G105_wall_038_00_00_1",center=Vector3.new(-1159.613746,123.463358,-1480.959375),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G106_wall_038_00_00_2",center=Vector3.new(-1159.791946,121.55261,-1480.957249),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G107_wall_038_01_00_0",center=Vector3.new(-1280.146844,121.681459,-1479.553659),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G108_wall_038_01_00_1",center=Vector3.new(-1280.325372,123.592172,-1479.551533),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G109_wall_038_01_00_2",center=Vector3.new(-1280.5039,121.681459,-1479.549462),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G110_wall_039_00_00_0",center=Vector3.new(-1094.13038,121.823978,-1517.76292),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G111_wall_039_00_00_1",center=Vector3.new(-1094.308908,123.734869,-1517.760795),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G112_wall_039_00_00_2",center=Vector3.new(-1094.48749,121.824156,-1517.758724),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G113_wall_039_01_00_0",center=Vector3.new(-1280.65894,121.682535,-1515.587507),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G114_wall_039_01_00_1",center=Vector3.new(-1280.837468,123.593249,-1515.585436),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G115_wall_039_01_00_2",center=Vector3.new(-1281.015996,121.682535,-1515.583365),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G116_wall_040_00_00_0",center=Vector3.new(-1010.255596,121.865777,-1565.033068),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G117_wall_040_00_00_1",center=Vector3.new(-1010.431944,123.776702,-1565.030997),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G118_wall_040_00_00_2",center=Vector3.new(-1010.612706,121.865988,-1565.028872),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G119_wall_040_01_00_0",center=Vector3.new(-1281.263024,121.685335,-1561.872482),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G120_wall_040_01_00_1",center=Vector3.new(-1281.441552,123.596048,-1561.870411),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G121_wall_040_01_00_2",center=Vector3.new(-1281.62008,121.685335,-1561.868286),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G122_wall_041_00_00_0",center=Vector3.new(-960.692978,121.688107,-1592.931311),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G123_wall_041_00_00_1",center=Vector3.new(-960.87156,123.598821,-1592.929241),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G124_wall_041_00_00_2",center=Vector3.new(-961.050143,121.688107,-1592.92717),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G125_wall_041_01_00_0",center=Vector3.new(-1281.570925,121.688107,-1589.189148),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G126_wall_041_01_00_1",center=Vector3.new(-1281.749453,123.598821,-1589.187023),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G127_wall_041_01_00_2",center=Vector3.new(-1281.927981,121.688107,-1589.184952),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G128_wall_042_00_00_0",center=Vector3.new(-921.973964,126.026406,-1624.952098),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G129_wall_042_00_00_2",center=Vector3.new(-922.331129,126.026406,-1624.947957),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G130_wall_profile_042_00_00_0",center=Vector3.new(-922.866767,133.169263,-1624.94169),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G131_wall_profile_042_00_00_2",center=Vector3.new(-923.223931,133.169263,-1624.937548),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G132_wall_profile_top_042_00_",center=Vector3.new(-923.938152,134.06212,-1624.92921),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G133_wall_042_01_00_0",center=Vector3.new(-931.283896,121.687119,-1624.843543),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G134_wall_042_01_00_1",center=Vector3.new(-931.462479,123.597833,-1624.841472),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G135_wall_042_01_00_2",center=Vector3.new(-931.641061,121.687119,-1624.839401),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G136_wall_042_02_00_0",center=Vector3.new(-931.646783,121.204976,-1624.839292),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G137_wall_042_02_00_1",center=Vector3.new(-933.432388,122.633546,-1624.818475),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G138_wall_042_02_00_2",center=Vector3.new(-935.217939,121.204976,-1624.797658),opacity=1.0,blend=false,texture="trackmat__haybales_left"},
    {name="G139_wall_cap_042_02_3",center=Vector3.new(-942.109353,121.207012,-1604.583522),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G140_wall_042_03_00_0",center=Vector3.new(-1281.929398,121.687119,-1620.754187),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G141_wall_042_03_00_1",center=Vector3.new(-1282.10798,123.597833,-1620.752117),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G142_wall_042_03_00_2",center=Vector3.new(-1282.286508,121.687119,-1620.749991),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G143_wall_043_00_00_0",center=Vector3.new(-914.263044,126.018511,-1662.882396),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G144_wall_043_00_00_2",center=Vector3.new(-914.620181,126.018511,-1662.878254),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G145_wall_profile_043_00_00_0",center=Vector3.new(-915.155847,133.161368,-1662.871987),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G146_wall_profile_043_00_00_2",center=Vector3.new(-915.51293,133.161368,-1662.867846),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G147_wall_profile_top_043_00_",center=Vector3.new(-916.227177,134.054225,-1662.859508),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G148_wall_043_01_00_0",center=Vector3.new(-919.37027,121.679224,-1662.822832),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G149_wall_043_01_00_1",center=Vector3.new(-919.548852,123.589938,-1662.820762),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
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
