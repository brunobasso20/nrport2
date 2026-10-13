-- Generated Watkins Glen visual installer: watkins_glen_walls_006.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_walls_006"
local KIND = "walls"
local SOURCE_HASH = "bec48664785127a33e26c21d37a127c0e786088175d32c3f0c522d8bec956fa0"
local GEOMETRIES = {
    {name="G000_wall_064_02_00_2",center=Vector3.new(-1223.735646,121.203027,-2264.283098),opacity=1.0,blend=false,texture="trackmat__tires"},
    {name="G001_wall_cap_064_02_4",center=Vector3.new(-1231.591197,121.20268,-2282.753536),opacity=1.0,blend=false,texture="trackmat__tires_far"},
    {name="G002_wall_064_03_00_0",center=Vector3.new(-1286.17581,121.203027,-2263.554818),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G003_wall_064_03_00_1",center=Vector3.new(-1287.96136,122.631598,-2263.534001),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G004_wall_064_04_00_0",center=Vector3.new(-1290.05443,121.685171,-2263.509587),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G005_wall_064_04_00_1",center=Vector3.new(-1290.233013,123.595885,-2263.507516),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G006_wall_064_04_00_2",center=Vector3.new(-1290.411595,121.685171,-2263.505445),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G007_wall_065_00_00_0",center=Vector3.new(-1229.468754,120.63553,-2350.18583),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G008_wall_065_00_00_1",center=Vector3.new(-1229.647337,122.546244,-2350.183759),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G009_wall_065_00_00_2",center=Vector3.new(-1229.825865,120.635537,-2350.181689),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G010_wall_065_01_00_0",center=Vector3.new(-1288.960702,121.201856,-2349.491991),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G011_wall_065_01_00_1",center=Vector3.new(-1290.746307,122.630426,-2349.471174),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G012_wall_065_02_00_0",center=Vector3.new(-1292.808805,121.683999,-2349.447087),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G013_wall_065_02_00_1",center=Vector3.new(-1292.987388,123.594713,-2349.445016),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G014_wall_065_02_00_2",center=Vector3.new(-1293.16597,121.683999,-2349.442945),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G015_wall_066_00_00_0",center=Vector3.new(-1176.939665,113.813571,-2546.698543),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G016_wall_066_00_00_1",center=Vector3.new(-1177.118192,115.724288,-2546.819196),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G017_wall_066_00_00_2",center=Vector3.new(-1177.246584,113.813768,-2546.820613),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G018_wall_066_01_00_0",center=Vector3.new(-1294.612503,118.158466,-2614.807674),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G019_wall_066_01_00_1",center=Vector3.new(-1296.299471,119.58704,-2616.028486),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G020_wall_066_02_00_0",center=Vector3.new(-1297.635869,118.64061,-2616.019004),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G021_wall_066_02_00_1",center=Vector3.new(-1297.804587,120.551327,-2616.141074),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G022_wall_066_02_00_2",center=Vector3.new(-1297.932925,118.64061,-2616.141074),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G023_wall_067_00_00_0",center=Vector3.new(-995.520428,102.770914,-2731.083461),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G024_wall_067_00_00_1",center=Vector3.new(-995.64724,104.681758,-2731.253052),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G025_wall_067_00_00_2",center=Vector3.new(-995.651027,102.77194,-2731.386239),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G026_wall_067_01_00_0",center=Vector3.new(-1067.032841,109.991053,-2862.368883),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G027_wall_067_01_00_1",center=Vector3.new(-1068.31616,111.419623,-2864.118086),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G028_wall_067_02_00_0",center=Vector3.new(-1068.330629,110.473197,-2865.341949),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G029_wall_067_02_00_1",center=Vector3.new(-1068.458966,112.383911,-2865.516881),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G030_wall_067_02_00_2",center=Vector3.new(-1068.461255,110.473197,-2865.641022),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G031_wall_067_03_00_0",center=Vector3.new(-1071.331024,113.919619,-2871.665519),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G032_wall_067_03_00_2",center=Vector3.new(-1071.46165,113.919619,-2871.964591),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G033_wall_profile_067_03_00_0",center=Vector3.new(-1071.329389,119.781787,-2871.576255),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G034_wall_profile_067_03_00_0",center=Vector3.new(-1071.23255,120.875543,-2871.198382),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G035_wall_profile_067_03_00_0",center=Vector3.new(-1070.96465,121.952547,-2870.451137),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G036_wall_profile_067_03_00_0",center=Vector3.new(-1070.550237,122.644506,-2869.390651),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G037_wall_profile_067_03_00_2",center=Vector3.new(-1071.460015,119.781787,-2871.875327),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G038_wall_profile_067_03_00_2",center=Vector3.new(-1071.363177,120.875543,-2871.497454),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G039_wall_profile_067_03_00_2",center=Vector3.new(-1071.095276,121.952547,-2870.750209),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G040_wall_profile_067_03_00_2",center=Vector3.new(-1070.680864,122.644506,-2869.689832),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G041_wall_profile_top_067_03_",center=Vector3.new(-1070.153182,122.848191,-2868.849509),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G042_wall_068_00_00_0",center=Vector3.new(-773.509271,95.474696,-2766.318403),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G043_wall_068_00_00_1",center=Vector3.new(-773.43799,97.386234,-2766.488103),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G044_wall_068_00_00_2",center=Vector3.new(-773.436465,95.475905,-2766.659001),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G045_wall_068_01_00_0",center=Vector3.new(-758.429255,102.966632,-2858.576856),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G046_wall_068_01_00_1",center=Vector3.new(-757.701193,104.395202,-2860.362353),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G047_wall_068_02_00_0",center=Vector3.new(-757.703999,103.448776,-2861.966705),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G048_wall_068_02_00_1",center=Vector3.new(-757.631193,105.35949,-2862.145233),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G049_wall_068_02_00_2",center=Vector3.new(-757.631193,103.448776,-2862.307194),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G050_wall_068_03_00_0",center=Vector3.new(-755.817114,106.895205,-2869.480351),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G051_wall_068_03_00_2",center=Vector3.new(-755.744307,106.895205,-2869.820949),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G052_wall_profile_068_03_00_0",center=Vector3.new(-755.817114,112.757373,-2869.363948),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G053_wall_profile_068_03_00_0",center=Vector3.new(-755.869429,113.851118,-2868.906403),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G054_wall_profile_068_03_00_0",center=Vector3.new(-756.017331,114.928126,-2868.032292),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G055_wall_profile_068_03_00_0",center=Vector3.new(-756.247112,115.620092,-2866.805594),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G056_wall_profile_068_03_00_2",center=Vector3.new(-755.744307,112.757373,-2869.704437),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G057_wall_profile_068_03_00_2",center=Vector3.new(-755.796623,113.851118,-2869.247001),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G058_wall_profile_068_03_00_2",center=Vector3.new(-755.944524,114.928126,-2868.372999),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G059_wall_profile_068_03_00_2",center=Vector3.new(-756.174333,115.620092,-2867.146083),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G060_wall_profile_top_068_03_",center=Vector3.new(-756.47237,115.823776,-2866.253117),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G061_wall_069_00_00_0",center=Vector3.new(-639.757347,93.115902,-2722.532872),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G062_wall_069_00_00_1",center=Vector3.new(-639.653833,95.026936,-2722.691345),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G063_wall_069_00_00_2",center=Vector3.new(-639.573751,93.117036,-2722.83674),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G064_wall_069_01_00_0",center=Vector3.new(-603.611101,100.60512,-2783.248792),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G065_wall_069_01_00_1",center=Vector3.new(-602.526229,102.03369,-2784.868949),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G066_wall_069_02_00_0",center=Vector3.new(-601.79487,101.087264,-2786.259242),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G067_wall_069_02_00_1",center=Vector3.new(-601.686369,102.997977,-2786.421204),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G068_wall_069_02_00_2",center=Vector3.new(-601.611274,101.087264,-2786.563001),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G069_wall_070_00_00_0",center=Vector3.new(-579.665892,92.714432,-2682.026781),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G070_wall_070_00_00_1",center=Vector3.new(-579.548318,94.625831,-2682.16204),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G071_wall_070_00_00_2",center=Vector3.new(-579.432814,92.716135,-2682.296535),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G072_wall_070_01_00_0",center=Vector3.new(-535.790961,99.986999,-2732.779476),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G073_wall_070_01_00_1",center=Vector3.new(-534.544999,101.415569,-2734.19778),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G074_wall_070_01_00_2",center=Vector3.new(-533.460127,99.986999,-2735.477012),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G075_wall_cap_070_01_4",center=Vector3.new(-511.860085,99.830825,-2714.873941),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G076_wall_070_02_00_0",center=Vector3.new(-533.479091,100.469143,-2735.452924),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G077_wall_070_02_00_1",center=Vector3.new(-533.354514,102.379857,-2735.594722),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G078_wall_070_02_00_2",center=Vector3.new(-533.246013,100.469143,-2735.722569),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G079_wall_071_00_00_0",center=Vector3.new(-540.720885,92.625635,-2643.816812),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G080_wall_071_00_00_1",center=Vector3.new(-540.587861,94.537214,-2643.937574),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G081_wall_071_00_00_2",center=Vector3.new(-540.455682,92.627471,-2644.054849),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G082_wall_071_01_00_0",center=Vector3.new(-489.326613,100.200203,-2690.099553),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G083_wall_071_01_00_1",center=Vector3.new(-489.186014,102.110917,-2690.2274),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G084_wall_071_01_00_2",center=Vector3.new(-489.061437,100.200203,-2690.337481),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G085_wall_072_00_00_0",center=Vector3.new(-508.16209,92.668683,-2604.856546),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G086_wall_072_00_00_1",center=Vector3.new(-508.018521,94.580146,-2604.960741),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G087_wall_072_00_00_2",center=Vector3.new(-507.870483,92.670407,-2605.061885),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G088_wall_072_01_00_0",center=Vector3.new(-452.514689,100.037459,-2644.016266),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G089_wall_072_01_00_1",center=Vector3.new(-452.363682,101.948173,-2644.126347),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G090_wall_072_01_00_2",center=Vector3.new(-452.223083,100.037459,-2644.221715),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G091_wall_073_00_00_0",center=Vector3.new(-550.227383,103.106771,-2510.54415),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G092_wall_073_00_00_2",center=Vector3.new(-549.909156,103.106948,-2510.702079),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G093_wall_073_01_00_0",center=Vector3.new(-475.576878,93.179297,-2547.74595),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G094_wall_073_01_00_1",center=Vector3.new(-475.416756,95.090655,-2547.836522),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G095_wall_073_01_00_2",center=Vector3.new(-475.258677,93.180827,-2547.903987),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G096_wall_073_02_00_0",center=Vector3.new(-404.614885,100.12816,-2581.797028),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G097_wall_073_02_00_1",center=Vector3.new(-404.447678,102.03886,-2581.892395),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G098_wall_073_02_00_2",center=Vector3.new(-404.296671,100.127895,-2581.955065),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G099_wall_074_00_00_0",center=Vector3.new(-523.767362,103.005075,-2452.313014),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G100_wall_074_00_00_2",center=Vector3.new(-523.42502,103.005045,-2452.410562),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G101_wall_074_01_00_0",center=Vector3.new(-446.224131,94.362719,-2474.57428),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G102_wall_074_01_00_1",center=Vector3.new(-446.049009,96.273388,-2474.634334),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G103_wall_074_01_00_2",center=Vector3.new(-445.881803,94.363414,-2474.671827),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G104_wall_074_02_00_0",center=Vector3.new(-344.29309,100.404205,-2502.256666),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G105_wall_074_02_00_1",center=Vector3.new(-344.117955,102.314666,-2502.319336),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G106_wall_074_02_00_2",center=Vector3.new(-343.950748,100.403476,-2502.354213),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G107_wall_075_00_00_0",center=Vector3.new(-507.557624,102.903472,-2406.532942),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G108_wall_075_00_00_2",center=Vector3.new(-507.20738,102.903226,-2406.602696),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G109_wall_075_01_00_0",center=Vector3.new(-432.486629,95.712457,-2421.497236),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G110_wall_075_01_00_1",center=Vector3.new(-432.311399,97.623161,-2421.536255),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G111_wall_075_01_00_2",center=Vector3.new(-432.136372,95.710492,-2421.56699),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G112_wall_075_02_00_0",center=Vector3.new(-304.033416,100.455873,-2447.113691),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G113_wall_075_02_00_1",center=Vector3.new(-303.853226,102.366182,-2447.14944),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G114_wall_075_02_00_2",center=Vector3.new(-303.683172,100.454998,-2447.183446),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G115_wall_076_00_00_0",center=Vector3.new(-479.273687,105.323679,-2291.740199),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G116_wall_076_00_00_2",center=Vector3.new(-478.923457,105.323665,-2291.809954),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G117_wall_076_01_00_0",center=Vector3.new(-409.469632,98.116027,-2305.662537),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G118_wall_076_01_00_1",center=Vector3.new(-409.274006,100.024445,-2305.697414),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G119_wall_076_01_00_2",center=Vector3.new(-409.119388,98.114072,-2305.732291),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G120_wall_076_02_00_0",center=Vector3.new(-230.111272,96.427243,-2341.404724),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G121_wall_076_02_00_1",center=Vector3.new(-229.932036,98.324186,-2341.456277),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G122_wall_076_02_00_2",center=Vector3.new(-229.761028,96.418841,-2341.474479),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G123_wall_077_00_00_0",center=Vector3.new(-444.736344,109.328341,-2143.749237),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G124_wall_077_00_00_2",center=Vector3.new(-444.386114,109.328399,-2143.819101),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G125_wall_077_01_00_0",center=Vector3.new(-379.818276,99.92765,-2156.692723),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G126_wall_077_01_00_1",center=Vector3.new(-379.645729,101.838613,-2156.7276),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G127_wall_077_01_00_2",center=Vector3.new(-379.468019,99.927899,-2156.762477),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G128_wall_077_02_00_0",center=Vector3.new(-209.169231,95.50394,-2190.718842),opacity=1.0,blend=false,texture="trackmat__tires"},
    {name="G129_wall_077_02_00_1",center=Vector3.new(-207.593114,97.342563,-2191.033064),opacity=1.0,blend=false,texture="trackmat__tires_top"},
    {name="G130_wall_077_02_00_2",center=Vector3.new(-206.01699,95.341638,-2191.347286),opacity=1.0,blend=false,texture="trackmat__tires"},
    {name="G131_wall_cap_077_02_3",center=Vector3.new(-170.418079,92.551443,-2253.134046),opacity=1.0,blend=false,texture="trackmat__tires_near"},
    {name="G132_wall_cap_077_02_4",center=Vector3.new(-244.768143,98.294136,-2128.932081),opacity=1.0,blend=false,texture="trackmat__tires_far"},
    {name="G133_wall_077_03_00_0",center=Vector3.new(-134.412224,91.244418,-2205.620357),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G134_wall_077_03_00_1",center=Vector3.new(-134.153124,93.136093,-2205.676379),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G135_wall_077_03_00_2",center=Vector3.new(-134.061967,91.226384,-2205.690329),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G136_wall_078_00_00_0",center=Vector3.new(-419.332831,111.963596,-2027.147675),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G137_wall_078_00_00_2",center=Vector3.new(-418.982588,111.96364,-2027.217647),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G138_wall_078_01_00_0",center=Vector3.new(-356.491852,99.970841,-2039.677102),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G139_wall_078_01_00_1",center=Vector3.new(-356.321989,101.882052,-2039.711435),opacity=1.0,blend=false,texture="trackmat__armco_top_r"},
    {name="G140_wall_078_01_00_2",center=Vector3.new(-356.141594,99.971591,-2039.746857),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G141_wall_078_02_00_0",center=Vector3.new(-260.493701,98.468287,-2058.818599),opacity=1.0,blend=false,texture="trackmat__haybales"},
    {name="G142_wall_078_02_00_1",center=Vector3.new(-258.742455,99.796619,-2059.167807),opacity=1.0,blend=false,texture="trackmat__haybales_top"},
    {name="G143_wall_078_02_00_2",center=Vector3.new(-256.991223,98.285978,-2059.517016),opacity=1.0,blend=false,texture="untextured"},
    {name="G144_wall_cap_078_02_3",center=Vector3.new(-244.768143,97.811992,-2128.93219),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G145_wall_cap_078_02_4",center=Vector3.new(-272.716781,98.590033,-1989.403425),opacity=1.0,blend=false,texture="trackmat__haybales_side"},
    {name="G146_wall_078_03_00_0",center=Vector3.new(-257.019097,98.76817,-2059.511457),opacity=1.0,blend=true,texture="trackmat__armco_l3"},
    {name="G147_wall_078_03_00_1",center=Vector3.new(-256.753445,100.659844,-2059.564318),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G148_wall_078_03_00_2",center=Vector3.new(-256.66884,98.749941,-2059.581212),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G149_wall_cap_078_03_3",center=Vector3.new(-242.884282,98.183305,-2129.307774),opacity=1.0,blend=false,texture="trackmat__armco_l"},
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
