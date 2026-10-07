0054cab0 SUB ESP,0x24
0054cab3 FLD dword ptr [ESP + 0x44]
0054cab7 FSUB dword ptr [ESP + 0x38]
0054cabb PUSH EBX
0054cabc PUSH EBP
0054cabd PUSH ESI
0054cabe MOV EAX,dword ptr [ESP + 0x44]
0054cac2 MOV ESI,ECX
0054cac4 MOV ECX,dword ptr [ESP + 0x50]
0054cac8 PUSH EDI
0054cac9 MOV dword ptr [ESP + 0x54],ECX
0054cacd FSTP dword ptr [ESI + 0x2ec]
0054cad3 FLD dword ptr [ESP + 0x4c]
0054cad7 FCHS
0054cad9 FSTP dword ptr [ESI + 0x2e8]
0054cadf MOV dword ptr [ESI + 0x2f0],EAX
0054cae5 MOV EAX,dword ptr [ESP + 0x54]
0054cae9 AND EAX,0x7fffffff
0054caee MOV dword ptr [ESP + 0x28],EAX
0054caf2 FLD dword ptr [ESP + 0x28]
0054caf6 MOV EDX,dword ptr [ESP + 0x60]
0054cafa MOV EAX,dword ptr [ESI + 0x6c]
0054cafd FSTP dword ptr [ESI + 0x2cc]
0054cb03 MOV dword ptr [ESI + 0x2bc],EDX
0054cb09 MOV [0x00c08250],EAX
0054cb0e MOV ECX,dword ptr [ESI + 0x2bc]
0054cb14 MOV dword ptr [ESP + 0x54],ECX
0054cb18 MOV EAX,dword ptr [ESP + 0x54]
0054cb1c AND EAX,0x7fffffff
0054cb21 MOV dword ptr [ESP + 0x28],EAX
0054cb25 FLD dword ptr [ESP + 0x28]
0054cb29 FCOMP dword ptr [0x006f5904]   ; [006f5904] f32=0.860000014305 i32=1063004406 f64=-2.77555821669e-17
0054cb2f FNSTSW AX
0054cb31 AND EAX,0x4100
0054cb36 JNZ 0x0054cb6d
0054cb38 CMP dword ptr [ESI + 0x2c0],0x11
0054cb3f JGE 0x0054cb6d
0054cb41 MOV dword ptr [0x00bf6f28],0x12
0054cb4b MOV EDX,dword ptr [ESI + 0x6c]
0054cb4e AND EDX,0x1
0054cb51 MOV dword ptr [0x00bf6f30],0xbf800000
0054cb5b LEA EAX,[EDX + EDX*0x1 + -0x1]
0054cb5f TEST EAX,EAX
0054cb61 JG 0x0054cb6d
0054cb63 MOV dword ptr [0x00bf6f30],0x3f800000
0054cb6d FLD dword ptr [ESP + 0x58]
0054cb71 FCOMP dword ptr [0x006ea454]   ; [006ea454] f32=0.0 i32=0 f64=-2048.0
0054cb77 FNSTSW AX
0054cb79 TEST AH,0x5
0054cb7c JP 0x0054d2f3
0054cb82 MOV ECX,dword ptr [ESI + 0x2ec]
0054cb88 MOV dword ptr [ESP + 0x54],ECX
0054cb8c MOV EAX,dword ptr [ESP + 0x54]
0054cb90 AND EAX,0x7fffffff
0054cb95 MOV dword ptr [ESP + 0x24],EAX
0054cb99 MOV EDX,dword ptr [ESI + 0x2e8]
0054cb9f MOV dword ptr [ESP + 0x54],EDX
0054cba3 MOV EAX,dword ptr [ESP + 0x54]
0054cba7 AND EAX,0x7fffffff
0054cbac MOV dword ptr [ESP + 0x28],EAX
0054cbb0 FLD dword ptr [ESP + 0x28]
0054cbb4 FADD dword ptr [ESP + 0x24]
0054cbb8 LEA EDI,[ESI + 0xe8]
0054cbbe PUSH EDI
0054cbbf FADD dword ptr [ESI + 0x2cc]
0054cbc5 FSTP dword ptr [ESP + 0x34]
0054cbc9 CALL 0x005f5890
0054cbce MOV EAX,dword ptr [ESI + 0xe4]
0054cbd4 MOV ECX,dword ptr [ESI + 0xdc]
0054cbda PUSH EDI
0054cbdb MOV ECX,dword ptr [ECX]
0054cbdd MOV EBX,dword ptr [EAX]
0054cbdf XOR ECX,EBX
0054cbe1 MOV dword ptr [ESP + 0x5c],ECX
0054cbe5 CALL 0x005f58a0
0054cbea FLD dword ptr [0x00c08620]
0054cbf0 FMUL dword ptr [ESI + 0x2cc]
0054cbf6 LEA EDI,[ESI + 0xe8]
0054cbfc PUSH EDI
0054cbfd FSUBR dword ptr [ESI + 0x2e8]
0054cc03 FMUL dword ptr [ESP + 0x60]
0054cc07 FADD dword ptr [0x00c08620]
0054cc0d FSTP dword ptr [ESP + 0x28]
0054cc11 CALL 0x005f5890
0054cc16 MOV EAX,dword ptr [ESI + 0xe4]
0054cc1c MOV ECX,dword ptr [ESI + 0xdc]
0054cc22 PUSH EDI
0054cc23 MOV EDX,dword ptr [ECX]
0054cc25 MOV EBX,dword ptr [EAX]
0054cc27 XOR EDX,EBX
0054cc29 MOV dword ptr [ESP + 0x64],EDX
0054cc2d CALL 0x005f58a0
0054cc32 FLD dword ptr [0x00c0828c]
0054cc38 FMUL dword ptr [ESI + 0x2cc]
0054cc3e MOV AL,[0x00e843fc]
0054cc43 ADD ESP,0x10
0054cc46 TEST AL,AL
0054cc48 FSUBR dword ptr [ESI + 0x2ec]
0054cc4e FMUL dword ptr [ESP + 0x54]
0054cc52 FADD dword ptr [0x00c0828c]
0054cc58 FSTP dword ptr [ESP + 0x10]
0054cc5c JZ 0x0054cc71
0054cc5e MOV EAX,dword ptr [ESP + 0x1c]
0054cc62 MOV ECX,dword ptr [ESP + 0x10]
0054cc66 MOV [0x00c08620],EAX
0054cc6b MOV dword ptr [0x00c0828c],ECX
0054cc71 FLD dword ptr [0x00c08444]
0054cc77 FMUL dword ptr [ESI + 0x2a8]
0054cc7d MOV EBX,dword ptr [ESP + 0x44]
0054cc81 MOV EDX,dword ptr [ESP + 0x60]
0054cc85 MOV dword ptr [ESP + 0x60],EDX
0054cc89 FMUL dword ptr [0x00c08444]
0054cc8f FMUL dword ptr [ESP + 0x58]
0054cc93 FLD ST0
0054cc95 FSTP dword ptr [EBX]
0054cc97 FST dword ptr [ESP + 0x54]
0054cc9b FMUL dword ptr [0x006f58e0]   ; [006f58e0] f32=0.000250000011874 i32=964891247 f64=0.026250008116
0054cca1 FSTP dword ptr [ESP + 0x58]
0054cca5 MOV EAX,dword ptr [ESP + 0x60]
0054cca9 AND EAX,0x7fffffff
0054ccae MOV dword ptr [ESP + 0x28],EAX
0054ccb2 FLD dword ptr [ESP + 0x54]
0054ccb6 FMUL dword ptr [ESI + 0x29c]
0054ccbc PUSH ECX
0054ccbd LEA EAX,[ESI + 0x8ec]
0054ccc3 FSTP dword ptr [ESP]
0054ccc6 PUSH EAX
0054ccc7 CALL 0x005677d1
0054cccc MOV ECX,dword ptr [ESI + 0x2cc]
0054ccd2 LEA EDX,[ESI + 0x7ec]
0054ccd8 FSTP dword ptr [ESP + 0x68]
0054ccdc PUSH ECX
0054ccdd PUSH EDX
0054ccde CALL 0x005677d1
0054cce3 FMUL dword ptr [ESP + 0x70]
0054cce7 FLD dword ptr [ESP + 0x38]
0054cceb FMUL dword ptr [0x006ee390]   ; [006ee390] f32=0.0250000003725 i32=1020054733 f64=3.24662749178e+21
0054ccf1 MOV EAX,dword ptr [ESI + 0x70]
0054ccf4 MOV ECX,dword ptr [ESI + 0x18]
0054ccf7 MOV EDX,dword ptr [ESI + 0x1c]
0054ccfa FSUBR dword ptr [0x006e97d8]   ; [006e97d8] f32=1.0 i32=1065353216 f64=3.63170317588e+19
0054cd00 FMULP
0054cd02 FMUL dword ptr [ESP + 0x64]
0054cd06 FSTP dword ptr [ESP + 0x70]
0054cd0a FLD dword ptr [ESP + 0x68]
0054cd0e FMUL dword ptr [ESP + 0x68]
0054cd12 FADD dword ptr [0x006e97d8]   ; [006e97d8] f32=1.0 i32=1065353216 f64=3.63170317588e+19
0054cd18 FDIVR dword ptr [0x006e97d8]   ; [006e97d8] f32=1.0 i32=1065353216 f64=3.63170317588e+19
0054cd1e FADD dword ptr [0x006e97d8]   ; [006e97d8] f32=1.0 i32=1065353216 f64=3.63170317588e+19
0054cd24 FMUL dword ptr [ESP + 0x70]
0054cd28 FSTP dword ptr [ESP + 0x38]
0054cd2c FLD dword ptr [EAX + 0x20]
0054cd2f MOV EAX,dword ptr [ESP + 0x64]
0054cd33 MOV dword ptr [ESI + 0xd4],ECX
0054cd39 FMUL dword ptr [ESP + 0x70]
0054cd3d LEA ECX,[ESI + 0x96c]
0054cd43 PUSH EAX
0054cd44 PUSH ECX
0054cd45 MOV dword ptr [ESI + 0xd8],EDX
0054cd4b FCHS
0054cd4d FSTP dword ptr [ESP + 0x38]
0054cd51 CALL 0x005677d1
0054cd56 FLD dword ptr [ESI + 0xd0]
0054cd5c FMUL dword ptr [ESI + 0xd4]
0054cd62 MOV EAX,dword ptr [ESI + 0x6c]
0054cd65 ADD ESP,0x14
0054cd68 FMUL ST1
0054cd6a FSTP dword ptr [ESI + 0xd4]
0054cd70 FLD dword ptr [ESI + 0xd0]
0054cd76 FMUL ST1
0054cd78 FMUL dword ptr [ESI + 0xd8]
0054cd7e FSTP dword ptr [ESI + 0xd8]
0054cd84 MOV EDX,dword ptr [EAX*0x4 + 0x74e080]   ; [0074e080] f32=1.07329597226e-38 i32=7659296 f64=1.85763246496e-306
0054cd8b FSTP ST0
0054cd8d FLD dword ptr [0x006f5900]   ; [006f5900] f32=26789.0 i32=1188121088 f64=0.00171875048115
0054cd93 FSUB dword ptr [ESP + 0x58]
0054cd97 FDIVR dword ptr [0x006f58fc]   ; [006f58fc] f32=19135.0 i32=1184202240 f64=1.40265573048e+33
0054cd9d FMUL dword ptr [ESI + 0x2bc]
0054cda3 FSTP dword ptr [ESP]
0054cda6 PUSH EDX
0054cda7 CALL 0x005677d1
0054cdac FLD ST0
0054cdae FMUL dword ptr [ESI + 0xd4]
0054cdb4 ADD ESP,0x8
0054cdb7 MOV dword ptr [ESP + 0x14],0x0
0054cdbf FSTP dword ptr [ESI + 0xd4]
0054cdc5 FMUL dword ptr [ESI + 0xd8]
0054cdcb FSTP dword ptr [ESI + 0xd8]
0054cdd1 FLD dword ptr [ESP + 0x5c]
0054cdd5 FCOMP dword ptr [0x006ea454]   ; [006ea454] f32=0.0 i32=0 f64=-2048.0
0054cddb FNSTSW AX
0054cddd TEST AH,0x5
0054cde0 JP 0x0054ce45
0054cde2 MOV EDI,dword ptr [ESI + 0x2c0]
0054cde8 PUSH EDI
0054cde9 PUSH 0x11
0054cdeb CALL 0x00579ea0
0054cdf0 FSTP dword ptr [ESP + 0x60]
0054cdf4 PUSH EDI
0054cdf5 PUSH 0x11
0054cdf7 CALL 0x00579e80
0054cdfc FMUL dword ptr [0x00c08444]
0054ce02 ADD ESP,0x10
0054ce05 FMUL dword ptr [ESP + 0x5c]
0054ce09 FLD dword ptr [ESP + 0x58]
0054ce0d FMUL dword ptr [ESP + 0x50]
0054ce11 FADDP
0054ce13 FMUL dword ptr [0x00c08444]
0054ce19 FST dword ptr [ESP + 0x14]
0054ce1d FADD dword ptr [EBX]
0054ce1f FSTP dword ptr [EBX]
0054ce21 FLD dword ptr [ESI + 0xd4]
0054ce27 FMUL dword ptr [0x006ee4c4]   ; [006ee4c4] f32=0.15000000596 i32=1041865114 f64=2.30967998963e-09
0054ce2d FSTP dword ptr [ESI + 0xd4]
0054ce33 FLD dword ptr [ESI + 0xd8]
0054ce39 FMUL dword ptr [0x006ee4c4]   ; [006ee4c4] f32=0.15000000596 i32=1041865114 f64=2.30967998963e-09
0054ce3f FSTP dword ptr [ESI + 0xd8]
0054ce45 FLD dword ptr [ESP + 0x54]
0054ce49 FMUL dword ptr [ESI + 0xd8]
0054ce4f MOV EAX,0xbe7ffffd
0054ce54 MOV ECX,dword ptr [ESI + 0x2bc]
0054ce5a FSTP dword ptr [ESP + 0x18]
0054ce5e FLD dword ptr [ESP + 0x54]
0054ce62 FMUL dword ptr [ESI + 0xd4]
0054ce68 FSTP dword ptr [ESP + 0x24]
0054ce6c FLD dword ptr [0x006e97d8]   ; [006e97d8] f32=1.0 i32=1065353216 f64=3.63170317588e+19
0054ce72 FDIV dword ptr [ESP + 0x18]
0054ce76 FLD dword ptr [ESP + 0x60]
0054ce7a FMUL ST1
0054ce7c FMUL dword ptr [ESP + 0x1c]
0054ce80 FSTP dword ptr [ESP + 0x50]
0054ce84 FLD dword ptr [ESP + 0x20]
0054ce88 FMUL dword ptr [ESI + 0x2bc]
0054ce8e FMUL ST1
0054ce90 FSTP dword ptr [ESP + 0x20]
0054ce94 FSTP ST0
0054ce96 FLD dword ptr [ESP + 0x10]
0054ce9a FDIV dword ptr [ESP + 0x24]
0054ce9e FMUL dword ptr [ESP + 0x28]
0054cea2 FST dword ptr [ESP + 0x58]
0054cea6 FMUL dword ptr [ESP + 0x58]
0054ceaa FLD dword ptr [ESP + 0x50]
0054ceae FMUL dword ptr [ESP + 0x50]
0054ceb2 FADDP
0054ceb4 FST dword ptr [ESP + 0x5c]
0054ceb8 MOV EDX,dword ptr [ESP + 0x5c]
0054cebc FLD dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0054cec2 SUB EAX,EDX
0054cec4 SHR EAX,0x1
0054cec6 FMUL ST1
0054cec8 MOV dword ptr [ESP + 0x5c],EAX
0054cecc FLD dword ptr [ESP + 0x5c]
0054ced0 FMUL dword ptr [ESP + 0x5c]
0054ced4 FMUL ST1
0054ced6 FSUBR dword ptr [0x006ea494]   ; [006ea494] f32=1.5 i32=1069547520 f64=6.10947490176e-12
0054cedc FMUL dword ptr [ESP + 0x5c]
0054cee0 MOV dword ptr [ESP + 0x5c],ECX
0054cee4 FLD ST0
0054cee6 FMUL ST1
0054cee8 FMUL ST2
0054ceea FSUBR dword ptr [0x006ea494]   ; [006ea494] f32=1.5 i32=1069547520 f64=6.10947490176e-12
0054cef0 FMUL ST1
0054cef2 FMUL ST3
0054cef4 FSTP dword ptr [ESP + 0x10]
0054cef8 FSTP ST0
0054cefa FSTP ST0
0054cefc FSTP ST0
0054cefe MOV EAX,dword ptr [ESP + 0x5c]
0054cf02 AND EAX,0x7fffffff
0054cf07 MOV dword ptr [ESP + 0x2c],EAX
0054cf0b FLD dword ptr [ESP + 0x2c]
0054cf0f FCOMP dword ptr [0x006ed020]   ; [006ed020] f32=0.899999976158 i32=1063675494 f64=5.25525519909e-315
0054cf15 FNSTSW AX
0054cf17 TEST AH,0x5
0054cf1a JP 0x0054cf52
0054cf1c FLD dword ptr [ESP + 0x58]
0054cf20 FADD dword ptr [ESI + 0x2ac]
0054cf26 INC dword ptr [ESI + 0x2b8]
0054cf2c FSTP dword ptr [ESI + 0x2ac]
0054cf32 FLD dword ptr [ESP + 0x50]
0054cf36 FADD dword ptr [ESI + 0x2b0]
0054cf3c FSTP dword ptr [ESI + 0x2b0]
0054cf42 FLD dword ptr [ESP + 0x10]
0054cf46 FADD dword ptr [ESI + 0x2b4]
0054cf4c FSTP dword ptr [ESI + 0x2b4]
0054cf52 MOV EDX,dword ptr [ESP + 0x20]
0054cf56 LEA EDI,[ESI + 0x2f4]
0054cf5c PUSH EDX
0054cf5d PUSH EDI
0054cf5e CALL 0x005677d1
0054cf63 FLD ST0
0054cf65 FMUL ST1
0054cf67 MOV EAX,dword ptr [ESP + 0x18]
0054cf6b PUSH EAX
0054cf6c PUSH EDI
0054cf6d FMUL dword ptr [ESP + 0x30]
0054cf71 FADD dword ptr [0x006e97d8]   ; [006e97d8] f32=1.0 i32=1065353216 f64=3.63170317588e+19
0054cf77 FSUB ST0,ST1
0054cf79 FSTP dword ptr [ESP + 0x3c]
0054cf7d FSTP ST0
0054cf7f CALL 0x005677d1
0054cf84 FSTP dword ptr [ESP + 0x6c]
0054cf88 LEA EDI,[ESI + 0x114]
0054cf8e PUSH EDI
0054cf8f CALL 0x005f5890
0054cf94 MOV EAX,dword ptr [ESI + 0x110]
0054cf9a MOV ECX,dword ptr [ESI + 0x108]
0054cfa0 PUSH EDI
0054cfa1 MOV ECX,dword ptr [ECX]
0054cfa3 MOV EDX,dword ptr [EAX]
0054cfa5 XOR ECX,EDX
0054cfa7 MOV dword ptr [ESP + 0x70],ECX
0054cfab CALL 0x005f58a0
0054cfb0 FLD dword ptr [0x006e97d8]   ; [006e97d8] f32=1.0 i32=1065353216 f64=3.63170317588e+19
0054cfb6 FSUB dword ptr [ESP + 0x74]
0054cfba MOV EDX,0xbe7ffffd
0054cfbf FST dword ptr [ESI + 0x2e4]
0054cfc5 FLD dword ptr [ESP + 0x70]
0054cfc9 FMUL dword ptr [ESP + 0x74]
0054cfcd FADD ST0,ST1
0054cfcf FDIV dword ptr [ESI + 0xd8]
0054cfd5 FMUL dword ptr [ESI + 0xd4]
0054cfdb FMUL dword ptr [ESI + 0x2e8]
0054cfe1 FSTP dword ptr [ESP + 0x70]
0054cfe5 FSTP ST0
0054cfe7 FLD dword ptr [ESI + 0x2ec]
0054cfed FLD dword ptr [ESP + 0x70]
0054cff1 FMUL dword ptr [ESP + 0x70]
0054cff5 FLD ST1
0054cff7 FMUL ST2
0054cff9 FADDP
0054cffb FSTP ST1
0054cffd FST dword ptr [ESP + 0x68]
0054d001 MOV EBX,dword ptr [ESP + 0x68]
0054d005 FLD dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0054d00b SUB EDX,EBX
0054d00d SHR EDX,0x1
0054d00f MOV dword ptr [ESP + 0x68],EDX
0054d013 ADD ESP,0x14
0054d016 FMUL ST1
0054d018 FLD dword ptr [ESP + 0x54]
0054d01c FMUL dword ptr [ESP + 0x54]
0054d020 FMUL ST1
0054d022 FSUBR dword ptr [0x006ea494]   ; [006ea494] f32=1.5 i32=1069547520 f64=6.10947490176e-12
0054d028 FMUL dword ptr [ESP + 0x54]
0054d02c FLD ST0
0054d02e FMUL ST1
0054d030 FMUL ST2
0054d032 FSUBR dword ptr [0x006ea494]   ; [006ea494] f32=1.5 i32=1069547520 f64=6.10947490176e-12
0054d038 FMUL ST1
0054d03a FSTP dword ptr [ESP + 0x54]
0054d03e FSTP ST0
0054d040 FSTP ST0
0054d042 FLD dword ptr [ESP + 0x60]
0054d046 FMUL dword ptr [ESP + 0x60]
0054d04a FMUL dword ptr [ESP + 0x14]
0054d04e FSTP dword ptr [ESP + 0x14]
0054d052 FLD dword ptr [ESP + 0x54]
0054d056 FMUL ST1
0054d058 FSTP dword ptr [ESP]
0054d05b LEA EAX,[ESI + 0x86c]
0054d061 FSTP ST0
0054d063 PUSH EAX
0054d064 CALL 0x005677d1
0054d069 FMUL dword ptr [ESI + 0x2e4]
0054d06f MOV EDI,dword ptr [ESP + 0x48]
0054d073 MOV EBX,dword ptr [ESP + 0x44]
0054d077 MOV EBP,dword ptr [ESP + 0x40]
0054d07b ADD ESP,0x8
0054d07e FST dword ptr [ESP + 0x20]
0054d082 FADD dword ptr [ESP + 0x10]
0054d086 FMUL dword ptr [ESP + 0x50]
0054d08a FLD ST0
0054d08c FMUL dword ptr [ESI + 0x2ec]
0054d092 FLD dword ptr [ESP + 0x58]
0054d096 FMUL ST2
0054d098 FLD dword ptr [ESP + 0x2c]
0054d09c FMUL dword ptr [ESP + 0x5c]
0054d0a0 FADDP
0054d0a2 FMUL dword ptr [ESP + 0x18]
0054d0a6 FSTP dword ptr [EDI]
0054d0a8 FMUL dword ptr [ESP + 0x24]
0054d0ac FSTP dword ptr [EBX]
0054d0ae MOV dword ptr [EBP],0x0
0054d0b5 MOV EDX,dword ptr [ESI + 0x70]
0054d0b8 FSTP ST0
0054d0ba FLD dword ptr [ESP + 0x54]
0054d0be FMUL dword ptr [ESI + 0x2c4]
0054d0c4 MOV ECX,dword ptr [ESI + 0x6c]
0054d0c7 FST dword ptr [ESI + 0x2c8]
0054d0cd FLD dword ptr [EDX]
0054d0cf MOV EAX,dword ptr [ECX*0x4 + 0xc081f4]
0054d0d6 FMUL ST1
0054d0d8 FADD dword ptr [EAX]
0054d0da FSTP dword ptr [EAX]
0054d0dc FSTP ST0
0054d0de FLD dword ptr [ESP + 0x14]
0054d0e2 FCOMP dword ptr [0x006f58f8]   ; [006f58f8] f32=500.0 i32=1140457472 f64=1.08978358083e+32
0054d0e8 FNSTSW AX
0054d0ea AND EAX,0x4100
0054d0ef JNZ 0x0054d103
0054d0f1 MOV EAX,dword ptr [ESP + 0x4c]
0054d0f5 MOV ECX,dword ptr [ESP + 0x48]
0054d0f9 PUSH EAX
0054d0fa PUSH ECX
0054d0fb CALL 0x00577260
0054d100 ADD ESP,0x8
0054d103 MOV EAX,dword ptr [ESI + 0x6c]
0054d106 MOV ECX,0x2
0054d10b CMP EAX,ECX
0054d10d JGE 0x0054d1a6
0054d113 FLD dword ptr [ESP + 0x50]
0054d117 FMUL dword ptr [ESP + 0x58]
0054d11b MOV EDX,dword ptr [ESP + 0x1c]
0054d11f FMUL dword ptr [ESP + 0x18]
0054d123 FLD dword ptr [ESP + 0x54]
0054d127 FMUL dword ptr [ESI + 0x2a4]
0054d12d FSQRT
0054d12f FLD dword ptr [EBX]
0054d131 FDIV dword ptr [ESP + 0x28]
0054d135 FMUL dword ptr [0x006e9824]   ; [006e9824] f32=0.20000000298 i32=1045220557 f64=4.23433939448e-16
0054d13b FADD dword ptr [EAX*0x4 + 0xc082d4]
0054d142 FLD ST1
0054d144 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0054d14a FADDP
0054d14c FADD dword ptr [ESP + 0x6c]
0054d150 FLD dword ptr [0x006e9824]   ; [006e9824] f32=0.20000000298 i32=1045220557 f64=4.23433939448e-16
0054d156 FDIV dword ptr [ESP + 0x60]
0054d15a FMUL dword ptr [EDI]
0054d15c FLD dword ptr [ESP + 0x5c]
0054d160 FADD dword ptr [0x006e97d8]   ; [006e97d8] f32=1.0 i32=1065353216 f64=3.63170317588e+19
0054d166 MOV dword ptr [0x00c085dc],EDX
0054d16c FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0054d172 FMUL ST3
0054d174 FSUBR ST0,ST2
0054d176 FLD dword ptr [ESP + 0x20]
0054d17a FMUL ST5
0054d17c FMULP
0054d17e FXCH ST3
0054d180 FMUL dword ptr [ESP + 0x5c]
0054d184 FMUL dword ptr [0x006efb28]   ; [006efb28] f32=0.800000011921 i32=1061997773 f64=1.41194257416e-50
0054d18a FSUBR ST0,ST2
0054d18c FLD dword ptr [ESP + 0x10]
0054d190 FMUL ST5
0054d192 FMULP
0054d194 FADDP ST3,ST0
0054d196 FMUL dword ptr [EBX]
0054d198 FADDP ST2,ST0
0054d19a FXCH
0054d19c FSTP dword ptr [0x00c081ec]
0054d1a2 FSTP ST0
0054d1a4 FSTP ST0
0054d1a6 FLD dword ptr [ESP + 0x30]
0054d1aa FCOMP dword ptr [0x006f58c4]   ; [006f58c4] f32=1.29999995232 i32=1067869798 f64=2.19902367269e+13
0054d1b0 FNSTSW AX
0054d1b2 TEST AH,0x5
0054d1b5 JP 0x0054d2e8
0054d1bb FLD dword ptr [ESP + 0x64]
0054d1bf FMUL dword ptr [ESP + 0x64]
0054d1c3 FLD dword ptr [ESP + 0x68]
0054d1c7 FMUL dword ptr [ESP + 0x68]
0054d1cb FADDP
0054d1cd FSTP dword ptr [ESP + 0x5c]
0054d1d1 FLD dword ptr [0x006f58bc]   ; [006f58bc] f32=0.00999999977648 i32=1008981770 f64=1.88737897632e-17
0054d1d7 FMUL dword ptr [0x006f58bc]   ; [006f58bc] f32=0.00999999977648 i32=1008981770 f64=1.88737897632e-17
0054d1dd FCOMP dword ptr [ESP + 0x5c]
0054d1e1 FNSTSW AX
0054d1e3 AND EAX,0x4100
0054d1e8 JNZ 0x0054d250
0054d1ea FLD dword ptr [0x00c08444]
0054d1f0 FMUL dword ptr [ESP + 0x64]
0054d1f4 MOV dword ptr [0x00c08284],0x0
0054d1fe MOV EAX,[0x00e84480]
0054d203 FMUL dword ptr [0x006f58f4]   ; [006f58f4] f32=-140000.0 i32=-938952704 f64=2.9975972866e+19
0054d209 FLD dword ptr [ESI + 0x2ec]
0054d20f FMUL dword ptr [0x006f58f0]   ; [006f58f0] f32=-2000.0 i32=-990248960 f64=-1.05141984406e+39
0054d215 FSUBP
0054d217 FMUL dword ptr [0x00c08444]
0054d21d FMUL dword ptr [EAX]
0054d21f FADD dword ptr [EBP]
0054d222 FSTP dword ptr [EBP]
0054d225 FLD dword ptr [ESP + 0x4c]
0054d229 FMUL dword ptr [0x006f58f0]   ; [006f58f0] f32=-2000.0 i32=-990248960 f64=-1.05141984406e+39
0054d22f FLD dword ptr [0x00c08444]
0054d235 FMUL dword ptr [ESP + 0x68]
0054d239 FMUL dword ptr [0x006f58ec]   ; [006f58ec] f32=140000.0 i32=1208530944 f64=-1.96450478129e+24
0054d23f FSUBP
0054d241 FMUL dword ptr [0x00c08444]
0054d247 FADD dword ptr [EDI]
0054d249 FSTP dword ptr [EDI]
0054d24b JMP 0x0054d3d0
0054d250 FLD dword ptr [0x006f58c0]   ; [006f58c0] f32=0.0149999996647 i32=1014350479 f64=0.0437499951175
0054d256 FMUL dword ptr [0x006f58c0]   ; [006f58c0] f32=0.0149999996647 i32=1014350479 f64=0.0437499951175
0054d25c FCOMP dword ptr [ESP + 0x5c]
0054d260 FNSTSW AX
0054d262 AND EAX,0x4100
0054d267 JNZ 0x0054d2e8
0054d269 FLD dword ptr [ESP + 0x5c]
0054d26d FSQRT
0054d26f MOV dword ptr [0x00c08284],0x1
0054d279 MOV ECX,dword ptr [0x00e84480]
0054d27f FDIVR dword ptr [0x006f58bc]   ; [006f58bc] f32=0.00999999977648 i32=1008981770 f64=1.88737897632e-17
0054d285 FST dword ptr [0x00c08624]
0054d28b FMUL dword ptr [0x00c08444]
0054d291 FMUL dword ptr [ESP + 0x64]
0054d295 FMUL dword ptr [0x006f58f4]   ; [006f58f4] f32=-140000.0 i32=-938952704 f64=2.9975972866e+19
0054d29b FLD dword ptr [ESI + 0x2ec]
0054d2a1 FMUL dword ptr [0x006f58f0]   ; [006f58f0] f32=-2000.0 i32=-990248960 f64=-1.05141984406e+39
0054d2a7 FSUBP
0054d2a9 FMUL dword ptr [0x00c08444]
0054d2af FMUL dword ptr [ECX]
0054d2b1 FADD dword ptr [EBP]
0054d2b4 FSTP dword ptr [EBP]
0054d2b7 FLD dword ptr [ESP + 0x4c]
0054d2bb FMUL dword ptr [0x006f58f0]   ; [006f58f0] f32=-2000.0 i32=-990248960 f64=-1.05141984406e+39
0054d2c1 FLD dword ptr [0x00c08624]
0054d2c7 FMUL dword ptr [0x00c08444]
0054d2cd FMUL dword ptr [ESP + 0x68]
0054d2d1 FMUL dword ptr [0x006f58ec]   ; [006f58ec] f32=140000.0 i32=1208530944 f64=-1.96450478129e+24
0054d2d7 FSUBP
0054d2d9 FMUL dword ptr [0x00c08444]
0054d2df FADD dword ptr [EDI]
0054d2e1 FSTP dword ptr [EDI]
0054d2e3 JMP 0x0054d3d0
0054d2e8 MOV dword ptr [0x00c08284],ECX
0054d2ee JMP 0x0054d3d0
0054d2f3 MOV EDX,dword ptr [ESP + 0x44]
0054d2f7 MOV EDI,dword ptr [ESP + 0x40]
0054d2fb FLD dword ptr [ESP + 0x5c]
0054d2ff MOV EBX,dword ptr [ESP + 0x3c]
0054d303 MOV EAX,dword ptr [ESP + 0x38]
0054d307 FCOMP dword ptr [0x006ea454]   ; [006ea454] f32=0.0 i32=0 f64=-2048.0
0054d30d XOR ECX,ECX
0054d30f MOV dword ptr [0x00c08284],0x2
0054d319 MOV dword ptr [EDX],ECX
0054d31b MOV dword ptr [EDI],ECX
0054d31d MOV dword ptr [EBX],ECX
0054d31f MOV dword ptr [EAX],ECX
0054d321 FNSTSW AX
0054d323 MOV dword ptr [0x00c08620],ECX
0054d329 MOV dword ptr [0x00c0828c],ECX
0054d32f TEST AH,0x5
0054d332 JP 0x0054d396
0054d334 MOV EBP,dword ptr [ESI + 0x2c0]
0054d33a PUSH EBP
0054d33b PUSH 0x11
0054d33d CALL 0x00579ea0
0054d342 FSTP dword ptr [ESP + 0x6c]
0054d346 PUSH EBP
0054d347 PUSH 0x11
0054d349 CALL 0x00579e80
0054d34e FMUL dword ptr [0x00c08444]
0054d354 MOV ECX,dword ptr [ESP + 0x54]
0054d358 ADD ESP,0x10
0054d35b FMUL dword ptr [ESP + 0x5c]
0054d35f FLD dword ptr [ESP + 0x64]
0054d363 FMUL dword ptr [ESP + 0x50]
0054d367 FADDP
0054d369 FMUL dword ptr [0x00c08444]
0054d36f FLD ST0
0054d371 FSTP dword ptr [ECX]
0054d373 FCOMP dword ptr [0x006f58f8]   ; [006f58f8] f32=500.0 i32=1140457472 f64=1.08978358083e+32
0054d379 FNSTSW AX
0054d37b AND EAX,0x4100
0054d380 JNZ 0x0054d394
0054d382 MOV EDX,dword ptr [ESP + 0x4c]
0054d386 MOV EAX,dword ptr [ESP + 0x48]
0054d38a PUSH EDX
0054d38b PUSH EAX
0054d38c CALL 0x00577260
0054d391 ADD ESP,0x8
0054d394 XOR ECX,ECX
0054d396 MOV EAX,dword ptr [ESI + 0x6c]
0054d399 MOV dword ptr [ESI + 0x2c8],ECX
0054d39f CMP EAX,0x2
0054d3a2 MOV dword ptr [ESI + 0x2e4],ECX
0054d3a8 MOV dword ptr [ESI + 0x2e8],ECX
0054d3ae MOV dword ptr [ESI + 0x2ec],ECX
0054d3b4 MOV dword ptr [ESI + 0x2f0],ECX
0054d3ba JGE 0x0054d3d0
0054d3bc MOV dword ptr [0x00c085dc],0x0
0054d3c6 MOV dword ptr [0x00c081ec],0x0
0054d3d0 MOV ECX,dword ptr [ESP + 0x44]
0054d3d4 MOV EDX,dword ptr [ECX]
0054d3d6 MOV dword ptr [ESI + 0x2e0],EDX
0054d3dc MOV EAX,dword ptr [EDI]
0054d3de MOV dword ptr [ESI + 0x2dc],EAX
0054d3e4 MOV ECX,dword ptr [EBX]
0054d3e6 MOV dword ptr [ESI + 0x2d8],ECX
0054d3ec POP EDI
0054d3ed POP ESI
0054d3ee POP EBP
0054d3ef POP EBX
0054d3f0 ADD ESP,0x24
0054d3f3 RET 0x38
