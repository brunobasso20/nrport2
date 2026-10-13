-- Generated Watkins Glen visual installer: watkins_glen_terrain_030.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_terrain_030"
local KIND = "terrain"
local SOURCE_HASH = "90b3197eed096873372e4a8d41325e3538d2a7a0c2d069e3dd57a27e1c0b3675"
local GEOMETRIES = {
    {name="G000_terrain_045_00",center=Vector3.new(-824.455152,119.762121,-1689.538901),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G001_terrain_045_01_baked_f_0",center=Vector3.new(-920.882525,119.762114,-1688.413674),opacity=1.0,blend=false,texture="baked_f_03096_00_00"},
    {name="G002_terrain_045_02",center=Vector3.new(-993.096215,119.762114,-1687.572316),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G003_terrain_045_03",center=Vector3.new(-1084.131731,119.762121,-1686.509541),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G004_terrain_045_04",center=Vector3.new(-1117.762865,119.762128,-1686.117826),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G005_terrain_045_05",center=Vector3.new(-1137.753677,119.762135,-1685.884748),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G006_terrain_045_06",center=Vector3.new(-1152.045332,119.762135,-1685.718046),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G007_terrain_045_07",center=Vector3.new(-1158.317947,120.18483,-1685.644913),opacity=1.0,blend=false,texture="trackmat__curbing_left"},
    {name="G008_terrain_045_08",center=Vector3.new(-1198.045622,120.1287,-1685.182898),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G009_terrain_045_09",center=Vector3.new(-1254.243197,119.742271,-1684.525245),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G010_terrain_045_10",center=Vector3.new(-1274.831063,119.762128,-1684.286336),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G011_terrain_045_11",center=Vector3.new(-1428.815188,119.762128,-1682.490322),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G012_terrain_046_00",center=Vector3.new(-822.753552,119.761433,-1719.947542),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G013_terrain_046_01_baked_f_0",center=Vector3.new(-921.23048,119.761215,-1718.79643),opacity=1.0,blend=false,texture="baked_f_03167_00_00"},
    {name="G014_terrain_046_02",center=Vector3.new(-993.531472,119.759975,-1717.953982),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G015_terrain_046_03",center=Vector3.new(-1084.175927,119.75973,-1716.890444),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G016_terrain_046_04",center=Vector3.new(-1117.3663,119.762979,-1716.508484),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G017_terrain_046_05",center=Vector3.new(-1133.473914,119.762979,-1716.320583),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G018_terrain_046_06",center=Vector3.new(-1147.426333,119.762986,-1716.157859),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G019_terrain_046_07",center=Vector3.new(-1157.895878,120.183059,-1716.035788),opacity=1.0,blend=false,texture="trackmat__curbing_left"},
    {name="G020_terrain_046_08",center=Vector3.new(-1195.89217,120.184299,-1715.595627),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G021_terrain_046_09",center=Vector3.new(-1254.677527,119.797025,-1714.907837),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G022_terrain_046_10",center=Vector3.new(-1275.143651,119.762979,-1714.667892),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G023_terrain_046_11",center=Vector3.new(-1429.496602,119.762979,-1712.87226),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G024_terrain_047_00",center=Vector3.new(-822.093064,119.898769,-1767.582485),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G025_terrain_047_01_baked_f_0",center=Vector3.new(-921.672821,119.905533,-1766.405051),opacity=1.0,blend=false,texture="baked_f_03237_00_00"},
    {name="G026_terrain_047_02",center=Vector3.new(-994.169562,119.99947,-1765.568379),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G027_terrain_047_03",center=Vector3.new(-1081.269455,120.027746,-1764.550127),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G028_terrain_047_04",center=Vector3.new(-1104.857908,120.027746,-1764.272799),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G029_terrain_047_05",center=Vector3.new(-1113.49847,119.764968,-1764.174979),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G030_terrain_047_06",center=Vector3.new(-1128.318296,119.764968,-1764.002119),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G031_terrain_047_07",center=Vector3.new(-1145.950753,119.764968,-1763.796507),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G032_terrain_047_08",center=Vector3.new(-1155.030932,119.954913,-1763.690622),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G033_terrain_047_09",center=Vector3.new(-1195.654406,120.053325,-1763.219615),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G034_terrain_047_10",center=Vector3.new(-1255.167116,119.79787,-1762.522725),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G035_terrain_047_11",center=Vector3.new(-1275.749915,119.764968,-1762.283325),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G036_terrain_047_12",center=Vector3.new(-1430.230658,119.764968,-1760.483061),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G037_terrain_048_00",center=Vector3.new(-820.3919,119.902045,-1813.534219),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G038_terrain_048_01_baked_f_0",center=Vector3.new(-922.668784,120.042719,-1812.340491),opacity=1.0,blend=false,texture="baked_f_03307_00_00"},
    {name="G039_terrain_048_02",center=Vector3.new(-994.748034,120.14216,-1811.501258),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G040_terrain_048_03",center=Vector3.new(-1081.878172,120.263842,-1810.481535),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G041_terrain_048_04",center=Vector3.new(-1105.109515,120.029129,-1810.20862),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G042_terrain_048_05",center=Vector3.new(-1114.598465,119.767639,-1810.12704),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G043_terrain_048_06",center=Vector3.new(-1128.828703,119.767639,-1809.930311),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G044_terrain_048_07",center=Vector3.new(-1145.954677,119.767639,-1809.714944),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G045_terrain_048_08",center=Vector3.new(-1155.012022,119.767639,-1809.629985),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G046_terrain_048_09",center=Vector3.new(-1195.920454,119.767639,-1809.156036),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G047_terrain_048_10",center=Vector3.new(-1255.709948,119.767639,-1808.455985),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G048_terrain_048_11",center=Vector3.new(-1276.347515,119.767639,-1808.215659),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G049_terrain_048_12",center=Vector3.new(-1431.101499,119.767639,-1806.41267),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G050_terrain_049_00",center=Vector3.new(-819.835445,119.907379,-1847.201538),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G051_terrain_049_01_baked_f_0",center=Vector3.new(-922.541373,120.049422,-1846.00514),opacity=1.0,blend=false,texture="baked_f_03380_00_00"},
    {name="G052_terrain_049_02",center=Vector3.new(-995.091684,120.151077,-1845.157732),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G053_terrain_049_03",center=Vector3.new(-1082.286889,120.271492,-1844.139426),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G054_terrain_049_04",center=Vector3.new(-1105.115019,120.037665,-1843.874577),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G055_terrain_049_05",center=Vector3.new(-1115.724945,119.769539,-1843.763951),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G056_terrain_049_06",center=Vector3.new(-1132.110432,119.769539,-1843.559047),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G057_terrain_049_07",center=Vector3.new(-1147.733688,119.769539,-1843.365043),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G058_terrain_049_08",center=Vector3.new(-1155.017362,119.769539,-1843.292563),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G059_terrain_049_09",center=Vector3.new(-1196.027047,119.769539,-1842.815399),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G060_terrain_049_10",center=Vector3.new(-1256.068475,119.769539,-1842.113931),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G061_terrain_049_11",center=Vector3.new(-1276.65002,119.769539,-1841.872951),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G062_terrain_049_12",center=Vector3.new(-1431.609944,119.769539,-1840.068817),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G063_terrain_050_00",center=Vector3.new(-818.17815,119.907754,-1879.811859),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G064_terrain_050_01_baked_f_0",center=Vector3.new(-922.711727,119.915983,-1878.582764),opacity=1.0,blend=false,texture="baked_f_03453_00_00"},
    {name="G065_terrain_050_02",center=Vector3.new(-995.599965,120.010887,-1877.739389),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G066_terrain_050_03",center=Vector3.new(-1085.452979,120.038039,-1876.684352),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G067_terrain_050_04",center=Vector3.new(-1119.321496,119.770506,-1876.335798),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G068_terrain_050_05",center=Vector3.new(-1136.671993,119.770506,-1876.089587),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G069_terrain_050_06",center=Vector3.new(-1149.357115,119.770506,-1875.90986),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G070_terrain_050_07",center=Vector3.new(-1159.267862,119.763599,-1875.867135),opacity=1.0,blend=false,texture="trackmat__curbing_left"},
    {name="G071_terrain_050_08",center=Vector3.new(-1196.666827,119.506005,-1875.349753),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G072_terrain_050_09",center=Vector3.new(-1256.464985,119.674921,-1874.694388),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G073_terrain_050_10",center=Vector3.new(-1277.078956,119.770506,-1874.454934),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G074_terrain_050_11",center=Vector3.new(-1432.17223,119.770506,-1872.647531),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G075_terrain_051_00",center=Vector3.new(-817.517281,119.771937,-1923.955427),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G076_terrain_051_01_baked_f_0",center=Vector3.new(-922.133364,119.771937,-1922.773416),opacity=1.0,blend=false,texture="baked_f_03522_00_00"},
    {name="G077_terrain_051_02",center=Vector3.new(-996.937725,119.771937,-1921.917071),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G078_terrain_051_03",center=Vector3.new(-1090.55639,119.771937,-1920.855604),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G079_terrain_051_04",center=Vector3.new(-1125.946753,119.771937,-1920.42378),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G080_terrain_051_05",center=Vector3.new(-1147.539411,119.771937,-1920.157078),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G081_terrain_051_06",center=Vector3.new(-1161.523438,119.771937,-1920.00351),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G082_terrain_051_07",center=Vector3.new(-1165.102168,119.90883,-1919.904654),opacity=1.0,blend=false,texture="trackmat__curbing_left"},
    {name="G083_terrain_051_08",center=Vector3.new(-1200.811877,119.643641,-1919.469452),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G084_terrain_051_09",center=Vector3.new(-1256.986182,119.675759,-1918.87316),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G085_terrain_051_10",center=Vector3.new(-1277.564566,119.771937,-1918.632943),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G086_terrain_051_11",center=Vector3.new(-1432.541384,119.771937,-1916.823578),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G087_terrain_052_00",center=Vector3.new(-822.562517,119.771603,-1967.603847),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G088_terrain_052_01_baked_f_0",center=Vector3.new(-925.042507,119.771603,-1966.555677),opacity=1.0,blend=false,texture="baked_f_03591_00_00"},
    {name="G089_terrain_052_02",center=Vector3.new(-1010.370908,119.771603,-1965.650613),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G090_terrain_052_03",center=Vector3.new(-1107.536697,119.771603,-1964.424133),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G091_terrain_052_04",center=Vector3.new(-1142.037092,119.771603,-1963.936179),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G092_terrain_052_05",center=Vector3.new(-1165.349197,119.771603,-1963.717215),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G093_terrain_052_06",center=Vector3.new(-1184.754453,119.771603,-1963.548824),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G094_terrain_052_07",center=Vector3.new(-1205.23589,119.859314,-1963.071224),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G095_terrain_052_08",center=Vector3.new(-1257.66607,119.752782,-1962.644958),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G096_terrain_052_09",center=Vector3.new(-1278.265272,119.771603,-1962.402998),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G097_terrain_052_10",center=Vector3.new(-1432.553864,119.771603,-1960.597665),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G098_terrain_053_00",center=Vector3.new(-855.854198,119.771017,-2012.033953),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G099_terrain_053_01_baked_f_0",center=Vector3.new(-947.363772,119.770908,-2010.804204),opacity=1.0,blend=false,texture="baked_f_03655_00_00"},
    {name="G100_terrain_053_02",center=Vector3.new(-1024.873734,119.770902,-2009.809331),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G101_terrain_053_03",center=Vector3.new(-1132.96269,119.771017,-2008.673423),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G102_terrain_053_04",center=Vector3.new(-1167.333494,119.771017,-2008.23713),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G103_terrain_053_05",center=Vector3.new(-1185.932541,119.771017,-2008.052172),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G104_terrain_053_06",center=Vector3.new(-1212.738528,119.771017,-2007.827977),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G105_terrain_053_07",center=Vector3.new(-1221.394403,119.77097,-2004.116276),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G106_terrain_053_08",center=Vector3.new(-1258.206885,119.771017,-2007.209669),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G107_terrain_053_09",center=Vector3.new(-1278.966304,119.771017,-2006.966836),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G108_terrain_053_10",center=Vector3.new(-1433.1513,119.771017,-2005.175781),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G109_terrain_054_00",center=Vector3.new(-894.88024,119.887073,-2051.739066),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G110_terrain_054_01_baked_f_0",center=Vector3.new(-997.343554,119.892924,-2050.265939),opacity=1.0,blend=false,texture="baked_f_03728_00_00"},
    {name="G111_terrain_054_02",center=Vector3.new(-1058.513042,119.944688,-2049.396733),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G112_terrain_054_03",center=Vector3.new(-1151.968057,119.968482,-2048.458971),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G113_terrain_054_04",center=Vector3.new(-1181.319482,119.968482,-2048.125022),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G114_terrain_054_05",center=Vector3.new(-1187.949753,119.773565,-2048.021371),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G115_terrain_054_06",center=Vector3.new(-1204.656655,119.773558,-2047.862571),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G116_terrain_054_07",center=Vector3.new(-1242.456,119.773538,-2047.304426),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G117_terrain_054_08",center=Vector3.new(-1279.639435,119.773497,-2046.979305),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G118_terrain_054_09",center=Vector3.new(-1433.409173,119.773497,-2045.180402),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G119_terrain_055_00",center=Vector3.new(-926.4734,119.915601,-2094.054413),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G120_terrain_055_01_baked_f_0",center=Vector3.new(-1052.427074,120.035199,-2092.273821),opacity=1.0,blend=false,texture="baked_f_03796_00_00"},
    {name="G121_terrain_055_02",center=Vector3.new(-1106.044224,120.08637,-2091.564723),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G122_terrain_055_03",center=Vector3.new(-1175.679943,119.74082,-2090.718733),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G123_terrain_055_04",center=Vector3.new(-1204.835074,119.977467,-2090.502058),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G124_terrain_055_05",center=Vector3.new(-1209.140451,119.775779,-2090.418679),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G125_terrain_055_06",center=Vector3.new(-1223.625401,119.775752,-2090.277318),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G126_terrain_055_07",center=Vector3.new(-1252.248165,119.775711,-2089.826202),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G127_terrain_055_08",center=Vector3.new(-1280.260631,119.775704,-2089.617048),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G128_terrain_055_09",center=Vector3.new(-1433.741924,119.775704,-2087.822723),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G129_terrain_056_00",center=Vector3.new(-938.407353,119.920206,-2123.874882),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G130_terrain_056_01_baked_f_0",center=Vector3.new(-1090.945162,120.06571,-2121.993692),opacity=1.0,blend=false,texture="baked_f_03864_00_00"},
    {name="G131_terrain_056_02",center=Vector3.new(-1141.633061,120.112964,-2121.369934),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G132_terrain_056_03",center=Vector3.new(-1201.724897,119.742019,-2120.675877),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G133_terrain_056_04",center=Vector3.new(-1220.986339,119.978925,-2120.480892),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G134_terrain_056_05",center=Vector3.new(-1223.940931,119.776072,-2117.979104),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G135_terrain_056_06",center=Vector3.new(-1237.211227,119.776079,-2120.28983),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G136_terrain_056_07",center=Vector3.new(-1262.6194,119.776072,-2119.955553),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G137_terrain_056_08",center=Vector3.new(-1280.629294,119.776072,-2119.783565),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G138_terrain_056_09",center=Vector3.new(-1433.367157,119.776072,-2118.000902),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G139_terrain_057_00",center=Vector3.new(-946.45789,119.934831,-2137.319074),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G140_terrain_057_01_baked_f_0",center=Vector3.new(-1107.405908,120.084694,-2135.361045),opacity=1.0,blend=false,texture="baked_f_03930_00_00"},
    {name="G141_terrain_057_02",center=Vector3.new(-1155.704607,120.131745,-2134.774235),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G142_terrain_057_03",center=Vector3.new(-1210.635866,120.183332,-2134.133693),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G143_terrain_057_04",center=Vector3.new(-1227.768871,119.992243,-2133.962686),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G144_terrain_057_05",center=Vector3.new(-1243.311691,119.77612,-2133.777182),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G145_terrain_057_06",center=Vector3.new(-1266.020748,119.77612,-2133.481925),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G146_terrain_057_07",center=Vector3.new(-1280.793435,119.77612,-2133.341217),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G147_terrain_057_08",center=Vector3.new(-1433.397947,119.77612,-2131.562369),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G148_terrain_058_00",center=Vector3.new(-949.044446,119.942951,-2145.200566),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G149_terrain_058_01_baked_f_0",center=Vector3.new(-1116.731916,120.107624,-2143.222155),opacity=1.0,blend=false,texture="baked_f_03993_00_00"},
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
