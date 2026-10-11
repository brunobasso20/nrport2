/* =====================================================================================================================
 * NR2003.exe -- Stage 11 recovered runtime systems (fuel / mass, tyre thermal / pressure / wear / failure, brake
 * temperature, engine thermal / damage / failure, random failures, collision damage, reset / repair / pit service).
 *
 * Cleaned pseudo-C written from the Ghidra exports in recovery/stage11/evidence/b1..b4 (raw .c/.asm, constants
 * resolved in the .asm comments) and checked by executing the original code in Unicorn (orig_stage11.py).
 * Names are SEMANTIC INTERPRETATIONS; confidence per item in STAGE11_STATE_MAP.md. The port does NOT use this file:
 * the Luau runtime executes the original x86 lifted instruction by instruction (NR2003CupFrameCode*).
 * Float32 stores round toward -inf (simulation task CW 0x077f). Addresses are NR2003.exe virtual addresses.
 * ===================================================================================================================*/

/* ---------------------------------------------------------------------------------------------------------------
 * 0. Order (simulation task, one 36 Hz frame; 288 Hz physics = 8 ticks per frame)
 * ---------------------------------------------------------------------------------------------------------------
 * task loop 005f78f0 / 005f8990:  ++getBGCount (0x7559bc); call the bg frame function (0055cef0 -> 0055d390)
 * 0055bfd0:  005a4cc0 dynamic weather; per car 005637e0 (aero factors 1.0, airspeed car+0x5aa, drafting 005afd80, the
 *            player car: 00592db0 + 0054b0d0 collision-geometry deformation); race order; 005b2190; 00549c40; ...
 * 005b2190:  00551e80 frame start (pedals, ramps, per-frame tyre accumulators cleared), 8 x tick (005539c0 inputs,
 *            predictor, tyre contacts 00578da0 -> 00576e00 -> 0055e1e0 (+ collision records 0054a760), forces,
 *            corrector, tyres, forces, commit), then 00554520 FRAME END.
 */
void frame_end_00554520(void)
{
    if (!player_vehicle_simulated_00551880()) return;          /* bf6e04 */
    attitude_filter_00551ce0();                                /* bf6ea8 / bf6384 / bf6398 (snapshot / camera)     */
    world_state_record_005547a0();                             /* HOST: track/replay recorder 005a02b0              */
    car = car_slot_00562f70(player_index_0055ab00());          /* 0x00c12030                                       */
    g_airspeed_bf3a00 = car->airspeed_5aa;                     /* |track-object velocity - wind| (005637e0)        */
    track_object = car->track_object_5ae;
    f = 1.0f - setup_item(0x3b /* grille tape fraction */);
    damage = car->vtable[1](1);                                /* 00566aa0 -> 00592db0: car+0x1493                 */
    if (damage_component_005486a0(damage, 1) > 1.0f) f = 1.0f; /* component 1 destroyed (2.0) -> tape irrelevant   */
    f *= car->aero_factor_front_5a2;                           /* drafting reduces radiator air                   */
    engine = engine_0051a000();                                /* car+0xc                                          */
    radiator_inputs_0051a830(engine, 1.1f, air_density_e0b84c, air_temperature_C_e0b830, car->airspeed_5aa, f);
    dt = 1.0f / taskGetRate();                                 /* 1/36 s                                           */
    engine_frame_0051aac0(engine, dt);
    random_failures_0051c3d0(stress_accumulator_0051c2d0() /* bcf760 */, dt);
    fuel_mass_005605c0();
    if (inBackground()) {
        if (track_object) angles_005f74c0(&car->yaw_1530, &car->pitch_1534, &car->roll_1538, track_object + 0x58);
        car_snapshot_and_tyres_00551990(car);                  /* -> 0054d610 per tyre + 00556e30                   */
    }
    if (ffb_enabled_bf6ebb && !car_held_bf6eb8) { /* steering force feedback output 005d08d0 (Stage 13) */ }
}

/* ---------------------------------------------------------------------------------------------------------------
 * 1. Protected values (anti-tamper storage used by every Stage 11 state)
 * ---------------------------------------------------------------------------------------------------------------
 * A protected float is a triple of pointers {p0, p1, p2} (+ lock word): value = *p0 ^ *p2, check = *p1 ^ KEY == *p0
 * with KEY = [f72118] (doubles: two dwords, key [f72120]). Stores (0051c3f0 float, 0040bde0 double) re-encode with
 * the current key; rdtsc (005cfcfc) decides random re-keying (& 0x3f) and relocation of the cells inside the static
 * pool (0051c5d0 / 0051c850, & 0x3ff / 0x1ff / 0x7ff). A failed check spins on rdtsc and sets f7212c.
 * In the bench rdtsc = 1 (Stage 6/7 builtin): no re-keying / relocation ever happens, the pool layout is static.
 */

/* ---------------------------------------------------------------------------------------------------------------
 * 2. Fuel (kg, protected double at engine+0x50c / car+0x518)
 * ---------------------------------------------------------------------------------------------------------------*/
void fuel_load_00550c60(void)                /* car build, car placed on track (00550a50), garage (00559360)      */
{
    spec = car->spec_58a;
    if (session_type_0055a690() == 2)        /* race: the garage fuel item 0x31 (internal kg)                        */
        fuel = setup_item(0x31);
    else                                      /* practice / qualifying / test: full cell spec+0x24 (Cup 62.47 kg)   */
        fuel = spec->fuel_capacity_24;
    protected_store_double(&engine->fuel_50c, fuel);
    /* + the fuel record is flagged 'variable mass' (negative record mass, 005b4060) so the generated callbacks
       read its mass / inertia cells every tick                                                                   */
}

void fuel_mass_005605c0(void)                /* every frame end                                                       */
{
    fuel = protected_load_double(&car->fuel_518);
    k = fuel * spec->fuel_inertia_per_kg_28;
    record_mass_inertia_005b4840(fuel_record_c08234, fuel /* mass x3 cells */, k, k, k /* inertia diagonal */);
    /* the fuel component record keeps its offset from the chassis: the aggregate CG / inertia of the multibody
       change through the generated solve, not through any explicit CG formula                                    */
}

/* fuel burn (inside 0051aac0):
 *   heat_front = rpm_484 * throttle_48c * 0.10472 ; heat_rear = rpm_484 * x_490 * 0.10472            (+0x494/+0x498)
 *   bsfc(rpm)  = 275 - 115 * rpm / max_rpm_438                                                        (0051be00)
 *   burn       = bsfc(rpm) * heat_front * dt * K_d (qword 006f47d0) * rate,  rate = settings+0x50 & 3 (+1) (x1..x4,
 *                game mode 5 forces x1)
 *   fuel      -= burn;   fuel < threshold (qword 006f47c8) -> out of fuel: ignition power 0 (+0x554 = 0),
 *                                                              engine state bit 28 via 0054b610
 *   fuel leak:  damage+0x54 > 0  ->  fuel -= leak^2 * dt * 2.5 * 0.75  (and below 0 -> 0)
 */

/* ---------------------------------------------------------------------------------------------------------------
 * 3. Engine (object car+0xc; Cup spec values in STAGE11_STATE_MAP.md)
 * ---------------------------------------------------------------------------------------------------------------*/
void engine_init_0051a020(engine, float ambient_C /* 10.0 at build */)   /* 00550c40                              */
{
    engine->ambient_478 = ambient_C; engine->max_rpm_438 = spec_engine->max_rpm_2c;
    protected_store(&engine->water_4a4, 93.0f);                 /* C                                               */
    engine->coolant_level_4a0 = spec_engine->coolant_34; engine->oil_level_49c = spec_engine->oil_38;
    engine->x4d0 = 2.7211 /* 0x402e2650 */; protected_store(&engine->oil_4d4, 0.0f);
    engine->k43c = spec_engine->k3c; engine->k440 = spec_engine->k40;
    engine->over_rev_508 = 0; engine->wear_558 = 0; engine->state_548 &= ~0x3f; engine->x504 = 13.8;
    engine->state_548 |= 0x22 (running, simulation task path) ...; engine->starter_54c = -1; engine->cut_550 = 0.25;
    engine->power_554 = (running) ? 1.0 : 0.0; engine->life_55c = 290000; engine->blown_560 = 0; ...
}

void radiator_inputs_0051a830(engine, a, rho, air_C, airspeed, radiator_air)
{ engine->k470 = a; engine->rho_474 = rho; engine->ambient_478 = air_C; engine->airspeed_47c = airspeed;
  engine->radiator_air_480 = radiator_air; }

void engine_frame_0051aac0(engine, dt)          /* one frame                                                     */
{
    player = (engine == engine_0051a000());
    cut_550 = max(0, cut_550 - dt);                           /* shift / ignition cut timer (Stages 6-10 subset) */
    if (player) starter_state_0051a9c0(engine);
    d = car->vtable[1]();                                     /* damage object                                    */
    /* engine damage d+0x58: misfire. Above 0.95 or below 0.05 -> power 1 - d; else 1 - d or 1 - d/2 (random)     */
    power_554 = 1 - d58 (or 1 - d58/2 with probability);  if (d60 > 0.01) power_554 -= d60 (or d60/2) ... >= 0
    heat_front_494 = rpm * throttle * 0.10472; heat_rear_498 = rpm * x490 * 0.10472;
    /* fuel burn: see section 2 */
    /* engine 'x4d0' (lubrication / temperature margin, 0..5.44): relaxes toward an rpm-band target at 0.15 / frame
       when the engine runs, decays by 0.03*k otherwise; below 3.265 above 0.8*max rpm it scales power down        */
    /* water temperature (protected +0x4a4), oil temperature (protected +0x4d4): explicit Euler per frame
         air  = (1 - (1 - radiator_air_480) * 0.79) * sqrt(airspeed_47c) * 1.35 + 0.5
         water += dt / ((coolant_level_4a0 + 3) * 12000) * heat_rear_498
         water -= x4d0 * 0.18375 * (water - ambient_478) * k43c * dt/((coolant+3)*12000) * air
         oil   += dt / ((oil_level_49c + 3) * 28000) * heat_front_494
         oil   -= (oil - ambient_478) * (rpm / max_rpm) * k440 * dt/((oil_level+3)*28000) * air                  */
    /* leaks: radiator d+0x4c -> coolant_level_4a0 -= d4c^2 * dt * 0.2 ; oil d+0x50 -> oil_level_49c -= d50^2*dt*0.8 */
    /* wear / failure (player engine): wear_558 += dt; when > 0.2 s:
         rate = 0.3..1.0 * wear * 3.448e-6  (+ high-rpm term, + water above 105 C, + oil above 115 C terms,
                over-rev accumulator 508 (rpm > 0.995*max + 100: += t, else -= t, clamp 0..50), x4d0 term,
                fuel-leak term);  life_55c = wear / rate * k46c;
         if (rnd * k46c < rate): engine damage += random amount (0054b5a0, engine state bit), may blow (power 0,
         blown_560 = random torque reduction factor);  wear_558 = 0                                             */
    power_554 *= rho_474 * 0.8333;                            /* air density: rho / 1.2                         */
    sound_00551e10(...);                                      /* car+0x1510 / +0x1508 audio values              */
}

/* ---------------------------------------------------------------------------------------------------------------
 * 4. Tyres (objects 0xbf3a20 + w * 0xa39; w = 0 LF, 1 RF, 2 LR, 3 RR)
 * ---------------------------------------------------------------------------------------------------------------*/
void car_snapshot_and_tyres_00551990(car)
{
    /* car snapshot for replay / render (car+0x1500..0x15ac): wheel data 00551890/920/950, attitude, gear ... */
    if (!player_vehicle_simulated()) return;
    g_airspeed_bf3a00 = car->airspeed_5aa;
    for (w = 0; w < 4; w++) {
        tyre_frame_0054d610(&tyre[w]);
        tyre_visual_00556e30(car, w, table_6f6520[tyre[w].surface_2c0], tyre[w].slide_2d4 * table_6f64b8[...],
                             tyre[w].x2d0, tyre[w].load_2e0);          /* car+0x11cb.. (smoke / skid presentation) */
    }
}

void tyre_frame_0054d610(tyre)                 /* thiscall, one frame                                            */
{
    g_ambient_K_74c954 = air_temperature_C_e0b830 + 273.15f;
    if (n_2b8 > 0) { a_2ac /= n; b_2b0 /= n; c_2b4 /= n; }       /* per-frame tick averages                       */
    rr_2c4 = min(1, f579ee0(surface) + f579ef0(surface) * v_2cc^2);  /* surface rolling resistance (6f63c8/6f6418) */
    /* hot pressure (gas law on the carcass mean): */
    Tc = (carcass[0] + carcass[1] + carcass[2]) * 0.33333;
    pressure_2a0 = cold_pressure_0 > 0.1 ? (((Tc - Tamb) * 0.4 + Tamb) / Tamb) * cold_pressure_0 : 0;
    k_2a4 = (0.2248 * 0.0254 * 0.0254) / pressure_2a0  (pressure <= 12: * 1/12)    /* N-in -> lbf, psi           */
    f_298 = pressure_2a0 / p_4 * 0.9 + 0.1;  g = pressure_2a0 / p_8 * 0.9 + 0.1;
    stiff_29c = (1.21 - (Ts0 + Ts1 + Ts2) * 0.000233331) / (2 * g * k_34);       /* temperature softening         */
    rr_2a8 = f579e80(0x13, surface) * f_298;  rr_2c4 /= f_298;
    /* work inputs of the frame: */
    long_2d4 = slip_2c8 * v_2cc;  lat_2d0 = |fy_2e8 * u_2ec * k_2e4 , fx_2dc * u_2f0 * k_2e4|;
    if (|u|+|v|+v_2cc in [3,10)) scale by (x-3)/7; below 3 -> 0;                 /* low-speed fade of the work   */
    if (surface in {6,7,8} && grass/dirt) dirt smoke particles (00583a20) ...
    heat_lat  = f5100e0(surface) * global_heat_510090 * k_c * lat_2d0 * 0.5;
    heat_long = f5100e0(surface) * global_heat_510090 * k_c * long_2d4;
    if (track_object && |track_object velocity|^2 < 0.01) heat_lat = heat_long = 0;
    /* camber split of the lateral heat over the three tread zones (inner / middle / outer), side sign bit0 of +0x6c:
       camber_2bc * side: <= -0.218 rad -> {1.4, ., 0.6}; >= 0.218 -> {0.6, ., 1.4}; else 1 -/+ camber*4.5837*0.4;
       middle = sqrt(pressure*0.9/(p_8 - 4) + 0.1); all divided by middle                                        */
    for (z = 0; z < 3; z++) {
        Ts = surface[z]; Tc = carcass[z];
        q  = (Ts - Tc) * h_50;                                       /* surface <-> carcass conduction            */
        surface[z] += (heat_lat * zone[z] - q) * (1/c_10) * dt;        /* clamp 505 K (0051c3f0 store)              */
        carcass[z] += (q + heat_long) * (1/c_14) * dt;
        air = sqrt(airspeed_bf3a00 + 2) * dt * 18;                    /* forced convection                          */
        surface[z] -= (surface[z] - Tamb) * air * k_ob(+0x14) / c_10;
        carcass[z] -= (carcass[z] - Tamb) * air * k_ob(+0x18) / c_14;
        surface[z] = max(surface[z], carcass?..) ; carcass[z] = max(carcass[z], min_58) ... (floor +0x58)
    }
    /* lateral conduction between the carcass zones (middle <-> inner, middle <-> outer) with h_50 * 0.02 */
    /* skid / smoke presentation (track object present): 0054d400 / 0054d580 / 00583590 (particles, RNG draws) */
    brake_temperature_0054f260(tyre, dt, |brake_torque_268 * band_speed_2cc|);
    age_134 += dt;
    if (age_134 > 0.2) {                                             /* wear integration, every frame after 0.2 s  */
        load = max(zone loads);  work = (|c086ac| * camber_term * 0.25 + heat_lat) * load;
        wear_0054e9f0(tyre, protected(age), work);  age_134 = 0;
    }
    grip_d0 = f5100c0(surface) * x_cc * temperature_grip_factor * pressure_term;   /* +0xd0 read by 0054cab0 */
}

void wear_0054e9f0(tyre, float age, float work)
{
    state = (damage[2] & 0xfff) >> (2*wheel) & 3;                   /* tyre damage state of this wheel           */
    if (state >= 2) { cold_pressure_0 = 0; wear = 1.0; grip_cc = 0.6; return; }  /* flat / blown              */
    rate = (game mode == 5 ? 1 : (settings+0x50 & 3) + 1) * k_40;
    hot = max(surface temps); limit = T_opt_54 - (T_max_58 - T_opt_54) * 0.18;
    if (hot > limit) { e = ((hot - limit) * k_44)^3; if (v_2cc < 15) e *= (16/(v+1) - 1); rate += e; }
    dw = global_wear_510080 * rate * work * k * age;
    wear += dw;
    if (wear > 0.66 && wear < 1 && rnd < blowout_probability(wear) [x2 when state == 1]) wear = 1;
    if (wear < 1) grip_cc = grip_vs_wear_0054ef10(wear);            /* 1 - k2 * wear^k1                           */
    else { cold_pressure_0 = 0; damage_set_tyre_state_0054b970(wheel, 2); wear = 1; grip_cc = 0.6; }
}

void brake_temperature_0054f260(tyre, float dt, float power)       /* protected +0x26c, Kelvin                   */
{
    T = protected(&tyre->brake_26c);
    T += (power / capacity_5c - (T - Tamb_74c954) * (sqrt(airspeed_bf3a00) + 1) * cooling_60) * dt;
    protected_store(&tyre->brake_26c, T);
    /* the temperature is NOT read by the brake torque (Stage 8): fade 0054f3d0 / failure 0054f610 are unreferenced */
}

void pit_tyre_00550f10(int w)                                       /* pit service, 005512d0 at car placement     */
{
    T = air_temperature_sun_C_e0b834 + (game mode 7 && kind < 4 ? 22 : 11) + 273.15;
    protected_store(surface[0..2], carcass[0..2], T);  cold_pressure_0 = setup_item(w) /* psi */;
    protected_store(&wear, 0); grip_cc = 1; x_d0 = 1; flags_a38 = 0; per-frame accumulators = 0;
    tyre_frame_0054d610(&tyre[w]);
}

/* ---------------------------------------------------------------------------------------------------------------
 * 5. Random component failures
 * ---------------------------------------------------------------------------------------------------------------*/
/* per tick, inside the forces natives: 0051c1e0 accumulates a stress value into bcf760 [0]/[1], 0056010a sets the
   watched component [3] = 3 and factor [2] = 1.0 (0055f880 at build: -1.0 / 1)                                  */
void random_failures_0051c3d0(acc, dt)
{
    /* 0051c300 */ if (!component_failed_00548a00(acc[3])) {
        p = acc[1]^3 * 1.4e-? (006f47e0) * damage_scale_bef700;
        if (rnd < p) { component_fail_00548aa0(acc[3], 1); drivetrain_broken_flag_0055e7e0(acc[3]); }
        acc[1] = 0; acc[0] = 0;
    }
    /* 0051c380 */ if (!(car->vtable[2]()->flags_e & 0x80) && rnd < dt * k(006f47e8)) component_fail(7, 1);
}

/* ---------------------------------------------------------------------------------------------------------------
 * 6. Damage object (car+0x1493, 0x68 bytes) -- packed (synchronised) words + decoded float caches
 * ---------------------------------------------------------------------------------------------------------------
 *  +0x00 u16  bits 6..13: per wheel 2-bit wheel / suspension damage (0054b9b0)
 *  +0x02 u16  bits 0..11: per wheel 2-bit tyre state 0 ok / 1 / 2 / 3 (0054b970; >= 2 flat); bits 14..15 0054b800
 *  +0x04 u32  bits 0..6 car index (00547ee0)
 *  +0x08 u32  packed zone / component values, layout table 006f56b8 (21-byte entries: shift, mask, 'destroyed' flag)
 *  +0x0c u32  bits 0..5 engine damage x63 (0054b5a0), bit 24 (0054b7d0), bit 25 'changed' (0054b4c0), bit 28 engine
 *             off / blown (0054b610), bits 29..30 (0054ba50)
 *  +0x0e u8   (inside +0x0c) component failure flags bits 0..7 (00548aa0 / 0054b940; read 00548a00)
 *  +0x10..+0x38  11 zone values (0..1, 2.0 = destroyed) decoded from +0x08 (005486a0), read by aero 00410910
 *  +0x3c..+0x48  4 tyre values (00548c50)
 *  +0x4c radiator leak  +0x50 oil leak  +0x54 fuel leak / fire  +0x58 engine damage  +0x5c  +0x60   (0054b410 decode)
 *  +0x64 cleared by 0054b4c0
 * Reset (car placed on track, 00563080(car, 1)): 0054b3c0 = 00547ee0 (words cleared, car index) + 0054b410 (decode).
 * Damage scale bef700 = race option 'damage' {0, 0.15, 0.6, 1.0} (00547e90 at session start 0055be60; game mode 5 1.0).
 */

/* collision record (0x60 bytes, pool bf09c0 -> list bf39f0, hash bf0940[32]), entered by the track contact code:
 *   +0 key (contact object, key->body+0x1a4 = car index)   +4 magnitude (frame maximum per key)   +8 self flags |
 *   material (0x13 tyre, 0x2000000 continuous contact)   +0xc other material   +0x10 world point   +0x1c point in the
 *   self car frame   +0x28 point in the other car frame   +0x34 body velocity   +0x40 normal (normalised)   +0x4c, +0x50
 *   contact query values (c7e78c / c7e790 set by 00577260 from the tyre model 0054cab0)   +0x54 other body
 */
void collision_record_0054a760(key, mag, self, other, p_world, p_self, p_other, v, q9, speed, other_body, n)
{
    record = find_or_allocate(key);                 /* keeps the maximum magnitude of the frame                       */
    if (record->mag < mag) { copy fields; normalise n;  zone_tyre_damage_0054a8d0(record, self car, 1);
                             if (other_body) zone_tyre_damage_0054a8d0(record, other car, 0); }
}
void zone_tyre_damage_0054a8d0(record, car, self)        /* tyre / continuous contacts only                         */
{
    if ((flags & 0xffffff) == 0x13 || (flags & 0x2000000)) {
        zone = zone_lookup_0054a710(car, self ? record+0x1c : record+0x28);   /* BSP of the chassis type 00890490 */
        wheel = table_6f5500[zone].wheel;  if (wheel != -1 && wheel_impact_0054aa20(car, damage, record, wheel)) ...;
    }
}
int wheel_impact_0054aa20(car, damage, record, w)
{
    n = rotate(track_object rotation +0x58, record->normal);  n.y *= 0.5; n.z *= 0.4;
    impact = min(1, |n|) * damage_scale * record->mag * material_factor_579e50(record->other) * 0.5;
    if (impact > {65000,65000,75000,75000}[w] && tyre_state != 3)
        tyre_level = tyre_level_value + (impact - limit)/{95000,95000,110000,110000}[w] -> state 0..3 (0.25/0.5/0.75)
    wheel / suspension level from a random draw (rnd), player car extra chance above 006f5870 scaled by spec +0x98
    -> debris event (bef3b8 list, at most 16 per frame; state 3 = wheel off: positions for the particles)
    -> 0054b9b0 (wheel level), 0054b970 (tyre state), 0054ba50 (flag)
}
void collision_frame_00549c40(void)                       /* after 005b2190, every frame                            */
{
    debris_events_0054a330();          /* applies queued wheel / tyre states; player: 0055e5d0 (one rnd draw),
                                          0055e610 / 0055e670 / 0055e6c0 / 0055e780 = 'ret' in the shipped exe:
                                          NO damage-dependent suspension geometry exists in NR2003.exe             */
    for each record: if (car+4 /* in the race order */) {
        if (other car) body_damage_00549290(other, ...);
        body_damage_00549290(car, damage, record, &delay, &bef380[car]);   /* -> car+0x1487 delay, 00592dc0 sync  */
        sparks / scrape effects (00557650 sound, 005862c0, 00583250, 00583490 particles, car+0x124b..0x1307),
        0054a2a0 (fuel-leak fire chance)
    }
}
uint body_damage_00549290(car_index, damage, record, delay, flag)
{
    if (!car->track_object || !car->series_596 /* roster series field */ || damage_scale_bef700 == 0) return 0;
    e = damage_scale * record->mag * material_factor(record->other) * 0.5;   if (e < 9000) return 0;
    zone = zone_lookup(...); zone_damage_00549860(..., zone, e) + neighbour zone (table 006f5660);
    eng = e * table_6f5518[zone].engine;  sus = e * table_6f551c[zone].x;
    if (eng > 006efb30) engine_damage_0054b5a0(d58 + (eng - k) * k' * (0.75 + rnd/2));
    if (sus > 125000) leak/flag d54 (0054b800) with probability; above 420000 random -> 0054b7d0 + d54 = 1
    rnd >= 0.5: oil leak d50 (0054b900) above 125000; else radiator leak d4c (0054b8c0) above 150000
    0054b4c0(1)  /* changed */
}
void zone_damage_00549860(..., zone, e)    /* zone value += (e - start)/range (table 006f5504..); destroyed -> 2.0;
                                              zones bound to a collision object deform it (0054b0d0 / 00577cb0)
                                              'parts off' debris objects 00549ab0 / 00585e30                        */

/* ---------------------------------------------------------------------------------------------------------------
 * 7. Car placed on track / restart (simulation task, 0055b450 -> 00550a50)
 * ---------------------------------------------------------------------------------------------------------------*/
void car_placed_on_track_00550a50(void)
{
    car_reset_00563080(car, 1 /* repair */);   /* 0054b3c0: damage cleared + decoded; delays 1487/148b/148f = 0     */
    engine_init_00550c40();                    /* 0051a020                                                          */
    fuel_load_00550c60();
    four_new_tyres_005512d0();                 /* 00550f10 x 4                                                      */
    hook_bf63c4();                             /* null in the bench                                                 */
    place_on_track_005512f0(...);              /* HOST: pose from the track (bench: reset pose)                     */
    car->x1518 = 0; ffb_setup_00550070(0); driver_aids_00524930(); car_held_bf6eb9 = 0;
}
