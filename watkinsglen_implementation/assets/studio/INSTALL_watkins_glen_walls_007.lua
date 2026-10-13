-- Generated Watkins Glen visual installer: watkins_glen_walls_007.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_walls_007"
local KIND = "walls"
local SOURCE_HASH = "484d3dd13073555b8ba471b7124651d88387c9ff094f1d9cdb3e1fa640351ea8"
local GEOMETRIES = {
    {name="G000_wall_078_04_00_0",center=Vector3.new(-170.93216,94.343363,-2076.676178),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G001_wall_078_04_00_1",center=Vector3.new(-170.757038,96.245442,-2076.711164),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G002_wall_078_04_00_2",center=Vector3.new(-170.581916,94.324705,-2076.746041),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G003_wall_cap_078_04_3",center=Vector3.new(-242.288807,98.152225,-2129.426466),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G004_wall_078_05_00_0",center=Vector3.new(-57.890792,88.201152,-2099.218423),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G005_wall_078_05_00_1",center=Vector3.new(-57.610654,90.096532,-2099.271393),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G006_wall_078_05_00_2",center=Vector3.new(-57.540538,88.18249,-2099.288286),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G007_wall_079_00_00_0",center=Vector3.new(-386.956828,113.231465,-1863.347462),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G008_wall_079_00_00_2",center=Vector3.new(-386.606584,113.23139,-1863.41738),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G009_wall_079_01_00_0",center=Vector3.new(-323.848792,100.01093,-1875.930132),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G010_wall_079_01_00_1",center=Vector3.new(-323.681232,101.922342,-1875.964028),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G011_wall_079_01_00_2",center=Vector3.new(-323.498535,100.012153,-1875.999996),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G012_wall_079_02_00_0",center=Vector3.new(-250.600338,99.33705,-1890.549469),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G013_wall_079_02_00_1",center=Vector3.new(-250.334672,101.23243,-1890.588597),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G014_wall_079_02_00_2",center=Vector3.new(-250.250067,99.326447,-1890.619387),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G015_wall_079_03_00_0",center=Vector3.new(-26.553932,90.165523,-1935.20813),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G016_wall_079_03_00_1",center=Vector3.new(-26.378797,92.065668,-1935.243007),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G017_wall_079_03_00_2",center=Vector3.new(-26.203675,90.146317,-1935.277884),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G018_wall_080_00_00_0",center=Vector3.new(-337.045056,113.131288,-1611.088017),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G019_wall_080_00_00_2",center=Vector3.new(-336.694813,113.130982,-1611.157881),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G020_wall_080_01_00_0",center=Vector3.new(-273.573262,100.038167,-1623.743602),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G021_wall_080_01_00_1",center=Vector3.new(-273.405879,101.949593,-1623.777008),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G022_wall_080_01_00_2",center=Vector3.new(-273.223019,100.039646,-1623.813466),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G023_wall_080_02_00_0",center=Vector3.new(-200.743014,99.798226,-1638.26937),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G024_wall_080_02_00_1",center=Vector3.new(-200.547286,101.706696,-1638.304302),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G025_wall_080_02_00_2",center=Vector3.new(-200.392764,99.796329,-1638.339233),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G026_wall_080_03_00_0",center=Vector3.new(-211.185203,103.230899,-1705.45845),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G027_wall_080_03_00_2",center=Vector3.new(-209.433964,103.22126,-1705.807659),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G028_wall_081_00_00_0",center=Vector3.new(-305.013766,112.714301,-1448.2181),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G029_wall_081_00_00_2",center=Vector3.new(-304.663522,112.713821,-1448.287909),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G030_wall_081_01_00_0",center=Vector3.new(-240.997342,100.045034,-1460.982295),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G031_wall_081_01_00_1",center=Vector3.new(-240.830108,101.956432,-1461.015647),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G032_wall_081_01_00_2",center=Vector3.new(-240.647098,100.046519,-1461.052104),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G033_wall_081_02_00_0",center=Vector3.new(-169.359902,99.906414,-1475.266048),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G034_wall_081_02_00_1",center=Vector3.new(-169.184773,101.817128,-1475.30098),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G035_wall_081_02_00_2",center=Vector3.new(-169.009645,99.906414,-1475.335911),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G036_wall_081_03_00_0",center=Vector3.new(-96.103603,99.906414,-1489.872578),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G037_wall_081_03_00_1",center=Vector3.new(-95.928482,101.817128,-1489.90751),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G038_wall_081_03_00_2",center=Vector3.new(-95.753354,99.906414,-1489.942442),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G039_wall_cap_081_03_3",center=Vector3.new(-170.011418,99.90639,-1485.459082),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G040_wall_082_00_00_0",center=Vector3.new(-296.60417,112.942699,-1402.317701),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G041_wall_082_00_00_2",center=Vector3.new(-296.253926,112.942662,-1402.387456),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G042_wall_082_01_00_0",center=Vector3.new(-231.522438,100.042905,-1415.294266),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G043_wall_082_01_00_1",center=Vector3.new(-231.355211,101.954317,-1415.327617),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G044_wall_082_01_00_2",center=Vector3.new(-231.172194,100.044407,-1415.364129),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G045_wall_082_02_00_0",center=Vector3.new(-160.181938,99.906526,-1429.518836),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G046_wall_082_02_00_1",center=Vector3.new(-160.006809,101.81724,-1429.553768),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G047_wall_082_02_00_2",center=Vector3.new(-159.831681,99.906526,-1429.588699),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G048_wall_cap_082_02_4",center=Vector3.new(-152.796902,99.906615,-1393.737085),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G049_wall_082_03_00_0",center=Vector3.new(45.623531,99.906526,-1470.554297),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G050_wall_082_03_00_1",center=Vector3.new(45.798666,101.81724,-1470.589229),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G051_wall_082_03_00_2",center=Vector3.new(45.973787,99.906526,-1470.624161),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G052_wall_083_00_00_0",center=Vector3.new(-286.366422,113.827825,-1346.123069),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G053_wall_083_00_00_2",center=Vector3.new(-286.016178,113.828288,-1346.192878),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G054_wall_083_01_00_0",center=Vector3.new(-220.143155,100.039857,-1359.327371),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G055_wall_083_01_00_1",center=Vector3.new(-219.975546,101.951279,-1359.360722),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G056_wall_083_01_00_2",center=Vector3.new(-219.792911,100.041325,-1359.39718),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G057_wall_083_02_00_0",center=Vector3.new(-131.61569,99.781666,-1376.978738),opacity=1.0,blend=false,texture="trackmat__tires_left"},
    {name="G058_wall_083_02_00_1",center=Vector3.new(-130.302255,101.567381,-1377.240644),opacity=1.0,blend=false,texture="trackmat__tires_top"},
    {name="G059_wall_083_02_00_2",center=Vector3.new(-128.988821,99.781666,-1377.502496),opacity=1.0,blend=false,texture="trackmat__tires_left"},
    {name="G060_wall_cap_083_02_3",center=Vector3.new(-152.796902,99.781615,-1393.73703),opacity=1.0,blend=false,texture="trackmat__tires_near"},
    {name="G061_wall_084_00_00_0",center=Vector3.new(-277.828039,114.240612,-1301.883534),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G062_wall_084_00_00_2",center=Vector3.new(-277.477796,114.240612,-1301.953397),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G063_wall_084_01_00_0",center=Vector3.new(-211.416701,100.035902,-1315.125329),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G064_wall_084_01_00_1",center=Vector3.new(-211.248881,101.947287,-1315.158735),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G065_wall_084_01_00_2",center=Vector3.new(-211.066457,100.037313,-1315.195193),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G066_wall_084_02_00_0",center=Vector3.new(-86.002711,99.781775,-1340.131542),opacity=1.0,blend=false,texture="trackmat__tires_left"},
    {name="G067_wall_084_02_00_1",center=Vector3.new(-84.68928,101.56749,-1340.393393),opacity=1.0,blend=false,texture="trackmat__tires_top"},
    {name="G068_wall_084_02_00_2",center=Vector3.new(-83.375846,99.781775,-1340.6553),opacity=1.0,blend=false,texture="trackmat__tires_left"},
    {name="G069_wall_cap_084_02_4",center=Vector3.new(-61.570948,99.781833,-1320.042637),opacity=1.0,blend=false,texture="trackmat__tires_far"},
    {name="G070_wall_084_03_00_0",center=Vector3.new(-15.847252,99.906775,-1354.119819),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G071_wall_084_03_00_1",center=Vector3.new(-15.67213,101.817489,-1354.154696),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G072_wall_084_03_00_2",center=Vector3.new(-15.497008,99.906775,-1354.189628),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G073_wall_084_04_00_0",center=Vector3.new(79.115556,99.906775,-1373.05445),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G074_wall_084_04_00_1",center=Vector3.new(79.290691,101.817489,-1373.089327),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G075_wall_084_04_00_2",center=Vector3.new(79.465813,99.906775,-1373.124204),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G076_wall_085_00_00_0",center=Vector3.new(-269.346373,114.17017,-1255.609839),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G077_wall_085_00_00_2",center=Vector3.new(-268.996143,114.170078,-1255.679703),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G078_wall_085_01_00_0",center=Vector3.new(-202.430609,100.029836,-1268.952233),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G079_wall_085_01_00_1",center=Vector3.new(-202.262674,101.941207,-1268.985694),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G080_wall_085_01_00_2",center=Vector3.new(-202.080366,100.031219,-1269.022042),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G081_wall_085_02_00_0",center=Vector3.new(-78.364846,99.906887,-1293.689564),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G082_wall_085_02_00_1",center=Vector3.new(-78.189724,101.817601,-1293.724496),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G083_wall_085_02_00_2",center=Vector3.new(-78.014602,99.906887,-1293.759428),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G084_wall_085_03_00_0",center=Vector3.new(-74.723927,105.139031,-1294.41561),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G085_wall_085_03_00_2",center=Vector3.new(-74.373685,105.139031,-1294.485365),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G086_wall_086_00_00_0",center=Vector3.new(-258.050455,113.681657,-1183.921051),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G087_wall_086_00_00_2",center=Vector3.new(-257.700225,113.681654,-1183.990914),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G088_wall_086_01_00_0",center=Vector3.new(-188.663435,100.019435,-1197.756304),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G089_wall_086_01_00_1",center=Vector3.new(-188.494757,101.930799,-1197.789764),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G090_wall_086_01_00_2",center=Vector3.new(-188.313184,100.020732,-1197.826113),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G091_wall_086_02_00_0",center=Vector3.new(-102.203604,99.907061,-1214.995302),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G092_wall_086_02_00_1",center=Vector3.new(-102.028482,101.817775,-1215.030234),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G093_wall_086_02_00_2",center=Vector3.new(-101.853357,99.907061,-1215.065166),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G094_wall_086_03_00_0",center=Vector3.new(-98.865553,105.139204,-1215.660913),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G095_wall_086_03_00_2",center=Vector3.new(-98.515306,105.139204,-1215.730722),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G096_wall_087_00_00_0",center=Vector3.new(-220.200838,113.387193,-891.799573),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G097_wall_087_00_00_2",center=Vector3.new(-219.850595,113.387241,-891.869409),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G098_wall_087_01_00_0",center=Vector3.new(-132.762456,99.975521,-909.234755),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G099_wall_087_01_00_1",center=Vector3.new(-132.589412,101.886851,-909.268379),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G100_wall_087_01_00_2",center=Vector3.new(-132.412209,99.976339,-909.304592),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G101_wall_087_02_00_0",center=Vector3.new(-56.914506,99.907667,-924.357169),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G102_wall_087_02_00_1",center=Vector3.new(-56.739381,101.818381,-924.392101),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G103_wall_087_02_00_2",center=Vector3.new(-56.564256,99.907667,-924.427032),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G104_wall_088_00_00_0",center=Vector3.new(-182.843862,113.651194,-612.213952),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G105_wall_088_00_00_2",center=Vector3.new(-182.493619,113.651085,-612.283788),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G106_wall_088_01_00_0",center=Vector3.new(-74.385139,99.938386,-633.839607),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G107_wall_088_01_00_1",center=Vector3.new(-74.211448,101.849273,-633.874103),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G108_wall_088_01_00_2",center=Vector3.new(-74.034892,99.938699,-633.909471),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G109_wall_088_02_00_0",center=Vector3.new(-9.522344,99.908209,-646.772439),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G110_wall_088_02_00_1",center=Vector3.new(-9.34722,101.818923,-646.807371),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G111_wall_088_02_00_2",center=Vector3.new(-9.172095,99.908209,-646.842303),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G112_wall_089_00_00_0",center=Vector3.new(-167.685931,113.790645,-542.733628),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G113_wall_089_00_00_2",center=Vector3.new(-167.335687,113.790509,-542.803492),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G114_wall_089_01_00_0",center=Vector3.new(-56.03564,99.932916,-564.995629),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G115_wall_089_01_00_1",center=Vector3.new(-55.861499,101.843766,-565.030261),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G116_wall_089_01_00_2",center=Vector3.new(-55.685389,99.933147,-565.065466),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G117_wall_089_02_00_0",center=Vector3.new(-6.424841,99.908301,-574.887412),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G118_wall_089_02_00_1",center=Vector3.new(-6.249716,101.819015,-574.922344),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G119_wall_089_02_00_2",center=Vector3.new(-6.074592,99.908301,-574.957275),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G120_wall_090_00_00_0",center=Vector3.new(-149.941976,112.598736,-473.83976),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G121_wall_090_00_00_2",center=Vector3.new(-149.591739,112.598419,-473.90961),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G122_wall_090_01_00_0",center=Vector3.new(-47.353203,99.922412,-494.294984),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G123_wall_090_01_00_1",center=Vector3.new(-47.178658,101.833221,-494.329698),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G124_wall_090_01_00_2",center=Vector3.new(-47.002952,99.922565,-494.364807),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G125_wall_090_02_00_0",center=Vector3.new(17.792569,99.908376,-507.284273),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G126_wall_090_02_00_1",center=Vector3.new(17.967694,101.819089,-507.319205),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G127_wall_090_02_00_2",center=Vector3.new(18.142819,99.908376,-507.35411),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G128_wall_091_00_00_0",center=Vector3.new(-115.086378,107.618461,-333.803545),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G129_wall_091_00_00_2",center=Vector3.new(-114.736141,107.6184,-333.873381),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G130_wall_091_01_00_0",center=Vector3.new(-24.821077,99.912916,-351.801613),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G131_wall_091_01_00_1",center=Vector3.new(-24.645997,101.823688,-351.836409),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G132_wall_091_01_00_2",center=Vector3.new(-24.47083,99.912977,-351.87145),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G133_wall_091_02_00_0",center=Vector3.new(55.41591,98.762458,-367.799732),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G134_wall_091_02_00_1",center=Vector3.new(55.591035,100.67309,-367.834813),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G135_wall_091_02_00_2",center=Vector3.new(55.76616,98.762376,-367.869554),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G136_wall_092_00_00_0",center=Vector3.new(-1.205,104.737779,-177.246533),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G137_wall_092_00_00_1",center=Vector3.new(-1.0561,111.88064,-177.281424),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G138_wall_092_00_00_2",center=Vector3.new(-0.880949,104.737782,-177.379986),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G139_wall_092_01_00_0",center=Vector3.new(6.804792,99.505751,-180.618112),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G140_wall_092_01_00_1",center=Vector3.new(6.95371,101.416469,-180.653031),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G141_wall_092_01_00_2",center=Vector3.new(7.128844,99.505758,-180.751562),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G142_wall_092_02_00_0",center=Vector3.new(93.107833,96.702416,-219.234221),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G143_wall_092_02_00_1",center=Vector3.new(93.257601,98.612676,-219.271721),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G144_wall_092_02_00_2",center=Vector3.new(93.431881,96.701898,-219.367674),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G145_wall_093_00_00_0",center=Vector3.new(25.443512,103.675628,-56.128479),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G146_wall_093_00_00_1",center=Vector3.new(25.562541,110.818485,-56.226997),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G147_wall_093_00_00_2",center=Vector3.new(25.711481,103.675628,-56.360113),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G148_wall_093_01_00_0",center=Vector3.new(31.065745,98.443508,-60.662247),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G149_wall_093_01_00_1",center=Vector3.new(31.184786,100.354225,-60.760771),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
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
