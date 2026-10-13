-- Generated Watkins Glen visual installer: watkins_glen_walls_002.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_walls_002"
local KIND = "walls"
local SOURCE_HASH = "4f897b2be7545b0da102d8b35614c44d25d2a15f1b266bd1f731952da6f4e63c"
local GEOMETRIES = {
    {name="G000_wall_013_01_00_0",center=Vector3.new(782.791601,18.320301,2973.179844),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G001_wall_013_01_00_1",center=Vector3.new(782.438278,19.710829,2974.932098),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G002_wall_013_02_00_0",center=Vector3.new(782.090269,18.832892,2976.658412),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G003_wall_013_02_00_1",center=Vector3.new(782.054983,20.743373,2976.833452),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G004_wall_013_02_00_2",center=Vector3.new(782.019697,18.832362,2977.008493),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G005_wall_013_03_00_0",center=Vector3.new(780.906051,22.27038,2982.534681),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G006_wall_013_03_00_2",center=Vector3.new(780.835479,22.26985,2982.88487),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G007_wall_profile_013_03_00_0",center=Vector3.new(780.929484,28.132743,2982.416425),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G008_wall_profile_013_03_00_0",center=Vector3.new(781.026241,29.227259,2981.936537),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G009_wall_profile_013_03_00_0",center=Vector3.new(781.208965,30.305675,2981.030164),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G010_wall_profile_013_03_00_0",center=Vector3.new(781.464604,30.999587,2979.76205),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G011_wall_profile_013_03_00_2",center=Vector3.new(780.858912,28.132214,2982.766506),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G012_wall_profile_013_03_00_2",center=Vector3.new(780.955642,29.226731,2982.286726),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G013_wall_profile_013_03_00_2",center=Vector3.new(781.138366,30.305145,2981.380245),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G014_wall_profile_013_03_00_2",center=Vector3.new(781.394032,30.999058,2980.11213),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G015_wall_profile_top_013_03_",center=Vector3.new(781.573732,31.203989,2979.220799),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G016_wall_014_00_00_0",center=Vector3.new(788.662257,14.384446,2746.34552),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G017_wall_014_00_00_1",center=Vector3.new(788.626971,16.299105,2746.52056),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G018_wall_014_00_00_2",center=Vector3.new(788.591685,14.393765,2746.6956),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G019_wall_014_01_00_0",center=Vector3.new(747.410583,17.348062,2950.982557),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G020_wall_014_01_00_1",center=Vector3.new(747.05737,18.739718,2952.733939),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G021_wall_014_01_00_2",center=Vector3.new(746.704837,17.344536,2954.483577),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G022_wall_cap_014_01_4",center=Vector3.new(723.648916,16.688338,2938.003649),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G023_wall_014_02_00_0",center=Vector3.new(746.712194,17.862443,2954.446193),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G024_wall_014_02_00_1",center=Vector3.new(746.676908,19.773037,2954.621233),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G025_wall_014_02_00_2",center=Vector3.new(746.641622,17.862089,2954.796273),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G026_wall_014_03_00_0",center=Vector3.new(745.620292,21.303334,2959.866006),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G027_wall_014_03_00_2",center=Vector3.new(745.54972,21.302981,2960.216086),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G028_wall_profile_014_03_00_0",center=Vector3.new(745.644161,27.165662,2959.744045),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G029_wall_profile_014_03_00_0",center=Vector3.new(745.740999,28.259967,2959.263829),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G030_wall_profile_014_03_00_0",center=Vector3.new(745.923805,29.337954,2958.356694),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G031_wall_profile_014_03_00_0",center=Vector3.new(746.179526,30.031245,2957.08847),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G032_wall_profile_014_03_00_2",center=Vector3.new(745.573562,27.165309,2960.094125),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G033_wall_profile_014_03_00_2",center=Vector3.new(745.6704,28.259615,2959.613909),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G034_wall_profile_014_03_00_2",center=Vector3.new(745.853233,29.3376,2958.706774),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G035_wall_profile_014_03_00_2",center=Vector3.new(746.108954,30.030894,2957.438551),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G036_wall_profile_top_014_03_",center=Vector3.new(746.288681,30.235301,2956.54711),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G037_wall_015_00_00_0",center=Vector3.new(739.289529,14.594715,2745.08558),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G038_wall_015_00_00_1",center=Vector3.new(739.254243,16.50571,2745.26062),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G039_wall_015_00_00_2",center=Vector3.new(739.218957,14.598941,2745.43566),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G040_wall_015_01_00_0",center=Vector3.new(704.667119,16.600966,2916.836112),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G041_wall_015_01_00_1",center=Vector3.new(704.631833,18.511629,2917.011152),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G042_wall_015_01_00_2",center=Vector3.new(704.596547,16.600795,2917.186192),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G043_wall_015_02_00_0",center=Vector3.new(703.586224,20.044804,2922.200121),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G044_wall_015_02_00_2",center=Vector3.new(703.515652,20.044633,2922.550201),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G045_wall_profile_015_02_00_0",center=Vector3.new(703.610829,25.907054,2922.075871),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G046_wall_profile_015_02_00_0",center=Vector3.new(703.70775,27.001085,2921.594892),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G047_wall_profile_015_02_00_0",center=Vector3.new(703.890691,28.078574,2920.68743),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G048_wall_profile_015_02_00_0",center=Vector3.new(704.146494,28.771192,2919.418662),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G049_wall_profile_015_02_00_2",center=Vector3.new(703.540257,25.906883,2922.425951),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G050_wall_profile_015_02_00_2",center=Vector3.new(703.637178,27.000913,2921.945081),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G051_wall_profile_015_02_00_2",center=Vector3.new(703.82012,28.078404,2921.037619),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G052_wall_profile_015_02_00_2",center=Vector3.new(704.075922,28.771022,2919.768742),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G053_wall_profile_top_015_02_",center=Vector3.new(704.255649,28.975034,2918.877302),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G054_wall_016_00_00_0",center=Vector3.new(670.459257,14.08237,2739.996447),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G055_wall_016_00_00_1",center=Vector3.new(670.423971,15.993145,2740.171487),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G056_wall_016_00_00_2",center=Vector3.new(670.388685,14.08243,2740.346636),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G057_wall_016_01_00_0",center=Vector3.new(648.687335,14.737937,2848.000009),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G058_wall_016_01_00_1",center=Vector3.new(648.652022,16.648652,2848.175049),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G059_wall_016_01_00_2",center=Vector3.new(648.616736,14.737897,2848.350089),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G060_wall_016_02_00_0",center=Vector3.new(647.610092,18.183716,2853.344945),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G061_wall_016_02_00_2",center=Vector3.new(647.53952,18.183676,2853.695025),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G062_wall_profile_016_02_00_0",center=Vector3.new(647.635187,24.045918,2853.21906),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G063_wall_profile_016_02_00_0",center=Vector3.new(647.73219,25.139764,2852.737863),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G064_wall_profile_016_02_00_0",center=Vector3.new(647.915241,26.216912,2851.829856),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G065_wall_profile_016_02_00_0",center=Vector3.new(648.171071,26.909052,2850.560869),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G066_wall_profile_016_02_00_2",center=Vector3.new(647.564616,24.045878,2853.56914),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G067_wall_profile_016_02_00_2",center=Vector3.new(647.661618,25.139724,2853.087943),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G068_wall_profile_016_02_00_2",center=Vector3.new(647.844669,26.216871,2852.180045),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G069_wall_profile_016_02_00_2",center=Vector3.new(648.100499,26.909012,2850.911059),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G070_wall_profile_top_016_02_",center=Vector3.new(648.280225,27.112691,2850.0194),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G071_wall_017_00_00_0",center=Vector3.new(398.667683,8.177547,2690.054648),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G072_wall_017_00_00_1",center=Vector3.new(398.632397,10.088261,2690.229688),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G073_wall_017_01_00_0",center=Vector3.new(398.601007,8.177543,2690.385437),opacity=1.0,blend=false,texture="trackmat__tires_02"},
    {name="G074_wall_017_01_00_1",center=Vector3.new(398.318706,10.088258,2691.785758),opacity=1.0,blend=false,texture="trackmat__tires_top"},
    {name="G075_wall_017_01_00_2",center=Vector3.new(398.036391,8.177512,2693.186188),opacity=1.0,blend=false,texture="trackmat__tires"},
    {name="G076_wall_cap_017_01_3",center=Vector3.new(624.214309,13.478777,2738.199071),opacity=1.0,blend=false,texture="trackmat__tires_near"},
    {name="G077_wall_cap_017_01_4",center=Vector3.new(172.42309,2.876278,2645.372554),opacity=1.0,blend=false,texture="trackmat__tires_far"},
    {name="G078_wall_017_02_00_0",center=Vector3.new(385.440602,8.177583,2755.669948),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G079_wall_017_02_00_1",center=Vector3.new(385.405316,10.088308,2755.844988),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G080_wall_017_02_00_2",center=Vector3.new(385.370002,8.177594,2756.020028),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G081_wall_018_00_00_0",center=Vector3.new(101.113396,1.621545,2628.875078),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G082_wall_018_00_00_1",center=Vector3.new(101.078108,3.53209,2629.051862),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G083_wall_018_00_00_2",center=Vector3.new(101.042816,1.621378,2629.225159),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G084_wall_018_01_00_0",center=Vector3.new(88.339834,2.393467,2692.242323),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G085_wall_018_01_00_1",center=Vector3.new(88.304546,4.304182,2692.417363),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G086_wall_018_01_00_2",center=Vector3.new(88.26926,2.393468,2692.592403),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G087_wall_019_00_00_0",center=Vector3.new(-96.167219,2.753995,2543.709019),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G088_wall_019_00_00_1",center=Vector3.new(-96.297501,4.662725,2543.897683),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G089_wall_019_00_00_2",center=Vector3.new(-96.332431,2.750236,2544.006566),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G090_wall_019_01_00_0",center=Vector3.new(-125.109515,5.028022,2595.760781),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G091_wall_019_01_00_1",center=Vector3.new(-125.239446,6.938583,2595.935822),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G092_wall_019_01_00_2",center=Vector3.new(-125.274734,5.027869,2596.058328),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G093_wall_020_00_00_0",center=Vector3.new(-284.276533,18.160522,2339.271545),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G094_wall_020_00_00_1",center=Vector3.new(-284.468167,20.069084,2339.394161),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G095_wall_020_00_00_2",center=Vector3.new(-284.583718,18.158632,2339.415741),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G096_wall_020_01_00_0",center=Vector3.new(-338.92968,20.565817,2364.6395),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G097_wall_020_01_00_1",center=Vector3.new(-339.106928,22.476532,2364.762006),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G098_wall_020_01_00_2",center=Vector3.new(-339.236859,20.56586,2364.783587),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G099_wall_021_00_00_0",center=Vector3.new(-339.291382,38.817109,2119.291469),opacity=1.0,blend=false,texture="trackmat__tires_left"},
    {name="G100_wall_021_00_00_1",center=Vector3.new(-340.620804,40.602488,2119.453757),opacity=1.0,blend=false,texture="trackmat__tires_top"},
    {name="G101_wall_021_00_00_2",center=Vector3.new(-341.950226,38.816774,2119.616045),opacity=1.0,blend=false,texture="trackmat__tires_left"},
    {name="G102_wall_cap_021_00_3",center=Vector3.new(-344.639519,30.925376,2204.938507),opacity=1.0,blend=false,texture="trackmat__tires_near"},
    {name="G103_wall_cap_021_00_4",center=Vector3.new(-336.601639,46.708507,2033.969007),opacity=1.0,blend=false,texture="trackmat__tires_far"},
    {name="G104_wall_021_01_00_0",center=Vector3.new(-356.11996,38.941664,2121.345084),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G105_wall_021_01_00_1",center=Vector3.new(-356.297684,40.852334,2121.366664),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G106_wall_021_01_00_2",center=Vector3.new(-356.474468,38.94162,2121.388245),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G107_wall_cap_021_01_4",center=Vector3.new(-365.628038,46.833495,2037.510899),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G108_wall_021_02_00_0",center=Vector3.new(-419.784219,39.905863,2129.113552),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G109_wall_021_02_00_1",center=Vector3.new(-419.96148,41.816579,2129.135132),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G110_wall_021_02_00_2",center=Vector3.new(-420.138727,39.905865,2129.156821),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G111_wall_021_03_00_0",center=Vector3.new(-486.578287,41.566713,2137.264034),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G112_wall_021_03_00_2",center=Vector3.new(-486.932809,41.566714,2137.307194),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G113_wall_022_00_00_0",center=Vector3.new(-365.024131,54.280635,1952.987126),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G114_wall_022_00_00_1",center=Vector3.new(-365.201391,56.191349,1953.008815),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G115_wall_022_00_00_2",center=Vector3.new(-365.378639,54.280635,1953.030504),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G116_wall_cap_022_00_3",center=Vector3.new(-336.601652,46.833508,2033.969007),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G117_wall_022_01_00_0",center=Vector3.new(-439.195401,53.442883,1962.037877),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G118_wall_022_01_00_1",center=Vector3.new(-439.372662,55.354854,1962.059566),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G119_wall_022_01_00_2",center=Vector3.new(-439.549923,53.444142,1962.081146),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G120_wall_022_02_00_0",center=Vector3.new(-504.904529,55.33425,1970.055934),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G121_wall_022_02_00_2",center=Vector3.new(-505.259051,55.335508,1970.099095),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G122_wall_023_00_00_0",center=Vector3.new(-441.103159,71.251052,1735.02655),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G123_wall_023_00_00_1",center=Vector3.new(-441.255011,73.161766,1735.048458),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G124_wall_023_00_00_2",center=Vector3.new(-441.432272,71.251021,1735.14219),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G125_wall_023_01_00_0",center=Vector3.new(-493.423476,69.320978,1753.558568),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G126_wall_023_01_00_1",center=Vector3.new(-493.575355,71.231692,1753.580148),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G127_wall_023_01_00_2",center=Vector3.new(-493.752616,69.321942,1753.674098),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G128_wall_023_02_00_0",center=Vector3.new(-558.606693,71.149475,1777.730833),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G129_wall_023_02_00_2",center=Vector3.new(-558.935819,71.150439,1777.846364),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G130_wall_024_00_00_0",center=Vector3.new(-575.828062,86.863538,1502.81274),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G131_wall_024_00_00_1",center=Vector3.new(-575.932394,88.774477,1502.906636),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G132_wall_024_00_00_2",center=Vector3.new(-576.085554,86.863763,1503.050613),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G133_wall_024_01_00_0",center=Vector3.new(-617.792538,84.4344,1541.791207),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G134_wall_024_01_00_1",center=Vector3.new(-617.898178,86.34572,1541.885158),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G135_wall_024_01_00_2",center=Vector3.new(-618.050058,84.435007,1542.029136),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G136_wall_024_02_00_0",center=Vector3.new(-622.8805,88.608459,1546.586173),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G137_wall_024_02_00_2",center=Vector3.new(-623.138019,88.609065,1546.824047),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G138_wall_profile_024_02_00_0",center=Vector3.new(-622.848538,94.798776,1546.564375),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G139_wall_profile_024_02_00_0",center=Vector3.new(-622.675541,95.27406,1546.399798),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G140_wall_profile_024_02_00_0",center=Vector3.new(-622.138269,96.224192,1545.895059),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G141_wall_profile_024_02_00_2",center=Vector3.new(-623.106057,94.799379,1546.802248),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G142_wall_profile_024_02_00_2",center=Vector3.new(-622.933061,95.274666,1546.637671),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G143_wall_profile_024_02_00_2",center=Vector3.new(-622.395761,96.224798,1546.132932),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G144_wall_profile_top_024_02_",center=Vector3.new(-621.944782,96.820855,1545.725087),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G145_wall_024_03_00_0",center=Vector3.new(-682.506507,86.30475,1605.667986),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G146_wall_024_03_00_2",center=Vector3.new(-682.764026,86.305356,1605.905914),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G147_wall_025_00_00_0",center=Vector3.new(-717.496409,94.068578,1362.996619),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G148_wall_025_00_00_1",center=Vector3.new(-717.61292,95.979834,1363.138362),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G149_wall_025_00_00_2",center=Vector3.new(-717.722511,94.069379,1363.272422),opacity=1.0,blend=false,texture="trackmat__armco_l"},
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
