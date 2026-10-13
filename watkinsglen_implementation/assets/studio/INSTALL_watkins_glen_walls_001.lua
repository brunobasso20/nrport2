-- Generated Watkins Glen visual installer: watkins_glen_walls_001.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_walls_001"
local KIND = "walls"
local SOURCE_HASH = "db0290021f4cd3948d993825ef8c9ade6e1fa6fcbe6e85659383d81064ebdbd4"
local GEOMETRIES = {
    {name="G000_wall_006_02_00_2",center=Vector3.new(1244.139045,26.422607,2755.029079),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G001_wall_006_02_01_0",center=Vector3.new(1216.446686,25.067424,2836.933899),opacity=1.0,blend=false,texture="trackmat__armco_p"},
    {name="G002_wall_006_02_01_1",center=Vector3.new(1216.614423,26.978151,2837.035915),opacity=1.0,blend=false,texture="trackmat__armco_p_top"},
    {name="G003_wall_006_02_01_2",center=Vector3.new(1216.761017,25.067437,2837.097168),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G004_wall_cap_006_02_3",center=Vector3.new(1252.473668,27.12167,2711.427416),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G005_wall_006_03_00_0",center=Vector3.new(1230.067934,29.212928,2795.209612),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G006_wall_006_03_00_2",center=Vector3.new(1230.392511,29.212928,2795.326233),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G007_wall_profile_006_03_00_0",center=Vector3.new(1229.962594,35.075094,2795.199149),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G008_wall_profile_006_03_00_0",center=Vector3.new(1229.536928,36.168844,2795.096043),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G009_wall_profile_006_03_00_0",center=Vector3.new(1228.712681,37.245853,2794.842638),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G010_wall_profile_006_03_00_0",center=Vector3.new(1227.550888,37.937817,2794.460842),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G011_wall_profile_006_03_00_2",center=Vector3.new(1230.28717,35.075094,2795.315661),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G012_wall_profile_006_03_00_2",center=Vector3.new(1229.86145,36.168844,2795.212664),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G013_wall_profile_006_03_00_2",center=Vector3.new(1229.037258,37.245853,2794.959368),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G014_wall_profile_006_03_00_2",center=Vector3.new(1227.87541,37.937817,2794.577462),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G015_wall_profile_top_006_03_",center=Vector3.new(1227.000264,38.141499,2794.145421),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G016_wall_007_00_00_0",center=Vector3.new(928.515625,21.38096,2689.324406),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G017_wall_007_00_00_1",center=Vector3.new(928.662218,23.299514,2689.458684),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G018_wall_007_00_00_2",center=Vector3.new(928.779984,21.393079,2689.560699),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G019_wall_007_01_00_0",center=Vector3.new(955.244936,22.600217,2713.369424),opacity=1.0,blend=false,texture="trackmat__armco_r02"},
    {name="G020_wall_007_01_00_1",center=Vector3.new(955.39153,24.509273,2713.503701),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G021_wall_007_01_00_2",center=Vector3.new(955.509295,22.598559,2713.605717),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G022_wall_007_02_00_0",center=Vector3.new(1175.926263,24.031326,2901.368931),opacity=1.0,blend=false,texture="trackmat__armco_p"},
    {name="G023_wall_007_02_00_1",center=Vector3.new(1176.072856,25.94204,2901.498304),opacity=1.0,blend=false,texture="trackmat__armco_p_top"},
    {name="G024_wall_007_02_00_2",center=Vector3.new(1176.195962,24.031443,2901.60032),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G025_wall_007_02_01_0",center=Vector3.new(1149.268014,23.510825,2932.044438),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G026_wall_007_02_01_1",center=Vector3.new(1149.39112,25.421657,2932.178715),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G027_wall_007_02_01_2",center=Vector3.new(1149.50883,23.510942,2932.308088),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G028_wall_007_03_00_0",center=Vector3.new(1175.565829,27.337256,2910.308511),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G029_wall_007_03_00_2",center=Vector3.new(1175.830133,27.337256,2910.544695),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G030_wall_profile_007_03_00_0",center=Vector3.new(1175.481197,33.199423,2910.23516),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G031_wall_profile_007_03_00_0",center=Vector3.new(1175.136675,34.293171,2909.931619),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G032_wall_profile_007_03_00_0",center=Vector3.new(1174.467305,35.37018,2909.336962),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G033_wall_profile_007_03_00_0",center=Vector3.new(1173.522568,36.062144,2908.495876),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G034_wall_profile_007_03_00_2",center=Vector3.new(1175.745501,33.199423,2910.471453),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G035_wall_profile_007_03_00_2",center=Vector3.new(1175.401034,34.293171,2910.167803),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G036_wall_profile_007_03_00_2",center=Vector3.new(1174.731609,35.37018,2909.573255),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G037_wall_profile_007_03_00_2",center=Vector3.new(1173.786926,36.062144,2908.73206),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G038_wall_profile_top_007_03_",center=Vector3.new(1173.069055,36.265828,2908.08051),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G039_wall_008_00_00_0",center=Vector3.new(927.180372,21.254426,2690.937805),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G040_wall_008_00_00_1",center=Vector3.new(927.298137,23.16942,2691.099766),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G041_wall_008_00_00_2",center=Vector3.new(927.373178,21.259083,2691.234044),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G042_wall_008_01_00_0",center=Vector3.new(947.953905,21.742848,2723.30355),opacity=1.0,blend=false,texture="trackmat__armco_r02"},
    {name="G043_wall_008_01_00_1",center=Vector3.new(948.071671,23.648754,2723.46562),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G044_wall_008_01_00_2",center=Vector3.new(948.146711,21.735841,2723.599788),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G045_wall_008_02_00_0",center=Vector3.new(1104.764666,22.824919,2964.216178),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G046_wall_008_02_00_1",center=Vector3.new(1104.882377,24.735633,2964.378248),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G047_wall_008_02_00_2",center=Vector3.new(1104.957417,22.824918,2964.512525),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G048_wall_008_03_00_0",center=Vector3.new(1108.36198,26.271336,2969.592067),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G049_wall_008_03_00_2",center=Vector3.new(1108.554731,26.271335,2969.888415),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G050_wall_profile_008_03_00_0",center=Vector3.new(1108.308084,32.133499,2969.49561),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G051_wall_profile_008_03_00_0",center=Vector3.new(1108.071027,33.22725,2969.106402),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G052_wall_profile_008_03_00_0",center=Vector3.new(1107.595062,34.30426,2968.353598),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G053_wall_profile_008_03_00_0",center=Vector3.new(1106.916264,34.996229,2967.292459),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G054_wall_profile_008_03_00_2",center=Vector3.new(1108.50078,32.133499,2969.791848),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G055_wall_profile_008_03_00_2",center=Vector3.new(1108.263779,33.22725,2969.40264),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G056_wall_profile_008_03_00_2",center=Vector3.new(1107.787813,34.30426,2968.649728),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G057_wall_profile_008_03_00_2",center=Vector3.new(1107.109015,34.996227,2967.588806),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G058_wall_profile_top_008_03_",center=Vector3.new(1106.552015,35.199913,2966.791098),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G059_wall_009_00_00_0",center=Vector3.new(925.465993,21.115574,2692.488752),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G060_wall_009_00_00_1",center=Vector3.new(925.541033,23.02375,2692.664337),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G061_wall_009_00_00_2",center=Vector3.new(925.573621,21.113036,2692.826298),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G062_wall_009_01_00_0",center=Vector3.new(937.973131,20.800733,2732.408142),opacity=1.0,blend=false,texture="trackmat__armco_r02"},
    {name="G063_wall_009_01_00_1",center=Vector3.new(938.048172,22.704962,2732.583727),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G064_wall_009_01_00_2",center=Vector3.new(938.080706,20.789446,2732.745797),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G065_wall_009_02_00_0",center=Vector3.new(1024.160276,21.263507,3002.539062),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G066_wall_009_02_00_1",center=Vector3.new(1024.910573,22.656348,3004.294913),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G067_wall_009_02_00_2",center=Vector3.new(1025.236239,21.263484,3005.915397),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G068_wall_cap_009_02_3",center=Vector3.new(1064.541299,21.761662,2990.19056),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G069_wall_009_03_00_0",center=Vector3.new(1025.207302,21.781342,3005.837141),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G070_wall_009_03_00_1",center=Vector3.new(1025.282342,23.692054,3006.012726),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G071_wall_009_03_00_2",center=Vector3.new(1025.314876,21.781339,3006.174796),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G072_wall_009_04_00_0",center=Vector3.new(1027.001408,25.227729,3011.470904),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G073_wall_009_04_00_2",center=Vector3.new(1027.108983,25.227727,3011.808559),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G074_wall_profile_009_04_00_0",center=Vector3.new(1026.977975,31.089895,3011.354501),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G075_wall_profile_009_04_00_0",center=Vector3.new(1026.857976,32.183647,3010.899135),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G076_wall_profile_009_04_00_0",center=Vector3.new(1026.602718,33.260662,3010.031019),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G077_wall_profile_009_04_00_0",center=Vector3.new(1026.232638,33.952635,3008.813586),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G078_wall_profile_009_04_00_2",center=Vector3.new(1027.085604,31.089893,3011.692047),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G079_wall_profile_009_04_00_2",center=Vector3.new(1026.965496,32.183645,3011.236681),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G080_wall_profile_009_04_00_2",center=Vector3.new(1026.710347,33.260659,3010.368674),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G081_wall_profile_009_04_00_2",center=Vector3.new(1026.340158,33.952631,3009.151023),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G082_wall_profile_top_009_04_",center=Vector3.new(1026.000486,34.156322,3008.270373),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G083_wall_010_00_00_0",center=Vector3.new(922.583989,20.865169,2694.422259),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G084_wall_010_00_00_1",center=Vector3.new(922.581264,22.769075,2694.597299),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G085_wall_010_00_00_2",center=Vector3.new(922.581264,20.855445,2694.772884),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G086_wall_010_01_00_0",center=Vector3.new(921.29037,19.487239,2742.189789),opacity=1.0,blend=false,texture="trackmat__armco_r02"},
    {name="G087_wall_010_01_00_1",center=Vector3.new(921.287618,21.389877,2742.364829),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G088_wall_010_01_00_2",center=Vector3.new(921.287618,19.472677,2742.540414),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G089_wall_010_02_00_0",center=Vector3.new(919.932747,20.385517,3020.394788),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G090_wall_010_02_00_1",center=Vector3.new(919.905554,21.774029,3022.179522),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G091_wall_010_03_00_0",center=Vector3.new(919.908387,20.899111,3023.875536),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G092_wall_010_03_00_1",center=Vector3.new(919.905635,22.809392,3024.054064),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G093_wall_010_03_00_2",center=Vector3.new(919.905635,20.898676,3024.229649),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G094_wall_010_04_00_0",center=Vector3.new(919.826344,24.337851,3029.897853),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G095_wall_010_04_00_2",center=Vector3.new(919.823647,24.337416,3030.251748),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G096_wall_profile_010_04_00_0",center=Vector3.new(919.826344,30.199971,3029.771641),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G097_wall_profile_010_04_00_0",center=Vector3.new(919.828033,31.294029,3029.287393),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G098_wall_profile_010_04_00_0",center=Vector3.new(919.83332,32.371919,3028.371538),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G099_wall_profile_010_04_00_0",center=Vector3.new(919.84163,33.065253,3027.090127),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G100_wall_profile_010_04_00_2",center=Vector3.new(919.823647,30.199535,3030.125645),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G101_wall_profile_010_04_00_2",center=Vector3.new(919.825336,31.293595,3029.641397),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G102_wall_profile_010_04_00_2",center=Vector3.new(919.830567,32.371484,3028.725542),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G103_wall_profile_010_04_00_2",center=Vector3.new(919.838933,33.064818,3027.444131),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G104_wall_profile_top_010_04_",center=Vector3.new(919.849941,33.270276,3026.538195),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G105_wall_011_00_00_0",center=Vector3.new(894.38343,18.387588,2710.444859),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G106_wall_011_00_00_1",center=Vector3.new(894.348145,20.292022,2710.619899),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G107_wall_011_00_00_2",center=Vector3.new(894.312831,18.3745,2710.794939),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G108_wall_011_01_00_0",center=Vector3.new(884.311186,17.148428,2760.409873),opacity=1.0,blend=false,texture="trackmat__armco_r02"},
    {name="G109_wall_011_01_00_1",center=Vector3.new(884.2759,19.057781,2760.584913),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G110_wall_011_01_00_2",center=Vector3.new(884.240614,17.138991,2760.759953),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G111_wall_cap_011_01_4",center=Vector3.new(858.550017,15.650117,2772.869001),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G112_wall_011_02_00_0",center=Vector3.new(834.79211,19.564663,3006.058938),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G113_wall_011_02_00_1",center=Vector3.new(834.438542,20.954218,3007.811955),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G114_wall_011_03_00_0",center=Vector3.new(834.096691,20.075016,3009.507751),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G115_wall_011_03_00_1",center=Vector3.new(834.061405,21.985401,3009.682792),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G116_wall_011_03_00_2",center=Vector3.new(834.026119,20.074253,3009.857832),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G117_wall_011_04_00_0",center=Vector3.new(832.823345,23.50769,3015.827288),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G118_wall_011_04_00_2",center=Vector3.new(832.752773,23.506926,3016.177368),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G119_wall_profile_011_04_00_0",center=Vector3.new(832.845906,29.370133,3015.712084),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G120_wall_profile_011_04_00_0",center=Vector3.new(832.942472,30.464995,3015.233067),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G121_wall_profile_011_04_00_0",center=Vector3.new(833.125087,31.544031,3014.327131),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G122_wall_profile_011_04_00_0",center=Vector3.new(833.380645,32.238805,3013.059671),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G123_wall_profile_011_04_00_2",center=Vector3.new(832.775334,29.369371,3016.062164),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G124_wall_profile_011_04_00_2",center=Vector3.new(832.8719,30.46423,3015.583147),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G125_wall_profile_011_04_00_2",center=Vector3.new(833.054515,31.54327,3014.677429),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G126_wall_profile_011_04_00_2",center=Vector3.new(833.310073,32.238044,3013.409751),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G127_wall_profile_top_011_04_",center=Vector3.new(833.489745,32.443506,3012.518638),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G128_wall_012_00_00_0",center=Vector3.new(855.88883,15.449549,2731.748744),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G129_wall_012_00_00_1",center=Vector3.new(855.853544,17.360264,2731.923785),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G130_wall_012_00_00_2",center=Vector3.new(855.818258,15.44353,2732.098825),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G131_wall_012_01_00_0",center=Vector3.new(804.505675,18.878835,2986.6442),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G132_wall_012_01_00_1",center=Vector3.new(804.152298,20.268715,2988.396999),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G133_wall_012_02_00_0",center=Vector3.new(803.800855,19.390441,2990.140206),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G134_wall_012_02_00_1",center=Vector3.new(803.765569,21.300858,2990.315247),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G135_wall_012_02_00_2",center=Vector3.new(803.730283,19.389814,2990.490287),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G136_wall_012_03_00_0",center=Vector3.new(802.536992,22.825623,2996.410915),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G137_wall_012_03_00_2",center=Vector3.new(802.46642,22.824996,2996.760995),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G138_wall_profile_012_03_00_0",center=Vector3.new(802.560207,28.688001,2996.294621),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G139_wall_profile_012_03_00_0",center=Vector3.new(802.656855,29.782627,2995.815168),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G140_wall_profile_012_03_00_0",center=Vector3.new(802.839552,30.861274,2994.909014),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G141_wall_profile_012_03_00_0",center=Vector3.new(803.095136,31.555523,2993.641009),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G142_wall_profile_012_03_00_2",center=Vector3.new(802.489635,28.687373,2996.64481),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G143_wall_profile_012_03_00_2",center=Vector3.new(802.586283,29.782002,2996.165248),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G144_wall_profile_012_03_00_2",center=Vector3.new(802.76898,30.860649,2995.259094),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G145_wall_profile_012_03_00_2",center=Vector3.new(803.024564,31.554895,2993.991198),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G146_wall_profile_top_012_03_",center=Vector3.new(803.204264,31.760124,2993.099867),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G147_wall_013_00_00_0",center=Vector3.new(829.361561,14.586807,2742.160906),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G148_wall_013_00_00_1",center=Vector3.new(829.326275,16.497782,2742.335946),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G149_wall_013_00_00_2",center=Vector3.new(829.290989,14.591968,2742.510986),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
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
