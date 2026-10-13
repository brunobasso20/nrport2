-- Generated Watkins Glen visual installer: watkins_glen_walls_004.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_walls_004"
local KIND = "walls"
local SOURCE_HASH = "2f8b5092c483bce1b53ae14edf72c916528e3fb7e003a849947c12a4c8fa03bc"
local GEOMETRIES = {
    {name="G000_wall_043_01_00_2",center=Vector3.new(-919.727434,121.679224,-1662.818691),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G001_wall_043_02_00_1",center=Vector3.new(-921.489716,122.625651,-1662.798091),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G002_wall_043_02_00_2",center=Vector3.new(-923.275321,121.197081,-1662.777274),opacity=1.0,blend=false,texture="trackmat__haybales_left"},
    {name="G003_wall_043_03_00_0",center=Vector3.new(-1282.376753,121.679224,-1658.589336),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G004_wall_043_03_00_1",center=Vector3.new(-1282.555335,123.589938,-1658.587211),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G005_wall_043_03_00_2",center=Vector3.new(-1282.733917,121.679224,-1658.58514),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G006_wall_044_00_00_0",center=Vector3.new(-910.669245,126.012339,-1683.175441),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G007_wall_044_00_00_2",center=Vector3.new(-911.026382,126.012339,-1683.1713),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G008_wall_profile_044_00_00_0",center=Vector3.new(-911.562075,133.155196,-1683.165033),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G009_wall_profile_044_00_00_2",center=Vector3.new(-911.919185,133.155196,-1683.160891),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G010_wall_profile_top_044_00_",center=Vector3.new(-912.633405,134.048053,-1683.152553),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G011_wall_044_01_00_0",center=Vector3.new(-915.685654,121.673053,-1683.116913),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G012_wall_044_01_00_1",center=Vector3.new(-915.864236,123.583766,-1683.114842),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G013_wall_044_01_00_2",center=Vector3.new(-916.042818,121.673053,-1683.112771),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G014_wall_044_02_00_1",center=Vector3.new(-917.751094,122.619472,-1683.092826),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G015_wall_044_02_00_2",center=Vector3.new(-919.5367,121.190902,-1683.072008),opacity=1.0,blend=false,texture="trackmat__haybales_left"},
    {name="G016_wall_044_03_00_0",center=Vector3.new(-1282.591738,121.6731,-1678.837912),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G017_wall_044_03_00_1",center=Vector3.new(-1282.77032,123.583814,-1678.835842),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G018_wall_044_03_00_2",center=Vector3.new(-1282.948903,121.6731,-1678.833771),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G019_wall_045_00_00_0",center=Vector3.new(-910.348456,126.012121,-1688.536835),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G020_wall_045_00_00_2",center=Vector3.new(-910.705566,126.012121,-1688.532693),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G021_wall_profile_045_00_00_0",center=Vector3.new(-911.241232,133.154978,-1688.526426),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G022_wall_profile_045_00_00_2",center=Vector3.new(-911.598342,133.154978,-1688.522284),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G023_wall_profile_top_045_00_",center=Vector3.new(-912.312562,134.047835,-1688.513947),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G024_wall_045_01_00_0",center=Vector3.new(-915.316064,121.672835,-1688.478906),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G025_wall_045_01_00_1",center=Vector3.new(-915.494646,123.583548,-1688.476835),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G026_wall_045_01_00_2",center=Vector3.new(-915.673229,121.672835,-1688.474764),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G027_wall_045_02_00_1",center=Vector3.new(-917.323848,122.619254,-1688.455473),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G028_wall_045_02_00_2",center=Vector3.new(-919.109453,121.190684,-1688.434655),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G029_wall_045_03_00_0",center=Vector3.new(-1282.654081,121.672841,-1684.194837),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G030_wall_045_03_00_1",center=Vector3.new(-1282.832609,123.583555,-1684.192766),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G031_wall_045_03_00_2",center=Vector3.new(-1283.011191,121.672841,-1684.190696),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G032_wall_046_00_00_0",center=Vector3.new(-910.325023,126.011365,-1718.923078),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G033_wall_046_00_00_2",center=Vector3.new(-910.682133,126.011365,-1718.918882),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G034_wall_profile_046_00_00_0",center=Vector3.new(-911.217799,133.154222,-1718.91267),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G035_wall_profile_046_00_00_2",center=Vector3.new(-911.574936,133.154222,-1718.908473),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G036_wall_profile_top_046_00_",center=Vector3.new(-912.289183,134.047065,-1718.90019),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G037_wall_046_01_00_0",center=Vector3.new(-915.415301,121.672031,-1718.863678),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G038_wall_046_01_00_1",center=Vector3.new(-915.593828,123.582738,-1718.861607),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G039_wall_046_01_00_2",center=Vector3.new(-915.772411,121.672024,-1718.859536),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G040_wall_046_02_00_1",center=Vector3.new(-917.488044,122.618423,-1718.839536),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G041_wall_046_02_00_2",center=Vector3.new(-919.273649,121.189853,-1718.818719),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G042_wall_046_03_00_0",center=Vector3.new(-1283.03081,121.673693,-1714.576394),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G043_wall_046_03_00_1",center=Vector3.new(-1283.209392,123.584407,-1714.574323),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G044_wall_046_03_00_2",center=Vector3.new(-1283.38792,121.673693,-1714.572253),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G045_wall_047_00_00_0",center=Vector3.new(-910.400854,126.143762,-1766.543743),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G046_wall_047_00_00_2",center=Vector3.new(-910.757964,126.144014,-1766.539492),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G047_wall_profile_047_00_00_0",center=Vector3.new(-911.283629,133.287866,-1766.533334),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G048_wall_profile_047_00_00_2",center=Vector3.new(-911.640767,133.288118,-1766.529083),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G049_wall_profile_top_047_00_",center=Vector3.new(-912.355014,134.180975,-1766.5208),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G050_wall_047_01_00_0",center=Vector3.new(-915.476118,121.80797,-1766.484397),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G051_wall_047_01_00_1",center=Vector3.new(-915.654646,123.718936,-1766.482326),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G052_wall_047_01_00_2",center=Vector3.new(-915.833228,121.808222,-1766.480255),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G053_wall_047_02_00_1",center=Vector3.new(-917.610005,122.757156,-1766.459547),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G054_wall_047_02_00_2",center=Vector3.new(-919.397627,121.328585,-1766.438729),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G055_wall_047_03_00_0",center=Vector3.new(-1283.598818,121.675682,-1762.191173),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G056_wall_047_03_00_1",center=Vector3.new(-1283.7774,123.586396,-1762.189102),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G057_wall_047_03_00_2",center=Vector3.new(-1283.955983,121.675682,-1762.187031),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G058_wall_048_00_00_0",center=Vector3.new(-910.490472,126.275839,-1812.481744),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G059_wall_048_00_00_2",center=Vector3.new(-910.847582,126.276336,-1812.477548),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G060_wall_profile_048_00_00_0",center=Vector3.new(-911.373411,133.419909,-1812.471444),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G061_wall_profile_048_00_00_2",center=Vector3.new(-911.730548,133.420406,-1812.467303),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G062_wall_profile_top_048_00_",center=Vector3.new(-912.443542,134.314258,-1812.45891),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G063_wall_048_01_00_0",center=Vector3.new(-915.637915,121.943712,-1812.421635),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G064_wall_048_01_00_1",center=Vector3.new(-915.813828,123.854664,-1812.419619),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G065_wall_048_01_00_2",center=Vector3.new(-915.995026,121.94421,-1812.417494),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G066_wall_048_02_00_1",center=Vector3.new(-917.766244,122.893081,-1812.396894),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G067_wall_048_02_00_2",center=Vector3.new(-919.553757,121.467018,-1812.376022),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G068_wall_048_03_00_0",center=Vector3.new(-1284.153748,121.678352,-1808.123888),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G069_wall_048_03_00_1",center=Vector3.new(-1284.33233,123.589066,-1808.121817),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G070_wall_048_03_00_2",center=Vector3.new(-1284.510912,121.678352,-1808.119747),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G071_wall_049_00_00_0",center=Vector3.new(-910.46099,126.281929,-1846.144649),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G072_wall_049_00_00_2",center=Vector3.new(-910.818127,126.282426,-1846.140507),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G073_wall_profile_049_00_00_0",center=Vector3.new(-911.343929,133.426026,-1846.134295),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G074_wall_profile_049_00_00_2",center=Vector3.new(-911.701093,133.426523,-1846.130153),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G075_wall_profile_top_049_00_",center=Vector3.new(-912.41406,134.320368,-1846.12187),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G076_wall_049_01_00_0",center=Vector3.new(-915.850067,121.95017,-1846.081761),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G077_wall_049_01_00_1",center=Vector3.new(-916.025925,123.861129,-1846.07969),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G078_wall_049_01_00_2",center=Vector3.new(-916.207232,121.950667,-1846.077619),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G079_wall_049_02_00_1",center=Vector3.new(-917.948587,122.899553,-1846.057347),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G080_wall_049_02_00_2",center=Vector3.new(-919.736208,121.473442,-1846.036421),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G081_wall_049_03_00_0",center=Vector3.new(-1284.499904,121.680253,-1841.782488),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G082_wall_049_03_00_1",center=Vector3.new(-1284.678486,123.590967,-1841.780417),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G083_wall_049_03_00_2",center=Vector3.new(-1284.857069,121.680253,-1841.778346),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G084_wall_050_00_00_0",center=Vector3.new(-910.469219,126.153605,-1878.729466),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G085_wall_050_00_00_2",center=Vector3.new(-910.826356,126.153857,-1878.725324),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G086_wall_profile_050_00_00_0",center=Vector3.new(-911.361994,133.297723,-1878.719221),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G087_wall_profile_050_00_00_2",center=Vector3.new(-911.719159,133.297975,-1878.715079),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G088_wall_profile_top_050_00_",center=Vector3.new(-912.432126,134.190832,-1878.706687),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G089_wall_050_01_00_0",center=Vector3.new(-915.960421,121.818188,-1878.665488),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G090_wall_050_01_00_1",center=Vector3.new(-916.138949,123.729154,-1878.663417),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G091_wall_050_01_00_2",center=Vector3.new(-916.317477,121.81844,-1878.661346),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G092_wall_050_02_00_1",center=Vector3.new(-918.069894,122.767346,-1878.640856),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G093_wall_050_02_00_2",center=Vector3.new(-919.855499,121.338776,-1878.620039),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G094_wall_050_03_00_0",center=Vector3.new(-1284.930093,121.68122,-1874.36251),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G095_wall_050_03_00_1",center=Vector3.new(-1285.108675,123.591934,-1874.360439),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G096_wall_050_03_00_2",center=Vector3.new(-1285.287258,121.68122,-1874.358259),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G097_wall_051_00_00_0",center=Vector3.new(-909.90497,126.021937,-1922.921099),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G098_wall_051_00_00_2",center=Vector3.new(-910.262081,126.021937,-1922.916957),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G099_wall_profile_051_00_00_0",center=Vector3.new(-910.797746,133.164794,-1922.910636),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G100_wall_profile_051_00_00_2",center=Vector3.new(-911.154883,133.164794,-1922.906494),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G101_wall_profile_top_051_00_",center=Vector3.new(-911.869104,134.057651,-1922.898102),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G102_wall_051_01_00_0",center=Vector3.new(-916.083091,121.682651,-1922.848947),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G103_wall_051_01_00_1",center=Vector3.new(-916.261673,123.593364,-1922.846876),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G104_wall_051_01_00_2",center=Vector3.new(-916.440201,121.682651,-1922.844805),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G105_wall_051_02_00_1",center=Vector3.new(-918.194907,122.629077,-1922.824315),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G106_wall_051_02_00_2",center=Vector3.new(-919.980512,121.200507,-1922.803497),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G107_wall_051_03_00_0",center=Vector3.new(-1285.661534,121.682651,-1918.538884),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G108_wall_051_03_00_1",center=Vector3.new(-1285.840062,123.593364,-1918.536704),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G109_wall_051_03_00_2",center=Vector3.new(-1286.018644,121.682651,-1918.534633),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G110_wall_052_00_00_0",center=Vector3.new(-909.274891,126.021603,-1966.705976),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G111_wall_052_00_00_2",center=Vector3.new(-909.632002,126.021603,-1966.701835),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G112_wall_profile_052_00_00_0",center=Vector3.new(-910.167667,133.16446,-1966.695513),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G113_wall_profile_052_00_00_2",center=Vector3.new(-910.524804,133.16446,-1966.691371),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G114_wall_profile_top_052_00_",center=Vector3.new(-911.239052,134.057317,-1966.682979),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G115_wall_052_01_00_0",center=Vector3.new(-916.083581,121.682317,-1966.626413),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G116_wall_052_01_00_1",center=Vector3.new(-916.262163,123.593031,-1966.624342),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G117_wall_052_01_00_2",center=Vector3.new(-916.440746,121.682317,-1966.622271),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G118_wall_052_02_00_1",center=Vector3.new(-918.170493,122.628743,-1966.602216),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G119_wall_052_02_00_2",center=Vector3.new(-919.956098,121.200173,-1966.581399),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G120_wall_052_03_00_0",center=Vector3.new(-1286.216354,121.682317,-1962.309919),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G121_wall_052_03_00_1",center=Vector3.new(-1286.394937,123.593031,-1962.307848),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G122_wall_052_03_00_2",center=Vector3.new(-1286.573465,121.682317,-1962.305777),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G123_wall_053_00_00_0",center=Vector3.new(-932.328497,126.020915,-2011.009652),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G124_wall_053_00_00_2",center=Vector3.new(-932.68558,126.020915,-2011.005511),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G125_wall_profile_053_00_00_0",center=Vector3.new(-933.221299,133.163772,-2010.999189),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G126_wall_profile_053_00_00_2",center=Vector3.new(-933.578382,133.163765,-2010.995047),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G127_wall_profile_top_053_00_",center=Vector3.new(-934.29263,134.056629,-2010.986764),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G128_wall_053_01_00_0",center=Vector3.new(-938.868768,121.681622,-2010.933358),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G129_wall_053_01_00_1",center=Vector3.new(-939.047296,123.592336,-2010.931287),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G130_wall_053_01_00_2",center=Vector3.new(-939.225878,121.681622,-2010.929217),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G131_wall_053_02_00_1",center=Vector3.new(-940.980748,122.628048,-2010.908835),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G132_wall_053_02_00_2",center=Vector3.new(-942.766353,121.199478,-2010.888018),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G133_wall_053_03_00_0",center=Vector3.new(-1282.651465,121.199587,-2006.924003),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G134_wall_053_03_00_1",center=Vector3.new(-1284.437016,122.628157,-2006.903185),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G135_wall_053_03_00_2",center=Vector3.new(-1286.222621,121.199587,-2006.882368),opacity=1.0,blend=false,texture="untextured"},
    {name="G136_wall_cap_053_03_3",center=Vector3.new(-1284.144701,121.199002,-1986.739567),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G137_wall_053_04_00_0",center=Vector3.new(-1286.656134,121.681731,-2006.877354),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G138_wall_053_04_00_1",center=Vector3.new(-1286.834717,123.592445,-2006.875283),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G139_wall_053_04_00_2",center=Vector3.new(-1287.013299,121.681731,-2006.873213),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G140_wall_054_00_00_0",center=Vector3.new(-980.256271,126.131453,-2050.469862),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G141_wall_054_00_00_2",center=Vector3.new(-980.613436,126.131616,-2050.46572),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G142_wall_profile_054_00_00_0",center=Vector3.new(-981.142371,133.275155,-2050.459508),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G143_wall_profile_054_00_00_2",center=Vector3.new(-981.499481,133.275325,-2050.455366),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G144_wall_profile_top_054_00_",center=Vector3.new(-982.213756,134.168175,-2050.446974),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G145_wall_054_01_00_0",center=Vector3.new(-987.537221,121.796077,-2050.384957),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G146_wall_054_01_00_1",center=Vector3.new(-987.714005,123.706961,-2050.382887),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G147_wall_054_01_00_2",center=Vector3.new(-987.894385,121.796247,-2050.380816),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G148_wall_054_02_00_1",center=Vector3.new(-989.675086,122.744363,-2050.359998),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G149_wall_054_02_00_2",center=Vector3.new(-991.462054,121.315793,-2050.339181),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
}
local selected = Selection:Get()
local src
for _, item in ipairs(selected) do
    if (item:IsA("Model") or item:IsA("Folder")) and item:FindFirstChild("NR2003_MARKER_O", true) then
        local complete = true
        for _, g in ipairs(GEOMETRIES) do if not item:FindFirstChild(g.name, true) then complete = false; break end end
        if complete then src = item; break end
    end
end
if not src then src = workspace:FindFirstChild(PACKAGE) end
local root = workspace:FindFirstChild("NR2003WatkinsGlen")
assert(not root or root:IsA("Model"), "Workspace.NR2003WatkinsGlen must be a Model")
local existing = root and root:FindFirstChild(PACKAGE)
if not src and existing and existing:GetAttribute("NR2003SourceHash") == SOURCE_HASH then
    print(PACKAGE .. " already installed and calibrated")
    return
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
for _, p in ipairs(markers) do p:Destroy() end
if #src:GetDescendants() == 0 then src:Destroy() else src.Name = PACKAGE .. "_ImportRemainder_" .. os.time(); src.Parent = backup end
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
