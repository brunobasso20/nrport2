-- Generated Watkins Glen visual installer: watkins_glen_terrain_029.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_terrain_029"
local KIND = "terrain"
local SOURCE_HASH = "ed3f849fd7318eb3bfa714742e404661b40ab4c614b96c122a1dafc2604e4f93"
local GEOMETRIES = {
    {name="G000_terrain_028_05",center=Vector3.new(-1366.247886,107.202193,598.88525),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G001_terrain_029_00",center=Vector3.new(-1028.692109,112.147069,212.476563),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G002_terrain_029_01_baked_f_0",center=Vector3.new(-1204.917962,110.234771,214.455567),opacity=1.0,blend=false,texture="baked_f_02255_00_00"},
    {name="G003_terrain_029_02",center=Vector3.new(-1208.915438,110.048349,214.504848),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G004_terrain_029_03",center=Vector3.new(-1230.865097,110.048587,214.761751),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G005_terrain_029_04",center=Vector3.new(-1253.043856,111.083797,215.020193),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G006_terrain_029_05",center=Vector3.new(-1398.373086,110.790277,216.71881),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G007_terrain_030_00",center=Vector3.new(-1038.588742,115.693368,-136.719033),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G008_terrain_030_01_baked_f_0",center=Vector3.new(-1208.51702,115.007663,-134.757975),opacity=1.0,blend=false,texture="baked_f_02295_00_00"},
    {name="G009_terrain_030_02",center=Vector3.new(-1212.909753,115.007659,-134.708592),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G010_terrain_030_03",center=Vector3.new(-1234.937777,115.007659,-134.450654),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G011_terrain_030_04",center=Vector3.new(-1257.080623,115.007901,-134.19199),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G012_terrain_030_05",center=Vector3.new(-1405.324282,115.008194,-132.497304),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G013_terrain_031_00",center=Vector3.new(-1045.956693,118.602153,-621.266229),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G014_terrain_031_01_baked_f_0",center=Vector3.new(-1212.419455,118.405274,-476.357446),opacity=1.0,blend=false,texture="baked_f_02335_00_00"},
    {name="G015_terrain_031_01_baked_f_0",center=Vector3.new(-1215.639959,119.568951,-762.413406),opacity=1.0,blend=false,texture="baked_f_02335_00_01"},
    {name="G016_terrain_031_02",center=Vector3.new(-1218.472672,118.602153,-619.335215),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G017_terrain_031_03",center=Vector3.new(-1240.589632,118.602153,-619.07583),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G018_terrain_031_04",center=Vector3.new(-1262.682778,118.602167,-618.817602),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G019_terrain_031_05",center=Vector3.new(-1407.865361,118.604524,-617.089721),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G020_terrain_032_00",center=Vector3.new(-983.318274,119.768851,-1172.862652),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G021_terrain_032_01_baked_f_0",center=Vector3.new(-1218.778774,119.768977,-1037.763895),opacity=1.0,blend=false,texture="baked_f_02374_00_00"},
    {name="G022_terrain_032_01_baked_f_0",center=Vector3.new(-1221.337128,119.770081,-1302.402823),opacity=1.0,blend=false,texture="baked_f_02374_00_01"},
    {name="G023_terrain_032_02",center=Vector3.new(-1224.772753,119.769566,-1170.023073),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G024_terrain_032_03",center=Vector3.new(-1247.010694,119.769566,-1169.763265),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G025_terrain_032_04",center=Vector3.new(-1269.017683,119.769566,-1169.505637),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G026_terrain_032_05",center=Vector3.new(-1418.645968,119.772938,-1167.814037),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G027_terrain_033_00",center=Vector3.new(-981.436702,119.758851,-1444.191633),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G028_terrain_033_01_baked_f_0",center=Vector3.new(-1222.073637,119.851201,-1441.385269),opacity=1.0,blend=false,texture="baked_f_02414_00_00"},
    {name="G029_terrain_033_02",center=Vector3.new(-1227.218519,119.863149,-1441.325215),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G030_terrain_033_03",center=Vector3.new(-1234.660612,119.770704,-1441.238403),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G031_terrain_033_04",center=Vector3.new(-1247.232819,119.770704,-1441.09181),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G032_terrain_033_05",center=Vector3.new(-1261.904962,119.770704,-1440.92162),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G033_terrain_033_06",center=Vector3.new(-1270.426069,119.770704,-1440.821293),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G034_terrain_033_07",center=Vector3.new(-1272.146988,119.770704,-1440.800858),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G035_terrain_033_08",center=Vector3.new(-1421.833474,119.770806,-1439.057214),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G036_terrain_034_00",center=Vector3.new(-979.463605,119.733947,-1457.817677),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G037_terrain_034_01_baked_f_0",center=Vector3.new(-1207.758168,119.722223,-1455.155182),opacity=1.0,blend=false,texture="baked_f_02464_00_00"},
    {name="G038_terrain_034_02",center=Vector3.new(-1211.661966,119.967556,-1455.109624),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G039_terrain_034_03",center=Vector3.new(-1226.869638,120.006589,-1454.932295),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G040_terrain_034_04",center=Vector3.new(-1232.751247,119.770724,-1454.863685),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G041_terrain_034_05",center=Vector3.new(-1243.484606,119.770724,-1454.738508),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G042_terrain_034_06",center=Vector3.new(-1260.177013,119.770724,-1454.544776),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G043_terrain_034_07",center=Vector3.new(-1270.586668,119.770724,-1454.422433),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G044_terrain_034_08",center=Vector3.new(-1272.270748,119.770724,-1454.402379),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G045_terrain_034_09",center=Vector3.new(-1422.074291,119.770779,-1452.657482),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G046_terrain_035_00",center=Vector3.new(-966.102982,119.690282,-1467.677089),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G047_terrain_035_01_baked_f_0",center=Vector3.new(-1190.25819,119.652551,-1465.062932),opacity=1.0,blend=false,texture="baked_f_02516_00_00"},
    {name="G048_terrain_035_02",center=Vector3.new(-1206.492833,119.939075,-1464.873614),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G049_terrain_035_03",center=Vector3.new(-1226.721028,120.025941,-1464.637702),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G050_terrain_035_04",center=Vector3.new(-1230.740847,119.770731,-1464.590781),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G051_terrain_035_05",center=Vector3.new(-1240.893991,119.770731,-1464.472362),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G052_terrain_035_06",center=Vector3.new(-1259.591402,119.770731,-1464.254761),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G053_terrain_035_07",center=Vector3.new(-1270.701817,119.770731,-1464.124734),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G054_terrain_035_08",center=Vector3.new(-1272.370039,119.770731,-1464.10517),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G055_terrain_035_09",center=Vector3.new(-1422.19865,119.770758,-1462.358693),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G056_terrain_036_00",center=Vector3.new(-960.59167,119.676617,-1472.290257),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G057_terrain_036_01_baked_f_0",center=Vector3.new(-1182.18629,119.595051,-1469.705909),opacity=1.0,blend=false,texture="baked_f_02568_00_00"},
    {name="G058_terrain_036_02",center=Vector3.new(-1203.080368,119.923346,-1469.462204),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G059_terrain_036_03",center=Vector3.new(-1226.038797,120.025975,-1469.194467),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G060_terrain_036_04",center=Vector3.new(-1229.699435,119.770731,-1469.151797),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G061_terrain_036_05",center=Vector3.new(-1239.586803,119.770731,-1469.036484),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G062_terrain_036_06",center=Vector3.new(-1259.075655,119.770731,-1468.8094),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G063_terrain_036_07",center=Vector3.new(-1270.755713,119.770731,-1468.672943),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G064_terrain_036_08",center=Vector3.new(-1272.402409,119.770731,-1468.653543),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G065_terrain_036_09",center=Vector3.new(-1422.267587,119.770752,-1466.906575),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G066_terrain_037_00",center=Vector3.new(-956.850706,119.676617,-1475.905555),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G067_terrain_037_01_baked_f_0",center=Vector3.new(-1175.671169,119.585725,-1473.353577),opacity=1.0,blend=false,texture="baked_f_02620_00_00"},
    {name="G068_terrain_037_02",center=Vector3.new(-1199.217769,119.921698,-1473.078973),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G069_terrain_037_03",center=Vector3.new(-1224.598476,120.026016,-1472.783007),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G070_terrain_037_04",center=Vector3.new(-1228.30974,119.770738,-1472.739683),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G071_terrain_037_05",center=Vector3.new(-1238.284411,119.770738,-1472.623335),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G072_terrain_037_06",center=Vector3.new(-1259.607261,119.770738,-1472.374943),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G073_terrain_037_07",center=Vector3.new(-1272.452545,119.770738,-1472.224971),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G074_terrain_037_08",center=Vector3.new(-1422.318377,119.770745,-1470.477295),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G075_terrain_038_00",center=Vector3.new(-952.024296,119.68097,-1483.380399),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G076_terrain_038_01_baked_f_0",center=Vector3.new(-1162.279347,119.640841,-1480.928312),opacity=1.0,blend=false,texture="baked_f_02669_00_00"},
    {name="G077_terrain_038_02",center=Vector3.new(-1187.868064,119.927195,-1480.629894),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G078_terrain_038_03",center=Vector3.new(-1219.496536,120.026023,-1480.261012),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G079_terrain_038_04",center=Vector3.new(-1223.674447,119.770745,-1480.212239),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G080_terrain_038_05",center=Vector3.new(-1234.839685,119.770745,-1480.082049),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G081_terrain_038_06",center=Vector3.new(-1257.642365,119.770745,-1479.816873),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G082_terrain_038_07",center=Vector3.new(-1272.496687,119.770745,-1479.642378),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G083_terrain_038_08",center=Vector3.new(-1422.50715,119.770738,-1477.894974),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G084_terrain_039_00",center=Vector3.new(-939.223289,119.913353,-1519.569506),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G085_terrain_039_01_baked_f_0",center=Vector3.new(-1097.011566,119.917597,-1517.729296),opacity=1.0,blend=false,texture="baked_f_02718_00_00"},
    {name="G086_terrain_039_02",center=Vector3.new(-1129.750443,119.98167,-1517.347499),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G087_terrain_039_03",center=Vector3.new(-1192.442594,120.026037,-1516.616331),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G088_terrain_039_04",center=Vector3.new(-1197.510474,119.771821,-1516.557203),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G089_terrain_039_05",center=Vector3.new(-1216.725758,119.771821,-1516.333117),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G090_terrain_039_06",center=Vector3.new(-1243.80079,119.771821,-1516.021511),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G091_terrain_039_07",center=Vector3.new(-1272.900336,119.771821,-1515.677806),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G092_terrain_039_08",center=Vector3.new(-1429.952839,119.771821,-1513.92904),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G093_terrain_040_00",center=Vector3.new(-884.126636,119.953448,-1566.503307),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G094_terrain_040_01_baked_f_0",center=Vector3.new(-1014.693396,119.960131,-1564.981297),opacity=1.0,blend=false,texture="baked_f_02766_00_00"},
    {name="G095_terrain_040_02",center=Vector3.new(-1082.152285,120.027113,-1564.194543),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G096_terrain_040_03",center=Vector3.new(-1169.37027,119.774621,-1563.177381),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G097_terrain_040_04",center=Vector3.new(-1193.461936,119.774621,-1562.896456),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G098_terrain_040_05",center=Vector3.new(-1214.524896,119.774621,-1562.65079),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G099_terrain_040_06",center=Vector3.new(-1222.092002,119.774723,-1565.740967),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G100_terrain_040_07",center=Vector3.new(-1252.882222,119.774621,-1562.203925),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G101_terrain_040_08",center=Vector3.new(-1273.422732,119.774621,-1561.963708),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G102_terrain_040_09",center=Vector3.new(-1430.290822,119.774621,-1560.132435),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G103_terrain_041_00",center=Vector3.new(-855.405235,119.777393,-1594.158772),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G104_terrain_041_01_baked_f_0",center=Vector3.new(-965.814699,119.777393,-1592.871584),opacity=1.0,blend=false,texture="baked_f_02819_00_00"},
    {name="G105_terrain_041_02",center=Vector3.new(-1049.889537,119.777393,-1591.891098),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G106_terrain_041_03",center=Vector3.new(-1151.62141,119.777393,-1590.704673),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G107_terrain_041_04",center=Vector3.new(-1177.59007,119.777393,-1590.40184),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G108_terrain_041_05",center=Vector3.new(-1196.985299,119.777393,-1590.175629),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G109_terrain_041_06",center=Vector3.new(-1213.854327,119.777393,-1589.981134),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G110_terrain_041_07",center=Vector3.new(-1253.15797,119.777393,-1589.519773),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G111_terrain_041_08",center=Vector3.new(-1273.716409,119.777393,-1589.280428),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G112_terrain_041_09",center=Vector3.new(-1425.974492,119.777393,-1587.503815),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G113_terrain_042_00",center=Vector3.new(-827.912794,119.776406,-1625.990295),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G114_terrain_042_01",center=Vector3.new(-931.103679,119.776406,-1624.845614),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G115_terrain_042_02_baked_f_0",center=Vector3.new(-938.722392,119.776406,-1624.756786),opacity=1.0,blend=false,texture="baked_f_02875_00_00"},
    {name="G116_terrain_042_03",center=Vector3.new(-1011.244202,119.776406,-1623.911013),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G117_terrain_042_04",center=Vector3.new(-1095.679147,119.776406,-1622.926331),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G118_terrain_042_05",center=Vector3.new(-1136.224038,119.776406,-1622.453472),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G119_terrain_042_06",center=Vector3.new(-1161.106164,119.776406,-1622.163282),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G120_terrain_042_07",center=Vector3.new(-1178.884561,119.776406,-1621.955926),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G121_terrain_042_08",center=Vector3.new(-1182.058334,120.030764,-1621.918924),opacity=1.0,blend=false,texture="trackmat__curbing_left"},
    {name="G122_terrain_042_09",center=Vector3.new(-1204.320581,120.031909,-1621.661867),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G123_terrain_042_10",center=Vector3.new(-1253.590884,119.776406,-1621.084867),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G124_terrain_042_11",center=Vector3.new(-1274.079296,119.776406,-1620.845631),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G125_terrain_042_12",center=Vector3.new(-1432.062749,119.776406,-1619.107982),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G126_terrain_043_00",center=Vector3.new(-830.40093,119.768511,-1663.86043),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G127_terrain_043_01_baked_f_0",center=Vector3.new(-926.729311,119.768511,-1662.737002),opacity=1.0,blend=false,texture="baked_f_02950_00_00"},
    {name="G128_terrain_043_02",center=Vector3.new(-986.257935,119.769566,-1658.501216),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G129_terrain_043_03",center=Vector3.new(-993.252237,119.768511,-1661.961692),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G130_terrain_043_04",center=Vector3.new(-1086.632156,119.768511,-1660.871669),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G131_terrain_043_05",center=Vector3.new(-1124.236952,119.768511,-1660.433578),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G132_terrain_043_06",center=Vector3.new(-1146.057728,119.768511,-1660.179138),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G133_terrain_043_07",center=Vector3.new(-1159.371294,119.768511,-1660.02388),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G134_terrain_043_08",center=Vector3.new(-1165.795789,120.187746,-1659.948948),opacity=1.0,blend=false,texture="trackmat__curbing_left"},
    {name="G135_terrain_043_09",center=Vector3.new(-1198.622295,120.194748,-1659.56737),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G136_terrain_043_10",center=Vector3.new(-1254.01595,119.773647,-1658.92116),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G137_terrain_043_11",center=Vector3.new(-1274.487141,119.768511,-1658.680943),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G138_terrain_043_12",center=Vector3.new(-1432.291957,119.768511,-1656.838989),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G139_terrain_044_00",center=Vector3.new(-826.00738,119.762339,-1684.162794),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G140_terrain_044_03",center=Vector3.new(-993.053218,119.762298,-1682.214737),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G141_terrain_044_04",center=Vector3.new(-1084.445844,119.762291,-1681.148693),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G142_terrain_044_05",center=Vector3.new(-1118.536268,119.762387,-1680.751201),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G143_terrain_044_06",center=Vector3.new(-1139.044789,119.762387,-1680.51202),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G144_terrain_044_07",center=Vector3.new(-1153.027889,119.762387,-1680.348969),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G145_terrain_044_08",center=Vector3.new(-1159.418106,120.18748,-1680.274418),opacity=1.0,blend=false,texture="trackmat__curbing_left"},
    {name="G146_terrain_044_09",center=Vector3.new(-1198.144368,120.13229,-1679.823467),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G147_terrain_044_10",center=Vector3.new(-1254.155513,119.752196,-1679.169246),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G148_terrain_044_11",center=Vector3.new(-1274.745178,119.762387,-1678.929738),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G149_terrain_044_12",center=Vector3.new(-1429.170282,119.762387,-1677.127784),opacity=1.0,blend=false,texture="trackmat__grass"},
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
