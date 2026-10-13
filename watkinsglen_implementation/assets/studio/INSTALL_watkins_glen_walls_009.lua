-- Generated Watkins Glen visual installer: watkins_glen_walls_009.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_walls_009"
local KIND = "walls"
local SOURCE_HASH = "116076457691478ed063c989b36f1b7547a91d0d365be21331818d395dd30964"
local GEOMETRIES = {
    {name="G000_wall_103_02_00_2",center=Vector3.new(1124.745778,92.46473,-15.66806),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G001_wall_profile_103_02_00_0",center=Vector3.new(1124.594498,98.326894,-15.20739),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G002_wall_profile_103_02_00_0",center=Vector3.new(1124.442291,99.420643,-14.741686),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G003_wall_profile_103_02_00_0",center=Vector3.new(1124.153301,100.497651,-13.862598),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G004_wall_profile_103_02_00_0",center=Vector3.new(1123.748507,101.189613,-12.633716),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G005_wall_profile_103_02_00_2",center=Vector3.new(1124.706486,98.326894,-15.546507),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G006_wall_profile_103_02_00_2",center=Vector3.new(1124.55428,99.420643,-15.080803),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G007_wall_profile_103_02_00_2",center=Vector3.new(1124.265289,100.497651,-14.201716),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G008_wall_profile_103_02_00_2",center=Vector3.new(1123.860495,101.189617,-12.97283),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G009_wall_profile_top_103_02_",center=Vector3.new(1123.571123,101.393298,-12.107784),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G010_wall_104_00_00_0",center=Vector3.new(1110.715866,83.997808,79.455713),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G011_wall_104_00_00_1",center=Vector3.new(1110.797283,85.908515,79.286592),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G012_wall_104_00_00_2",center=Vector3.new(1110.855865,83.998057,79.12833),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G013_wall_104_01_00_0",center=Vector3.new(1143.421337,89.018147,3.038771),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G014_wall_104_01_00_1",center=Vector3.new(1143.504061,90.928861,2.869655),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G015_wall_104_01_00_2",center=Vector3.new(1143.56139,89.018147,2.711389),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G016_wall_104_02_00_0",center=Vector3.new(1147.533744,92.46458,-6.502013),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G017_wall_104_02_00_2",center=Vector3.new(1147.673743,92.46458,-6.829389),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G018_wall_profile_104_02_00_0",center=Vector3.new(1147.492545,98.326744,-6.388258),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G019_wall_profile_104_02_00_0",center=Vector3.new(1147.316633,99.420493,-5.945232),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G020_wall_profile_104_02_00_0",center=Vector3.new(1146.967643,100.497498,-5.102192),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G021_wall_profile_104_02_00_0",center=Vector3.new(1146.471895,101.189463,-3.920522),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G022_wall_profile_104_02_00_2",center=Vector3.new(1147.632544,98.326744,-6.715637),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G023_wall_profile_104_02_00_2",center=Vector3.new(1147.456687,99.420493,-6.272612),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G024_wall_profile_104_02_00_2",center=Vector3.new(1147.107697,100.497501,-5.429571),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G025_wall_profile_104_02_00_2",center=Vector3.new(1146.611949,101.189463,-4.247901),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G026_wall_profile_top_104_02_",center=Vector3.new(1146.216038,101.393148,-3.397316),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G027_wall_105_00_00_0",center=Vector3.new(1147.966712,83.445515,102.328147),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G028_wall_105_00_00_1",center=Vector3.new(1148.089872,85.356501,102.172531),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G029_wall_105_00_00_2",center=Vector3.new(1148.174994,83.446087,102.042934),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G030_wall_105_01_00_0",center=Vector3.new(1187.35624,89.031393,25.03752),opacity=1.0,blend=false,texture="trackmat__armco_p"},
    {name="G031_wall_105_01_00_1",center=Vector3.new(1187.468556,90.942107,24.879255),opacity=1.0,blend=false,texture="trackmat__armco_p_top"},
    {name="G032_wall_105_01_00_2",center=Vector3.new(1187.55128,89.031393,24.740392),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G033_wall_105_01_01_0",center=Vector3.new(1222.53952,89.049472,47.617165),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G034_wall_105_01_01_1",center=Vector3.new(1222.665078,90.960186,47.478301),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G035_wall_105_02_00_0",center=Vector3.new(1204.92788,92.482519,25.017191),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G036_wall_105_02_00_2",center=Vector3.new(1205.136163,92.482519,24.731982),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G037_wall_profile_105_02_00_0",center=Vector3.new(1204.868426,98.344684,25.108433),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G038_wall_profile_105_02_00_0",center=Vector3.new(1204.610171,99.438432,25.480052),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G039_wall_profile_105_02_00_0",center=Vector3.new(1204.094042,100.515441,26.202209),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G040_wall_profile_105_02_00_0",center=Vector3.new(1203.359059,101.207406,27.221427),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G041_wall_profile_105_02_00_2",center=Vector3.new(1205.076763,98.344684,24.823226),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G042_wall_profile_105_02_00_2",center=Vector3.new(1204.818453,99.438432,25.194843),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G043_wall_profile_105_02_00_2",center=Vector3.new(1204.302325,100.515441,25.917),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G044_wall_profile_105_02_00_2",center=Vector3.new(1203.567396,101.207406,26.93622),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G045_wall_profile_top_105_02_",center=Vector3.new(1202.970559,101.411091,27.711057),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G046_wall_106_00_00_0",center=Vector3.new(1192.947551,83.46077,152.22234),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G047_wall_106_00_00_1",center=Vector3.new(1193.109839,85.371811,152.097811),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G048_wall_106_00_00_2",center=Vector3.new(1193.238722,83.461424,152.028588),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G049_wall_106_01_00_0",center=Vector3.new(1260.662842,88.553313,106.741772),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G050_wall_106_01_00_1",center=Vector3.new(1262.318856,89.981883,105.472279),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G051_wall_106_01_00_2",center=Vector3.new(1263.574764,88.553344,104.804243),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G052_wall_cap_106_01_3",center=Vector3.new(1232.444273,88.572025,57.603049),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G053_wall_106_02_00_0",center=Vector3.new(1263.500159,89.035484,104.854626),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G054_wall_106_02_00_1",center=Vector3.new(1263.665771,90.946198,104.727677),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G055_wall_106_02_00_2",center=Vector3.new(1263.79133,89.035487,104.660879),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G056_wall_106_03_00_0",center=Vector3.new(1273.282078,92.482015,98.491875),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G057_wall_106_03_00_2",center=Vector3.new(1273.573303,92.482018,98.298122),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G058_wall_profile_106_03_00_0",center=Vector3.new(1273.191725,98.34418,98.539892),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G059_wall_profile_106_03_00_0",center=Vector3.new(1272.817612,99.437928,98.766829),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G060_wall_profile_106_03_00_0",center=Vector3.new(1272.084808,100.51493,99.235547),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G061_wall_profile_106_03_00_0",center=Vector3.new(1271.047974,101.206885,99.909711),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G062_wall_profile_106_03_00_2",center=Vector3.new(1273.482895,98.344183,98.34614),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G063_wall_profile_106_03_00_2",center=Vector3.new(1273.108782,99.437932,98.573085),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G064_wall_profile_106_03_00_2",center=Vector3.new(1272.376033,100.514933,99.041801),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G065_wall_profile_106_03_00_2",center=Vector3.new(1271.339199,101.206888,99.715958),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G066_wall_profile_top_106_03_",center=Vector3.new(1270.53566,101.410559,100.302461),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G067_wall_107_00_00_0",center=Vector3.new(1218.726785,83.96178,198.557929),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G068_wall_107_00_00_1",center=Vector3.new(1218.896321,85.872868,198.492473),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G069_wall_107_00_00_2",center=Vector3.new(1219.065911,83.962502,198.448999),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G070_wall_107_01_00_0",center=Vector3.new(1295.228195,88.537063,173.913424),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G071_wall_107_01_00_1",center=Vector3.new(1296.963501,89.965633,173.245396),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G072_wall_107_02_00_0",center=Vector3.new(1298.547145,89.01922,172.848354),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G073_wall_107_02_00_1",center=Vector3.new(1298.72066,90.929934,172.781556),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G074_wall_107_02_00_2",center=Vector3.new(1298.886272,89.01922,172.739424),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G075_wall_107_03_00_0",center=Vector3.new(1310.335159,92.465704,169.054597),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G076_wall_107_03_00_2",center=Vector3.new(1310.67434,92.465707,168.945667),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G077_wall_profile_107_03_00_0",center=Vector3.new(1310.216141,98.327868,169.084896),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G078_wall_profile_107_03_00_0",center=Vector3.new(1309.755053,99.42162,169.218479),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G079_wall_profile_107_03_00_0",center=Vector3.new(1308.879852,100.498625,169.487122),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G080_wall_profile_107_03_00_0",center=Vector3.new(1307.65419,101.190587,169.870417),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G081_wall_profile_107_03_00_2",center=Vector3.new(1310.555322,98.327872,168.975973),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G082_wall_profile_107_03_00_2",center=Vector3.new(1310.094179,99.42162,169.109549),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G083_wall_profile_107_03_00_2",center=Vector3.new(1309.218979,100.498629,169.378206),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G084_wall_profile_107_03_00_2",center=Vector3.new(1307.993371,101.190591,169.761494),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G085_wall_profile_top_107_03_",center=Vector3.new(1307.117353,101.394262,170.077092),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G086_wall_108_00_00_0",center=Vector3.new(1223.320007,84.236452,213.675949),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G087_wall_108_00_00_1",center=Vector3.new(1223.489761,86.147584,213.634791),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G088_wall_108_00_00_2",center=Vector3.new(1223.667799,84.237266,213.594784),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G089_wall_108_01_00_0",center=Vector3.new(1300.744247,88.54051,195.605837),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G090_wall_108_01_00_1",center=Vector3.new(1302.486747,89.969117,195.184599),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G091_wall_108_02_00_0",center=Vector3.new(1304.160854,89.022691,194.80849),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G092_wall_108_02_00_1",center=Vector3.new(1304.335131,90.933405,194.766372),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G093_wall_108_02_00_2",center=Vector3.new(1304.5087,89.022691,194.727332),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G094_wall_108_03_00_0",center=Vector3.new(1316.135352,92.469249,192.013768),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G095_wall_108_03_00_2",center=Vector3.new(1316.483143,92.469256,191.932603),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G096_wall_profile_108_03_00_0",center=Vector3.new(1316.010502,98.331411,192.041833),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G097_wall_profile_108_03_00_0",center=Vector3.new(1315.532793,99.425149,192.15141),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G098_wall_profile_108_03_00_0",center=Vector3.new(1314.631108,100.502144,192.360204),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G099_wall_profile_108_03_00_0",center=Vector3.new(1313.370677,101.194092,192.652975),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G100_wall_profile_108_03_00_2",center=Vector3.new(1316.358294,98.331414,191.960669),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G101_wall_profile_108_03_00_2",center=Vector3.new(1315.88053,99.425152,192.070253),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G102_wall_profile_108_03_00_2",center=Vector3.new(1314.978899,100.50215,192.279039),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G103_wall_profile_108_03_00_2",center=Vector3.new(1313.718523,101.194096,192.571817),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G104_wall_profile_top_108_03_",center=Vector3.new(1312.831606,101.397787,192.783294),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G105_wall_109_00_00_0",center=Vector3.new(1225.864683,84.71102,233.313533),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G106_wall_109_00_00_1",center=Vector3.new(1226.039396,86.622064,233.275502),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G107_wall_109_00_00_2",center=Vector3.new(1226.217433,84.7118,233.26852),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G108_wall_109_01_00_0",center=Vector3.new(1303.065872,88.915443,223.348658),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G109_wall_109_01_00_1",center=Vector3.new(1304.84908,90.344013,222.958265),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G110_wall_109_02_00_0",center=Vector3.new(1306.544985,89.397631,222.905711),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G111_wall_109_02_00_1",center=Vector3.new(1306.723295,91.308345,222.866685),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G112_wall_109_02_00_2",center=Vector3.new(1306.897572,89.397635,222.860704),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G113_wall_109_03_00_0",center=Vector3.new(1318.631199,92.844221,221.359607),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G114_wall_109_03_00_2",center=Vector3.new(1318.983786,92.844227,221.314587),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G115_wall_profile_109_03_00_0",center=Vector3.new(1318.505968,98.706385,221.363933),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G116_wall_profile_109_03_00_0",center=Vector3.new(1318.023845,99.80013,221.404123),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G117_wall_profile_109_03_00_0",center=Vector3.new(1317.111588,100.877132,221.502297),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G118_wall_profile_109_03_00_0",center=Vector3.new(1315.835462,101.56908,221.649981),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G119_wall_profile_109_03_00_2",center=Vector3.new(1318.858501,98.706392,221.318913),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G120_wall_profile_109_03_00_2",center=Vector3.new(1318.376378,99.800134,221.359117),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G121_wall_profile_109_03_00_2",center=Vector3.new(1317.464229,100.877135,221.457277),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G122_wall_profile_109_03_00_2",center=Vector3.new(1316.188049,101.569087,221.60496),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G123_wall_profile_top_109_03_",center=Vector3.new(1315.283748,101.772744,221.770763),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G124_wall_110_00_00_0",center=Vector3.new(1227.719225,85.331355,262.456076),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G125_wall_110_00_00_1",center=Vector3.new(1227.894974,87.242058,262.464891),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G126_wall_110_00_00_2",center=Vector3.new(1228.075681,85.331702,262.464769),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G127_wall_110_01_00_0",center=Vector3.new(1304.008484,89.429811,264.288861),opacity=1.0,blend=false,texture="trackmat__haybales_2"},
    {name="G128_wall_110_01_00_1",center=Vector3.new(1305.793217,90.858374,264.375646),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G129_wall_110_02_00_0",center=Vector3.new(1307.484981,89.91191,264.370142),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G130_wall_110_02_00_1",center=Vector3.new(1307.663509,91.822624,264.37882),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G131_wall_110_02_00_2",center=Vector3.new(1307.841437,89.911907,264.37882),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G132_wall_110_03_00_0",center=Vector3.new(1318.072074,93.358224,264.535618),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G133_wall_110_03_00_2",center=Vector3.new(1318.42853,93.35822,264.544296),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G134_wall_profile_110_03_00_0",center=Vector3.new(1317.944281,99.220392,264.535618),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G135_wall_profile_110_03_00_0",center=Vector3.new(1317.454583,100.314147,264.529392),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G136_wall_profile_110_03_00_0",center=Vector3.new(1316.530282,101.391169,264.511749),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G137_wall_profile_110_03_00_0",center=Vector3.new(1315.238462,102.083155,264.484378),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G138_wall_profile_110_03_00_2",center=Vector3.new(1318.300738,99.220388,264.544296),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G139_wall_profile_110_03_00_2",center=Vector3.new(1317.810985,100.314144,264.53807),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G140_wall_profile_110_03_00_2",center=Vector3.new(1316.886738,101.391166,264.520441),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G141_wall_profile_110_03_00_2",center=Vector3.new(1315.594918,102.083148,264.493043),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G142_wall_profile_top_110_03_",center=Vector3.new(1314.686312,102.286839,264.457512),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G143_wall_111_00_00_0",center=Vector3.new(1209.442466,87.688221,342.936093),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G144_wall_111_00_00_1",center=Vector3.new(1209.620394,89.598935,342.950753),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G145_wall_111_00_00_2",center=Vector3.new(1209.798377,87.688221,342.965412),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G146_wall_111_01_00_0",center=Vector3.new(1296.987425,89.820048,350.144059),opacity=1.0,blend=false,texture="trackmat__haybales_2"},
    {name="G147_wall_111_01_00_1",center=Vector3.new(1298.76709,91.248577,350.290598),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G148_wall_111_01_00_2",center=Vector3.new(1300.546755,89.819976,350.437137),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G149_wall_cap_111_01_4",center=Vector3.new(1292.644065,90.069836,420.558466),opacity=1.0,blend=false,texture="trackmat__haybales_side_2"},
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
