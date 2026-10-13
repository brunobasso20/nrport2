-- Generated Watkins Glen visual installer: watkins_glen_walls_000.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_walls_000"
local KIND = "walls"
local SOURCE_HASH = "077778382ffef55887626a70e608361508a5bf296cec713a9840d84140f40e9c"
local GEOMETRIES = {
    {name="G000_wall_000_01_00_0",center=Vector3.new(1130.821228,99.588834,1102.342551),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G001_wall_000_01_00_1",center=Vector3.new(1130.999211,101.195976,1102.357156),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G002_wall_000_01_00_2",center=Vector3.new(1131.177194,99.588834,1102.371815),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G003_wall_000_02_00_0",center=Vector3.new(1167.336709,99.767409,1105.349023),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G004_wall_000_02_00_1",center=Vector3.new(1168.226569,101.553123,1105.422265),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G005_wall_000_02_00_2",center=Vector3.new(1169.116429,99.767412,1105.495507),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G006_wall_000_03_00_0",center=Vector3.new(1229.646301,99.892412,1110.479246),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G007_wall_000_03_00_1",center=Vector3.new(1229.824284,101.803126,1110.493905),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G008_wall_000_03_00_2",center=Vector3.new(1230.002267,99.892412,1110.508565),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G009_wall_000_04_00_0",center=Vector3.new(1243.093872,103.338841,1111.586435),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G010_wall_000_04_00_2",center=Vector3.new(1243.449838,103.338841,1111.615753),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G011_wall_profile_000_04_00_0",center=Vector3.new(1242.965971,109.201006,1111.575917),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G012_wall_profile_000_04_00_0",center=Vector3.new(1242.4766,110.294754,1111.53559),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G013_wall_profile_000_04_00_0",center=Vector3.new(1241.553334,111.371762,1111.459623),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G014_wall_profile_000_04_00_0",center=Vector3.new(1240.263094,112.063728,1111.353356),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G015_wall_profile_000_04_00_2",center=Vector3.new(1243.321936,109.201006,1111.605181),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G016_wall_profile_000_04_00_2",center=Vector3.new(1242.832456,110.294754,1111.564909),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G017_wall_profile_000_04_00_2",center=Vector3.new(1241.9093,111.371762,1111.488942),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G018_wall_profile_000_04_00_2",center=Vector3.new(1240.619005,112.063728,1111.382675),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G019_wall_profile_top_000_04_",center=Vector3.new(1239.71247,112.267412,1111.308016),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G020_wall_001_01_00_0",center=Vector3.new(1119.201933,99.550118,1120.682362),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G021_wall_001_01_00_1",center=Vector3.new(1119.379916,101.15726,1120.697021),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G022_wall_001_01_00_2",center=Vector3.new(1119.557898,99.550118,1120.711626),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G023_wall_cap_001_01_4",center=Vector3.new(1108.715275,99.525455,1127.518409),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G024_wall_001_02_00_0",center=Vector3.new(1165.780585,99.728717,1124.517386),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G025_wall_001_02_00_1",center=Vector3.new(1166.670445,101.514435,1124.590628),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G026_wall_001_02_00_2",center=Vector3.new(1167.56025,99.728724,1124.663871),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G027_wall_001_03_00_0",center=Vector3.new(1228.07094,99.85372,1129.646029),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G028_wall_001_03_00_1",center=Vector3.new(1228.248923,101.764434,1129.660688),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G029_wall_001_03_00_2",center=Vector3.new(1228.426906,99.85372,1129.675347),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G030_wall_001_04_00_0",center=Vector3.new(1241.378566,103.300149,1130.741664),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G031_wall_001_04_00_2",center=Vector3.new(1241.734477,103.300149,1130.770983),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G032_wall_profile_001_04_00_0",center=Vector3.new(1241.25061,109.162314,1130.731147),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G033_wall_profile_001_04_00_0",center=Vector3.new(1240.761239,110.256062,1130.690874),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G034_wall_profile_001_04_00_0",center=Vector3.new(1239.838028,111.33307,1130.614853),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G035_wall_profile_001_04_00_0",center=Vector3.new(1238.547734,112.025036,1130.508586),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G036_wall_profile_001_04_00_2",center=Vector3.new(1241.606576,109.162314,1130.760465),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G037_wall_profile_001_04_00_2",center=Vector3.new(1241.117205,110.256062,1130.720193),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G038_wall_profile_001_04_00_2",center=Vector3.new(1240.193939,111.33307,1130.644172),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G039_wall_profile_001_04_00_2",center=Vector3.new(1238.9037,112.025036,1130.537905),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G040_wall_profile_top_001_04_",center=Vector3.new(1237.997164,112.228721,1130.463246),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G041_wall_002_00_01_0",center=Vector3.new(1050.60403,84.52864,1635.841751),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G042_wall_002_00_01_2",center=Vector3.new(1050.959996,84.52864,1635.871015),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G043_wall_002_01_00_0",center=Vector3.new(1068.700409,81.207694,1603.288596),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G044_wall_002_01_00_1",center=Vector3.new(1069.590269,82.100551,1603.361838),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G045_wall_002_01_00_2",center=Vector3.new(1070.480129,81.207694,1603.435135),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G046_wall_cap_002_01_3",center=Vector3.new(1108.715221,98.81117,1127.518409),opacity=1.0,blend=false,texture="trackmat__wall_side"},
    {name="G047_wall_002_02_00_0",center=Vector3.new(1126.52626,82.100575,1608.049665),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G048_wall_002_02_00_1",center=Vector3.new(1127.416066,83.886293,1608.122907),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G049_wall_002_02_00_2",center=Vector3.new(1128.305926,82.100579,1608.19615),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G050_wall_002_03_00_0",center=Vector3.new(1188.33253,82.225575,1613.138471),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G051_wall_002_03_00_1",center=Vector3.new(1188.510513,84.136289,1613.153076),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G052_wall_002_03_00_2",center=Vector3.new(1188.688496,82.225575,1613.167736),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G053_wall_002_04_00_0",center=Vector3.new(1198.109164,85.672004,1613.943372),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G054_wall_002_04_00_2",center=Vector3.new(1198.465075,85.672004,1613.972637),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G055_wall_profile_002_04_00_0",center=Vector3.new(1197.981262,91.534168,1613.932855),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G056_wall_profile_002_04_00_0",center=Vector3.new(1197.491837,92.627917,1613.892528),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G057_wall_profile_002_04_00_0",center=Vector3.new(1196.568625,93.704925,1613.816507),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G058_wall_profile_002_04_00_0",center=Vector3.new(1195.278331,94.396891,1613.710349),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G059_wall_profile_002_04_00_2",center=Vector3.new(1198.337173,91.534168,1613.962119),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G060_wall_profile_002_04_00_2",center=Vector3.new(1197.847748,92.627917,1613.921901),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G061_wall_profile_002_04_00_2",center=Vector3.new(1196.924591,93.704925,1613.845771),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G062_wall_profile_002_04_00_2",center=Vector3.new(1195.634297,94.396891,1613.739559),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G063_wall_profile_top_002_04_",center=Vector3.new(1194.727761,94.600575,1613.665009),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G064_wall_003_00_00_0",center=Vector3.new(1019.464983,55.649883,2201.780374),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G065_wall_003_00_00_1",center=Vector3.new(1020.354843,56.542741,2201.853616),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G066_wall_003_00_00_2",center=Vector3.new(1021.244649,55.64994,2201.926967),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G067_wall_cap_003_00_4",center=Vector3.new(1010.24437,47.695604,2324.502019),opacity=1.0,blend=false,texture="trackmat__wall_side"},
    {name="G068_wall_003_01_00_0",center=Vector3.new(1076.720537,56.544522,2206.494468),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G069_wall_003_01_00_1",center=Vector3.new(1077.610397,58.330236,2206.567819),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G070_wall_003_01_00_2",center=Vector3.new(1078.500257,56.544578,2206.641061),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G071_wall_cap_003_01_4",center=Vector3.new(1066.438239,48.592024,2329.128701),opacity=1.0,blend=false,texture="trackmat__wall_side"},
    {name="G072_wall_003_02_00_0",center=Vector3.new(1146.371678,56.671207,2212.229156),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G073_wall_003_02_00_1",center=Vector3.new(1146.549661,58.581921,2212.24387),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G074_wall_003_02_00_2",center=Vector3.new(1146.727589,56.671207,2212.258475),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G075_wall_003_03_00_0",center=Vector3.new(1172.637177,56.67124,2214.391763),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G076_wall_003_03_00_1",center=Vector3.new(1172.815159,58.581953,2214.406368),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G077_wall_003_03_00_2",center=Vector3.new(1172.993142,56.67124,2214.420973),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G078_wall_cap_003_03_3",center=Vector3.new(1152.598899,64.622075,2089.261082),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G079_wall_003_04_00_0",center=Vector3.new(1177.407564,60.117672,2214.784459),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G080_wall_003_04_00_2",center=Vector3.new(1177.76353,60.117674,2214.813777),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G081_wall_profile_003_04_00_0",center=Vector3.new(1177.279663,65.979835,2214.773887),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G082_wall_profile_003_04_00_0",center=Vector3.new(1176.790292,67.073587,2214.733669),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G083_wall_profile_003_04_00_0",center=Vector3.new(1175.867026,68.150595,2214.657702),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G084_wall_profile_003_04_00_0",center=Vector3.new(1174.576732,68.842561,2214.551326),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G085_wall_profile_003_04_00_2",center=Vector3.new(1177.635629,65.979838,2214.803314),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G086_wall_profile_003_04_00_2",center=Vector3.new(1177.146149,67.073587,2214.762878),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G087_wall_profile_003_04_00_2",center=Vector3.new(1176.222992,68.150595,2214.686911),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G088_wall_profile_003_04_00_2",center=Vector3.new(1174.932698,68.842561,2214.580754),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G089_wall_profile_top_003_04_",center=Vector3.new(1174.026162,69.046242,2214.505986),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G090_wall_004_00_00_0",center=Vector3.new(992.337527,41.345416,2434.856306),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G091_wall_004_00_00_1",center=Vector3.new(992.515509,43.25614,2434.870911),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G092_wall_004_00_00_2",center=Vector3.new(992.693492,41.345455,2434.885624),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G093_wall_cap_004_00_3",center=Vector3.new(1010.244424,48.713459,2324.502019),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G094_wall_004_01_00_0",center=Vector3.new(1038.464301,41.350026,2438.654109),opacity=1.0,blend=false,texture="trackmat__armco_r02"},
    {name="G095_wall_004_01_00_1",center=Vector3.new(1038.642284,43.260751,2438.668823),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G096_wall_004_01_00_2",center=Vector3.new(1038.820267,41.350065,2438.683537),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G097_wall_cap_004_01_3",center=Vector3.new(1066.438402,48.717024,2329.128701),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G098_wall_004_02_00_0",center=Vector3.new(1140.938677,41.354615,2447.091239),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G099_wall_004_02_00_1",center=Vector3.new(1141.116605,43.265329,2447.105953),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G100_wall_004_02_00_2",center=Vector3.new(1141.294588,41.354615,2447.120667),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G101_wall_cap_004_02_4",center=Vector3.new(1138.534655,33.988891,2558.722033),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G102_wall_004_03_00_0",center=Vector3.new(1206.474086,41.354661,2452.487183),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G103_wall_004_03_00_1",center=Vector3.new(1206.652015,43.265375,2452.501787),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G104_wall_004_03_00_2",center=Vector3.new(1206.829997,41.354661,2452.516392),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G105_wall_004_04_00_0",center=Vector3.new(1214.553452,44.801094,2453.152357),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G106_wall_004_04_00_2",center=Vector3.new(1214.909417,44.801097,2453.181676),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G107_wall_profile_004_04_00_0",center=Vector3.new(1214.42555,50.663262,2453.141894),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G108_wall_profile_004_04_00_0",center=Vector3.new(1213.936125,51.75701,2453.101567),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G109_wall_profile_004_04_00_0",center=Vector3.new(1213.012859,52.83402,2453.025491),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G110_wall_profile_004_04_00_0",center=Vector3.new(1211.722619,53.525983,2452.919333),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G111_wall_profile_004_04_00_2",center=Vector3.new(1214.781461,50.663262,2453.171103),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G112_wall_profile_004_04_00_2",center=Vector3.new(1214.292036,51.75701,2453.130777),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G113_wall_profile_004_04_00_2",center=Vector3.new(1213.368825,52.83402,2453.05481),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G114_wall_profile_004_04_00_2",center=Vector3.new(1212.07853,53.525983,2452.948543),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G115_wall_profile_top_004_04_",center=Vector3.new(1211.171995,53.729665,2452.873993),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G116_wall_005_00_00_0",center=Vector3.new(952.71334,27.839724,2615.084621),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G117_wall_005_00_00_1",center=Vector3.new(952.891323,29.750467,2615.099335),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G118_wall_005_00_00_2",center=Vector3.new(953.069251,27.853164,2615.11394),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G119_wall_005_01_00_0",center=Vector3.new(989.787292,29.277657,2618.137142),opacity=1.0,blend=false,texture="trackmat__armco_r02"},
    {name="G120_wall_005_01_00_1",center=Vector3.new(989.965275,31.188399,2618.151746),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G121_wall_005_01_00_2",center=Vector3.new(990.143258,29.284579,2618.16646),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G122_wall_005_02_00_0",center=Vector3.new(1215.236064,30.555294,2636.69935),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G123_wall_005_02_00_1",center=Vector3.new(1215.413993,32.466008,2636.714063),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G124_wall_005_02_00_2",center=Vector3.new(1215.591976,30.555294,2636.728668),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G125_wall_cap_005_02_4",center=Vector3.new(1210.555376,27.12167,2707.976096),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G126_wall_005_03_00_0",center=Vector3.new(1236.393084,30.430295,2638.441358),opacity=1.0,blend=false,texture="trackmat__tires"},
    {name="G127_wall_005_03_00_1",center=Vector3.new(1237.282944,32.216011,2638.5146),opacity=1.0,blend=false,texture="trackmat__tires_top"},
    {name="G128_wall_005_03_00_2",center=Vector3.new(1238.172804,30.430296,2638.587843),opacity=1.0,blend=false,texture="trackmat__tires_left"},
    {name="G129_wall_cap_005_03_3",center=Vector3.new(1222.092165,33.863921,2565.601676),opacity=1.0,blend=false,texture="trackmat__tires_near"},
    {name="G130_wall_cap_005_03_4",center=Vector3.new(1252.473722,26.99667,2711.427525),opacity=1.0,blend=false,texture="trackmat__tires_far"},
    {name="G131_wall_005_04_00_0",center=Vector3.new(1243.900572,34.001725,2639.059448),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G132_wall_005_04_00_2",center=Vector3.new(1244.256537,34.001725,2639.088767),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G133_wall_profile_005_04_00_0",center=Vector3.new(1243.77267,39.86389,2639.048876),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G134_wall_profile_005_04_00_0",center=Vector3.new(1243.283245,40.957642,2639.008658),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G135_wall_profile_005_04_00_0",center=Vector3.new(1242.360033,42.03465,2638.932691),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G136_wall_profile_005_04_00_0",center=Vector3.new(1241.069739,42.726614,2638.826316),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G137_wall_profile_005_04_00_2",center=Vector3.new(1244.128581,39.86389,2639.078195),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G138_wall_profile_005_04_00_2",center=Vector3.new(1243.639156,40.957642,2639.037868),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G139_wall_profile_005_04_00_2",center=Vector3.new(1242.715945,42.03465,2638.961901),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G140_wall_profile_005_04_00_2",center=Vector3.new(1241.42565,42.726614,2638.855743),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G141_wall_profile_top_005_04_",center=Vector3.new(1240.519115,42.930296,2638.780975),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G142_wall_006_00_00_0",center=Vector3.new(929.933003,21.57095,2686.754826),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G143_wall_006_00_00_1",center=Vector3.new(930.110986,23.495076,2686.856842),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G144_wall_006_00_00_2",center=Vector3.new(930.257579,21.5922,2686.871556),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G145_wall_006_01_00_0",center=Vector3.new(963.445663,23.779691,2698.387255),opacity=1.0,blend=false,texture="trackmat__armco_r02"},
    {name="G146_wall_006_01_00_1",center=Vector3.new(963.623592,25.697303,2698.489271),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G147_wall_006_01_00_2",center=Vector3.new(963.770185,23.787124,2698.503876),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G148_wall_006_02_00_0",center=Vector3.new(1243.793324,26.422594,2754.953112),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G149_wall_006_02_00_1",center=Vector3.new(1243.971307,28.333309,2755.014365),opacity=1.0,blend=false,texture="trackmat__armco_top"},
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
