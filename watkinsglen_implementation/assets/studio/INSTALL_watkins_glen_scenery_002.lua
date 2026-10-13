-- Generated Watkins Glen visual installer: watkins_glen_scenery_002.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_scenery_002"
local KIND = "scenery"
local SOURCE_HASH = "bf019042b57192b292cd6a3a8bc1477c80d885dd4f6de1ec788931d0230ee4ec"
local GEOMETRIES = {
    {name="G000_m_van2_218_0",center=Vector3.new(-1052.610146,114.665735,695.852536),opacity=1.0,blend=false,texture="m_van2"},
    {name="G001_peop_03_219_0",center=Vector3.new(-1080.822709,114.76574,646.705025),opacity=1.0,blend=true,texture="people_pit"},
    {name="G002_people_bs01_220_0_cell__",center=Vector3.new(-1118.838884,119.188913,304.659871),opacity=1.0,blend=true,texture="people_pit"},
    {name="G003_people_bs01_220_0_cell_0",center=Vector3.new(-1141.160465,122.870783,-638.655145),opacity=1.0,blend=true,texture="people_pit"},
    {name="G004_bus_221_0",center=Vector3.new(-1035.488548,124.604896,-2301.492612),opacity=1.0,blend=false,texture="bus"},
    {name="G005_m_van6_222_0",center=Vector3.new(-1075.429622,121.094303,-2355.871322),opacity=1.0,blend=false,texture="m_van6"},
    {name="G006_peop_03_223_0",center=Vector3.new(-1067.106996,122.070938,-2326.028929),opacity=1.0,blend=true,texture="people_pit"},
    {name="G007_m_van4_224_0",center=Vector3.new(-1088.434883,120.948066,-2408.309882),opacity=1.0,blend=false,texture="m_van4"},
    {name="G008_peop_03_225_0",center=Vector3.new(-1013.336502,106.247889,-2633.752619),opacity=1.0,blend=true,texture="people_pit"},
    {name="G009_trailer01_226_0",center=Vector3.new(-1046.050739,113.037053,-2572.832726),opacity=1.0,blend=false,texture="trailer01"},
    {name="G010_m_van2_227_0",center=Vector3.new(-872.837915,98.938499,-2624.954283),opacity=1.0,blend=false,texture="m_van2"},
    {name="G011_suv_228_0",center=Vector3.new(-835.739721,98.594306,-2614.511493),opacity=1.0,blend=false,texture="suv"},
    {name="G012_trailer_229_0",center=Vector3.new(490.181411,13.411536,2631.375932),opacity=1.0,blend=false,texture="trailer"},
    {name="G013_m_van4_230_0",center=Vector3.new(450.595464,10.055214,2618.578927),opacity=1.0,blend=false,texture="m_van4"},
    {name="G014_m_van2_231_0",center=Vector3.new(407.583729,8.951446,2615.747255),opacity=1.0,blend=false,texture="m_van2"},
    {name="G015_peop_03_232_0",center=Vector3.new(512.141532,11.523485,2649.798486),opacity=1.0,blend=true,texture="people_pit"},
    {name="G016_vc_light_l_233_0",center=Vector3.new(1197.292261,95.304765,1548.264547),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G017_vc_light_l_234_0",center=Vector3.new(1157.032755,72.804768,2026.291128),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G018_vc_light_l_235_0",center=Vector3.new(974.604113,26.376196,3025.632918),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G019_vc_light_l_236_0",center=Vector3.new(618.049894,19.233339,2815.622202),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G020_vc_light_l_237_0",center=Vector3.new(301.991157,9.947625,2743.18789),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G021_vc_light_238_0",center=Vector3.new(-251.047516,13.16191,2433.8075),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G022_vc_light_l_239_0",center=Vector3.new(-494.471855,77.090485,1719.750265),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G023_vc_light_240_0",center=Vector3.new(-1128.078034,108.876198,764.859794),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G024_vc_light_l_241_0",center=Vector3.new(-1262.815161,117.447625,250.044174),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G025_vc_light_l_242_0",center=Vector3.new(-1268.577182,122.44763,-180.291677),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G026_vc_light_l_243_0",center=Vector3.new(-1272.632532,126.376196,-624.001383),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G027_vc_light_l_244_0",center=Vector3.new(-1277.860336,126.733334,-1142.876315),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G028_vc_light_245_0",center=Vector3.new(-1228.265852,128.161911,-2286.730521),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G029_vc_light_246_0",center=Vector3.new(-1158.173326,115.304766,-2631.571167),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G030_vc_light_247_0",center=Vector3.new(-812.616217,100.661908,-2780.455135),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G031_vc_light_248_0",center=Vector3.new(-457.343663,98.161912,-2504.107255),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G032_vc_light_249_0",center=Vector3.new(-385.059587,104.947625,-2163.377396),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G033_vc_light_250_0",center=Vector3.new(-315.007765,104.590481,-1813.18317),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G034_vc_light_251_0",center=Vector3.new(-242.795934,104.947625,-1458.797433),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G035_vc_light_252_0",center=Vector3.new(-175.985758,104.947625,-1118.357408),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G036_vc_light_253_0",center=Vector3.new(-104.253629,104.590481,-746.067007),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G037_vc_light_l_254_0",center=Vector3.new(352.698626,97.090479,-65.199969),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G038_vc_light_l_255_0",center=Vector3.new(746.660925,93.876195,-41.473751),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G039_vc_light_256_0",center=Vector3.new(1041.955095,90.304766,66.442122),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G040_vc_light_l_257_0",center=Vector3.new(1266.948953,99.947626,734.644808),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G041_c_light_br_258_0",center=Vector3.new(1219.723402,111.739997,1098.020805),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G042_vc_light_l_259_0",center=Vector3.new(1306.272323,94.947628,341.48852),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G043_vc_light_260_0",center=Vector3.new(-9.211207,104.590481,-250.955658),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G044_c_light_261_0",center=Vector3.new(1219.767809,-10711.558321,1097.988422),opacity=1.0,blend=true,texture="c_light_off"},
    {name="G045_cone01_262_0",center=Vector3.new(-1252.524989,121.085718,-1519.656686),opacity=1.0,blend=false,texture="cone01"},
    {name="G046_ambulance_269_0",center=Vector3.new(-164.674022,95.466575,-2218.071228),opacity=1.0,blend=false,texture="ambulance"},
    {name="G047_ambulance_270_0",center=Vector3.new(1148.546674,93.323716,459.970468),opacity=1.0,blend=false,texture="ambulance"},
    {name="G048_ambulance_271_0",center=Vector3.new(-321.017913,49.038003,2048.175875),opacity=1.0,blend=false,texture="ambulance"},
    {name="G049_ambulance_272_0",center=Vector3.new(988.914255,67.963684,2067.143163),opacity=1.0,blend=false,texture="ambulance"},
    {name="G050_tow_truck_273_0",center=Vector3.new(-319.93569,46.383428,2066.362902),opacity=1.0,blend=true,texture="tow_truck"},
    {name="G051_tow_truck_273_1",center=Vector3.new(-329.89321,46.123997,2063.48019),opacity=1.0,blend=true,texture="ambulance_lights"},
    {name="G052_tow_truck_274_0",center=Vector3.new(1153.19883,92.958242,435.910886),opacity=1.0,blend=true,texture="tow_truck"},
    {name="G053_tow_truck_274_1",center=Vector3.new(1162.744938,92.394886,440.206353),opacity=1.0,blend=true,texture="ambulance_lights"},
    {name="G054_tow_truck_275_0",center=Vector3.new(-173.931343,95.825517,-2197.120372),opacity=1.0,blend=true,texture="tow_truck"},
    {name="G055_tow_truck_275_1",center=Vector3.new(-179.367697,95.252656,-2206.027027),opacity=1.0,blend=true,texture="ambulance_lights"},
    {name="G056_tow_truck_276_0",center=Vector3.new(989.728151,67.254088,2082.83948),opacity=1.0,blend=true,texture="tow_truck"},
    {name="G057_tow_truck_276_1",center=Vector3.new(999.989773,66.681228,2083.555524),opacity=1.0,blend=true,texture="ambulance_lights"},
    {name="G058_cmpr_curv_277_0",center=Vector3.new(-689.200687,107.896747,-2405.386413),opacity=1.0,blend=false,texture="cmpr_curv"},
    {name="G059_cmpr_curv_277_1",center=Vector3.new(-689.320247,108.475068,-2403.071463),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G060_cmpr_line1_278_0",center=Vector3.new(-425.545824,118.725354,-1205.44274),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G061_cmpr_line1_278_1",center=Vector3.new(-424.9035,119.216807,-1212.231687),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G062_cmpr_line2_279_0",center=Vector3.new(-448.717597,118.597691,-1337.809846),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G063_cmpr_line2_279_1",center=Vector3.new(-447.236576,119.804853,-1341.142074),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G064_nbc_wagon_280_0",center=Vector3.new(996.670735,78.302193,1890.662536),opacity=1.0,blend=true,texture="nbc_wagon"},
    {name="G065_red_track_truck_281_0",center=Vector3.new(1129.895564,95.72888,655.993325),opacity=1.0,blend=false,texture="red_track_truck"},
    {name="G066_red_track_truck_281_1",center=Vector3.new(1140.917021,95.974356,655.968793),opacity=1.0,blend=true,texture="ambulance_lights"},
    {name="G067_pickup_new_282_0",center=Vector3.new(1127.575667,96.355355,678.391756),opacity=1.0,blend=false,texture="pickup_new"},
    {name="G068_truck_fire_283_0",center=Vector3.new(912.699017,72.820621,1982.252153),opacity=1.0,blend=false,texture="truck_fire"},
    {name="G069_truck_fire_283_1",center=Vector3.new(928.873771,71.604185,1982.34429),opacity=1.0,blend=true,texture="ambulance_lights"},
    {name="G070_cmpr_line1_284_0",center=Vector3.new(793.33662,94.082499,-219.06771),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G071_cmpr_line1_284_1",center=Vector3.new(793.455031,94.573952,-223.109638),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G072_cmpr_line2_285_0",center=Vector3.new(907.026991,94.04413,-213.509654),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G073_cmpr_line2_285_1",center=Vector3.new(907.958954,94.55875,-211.107944),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G074_cmpr_line1_286_0",center=Vector3.new(1044.964514,94.082499,-188.850331),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G075_cmpr_line1_286_1",center=Vector3.new(1044.37528,94.573952,-183.520149),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G076_cmpr_line2_287_0",center=Vector3.new(1145.436596,94.04413,-145.460362),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G077_cmpr_line2_287_1",center=Vector3.new(1141.438597,94.55875,-146.521327),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G078_cmpr_line1_288_0",center=Vector3.new(419.915759,12.69057,2517.24283),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G079_cmpr_line1_288_1",center=Vector3.new(419.453447,13.132358,2523.639885),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G080_cmpr_line2_289_0",center=Vector3.new(526.303665,15.204833,2547.959317),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G081_cmpr_line2_289_1",center=Vector3.new(523.556488,16.411996,2546.280586),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G082_cmpr_line1_290_0",center=Vector3.new(-367.629647,90.788601,1389.447917),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G083_cmpr_line1_290_1",center=Vector3.new(-367.368816,91.550912,1382.148648),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G084_cmpr_line2_291_0",center=Vector3.new(-313.455109,85.66845,1499.076173),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G085_cmpr_line2_291_1",center=Vector3.new(-312.900397,86.50313,1495.69262),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G086_cmpr_line1_292_0",center=Vector3.new(-708.939613,86.748771,1683.977918),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G087_cmpr_line1_292_1",center=Vector3.new(-708.242623,87.787569,1675.061539),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G088_cmpr_line2_293_0",center=Vector3.new(-668.830453,77.430215,1787.09503),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G089_cmpr_line2_293_1",center=Vector3.new(-668.063208,78.502638,1783.823314),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G090_cmpr_line1_294_0",center=Vector3.new(-942.612907,113.914915,786.896995),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G091_cmpr_line1_294_1",center=Vector3.new(-942.187244,114.898558,779.193844),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G092_cmpr_line1_295_0",center=Vector3.new(-694.046945,101.261997,1131.661671),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G093_cmpr_line1_295_1",center=Vector3.new(-693.07334,101.703786,1130.505922),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G094_cmpr_line2_296_0",center=Vector3.new(-593.23144,98.8989,1198.615972),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G095_cmpr_line2_296_1",center=Vector3.new(-594.610522,99.494821,1195.298529),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G096_cmpr_line1_297_0",center=Vector3.new(-475.169503,96.145744,1269.4285),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G097_cmpr_line1_297_1",center=Vector3.new(-475.944549,96.908055,1269.179511),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G098_cmpr_line1_298_0",center=Vector3.new(-1042.924359,121.225357,402.495188),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G099_cmpr_line1_298_1",center=Vector3.new(-1043.239213,121.71681,397.039698),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G100_cmpr_line2_299_0",center=Vector3.new(-1050.186974,121.186988,285.943193),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G101_cmpr_line2_299_1",center=Vector3.new(-1048.435578,121.701608,282.806187),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G102_cmpr_line1_300_0",center=Vector3.new(-1062.53421,123.011071,163.325078),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G103_cmpr_line1_300_1",center=Vector3.new(-1061.589852,123.502524,167.440464),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G104_cmpr_line2_301_0",center=Vector3.new(-1069.909624,122.972702,46.457211),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G105_cmpr_line2_301_1",center=Vector3.new(-1072.030997,123.487323,48.73285),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G106_cmpr_line1_302_0",center=Vector3.new(-1075.165234,124.796786,-67.231487),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G107_cmpr_line1_302_1",center=Vector3.new(-1078.153574,125.288239,-69.952655),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G108_cmpr_line2_303_0",center=Vector3.new(-1080.602857,124.758417,-181.775015),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G109_cmpr_line2_303_1",center=Vector3.new(-1078.481482,125.273037,-184.050655),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G110_cmpr_line1_304_0",center=Vector3.new(-1081.855008,125.511074,-298.298711),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G111_cmpr_line1_304_1",center=Vector3.new(-1078.866667,126.002527,-295.577543),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G112_cmpr_line2_305_0",center=Vector3.new(-1081.637853,125.829843,-412.605895),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G113_cmpr_line2_305_1",center=Vector3.new(-1083.759228,126.344463,-410.330255),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G114_cmpr_line1_306_0",center=Vector3.new(-1075.456569,125.868211,-530.80716),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G115_cmpr_line1_306_1",center=Vector3.new(-1079.733781,126.359665,-530.951138),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G116_cmpr_line2_307_0",center=Vector3.new(-1061.997857,125.829843,-644.408306),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G117_cmpr_line2_307_1",center=Vector3.new(-1064.401634,126.344463,-642.956596),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G118_cmpr_line1_308_0",center=Vector3.new(-1042.905169,126.225363,-758.525121),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G119_cmpr_line1_308_1",center=Vector3.new(-1048.109779,126.716816,-758.77085),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G120_cmpr_line1_309_0",center=Vector3.new(-1030.416185,119.439643,511.819234),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G121_cmpr_line1_309_1",center=Vector3.new(-1030.731039,119.931096,506.363745),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G122_cmpr_line2_310_0",center=Vector3.new(-1008.627584,119.348105,624.093363),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G123_cmpr_line2_310_1",center=Vector3.new(-1007.643956,119.884212,620.703971),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G124_cmpr_line1_311_0",center=Vector3.new(-829.133176,104.4653,1005.213627),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G125_cmpr_line1_311_1",center=Vector3.new(-829.833022,104.953633,1002.120134),opacity=1.0,blend=false,texture="cmprs_only"},
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
