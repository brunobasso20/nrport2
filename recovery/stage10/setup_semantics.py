"""Stage 10 semantic map of the 184 NR2003 setup items (setup struct: 184 dwords + names/notes, 0xefd bytes;
active setup c055c0, garage setup c03350). Evidence codes:
  UI   garage page strings (00485070/0047e910 per corner, 0047efc0 summary, 00484e70 sliders, 0047e8e0)
  TEL  telemetry export 0055c830 (field order)            CONV converter/descriptor (units)
  DER  derived by 00425ad0 chain (00425690/004257a0/00425900/00425a30/00424860)
  RT   runtime destination (0055e9b0 build, 005601c0/00550f10 pit stop, 00410280 aero, 0051a730 gears)
  DYN  dynamic destination analysis (recovery/stage10: one garage step, original build, memory diff)
status: IDENTIFIED (name backed by UI/TEL and runtime use), INFERRED (runtime use + units, no UI label),
UNKNOWN (stored/derived, semantics not established)."""

C = ['LF', 'RF', 'LR', 'RR']
S = {}
def item(i, name, unit, conv, group, status, evidence, note=''):
    S[i] = dict(name=name, unit=unit, conv=conv, group=group, status=status, evidence=evidence, note=note)

for c in range(4):
    item(c, 'tirePressure' + C[c], 'psi (cold)', 'stored as display value (float identity)', 'tires', 'IDENTIFIED',
         'UI N3TirePressure%sText; TEL; RT 0055e9b0 -> tyre object +0 (bf3a20+0xa39*w), 00550f10 pit stop' % C[c],
         'garage 8..60 step 0.5, default 36')
    item(4 + c, 'shockBump' + C[c], 'setting 1..9', 'int identity', 'shocks', 'IDENTIFIED',
         'UI N3Compression%sText; RT 0055e9b0 -> 0074e0e0+4w, damper curve 0055e880/0055e510 -> 0074e32c..; DER 0x81+w (00425900, table 00721ff0)' % C[c])
    item(8 + c, 'shockReserved8_' + C[c], '0..1', 'int identity', 'shocks', 'UNKNOWN',
         'UI column param_5 = 0 (not shown); step 0 (not adjustable for the Cup); TEL item c+8 exported as float')
    item(12 + c, 'shockRebound' + C[c], 'setting 1..9', 'int identity', 'shocks', 'IDENTIFIED',
         'UI N3Rebound%sText; RT 0055e9b0 -> 0074e0f0+4w, damper curve tables; DER 0x85+w (00425900)' % C[c])
    item(16 + c, 'shockReserved16_' + C[c], '0..1', 'int identity', 'shocks', 'UNKNOWN', 'UI column param_7 = 0 (not shown); step 0')
    item(20 + c, 'spring' + C[c], 'lb/in -> N/m wheel rate (x175 x MR^2, MR 0.56 front / 0.85 rear, sign -)', '00423ee0/00423f00 front, 00423f30/00423f50 rear',
         'springs', 'IDENTIFIED', 'UI N3Springs%sText; TEL; RT 0055e9b0 -> 0074e0a0+4w; DER corner weights/ride heights 00424860' % C[c],
         'front 450..2500 step 50 (default 1300), rear 150..650 step 25 (default 325)')
    item(24 + c, 'springRubber' + C[c], 'in?', 'float identity', 'springs', 'IDENTIFIED',
         'UI N3SpringRubbers%sText; range 0..0 (not adjustable for the Cup)' % C[c])
    item(28 + c, 'bumpRubber' + C[c], 'in -> m', '00423f80/00423fa0', 'springs', 'IDENTIFIED',
         'UI N3BumpRubbers%sText; RT 0055e9b0 -> 0074e0c0+4w; fixed 1.25 in for the Cup' % C[c])
    item(32 + c, 'camber' + C[c], 'deg -> rad', '00423e60/00423e80', 'geometry', 'IDENTIFIED',
         'UI N3Camber%sText; TEL; DER 0x8d+w static camber (00424860); RT hub rotation +0x59 (0055e9b0)' % C[c],
         'front -7..7 step 0.1 (default -2.0), rear -1.8..1.8 step 1.8 (default 0)')
    item(36 + c, 'rideHeight' + C[c], 'in -> m', '00423f80/00423fa0', 'geometry', 'IDENTIFIED',
         'UI N3RideHeight%sText; TEL; DER RF = LF + (RR - LR) snapped (00425a30), chassis plane; RT spring perches/ballast/aero ref (0055e9b0)' % C[c],
         'LF 4.5..5.5, LR 5.5..6.5, RR 6.0..7.0 step 0.25; RF not adjustable (derived)')
item(40, 'brakeBias', '% front -> fraction', '00423de0/00423e00', 'brakes', 'IDENTIFIED',
     'UI N3BrakeBiasText; TEL; RT 0055e9b0 -> brake torque cells c0850c..c08518 (variable cells, Stage 8)', '50..90 step 1, default 74')
item(41, 'toeFront', 'in (at 27.9 in) -> rad', '00423fc0/00423fe0', 'geometry', 'IDENTIFIED',
     'UI N3ToeFrontText (0047efc0 0x29); TEL; RT 0055e9b0 -> c086b0/c086b4 = toe*0.5 (read by 005539c0 each tick)', '-0.2..0.2 step 0.025, default -0.125')
item(42, 'toeRear', 'in (at 27.9 in) -> rad', '00423fc0/00423fe0', 'geometry', 'IDENTIFIED',
     'TEL 0x2a; RT c086b8/c086bc -> rear wheel record +0x51 (0055e9b0); fixed 0.0625 for the Cup')
item(43, 'swayBarFrontIndex', 'bar size index 0..19', 'int identity', 'antiroll', 'IDENTIFIED',
     'DER 004257a0: 0x63 = -(((i+13)*k1-1)*k2+k3)*175 (front ARB rate), display 00424160; UI N3SwayBarFText shows 0x63; RT 0074e788 (variable cell)')
item(44, 'swayBarRearIndex', 'bar size index 0..31 (0 = none)', 'int identity', 'antiroll', 'IDENTIFIED',
     'DER 004257a0: 0x64 = 6200 - ((i+9)*k)^4*... (rear ARB rate), display 004241a0; UI N3SwayBarRText; RT 0074e78c (variable cell)')
item(45, 'trackBarLR', 'in -> m', '00423f80/00423fa0', 'geometry', 'IDENTIFIED',
     'UI N3TrackBarLRText (0x2d); TEL; RT rear axle/wheel z offsets c085ac (0055e9b0), pit stop 005601c0', '8.5..14 step 0.25, default 10')
item(46, 'trackBarRR', 'in -> m', '00423f80/00423fa0', 'geometry', 'IDENTIFIED',
     'UI N3TrackBarRRText (0x2e); TEL; RT as LR; pit-stop adjustable (0040e1c0 -> 005580f0 -> 005601c0)', '8.5..14 step 0.25, default 10')
item(47, 'option47', '0..1', 'int identity', 'misc', 'UNKNOWN', 'no runtime use found in the build (DYN: only the item changes)')
item(48, 'steeringRatio', ':1', '00423e30/00423e40 (int -> float)', 'steering', 'IDENTIFIED',
     'TEL 0x30; read at run time by the steering chain (00554fb0, Stage 12); DYN: no build cell changes', '12..32 step 1, default 18')
item(49, 'fuel', 'US gal -> kg (/0.3524)', '00424050/00424070', 'fuel', 'IDENTIFIED',
     'garage fuel step 00480b40 -> 00558530 with live limits; 004254d0 sets 0x31 = spec+0x24 (full cell 62.47 kg) at default completion; DER 0x5c gallons, 0x62 total weight; DYN: no build cell changes (fuel mass from 00550c60, Stage 11)', '1..22 gal')
item(50, 'gearSetChoice', '0..1', 'int identity', 'drivetrain', 'INFERRED',
     '00424570 reads 0x32 to choose the engine/gear set row for 0051a730 (session dependent); DYN: no change for the Cup')
for k, (idx, nm) in enumerate([(51, 'R'), (52, 'N'), (53, '1'), (54, '2'), (55, '3'), (56, '4')]):
    item(idx, 'gearChoice' + nm, 'gear table index (006ed880 numerator/denominator pairs)', 'int identity', 'drivetrain', 'IDENTIFIED',
         'garage gear step 00480ba0 -> 005583e0 + 00425690; DER ratio 0x66+%d, numerator 0x6f+%d, denominator 0x78+%d; RT engine object +0x448.. via 0051a730 (reads the garage setup c03350)' % (k, k, k))
item(57, 'finalDriveChoice', 'gear table index', 'int identity', 'drivetrain', 'IDENTIFIED',
     '00425690 case 8 -> ratio 0x6e (final drive); RT engine object +0x468 via 0051a730', '100..148, default 127')
item(58, 'steeringGeometryIndex', 'table index 0..32767 (006ed7e0 pairs)', 'int identity', 'steering', 'INFERRED',
     'DER 00424860: 0x9f/0xa0 = cos(table[0x3a].a/b * k), 0xa1..0xa4; not used by the build (DYN)')
item(59, 'grilleTape', '% -> fraction', '00423de0/00423e00', 'aero', 'IDENTIFIED',
     'UI txtN3GrilleTape; TEL 0x3b; read at run time by 00410280 (aero, Stage 9) and 00554520 (engine thermal, Stage 11); pit-stop adjustable', '0..100 step 5')
item(60, 'tape2', '% -> fraction', '00423de0/00423e00', 'aero', 'INFERRED', 'second tape item (0x3c), same converter; no build use (DYN)')
item(61, 'spoilerAngle', 'deg -> deg-45', '004241d0/004241f0', 'aero', 'IDENTIFIED',
     'UI txtN3SpoilerAngle; TEL 0x3d; read at run time by 00410280 (Stage 9)', '45..70 step 1, default 65')
item(62, 'ballastLeftRight', 'lb -> kg', '004240c0/004240e0', 'weight', 'IDENTIFIED',
     'UI slicntrlN3LRBias (0x3e, inverted slider); DER corner weights 00424860; RT ballast record position (0055e9b0)', '-50..150 step 5')
item(63, 'ballastFrontRear', 'lb -> kg', '00424110/00424130', 'weight', 'IDENTIFIED',
     'UI slicntrlN3FRBias (0x3f); DER corner weights; RT ballast record position', '-200..150 step 5')
item(64, 'wedge', 'lb -> kg', '00424000/00424020', 'weight', 'IDENTIFIED',
     'UI slicntrlN3Wedge (0x40); TEL; DER corner weights/spring perches 00424860 (0x9b/0x9c/0x9d); pit-stop adjustable (0040e1c0 -> 005581d0 -> 005601c0)', '-150..150 step 5')
item(65, 'staggerFront', 'in circumference -> m radius (x0.0254/6.28)', '00423ea0/00423ec0', 'tires', 'IDENTIFIED',
     'UI N3StaggerFText (0x41); DER overwritten by 00424860 = tyre radius RF - LF (display only); DYN: no effect')
item(66, 'staggerRear', 'in circumference -> m radius', '00423ea0/00423ec0', 'tires', 'IDENTIFIED',
     'UI N3StaggerRText (0x42); DER overwritten = tyre radius RR - LR; DYN: no effect')
item(67, 'casterLF', 'deg -> rad', '00423e60/00423e80', 'geometry', 'IDENTIFIED',
     'UI N3CasterLFText (0x43); TEL; RT hub rotation +0x55 (0055e9b0), c082d4 trail term', '-2..6 step 0.25, default 2.5')
item(68, 'casterRF', 'deg -> rad', '00423e60/00423e80', 'geometry', 'IDENTIFIED', 'UI N3CasterRFText (0x44); TEL; RT rfhub +0x55, c082d8')
item(69, 'gearChoice5', 'gear table index', 'int identity', 'drivetrain', 'IDENTIFIED', '00425690 case 6 (5th gear); Cup has 4 gears')
item(70, 'gearChoice6', 'gear table index', 'int identity', 'drivetrain', 'IDENTIFIED', '00425690 case 7 (6th gear); Cup has 4 gears')
for c in range(4):
    item(71 + c, 'tirePressureHot' + C[c], 'psi', 'derived (00425ad0: = cold pressure)', 'tires', 'INFERRED', 'DER 00425ad0 copies item c; 00425c20 live tyre values (Stage 11)')
for c in range(4):
    for z, zn in enumerate(['Inner', 'Middle', 'Outer']):
        item(75 + 3 * c + z, 'tireTemp%s%s' % (C[c], zn), 'K (display C)', 'derived; toDisplay 004240a0 (K-273.15)', 'tires', 'INFERRED',
             'DER 00425ad0 = 295.37 K (0x4393afa5); live from tyre thermal (00425c20, Stage 11)')
for c in range(4):
    item(87 + c, 'tireWear' + C[c], '-', 'derived', 'tires', 'UNKNOWN', 'DER 00425ad0 = 0 (0x57+c); live values 00425c20 (Stage 11)')
item(91, 'fuelUseFactor', '-', 'derived 00425ad0 (0x5b = 1/(k*spec+0x1c0))', 'fuel', 'INFERRED', 'live 00425c20')
item(92, 'fuelGallons', 'gal', 'derived (0x5c = 0x31*0.3524)', 'fuel', 'IDENTIFIED', 'DER 00425ad0')
item(93, 'frontRollCouple', '%', 'derived 004257a0', 'antiroll', 'IDENTIFIED', 'UI txtFrontRollCouple shows 0x5d (0047efc0)')
for c in range(4):
    item(94 + c, 'cornerWeight' + C[c], 'kg (display lb)', 'derived 00424860; toDisplay 00424020', 'weight', 'IDENTIFIED', 'UI txtN3%sWeight' % C[c])
item(98, 'totalWeight', 'lb', 'derived 00425ad0 (0x62)', 'weight', 'IDENTIFIED', '')
item(99, 'swayBarFrontRate', 'N/m (sign -)', 'derived 004257a0; display 00424160 (bar size)', 'antiroll', 'IDENTIFIED', 'RT 0074e788 (0055e9b0, variable cell)')
item(100, 'swayBarRearRate', 'N/m', 'derived 004257a0; display 004241a0', 'antiroll', 'IDENTIFIED', 'RT 0074e78c (variable cell)')
item(101, 'gearCount', 'forward gears', 'derived 004254d0 (engine +0x444)', 'drivetrain', 'IDENTIFIED', 'Cup: 4')
for k, nm in enumerate(['R', 'N', '1', '2', '3', '4', '5', '6']):
    item(102 + k, 'gearRatio' + nm, 'ratio', 'derived 00425690 (numerator/denominator, R negated, N = 0)', 'drivetrain', 'IDENTIFIED', 'RT engine +0x448.. via 0051a730')
item(110, 'finalDriveRatio', 'ratio', 'derived 00425690 (case 8)', 'drivetrain', 'IDENTIFIED', 'UI txtN3DiffRatio; RT engine +0x468')
for k in range(9):
    item(111 + k, 'gearNumerator%d' % k, 'teeth', 'derived 00425690', 'drivetrain', 'IDENTIFIED', '')
    item(120 + k, 'gearDenominator%d' % k, 'teeth', 'derived 00425690', 'drivetrain', 'IDENTIFIED', '')
for c in range(4):
    item(129 + c, 'shockBumpCoefficient' + C[c], '-', 'derived 00425900 (table 00721ff0[toDisplay(item c+4)])', 'shocks', 'IDENTIFIED', 'RT damper curves (0055e880)')
    item(133 + c, 'shockReboundCoefficient' + C[c], '-', 'derived 00425900 (table 00721ff0[toDisplay(item c+12)])', 'shocks', 'IDENTIFIED', '')
for c in range(4):
    item(137 + c, 'bumpStopRate' + C[c], 'N/m (sign -)', 'derived 00424490 (2400 lb/in front/rear converters)', 'springs', 'IDENTIFIED', 'RT 0055e9b0 (0x89+w -> 0074e0d0)')
item(141, 'staticCamberLF', 'rad', 'derived 00424860 (camber + gain x deflection)', 'geometry', 'IDENTIFIED', 'RT lfhub +0x59')
item(142, 'staticCamberRF', 'rad', 'derived 00424860', 'geometry', 'IDENTIFIED', 'RT rfhub +0x59')
item(143, 'staticCamberLR', 'rad', 'derived 00424860', 'geometry', 'INFERRED', '')
item(144, 'staticCamberRR', 'rad', 'derived 00424860', 'geometry', 'INFERRED', '')
for c in range(4):
    item(145 + c, 'springPerch' + C[c], 'm', 'derived 00424860 (ride height - static deflection - tyre geometry)', 'springs', 'INFERRED', 'RT 0055e9b0 -> c083b0+4w (suspension z offsets)')
    item(149 + c, 'bumpStopGap' + C[c], 'm', 'derived 00424490 (8 in)', 'springs', 'INFERRED', 'RT 0055e9b0 (0x95+w -> 0074e0b0)')
item(153, 'frontPerchDifference', 'm', 'derived 00424860 (0x99)', 'weight', 'INFERRED', 'RT variable cell c0867c')
item(154, 'rearPerchDifference', 'm', 'derived 00424860 (0x9a)', 'weight', 'INFERRED', 'RT variable cell c08280')
item(155, 'trackBarTerm9b', '-', 'derived 00424860 (track bar difference)', 'geometry', 'INFERRED', 'RT variable cell c081f0; pit stop 005601c0')
item(156, 'trackBarTerm9c', '-', 'derived 00424860', 'geometry', 'INFERRED', 'RT variable cell c08490; pit stop 005601c0')
item(157, 'trackBarTerm9d', '-', 'derived 00424860', 'geometry', 'INFERRED', 'RT variable cell c08534; pit stop 005601c0')
item(158, 'rearRideHeightDifference', 'm', 'derived 00425a30 (RR - LR)', 'geometry', 'IDENTIFIED', '')
for k in range(6):
    item(159 + k, 'steeringGeometry%d' % k, '-', 'derived 00424860 from item 58', 'steering', 'UNKNOWN', '')
for c in range(4):
    item(165 + c, 'cornerLoadDelta' + C[c], 'N', 'derived 00424860 (0xa5..0xa8)', 'weight', 'INFERRED', '')
    item(169 + c, 'cornerLoad' + C[c], 'N/g? (static)', 'derived 00424860 (0xa9..0xac)', 'weight', 'INFERRED', '')
item(173, 'aeroRefHeightLF', 'm', 'derived 00424860 (0xad)', 'aero', 'IDENTIFIED', 'RT c084c8 (aero ride height reference, Stage 9)')
item(174, 'aeroRefHeightRF', 'm', 'derived 00424860 (0xae)', 'aero', 'IDENTIFIED', 'RT c084cc')
item(175, 'aeroRefHeightLR', 'm', 'derived 00424860 (0xaf)', 'aero', 'INFERRED', '')
item(176, 'aeroRefHeightRR', 'm', 'derived 00424860 (0xb0)', 'aero', 'INFERRED', '')
item(177, 'staticRake', 'rad', 'derived 00424860 (0xb1 = atan of ride heights)', 'aero', 'IDENTIFIED', 'RT c083c4 (aero pitch offset, Stage 9)')
for c in range(4):
    item(178 + c, 'staticDeflection' + C[c], 'm', 'derived 00424860 (0xb2+w)', 'springs', 'INFERRED', '')
item(182, 'chassisType', '-', '00559950 (car slot +0x58e)', 'car', 'IDENTIFIED', 'Cup: 2 (spdway)')
item(183, 'series', '-', '00559950', 'car', 'IDENTIFIED', 'Cup: 0')
assert len(S) == 184, len(S)
