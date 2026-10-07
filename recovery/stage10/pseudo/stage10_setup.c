/* NR2003.exe — Stage 10 recovered pseudo-C (setup -> runtime). Cleaned from the Ghidra 11.1.2 exports in
   recovery/stage10/evidence/b1..b4 (FUN_xxxxxxxx.c/.asm) and confirmed by executing the original x86 in Unicorn
   (recovery/stage10/gen_setup_vectors.py, orig_setup.py). Constants are the .rdata/.data values (float32).
   Every converter returns through FSTP/FISTP with the CURRENT FPU control word: 0x027f (round to nearest even:
   CRT init, garage UI, setup files) or 0x077f (round toward -inf: simulation task, pit stops). */

typedef unsigned int u32; typedef unsigned short u16;

/* ------------------------------------------------------------------ storage */
#define SETUP_SIZE 0xefd                       /* 184 dwords + name/notes + chassisInfo at +0xef1          */
u32 g_garageSetup[SETUP_SIZE / 4];             /* c03350 */
u32 g_activeSetup[SETUP_SIZE / 4];             /* c055c0 */
void *setupItem(int i) { return &g_activeSetup[i]; }   /* 00557d60 */

struct SetupDesc { u16 type;                   /* 3 = int display, 4 = float display */
                   u32 min, max, step, deflt;  /* display units, raw bits             */
                   u32 (*toInternal)(u32);     /* display -> stored                   */
                   u32 (*toDisplay)(u32); };   /* stored  -> display                  */
struct { u16 kind; struct SetupDesc *desc; } g_setupItems[184];   /* c05150 (6-byte entries) */

/* ------------------------------------------------------------------ unit converters (00423dc0..004241f0) */
float F_ID(float x)               { return x; }                                  /* 00423dc0 */
int   I_ID(int x)                 { return x; }                                  /* 00423dd0 */
float PCT_TO_FRAC(int p)          { return (float)p * 0.01f; }                   /* 00423de0 (6ea4a4) */
int   FRAC_TO_PCT(float f)        { return fist(f * 100.0f + 0.1f); }            /* 00423e00 (6ed00c, 6ea4cc) */
float INT_TO_FLOAT(int i)         { return (float)i; }                           /* 00423e30 */
int   FLOAT_TO_INT(float f)       { return fist(f + 0.1f); }                     /* 00423e40 */
float DEG_TO_RAD(float d)         { return 0.0174533f * d; }                     /* 00423e60 (6ed7b4) */
float RAD_TO_DEG(float r)         { return 57.29578f * r; }                      /* 00423e80 (6ed7b8) */
float STAGGER_IN_TO_M(float in)   { return 0.0254f * in * 0.15923566f; }         /* 00423ea0: circumference -> radius */
float STAGGER_M_TO_IN(float m)    { return 39.37f * m * 6.28f; }                 /* 00423ec0 */
float FSPRING_LBIN_TO_NM(int lbin){ return (float)lbin * 175.0f * -0.3136f; }    /* 00423ee0: 0.56^2 motion ratio */
int   FSPRING_NM_TO_LBIN(float k) { return fist((1/175.0f) * k * -3.1887755f + 0.1f); }   /* 00423f00 (871a7c) */
float RSPRING_LBIN_TO_NM(int lbin){ return (float)lbin * 175.0f * -0.7225f; }    /* 00423f30: 0.85^2 */
int   RSPRING_NM_TO_LBIN(float k) { return fist((1/175.0f) * k * -1.3840830f + 0.1f); }   /* 00423f50 */
float IN_TO_M(float in)           { return 0.0254f * in; }                       /* 00423f80 */
float M_TO_IN(float m)            { return 39.37f * m; }                         /* 00423fa0 */
float TOE_IN_TO_RAD(float in)     { return in * -0.035842296f; }                 /* 00423fc0: -1/27.9 in */
float TOE_RAD_TO_IN(float r)      { return r * -27.9f; }                         /* 00423fe0 */
float LB_TO_KG(int lb)            { return (float)lb * 0.4536f; }                /* 00424000 / 004240c0 / 00424110 */
int   KG_TO_LB(float kg)          { return fist(2.205f * kg + 0.1f); }           /* 00424020 / 004240e0 / 00424130 */
float GAL_TO_KG(int gal)          { return (float)gal / 0.3524f; }               /* 00424050 */
int   KG_TO_GAL(float kg)         { return fist(0.3524f * kg + 0.1f); }          /* 00424070 */
float K_TO_C(float k)             { return k - 273.15f; }                        /* 004240a0 (display only) */
float FARB_RATE_TO_SIZE(float r)  { return r < 0 ? (-(r / 175.0f) - 222.0f) * 0.0010869565f + 1.0f : 0.0f; } /* 00424160 */
float RARB_RATE_TO_SIZE(float r)  { return sqrt(sqrt((r - 6200.0f) * 3.4626038f * (1/175.0f) * -0.0015313936f)); } /* 004241a0 (NaN for r > 6200) */
float SPOILER_DEG_TO_INT(int deg) { return (float)(deg - 45); }                  /* 004241d0 */
int   SPOILER_INT_TO_DEG(float x) { return fist(x + 0.1f) + 45; }                /* 004241f0 */

/* ------------------------------------------------------------------ defaults */
void setupDefaults(u32 *s)                                                       /* 00557d20 (CRT init, CW 0x027f) */
{ for (int i = 0; i < 184; i++) { struct SetupDesc *d = g_setupItems[i].desc;
      s[i] = (d && d->toInternal) ? d->toInternal(d->deflt) : 0; } }
/* 00559950(chassisInfo): completes the car default (004254d0: s[0x31] = spec+0x24 full fuel cell 62.47 kg, gear
   choices of the chassis; 00424490: bump stops s[0x89..0x8c] = 2400 lb/in through the spring converters, bump-stop
   gaps s[0x95..0x98] = 8 in; ...). Cup default garage = c03350 after 00559950 (NR2003CupSetupData.cupGarageDefault). */

/* ------------------------------------------------------------------ garage API (the setup page) */
static int stepIndexOf(struct SetupDesc *d, u32 disp)                            /* shared body */
{ if (d->type == 3) return ((int)disp - (int)d->min) / (int)d->step;            /* IDIV */
  return fist((float)((f(disp) - f(d->min)) / f(d->step) + 0.1f)); }            /* FSTP float32, FISTP */
static u32 valueAtStep(struct SetupDesc *d, int k)
{ return d->type == 4 ? bits((float)(k * f(d->step) + f(d->min))) : (u32)(k * (int)d->step + (int)d->min); }
int  stepCount(int i)            { struct SetupDesc *d = g_setupItems[i].desc;   /* 005582d0 */
     return d->type == 4 ? fist((float)((f(d->max) - f(d->min)) / f(d->step) + 0.1f)) : ((int)d->max - (int)d->min) / (int)d->step; }
int  stepIndex(u32 *s, int i)    { struct SetupDesc *d = g_setupItems[i].desc;   /* 00558320 */
     return stepIndexOf(d, d->toDisplay(s[i])); }
float snapped(u32 *s, int i)     { struct SetupDesc *d = g_setupItems[i].desc;   /* 00557e40 (int items: FLD of the int bits) */
     u32 v = d->toDisplay(s[i]); return d->toInternal ? f(valueAtStep(d, stepIndexOf(d, v))) : f(v); }
u32  setSnapped(u32 *s, int i, u32 disp)                                         /* 005581d0 */
{ struct SetupDesc *d = g_setupItems[i].desc; u32 v = valueAtStep(d, stepIndexOf(d, disp));
  if (less(v, d->min)) v = d->min; else if (greater(v, d->max)) v = d->max;     /* NaN keeps the snapped value */
  s[i] = d->toInternal(v); return v; }
/* 005580f0: same store as 005581d0 (snap, then clamp the snapped value); returns the unclamped snapped value */
int  step(u32 *s, int i, int up)                                                 /* 005583e0 */
{ struct SetupDesc *d = g_setupItems[i].desc; int k0 = stepIndexOf(d, d->toDisplay(s[i]));
  u32 v = valueAtStep(d, up ? k0 + 1 : k0 - 1); v = clamp(v, d->min, d->max);
  if (stepIndexOf(d, v) == k0) return 0; s[i] = d->toInternal(v); return 1; }
void setIndex(u32 *s, int i, int k)                                              /* 00558380 (no clamp) */
{ struct SetupDesc *d = g_setupItems[i].desc; s[i] = d->toInternal(valueAtStep(d, k)); }

/* ------------------------------------------------------------------ setup file (.sto) */
int validateLoaded(u32 *s)                                                       /* 00558da0 */
{ for (int i = 0; i < 184; i++) { struct SetupDesc *d = g_setupItems[i].desc;
      if (!d || !d->toInternal) continue; if (d->type != 3 && d->type != 4) return 0;
      s[i] = d->toInternal(clamp(d->toDisplay(s[i]), d->min, d->max)); }       /* no snapping */
  if (g_871ad4 == 1 || g_871ad4 == 5)                                            /* 004247e0 */
      if (f(TrackBarRR_display) < f(TrackBarLR_display)) s[0x2d] = toInternal(RR);
  return 1; }

/* ------------------------------------------------------------------ application */
int applyGarageSetup(void)                                                       /* 00559360 (session start) */
{ memcpy(g_activeSetup, g_garageSetup, SETUP_SIZE);
  bgRequestFGAction(FUN_00559400 /* car rebuild on the foreground task */, ...);
  derivedItems(g_activeSetup);                                                   /* 00559820 -> 00425ad0 */
  setFuelMass();                                                                 /* 00550c60 */
  return 1; }
void derivedItems(u32 *s)                                                        /* 00425ad0 */
{ s[0x5b] = 1/(k*spec[0x1c0]) or 0;  s[0x5c] = s[0x31] * 0.3524f;               /* fuel use, gallons */
  for (c = 0; c < 4; c++) { s[0x4b+3c..0x4d+3c] = 295.37 K; s[0x47+c] = s[c]; s[0x57+c] = 0; }
  s[0x62] = (spec[8] + s[0x31] + k) * 2.205f;                                     /* total weight (lb) */
  gearRatios(s);      /* 00425690: s[0x66..0x6e] from choice indices s[0x33..0x39,0x45,0x46] (table 006ed880) */
  antiRoll(s);        /* 004257a0: s[0x63] front rate, s[0x64] rear rate, s[0x5d] roll couple         */
  shocks(s);          /* 00425900: s[0x81..0x88] from table 00721ff0[toDisplay(s[4..7], s[12..15])]   */
  rideHeightRF(s);    /* 00425a30: s[0x25] = grid(LF + (RR - LR))                                     */
  cornerWeights(s); } /* 00424860: s[0x5e..0x61], perches s[0x91..0x94], static camber s[0x8d..0x90],
                         s[0x99..0x9d], aero reference heights s[0xad..0xb0], rake s[0xb1], deflections   */
/* car build (orig_setup.APPLY_CALLS, identical sequence): 00425690 x2, 0051a730 (gear set from the GARAGE
   setup), 00559950 x2, 00559820 x2, 00550c40 (engine 0051a020), 00550c60, 00550bc0 (tyres), 005b29c0 (tree),
   005b2f20 = { 0057dcd0(0); 0057c930(); 0055e9b0() /* setup -> cells */; 0057c990(e84474..e84494, 0);
   005b4060; 005b4560; 005b3f50; 005b2fb0; 005b9ce0; 0057dcd0(2); 005b3090 /* runs the solve callback */;
   0057dcd0(1) }, 0054d610 x4. */

/* ------------------------------------------------------------------ callback emitter decisions (value dependent) */
int isConstZero(Cell **p) { return !isVariable(p) && **p == 0.0f; }             /* 0057c8d0 (fcomp 6ea454) */
int isConstOne(Cell **p)  { return !isVariable(p) && **p == 1.0f; }             /* 0057c900 (fcomp 6e97d8) */
/* isVariable = 0057c890: *p in [ebbf60, ebf610) (JIT variable cells) */
void setConstant(Cell **p, float v)                                              /* 0057ca60 */
{ if (p == &g_cell74fda8) goto store;
  Cell *c = *p;
  if (c && (c < &pool[g_poolCount] || c >= pool_end /* d3fe50 */) && !isVariable(p) && *c == v) return; /* keep */
  if (v == 0.0f && !isVariable(p) && !promoted(p)) { *p = g_zeroCell; return; }  /* 0057c890 / 0057c860 */
  if (v == 1.0f && !isVariable(p) && !promoted(p)) { *p = g_oneCell; return; }
  newConstCell(p);                                                               /* 0057cb30: pool d3b030, 5000 cells */
store: **p = v; }
float *internLiteral(float v)                                                    /* 005b9970 */
{ float *top = g_litTop;                                                         /* ec02c4, pool from ebf614 */
  for (float *c = top - 1; c > (float *)0xebf610; c--) if (*c == v) return c;   /* quirk: never compares *top */
  *++g_litTop = v; return g_litTop; }

/* ------------------------------------------------------------------ pit stop (mapped, not ported in Stage 10) */
void pitAdjustTrackBarWedge(void)                                                /* 005601c0 */
{ float h = trackHeight - (s[0x2e] + s[0x2d]) * 0.5f - spec[0x6c];
  *(lrRecord + 0x1bd) = (c085ac + rearAxle[0x4c]) - h; *(lfwheel/rfwheel + 0x1bd) = h;
  *c08490 = s[0x9c]; *c081f0 = s[0x9b]; *c08534 = s[0x9d];
  *c08664 = (s[0x92] + s[0x93]) - (s[0x94] + s[0x91]) - c083a8; }
void pitTyrePressure(int w)                                                      /* 00550f10 */
{ tyre[w].pressure /* bf3a20 + 0xa39 w */ = s[w]; reset tyre temperatures/wear accumulators; 0054d610(); }
