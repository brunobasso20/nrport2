-- Generated Watkins Glen visual installer: watkins_glen_walls_010.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_walls_010"
local KIND = "walls"
local SOURCE_HASH = "953809a664570abe73152ef3ddbf280856441bd946b92450211c95f5799d531f"
local GEOMETRIES = {
    {name="G000_wall_111_02_00_0",center=Vector3.new(1300.469153,90.302123,350.430734),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G001_wall_111_02_00_1",center=Vector3.new(1300.647136,92.212834,350.445393),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G002_wall_111_02_00_2",center=Vector3.new(1300.825065,90.302117,350.460039),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G003_wall_111_03_00_0",center=Vector3.new(1308.918871,93.748382,351.126439),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G004_wall_111_03_00_2",center=Vector3.new(1309.274837,93.748375,351.155744),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G005_wall_profile_111_03_00_0",center=Vector3.new(1308.791079,99.61055,351.115922),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G006_wall_profile_111_03_00_0",center=Vector3.new(1308.301708,100.704309,351.075622),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G007_wall_profile_111_03_00_0",center=Vector3.new(1307.378496,101.781334,350.999614),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G008_wall_profile_111_03_00_0",center=Vector3.new(1306.088202,102.473327,350.893375),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G009_wall_profile_111_03_00_2",center=Vector3.new(1309.147045,99.610543,351.145227),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G010_wall_profile_111_03_00_2",center=Vector3.new(1308.657673,100.704302,351.104927),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G011_wall_profile_111_03_00_2",center=Vector3.new(1307.734408,101.781327,351.028919),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G012_wall_profile_111_03_00_2",center=Vector3.new(1306.444168,102.47332,350.92268),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G013_wall_profile_top_111_03_",center=Vector3.new(1305.537633,102.677022,350.848048),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G014_wall_112_00_00_0",center=Vector3.new(1174.172538,89.85346,449.264663),opacity=1.0,blend=false,texture="trackmat__tires_left"},
    {name="G015_wall_112_00_00_1",center=Vector3.new(1175.5073,91.1934,449.374499),opacity=1.0,blend=false,texture="trackmat__tires_top"},
    {name="G016_wall_112_00_00_2",center=Vector3.new(1176.842063,89.854114,449.484457),opacity=1.0,blend=false,texture="trackmat__tires_left"},
    {name="G017_wall_cap_112_00_3",center=Vector3.new(1189.294815,89.295323,412.049253),opacity=1.0,blend=false,texture="trackmat__tires_near"},
    {name="G018_wall_cap_112_00_4",center=Vector3.new(1161.720439,90.412252,486.699813),opacity=1.0,blend=false,texture="trackmat__tires_far"},
    {name="G019_wall_112_01_00_0",center=Vector3.new(1187.557602,90.430593,450.366729),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G020_wall_112_01_00_1",center=Vector3.new(1187.735585,92.341396,450.381306),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G021_wall_112_01_00_2",center=Vector3.new(1187.913568,90.430682,450.396047),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G022_wall_cap_112_01_4",center=Vector3.new(1183.744758,90.994535,488.513184),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G023_wall_112_02_00_0",center=Vector3.new(1291.523416,90.889362,458.926637),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G024_wall_112_02_00_1",center=Vector3.new(1291.701399,92.800072,458.941296),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G025_wall_112_02_00_2",center=Vector3.new(1291.879381,90.889355,458.955956),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G026_wall_112_03_00_0",center=Vector3.new(1297.650201,94.335706,459.431062),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G027_wall_112_03_00_2",center=Vector3.new(1298.006112,94.335702,459.460381),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G028_wall_profile_112_03_00_0",center=Vector3.new(1297.5223,100.19787,459.420545),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G029_wall_profile_112_03_00_0",center=Vector3.new(1297.032928,101.291626,459.380259),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G030_wall_profile_112_03_00_0",center=Vector3.new(1296.109717,102.368644,459.304251),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G031_wall_profile_112_03_00_0",center=Vector3.new(1294.819423,103.060624,459.197998),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G032_wall_profile_112_03_00_2",center=Vector3.new(1297.878265,100.197867,459.44985),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G033_wall_profile_112_03_00_2",center=Vector3.new(1297.38884,101.291619,459.409578),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G034_wall_profile_112_03_00_2",center=Vector3.new(1296.465683,102.368637,459.333542),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G035_wall_profile_112_03_00_2",center=Vector3.new(1295.175389,103.06062,459.227317),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G036_wall_profile_top_112_03_",center=Vector3.new(1294.268853,103.264318,459.152658),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G037_wall_113_00_00_0",center=Vector3.new(1157.823236,91.713701,531.362261),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G038_wall_113_00_00_1",center=Vector3.new(1158.000238,93.624415,531.37692),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G039_wall_113_00_00_2",center=Vector3.new(1158.179092,91.71379,531.39158),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G040_wall_cap_113_00_3",center=Vector3.new(1161.720112,90.98368,486.699786),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G041_wall_cap_113_00_4",center=Vector3.new(1154.281235,92.443807,576.05411),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G042_wall_113_01_00_0",center=Vector3.new(1212.461199,91.155822,535.860879),opacity=1.0,blend=false,texture="trackmat__tires_left"},
    {name="G043_wall_113_01_00_1",center=Vector3.new(1214.243644,92.491487,536.007418),opacity=1.0,blend=false,texture="trackmat__tires_top"},
    {name="G044_wall_113_01_00_2",center=Vector3.new(1216.023309,91.152212,536.154011),opacity=1.0,blend=false,texture="trackmat__tires"},
    {name="G045_wall_cap_113_01_3",center=Vector3.new(1218.310874,90.435655,491.359166),opacity=1.0,blend=false,texture="trackmat__tires_near"},
    {name="G046_wall_cap_113_01_4",center=Vector3.new(1210.17298,91.872379,580.655943),opacity=1.0,blend=false,texture="trackmat__tires_far"},
    {name="G047_wall_113_02_00_0",center=Vector3.new(1284.185846,91.851936,541.766385),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G048_wall_113_02_00_1",center=Vector3.new(1284.364155,93.762646,541.781017),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G049_wall_113_02_00_2",center=Vector3.new(1284.541811,91.851902,541.795676),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G050_wall_113_03_00_0",center=Vector3.new(1289.379392,95.297871,542.194012),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G051_wall_113_03_00_2",center=Vector3.new(1289.735358,95.297844,542.223331),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G052_wall_profile_113_03_00_0",center=Vector3.new(1289.252363,101.160056,542.183495),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G053_wall_profile_113_03_00_0",center=Vector3.new(1288.763101,102.253863,542.143222),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G054_wall_profile_113_03_00_0",center=Vector3.new(1287.839944,103.330963,542.067201),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G055_wall_profile_113_03_00_0",center=Vector3.new(1286.549704,104.023048,541.960961),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G056_wall_profile_113_03_00_2",center=Vector3.new(1289.608329,101.160029,542.212813),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G057_wall_profile_113_03_00_2",center=Vector3.new(1289.119012,102.253836,542.172486),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G058_wall_profile_113_03_00_2",center=Vector3.new(1288.195855,103.330932,542.096492),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G059_wall_profile_113_03_00_2",center=Vector3.new(1286.90567,104.023014,541.990253),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G060_wall_profile_top_113_03_",center=Vector3.new(1285.999135,104.226736,541.915648),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G061_wall_114_00_00_0",center=Vector3.new(1145.219476,93.405199,674.959101),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G062_wall_114_00_00_1",center=Vector3.new(1146.109336,94.298444,675.032343),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G063_wall_114_00_00_2",center=Vector3.new(1146.999196,93.405587,675.10564),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G064_wall_cap_114_00_3",center=Vector3.new(1154.281235,91.42595,576.054137),opacity=1.0,blend=false,texture="trackmat__wall_top"},
    {name="G065_wall_114_01_00_0",center=Vector3.new(1201.832962,94.310536,679.620634),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G066_wall_114_01_00_1",center=Vector3.new(1202.726855,96.09625,679.693876),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G067_wall_114_01_00_2",center=Vector3.new(1203.612682,94.308526,679.767145),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G068_wall_cap_114_01_3",center=Vector3.new(1210.17298,92.318807,580.655915),opacity=1.0,blend=false,texture="trackmat__wall_side"},
    {name="G069_wall_114_02_00_0",center=Vector3.new(1268.452181,94.394922,685.105351),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G070_wall_114_02_00_1",center=Vector3.new(1268.630164,96.305605,685.120038),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G071_wall_114_02_00_2",center=Vector3.new(1268.808147,94.394892,685.13467),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G072_wall_114_03_00_0",center=Vector3.new(1275.423595,97.840871,685.679272),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G073_wall_114_03_00_2",center=Vector3.new(1275.779561,97.840844,685.708591),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G074_wall_profile_114_03_00_0",center=Vector3.new(1275.295694,103.703036,685.668836),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G075_wall_profile_114_03_00_0",center=Vector3.new(1274.806377,104.796805,685.628564),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G076_wall_profile_114_03_00_0",center=Vector3.new(1273.883275,105.873871,685.552515),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G077_wall_profile_114_03_00_0",center=Vector3.new(1272.593035,106.565925,685.446303),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G078_wall_profile_114_03_00_2",center=Vector3.new(1275.651659,103.703008,685.698128),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G079_wall_profile_114_03_00_2",center=Vector3.new(1275.162288,104.796777,685.657828),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G080_wall_profile_114_03_00_2",center=Vector3.new(1274.239186,105.873844,685.581834),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G081_wall_profile_114_03_00_2",center=Vector3.new(1272.949001,106.565898,685.475622),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G082_wall_profile_top_114_03_",center=Vector3.new(1272.04252,106.769695,685.400963),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G083_wall_115_00_00_0",center=Vector3.new(1136.898477,95.417302,775.716754),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G084_wall_115_00_00_1",center=Vector3.new(1137.787955,96.310541,775.789997),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G085_wall_115_00_00_2",center=Vector3.new(1138.678196,95.418072,775.863293),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G086_wall_115_01_00_0",center=Vector3.new(1194.230597,96.334948,780.436897),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G087_wall_115_01_00_1",center=Vector3.new(1195.120457,98.118642,780.510821),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G088_wall_115_01_00_2",center=Vector3.new(1196.01108,96.330976,780.583736),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G089_wall_115_02_00_0",center=Vector3.new(1257.014411,96.346263,785.606439),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G090_wall_115_02_00_1",center=Vector3.new(1257.192394,98.256976,785.621098),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G091_wall_115_02_00_2",center=Vector3.new(1257.370377,96.346263,785.635757),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G092_wall_115_03_00_0",center=Vector3.new(1264.972196,99.792692,786.26164),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G093_wall_115_03_00_2",center=Vector3.new(1265.328162,99.792692,786.290959),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G094_wall_profile_115_03_00_0",center=Vector3.new(1264.844295,105.654856,786.251123),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G095_wall_profile_115_03_00_0",center=Vector3.new(1264.354869,106.748605,786.210796),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G096_wall_profile_115_03_00_0",center=Vector3.new(1263.431713,107.825613,786.134802),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G097_wall_profile_115_03_00_0",center=Vector3.new(1262.141418,108.517579,786.028562),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G098_wall_profile_115_03_00_2",center=Vector3.new(1265.200261,105.654856,786.280414),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G099_wall_profile_115_03_00_2",center=Vector3.new(1264.710835,106.748605,786.240114),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G100_wall_profile_115_03_00_2",center=Vector3.new(1263.787569,107.825613,786.16412),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G101_wall_profile_115_03_00_2",center=Vector3.new(1262.49733,108.517579,786.057854),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G102_wall_profile_top_115_03_",center=Vector3.new(1261.590849,108.721263,785.983222),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G103_wall_116_00_00_0",center=Vector3.new(1136.088344,95.596262,785.515949),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G104_wall_116_00_00_1",center=Vector3.new(1136.977822,96.489474,785.589191),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G105_wall_116_00_00_2",center=Vector3.new(1137.868064,95.597001,785.662488),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G106_wall_116_01_00_0",center=Vector3.new(1193.410056,96.512852,790.235492),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G107_wall_116_01_00_1",center=Vector3.new(1194.30384,98.296601,790.309061),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G108_wall_116_01_00_2",center=Vector3.new(1195.194408,96.509058,790.382385),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G109_wall_116_02_00_0",center=Vector3.new(1256.188256,96.528895,795.404298),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G110_wall_116_02_00_1",center=Vector3.new(1256.366239,98.439608,795.418957),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G111_wall_116_02_00_2",center=Vector3.new(1256.544222,96.528895,795.433617),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G112_wall_116_03_00_0",center=Vector3.new(1264.296504,99.975324,796.071897),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G113_wall_116_03_00_2",center=Vector3.new(1264.65247,99.975324,796.101216),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G114_wall_profile_116_03_00_0",center=Vector3.new(1264.168603,105.837488,796.061352),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G115_wall_profile_116_03_00_0",center=Vector3.new(1263.679177,106.931237,796.02108),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G116_wall_profile_116_03_00_0",center=Vector3.new(1262.755966,108.008245,795.945086),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G117_wall_profile_116_03_00_0",center=Vector3.new(1261.465672,108.700211,795.838819),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G118_wall_profile_116_03_00_2",center=Vector3.new(1264.524514,105.837488,796.090671),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G119_wall_profile_116_03_00_2",center=Vector3.new(1264.035143,106.931237,796.050399),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G120_wall_profile_116_03_00_2",center=Vector3.new(1263.111877,108.008245,795.97435),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G121_wall_profile_116_03_00_2",center=Vector3.new(1261.821583,108.700211,795.868138),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G122_wall_profile_top_116_03_",center=Vector3.new(1260.915048,108.903895,795.793479),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G123_wall_117_00_00_0",center=Vector3.new(1132.309341,96.375244,831.321853),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G124_wall_117_00_00_1",center=Vector3.new(1133.198874,97.268326,831.395095),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G125_wall_117_00_00_2",center=Vector3.new(1134.089007,96.375823,831.468391),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G126_wall_117_01_00_0",center=Vector3.new(1189.627893,97.28682,836.041124),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G127_wall_117_01_00_1",center=Vector3.new(1190.521404,99.070695,836.114584),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G128_wall_117_01_00_2",center=Vector3.new(1191.4117,97.283816,836.187908),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G129_wall_117_02_00_0",center=Vector3.new(1252.326584,97.325533,841.203417),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G130_wall_117_02_00_1",center=Vector3.new(1252.504567,99.236247,841.218049),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G131_wall_117_02_00_2",center=Vector3.new(1252.68255,97.325533,841.232709),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G132_wall_117_03_00_0",center=Vector3.new(1260.704585,100.771962,841.893196),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G133_wall_117_03_00_2",center=Vector3.new(1261.060551,100.771962,841.922515),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G134_wall_profile_117_03_00_0",center=Vector3.new(1260.576684,106.634126,841.882678),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G135_wall_profile_117_03_00_0",center=Vector3.new(1260.087258,107.727875,841.842406),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G136_wall_profile_117_03_00_0",center=Vector3.new(1259.164047,108.804883,841.766357),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G137_wall_profile_117_03_00_0",center=Vector3.new(1257.873753,109.496849,841.660145),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G138_wall_profile_117_03_00_2",center=Vector3.new(1260.932595,106.634126,841.911997),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G139_wall_profile_117_03_00_2",center=Vector3.new(1260.44317,107.727875,841.871698),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G140_wall_profile_117_03_00_2",center=Vector3.new(1259.519958,108.804883,841.795676),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G141_wall_profile_117_03_00_2",center=Vector3.new(1258.229664,109.496849,841.689437),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G142_wall_profile_top_117_03_",center=Vector3.new(1257.323129,109.700533,841.614805),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G143_wall_118_00_00_0",center=Vector3.new(1128.589467,97.116998,876.394054),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G144_wall_118_00_00_1",center=Vector3.new(1129.479054,98.01006,876.467323),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G145_wall_118_00_00_2",center=Vector3.new(1130.369186,97.117427,876.540593),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G146_wall_118_01_00_0",center=Vector3.new(1185.902296,98.023653,881.112889),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G147_wall_118_01_00_1",center=Vector3.new(1186.794444,99.808189,881.186322),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G148_wall_118_01_00_2",center=Vector3.new(1187.68474,98.021426,881.259618),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G149_wall_118_02_00_0",center=Vector3.new(1248.526764,98.084702,886.269052),opacity=1.0,blend=false,texture="trackmat__armco_l"},
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
