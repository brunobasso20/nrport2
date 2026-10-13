-- Generated Watkins Glen visual installer: watkins_glen_walls_008.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_walls_008"
local KIND = "walls"
local SOURCE_HASH = "cc4372c2ec2910146b98681614e98a2bc35dc8415e90b0401cfd030b90e8f6f6"
local GEOMETRIES = {
    {name="G000_wall_093_01_00_2",center=Vector3.new(31.333716,98.443512,-60.893877),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G001_wall_093_02_00_0",center=Vector3.new(31.286399,97.925653,-60.852456),opacity=1.0,blend=false,texture="untextured"},
    {name="G002_wall_093_02_00_1",center=Vector3.new(32.47685,99.318521,-61.837786),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G003_wall_093_02_00_2",center=Vector3.new(33.966113,97.92567,-63.168802),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G004_wall_cap_093_02_3",center=Vector3.new(19.942816,98.584414,-115.305649),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G005_wall_093_03_00_0",center=Vector3.new(131.261655,95.064783,-151.545572),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G006_wall_093_03_00_1",center=Vector3.new(131.384604,96.974863,-151.648896),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G007_wall_093_03_00_2",center=Vector3.new(131.529628,95.063741,-151.777206),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G008_wall_094_00_00_0",center=Vector3.new(79.128063,102.331577,39.618659),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G009_wall_094_00_00_1",center=Vector3.new(79.208253,109.474434,39.485576),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G010_wall_094_00_00_2",center=Vector3.new(79.327296,102.331577,39.326011),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G011_wall_094_01_00_0",center=Vector3.new(81.896441,97.099444,35.664954),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G012_wall_094_01_00_1",center=Vector3.new(81.976632,99.010158,35.531861),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G013_wall_094_01_00_2",center=Vector3.new(82.095676,97.099444,35.372302),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G014_wall_094_02_00_1",center=Vector3.new(82.872275,97.974454,34.072449),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G015_wall_094_02_00_2",center=Vector3.new(84.062731,96.581595,32.476937),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G016_wall_094_03_00_0",center=Vector3.new(178.402042,93.968064,-109.381516),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G017_wall_094_03_00_1",center=Vector3.new(178.486524,95.878005,-109.521563),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G018_wall_094_03_00_2",center=Vector3.new(178.601285,93.966736,-109.674168),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G019_wall_095_00_00_0",center=Vector3.new(165.033851,101.04898,114.788822),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G020_wall_095_00_00_1",center=Vector3.new(165.069689,108.191786,114.629279),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G021_wall_095_00_00_2",center=Vector3.new(165.153381,101.049379,114.455087),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G022_wall_095_01_00_0",center=Vector3.new(166.816173,95.824885,109.287269),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G023_wall_095_01_00_1",center=Vector3.new(166.854572,97.735585,109.127722),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G024_wall_095_01_00_2",center=Vector3.new(166.935703,95.825284,108.953534),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G025_wall_095_02_00_1",center=Vector3.new(167.323215,96.700256,107.371892),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G026_wall_095_02_00_2",center=Vector3.new(168.125854,95.311376,105.630033),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G027_wall_095_03_00_0",center=Vector3.new(233.239746,93.376361,-80.906609),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G028_wall_095_03_00_1",center=Vector3.new(233.282573,95.286328,-81.073506),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G029_wall_095_03_00_2",center=Vector3.new(233.359276,93.374934,-81.240344),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G030_wall_096_00_00_0",center=Vector3.new(246.870259,99.998379,159.494993),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G031_wall_096_00_00_1",center=Vector3.new(246.882125,107.141617,159.336288),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G032_wall_096_00_00_2",center=Vector3.new(246.922139,99.999019,159.142685),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G033_wall_096_01_00_0",center=Vector3.new(247.857639,94.777928,153.295646),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G034_wall_096_01_00_1",center=Vector3.new(247.870023,96.689037,153.125599),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G035_wall_096_01_00_2",center=Vector3.new(247.909532,94.778568,152.943339),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G036_wall_096_02_00_1",center=Vector3.new(248.032856,95.657509,151.218237),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G037_wall_096_02_00_2",center=Vector3.new(248.426328,94.267069,149.433926),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G038_wall_096_03_00_0",center=Vector3.new(279.819175,93.015242,-67.917653),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G039_wall_096_03_00_1",center=Vector3.new(279.833385,94.925332,-68.098167),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G040_wall_096_03_00_2",center=Vector3.new(279.871055,93.013944,-68.269968),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G041_wall_097_00_00_0",center=Vector3.new(334.941837,98.219354,175.171259),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G042_wall_097_00_00_1",center=Vector3.new(334.954398,105.362449,175.002772),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G043_wall_097_00_00_2",center=Vector3.new(334.966946,98.219592,174.815001),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G044_wall_097_01_00_0",center=Vector3.new(335.337053,92.990834,169.571372),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G045_wall_097_01_00_1",center=Vector3.new(335.349614,94.90179,169.395821),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G046_wall_097_01_00_2",center=Vector3.new(335.362176,92.991076,169.215114),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G047_wall_097_02_00_1",center=Vector3.new(335.486862,93.868484,167.44865),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G048_wall_097_02_00_2",center=Vector3.new(335.61242,92.475629,165.665477),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G049_wall_097_03_00_0",center=Vector3.new(351.643821,92.267408,-61.775776),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G050_wall_097_03_00_1",center=Vector3.new(351.656818,94.178121,-61.953912),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G051_wall_097_03_00_2",center=Vector3.new(351.668916,92.266815,-62.132035),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G052_wall_097_04_00_0",center=Vector3.new(352.087784,95.703074,-68.085773),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G053_wall_097_04_00_2",center=Vector3.new(352.112893,95.702481,-68.442031),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G054_wall_098_00_00_0",center=Vector3.new(467.321627,95.571051,185.211972),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G055_wall_098_00_00_1",center=Vector3.new(467.334189,102.713908,185.033832),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G056_wall_098_00_00_2",center=Vector3.new(467.34675,95.571051,184.855706),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G057_wall_098_01_00_0",center=Vector3.new(467.870154,90.338905,177.430078),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G058_wall_098_01_00_1",center=Vector3.new(467.882715,92.249618,177.251945),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G059_wall_098_01_00_2",center=Vector3.new(467.895276,90.338905,177.073819),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G060_wall_098_02_00_1",center=Vector3.new(468.018259,91.213911,175.328909),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G061_wall_098_02_00_2",center=Vector3.new(468.143817,89.821053,173.547615),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G062_wall_098_03_00_0",center=Vector3.new(483.823,89.767919,-48.892266),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G063_wall_098_03_00_1",center=Vector3.new(483.948558,91.107205,-50.673558),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G064_wall_098_03_00_2",center=Vector3.new(484.074116,89.767912,-52.454853),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G065_wall_cap_098_03_3",center=Vector3.new(404.824638,91.090781,-55.818854),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G066_wall_cap_098_03_4",center=Vector3.new(563.072477,88.44505,-45.52826),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G067_wall_098_04_00_0",center=Vector3.new(484.13259,90.339337,-53.284374),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G068_wall_098_04_00_1",center=Vector3.new(484.145124,92.250051,-53.462504),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G069_wall_098_04_00_2",center=Vector3.new(484.157671,90.339337,-53.640633),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G070_wall_098_05_00_0",center=Vector3.new(484.624468,93.785756,-60.262922),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G071_wall_098_05_00_2",center=Vector3.new(484.649576,93.785756,-60.619181),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G072_wall_099_00_00_0",center=Vector3.new(626.65656,94.233128,194.641631),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G073_wall_099_00_00_1",center=Vector3.new(626.669121,101.375937,194.463498),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G074_wall_099_00_00_2",center=Vector3.new(626.681682,94.23308,194.285372),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G075_wall_099_01_00_0",center=Vector3.new(627.311952,88.999707,185.343422),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G076_wall_099_01_00_1",center=Vector3.new(627.324513,90.910373,185.165296),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G077_wall_099_01_00_2",center=Vector3.new(627.337074,88.99966,184.98717),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G078_wall_099_02_00_1",center=Vector3.new(627.457837,89.874193,183.273738),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G079_wall_099_02_00_2",center=Vector3.new(627.583395,88.481334,181.492444),opacity=1.0,blend=false,texture="trackmat__haybales_left_2"},
    {name="G080_wall_099_03_00_0",center=Vector3.new(643.465778,89.016724,-43.830178),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G081_wall_099_03_00_1",center=Vector3.new(643.478339,90.927437,-44.008308),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G082_wall_099_03_00_2",center=Vector3.new(643.490873,89.016724,-44.186439),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G083_wall_099_04_00_0",center=Vector3.new(644.031688,92.463153,-51.858805),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G084_wall_099_04_00_2",center=Vector3.new(644.056811,92.463153,-52.215065),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G085_wall_100_00_00_0",center=Vector3.new(800.280653,94.249705,138.816925),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G086_wall_100_00_00_1",center=Vector3.new(800.293214,101.392562,138.638803),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G087_wall_100_00_00_2",center=Vector3.new(800.305775,94.249705,138.460674),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G088_wall_100_01_00_0",center=Vector3.new(801.191166,89.017568,125.899373),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G089_wall_100_01_00_1",center=Vector3.new(801.203728,90.928282,125.721243),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G090_wall_100_01_00_2",center=Vector3.new(801.216289,89.017568,125.543118),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G091_wall_100_02_00_0",center=Vector3.new(801.210376,88.499713,125.626884),opacity=1.0,blend=false,texture="untextured"},
    {name="G092_wall_100_02_00_1",center=Vector3.new(801.335934,89.892571,123.845591),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G093_wall_100_02_00_2",center=Vector3.new(801.461492,88.499716,122.064298),opacity=1.0,blend=false,texture="trackmat__haybales_left"},
    {name="G094_wall_cap_100_02_4",center=Vector3.new(894.920785,88.500285,61.299835),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G095_wall_100_03_00_0",center=Vector3.new(812.410355,89.01748,-33.266836),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G096_wall_100_03_00_1",center=Vector3.new(812.422916,90.928194,-33.444967),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G097_wall_100_03_00_2",center=Vector3.new(812.435477,89.01748,-33.623098),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G098_wall_100_04_00_0",center=Vector3.new(812.992314,92.463909,-41.522992),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G099_wall_100_04_00_2",center=Vector3.new(813.017436,92.463909,-41.879252),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G100_wall_profile_100_04_00_0",center=Vector3.new(812.983295,98.326073,-41.394961),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G101_wall_profile_100_04_00_0",center=Vector3.new(812.948772,99.419822,-40.905108),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G102_wall_profile_100_04_00_0",center=Vector3.new(812.883622,100.49683,-39.98106),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G103_wall_profile_100_04_00_0",center=Vector3.new(812.792615,101.188796,-38.68962),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G104_wall_profile_100_04_00_2",center=Vector3.new(813.00839,98.326073,-41.751223),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G105_wall_profile_100_04_00_2",center=Vector3.new(812.973867,99.419822,-41.261366),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G106_wall_profile_100_04_00_2",center=Vector3.new(812.908745,100.49683,-40.337321),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G107_wall_profile_100_04_00_2",center=Vector3.new(812.817683,101.188796,-39.045882),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G108_wall_profile_top_100_04_",center=Vector3.new(812.753759,101.39248,-38.138533),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G109_wall_101_00_00_0",center=Vector3.new(971.441269,87.266745,63.627461),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G110_wall_101_00_00_1",center=Vector3.new(971.453803,89.177459,63.449332),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G111_wall_101_00_00_2",center=Vector3.new(971.466364,87.266745,63.271202),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G112_wall_101_01_00_0",center=Vector3.new(977.518981,89.018219,-22.596914),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G113_wall_101_01_00_1",center=Vector3.new(977.531515,90.928933,-22.775044),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G114_wall_101_01_00_2",center=Vector3.new(977.544076,89.018219,-22.953174),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G115_wall_101_02_00_0",center=Vector3.new(978.124373,92.464648,-31.185427),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G116_wall_101_02_00_2",center=Vector3.new(978.149469,92.464648,-31.541683),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G117_wall_profile_101_02_00_0",center=Vector3.new(978.115354,98.326812,-31.057397),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G118_wall_profile_101_02_00_0",center=Vector3.new(978.080804,99.420561,-30.56754),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G119_wall_profile_101_02_00_0",center=Vector3.new(978.015682,100.497569,-29.643494),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G120_wall_profile_101_02_00_0",center=Vector3.new(977.924647,101.189535,-28.352055),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G121_wall_profile_101_02_00_2",center=Vector3.new(978.14045,98.326812,-31.413653),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G122_wall_profile_101_02_00_2",center=Vector3.new(978.105954,99.420561,-30.923801),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G123_wall_profile_101_02_00_2",center=Vector3.new(978.040804,100.497569,-29.999753),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G124_wall_profile_101_02_00_2",center=Vector3.new(977.949742,101.189535,-28.708314),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G125_wall_profile_top_101_02_",center=Vector3.new(977.885791,101.393219,-27.800967),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G126_wall_102_00_00_0",center=Vector3.new(1071.0392,84.936149,68.269035),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G127_wall_102_00_00_1",center=Vector3.new(1071.093859,86.846863,68.090909),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G128_wall_102_00_00_2",center=Vector3.new(1071.106393,84.936156,67.92091),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G129_wall_102_01_00_0",center=Vector3.new(1086.650194,89.018376,-12.316251),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G130_wall_102_01_00_1",center=Vector3.new(1086.704854,90.929089,-12.494382),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G131_wall_102_01_00_2",center=Vector3.new(1086.717388,89.018376,-12.664379),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G132_wall_102_02_00_0",center=Vector3.new(1088.493075,92.464808,-21.536785),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G133_wall_102_02_00_2",center=Vector3.new(1088.560268,92.464808,-21.884911),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G134_wall_profile_102_02_00_0",center=Vector3.new(1088.484028,98.326973,-21.414599),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G135_wall_profile_102_02_00_0",center=Vector3.new(1088.419233,99.420721,-20.94126),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G136_wall_profile_102_02_00_0",center=Vector3.new(1088.268607,100.497729,-20.042875),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G137_wall_profile_102_02_00_0",center=Vector3.new(1088.044684,101.189695,-18.784723),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G138_wall_profile_102_02_00_2",center=Vector3.new(1088.551276,98.326973,-21.762725),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G139_wall_profile_102_02_00_2",center=Vector3.new(1088.486481,99.420721,-21.289386),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G140_wall_profile_102_02_00_2",center=Vector3.new(1088.3358,100.497729,-20.391001),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G141_wall_profile_102_02_00_2",center=Vector3.new(1088.111877,101.189695,-19.132852),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G142_wall_profile_top_102_02_",center=Vector3.new(1087.87553,101.393379,-18.233635),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G143_wall_103_00_00_0",center=Vector3.new(1095.426287,84.326203,73.105686),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G144_wall_103_00_00_1",center=Vector3.new(1095.483616,86.236892,72.935425),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G145_wall_103_00_00_2",center=Vector3.new(1095.538276,84.326179,72.76657),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G146_wall_103_01_00_0",center=Vector3.new(1121.492822,89.018294,-5.819327),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G147_wall_103_01_00_1",center=Vector3.new(1121.550151,90.929008,-5.989325),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G148_wall_103_01_00_2",center=Vector3.new(1121.60481,89.018294,-6.158443),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G149_wall_103_02_00_0",center=Vector3.new(1124.633789,92.46473,-15.328946),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
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
