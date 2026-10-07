005bc950 PUSH EBP
005bc951 MOV EBP,ESP
005bc953 AND ESP,0xfffffff8
005bc956 SUB ESP,0x74
005bc959 PUSH EBX
005bc95a PUSH ESI
005bc95b PUSH EDI
005bc95c CALL 0x005d8700
005bc961 MOV EBX,EAX
005bc963 TEST EBX,EBX
005bc965 MOV dword ptr [ESP + 0x34],EBX
005bc969 JZ 0x005bccab
005bc96f MOV EAX,dword ptr [EBX]
005bc971 PUSH 0x752ef8   ; [00752ef8] f32=6.7110921272e+22 i32=1701011826 f64=3.94357125246e+180
005bc976 MOV ECX,EBX
005bc978 CALL dword ptr [EAX + 0x1c]
005bc97b MOV EDX,dword ptr [EBX]
005bc97d PUSH 0x1
005bc97f PUSH 0x1
005bc981 MOV ECX,EBX
005bc983 CALL dword ptr [EDX + 0x18]
005bc986 TEST EAX,EAX
005bc988 JZ 0x005bcca2
005bc98e CALL 0x005e4e50
005bc993 MOV EDI,EAX
005bc995 TEST EDI,EDI
005bc997 JZ 0x005bcca2
005bc99d MOV EAX,[0x00b8faa0]
005bc9a2 LEA ECX,[ESP + 0x28]
005bc9a6 SHL EAX,0x3
005bc9a9 PUSH EAX
005bc9aa PUSH ECX
005bc9ab CALL 0x005cfce4
005bc9b0 MOV EDX,dword ptr [ESP + 0x30]
005bc9b4 MOV ESI,EAX
005bc9b6 NEG ESI
005bc9b8 SBB ESI,ESI
005bc9ba AND ESI,EDX
005bc9bc MOV EDX,dword ptr [0x00b8faa0]
005bc9c2 MOV dword ptr [ESP + 0x28],ESI
005bc9c6 LEA EAX,[EDX*0x8 + 0x0]
005bc9cd PUSH EAX
005bc9ce LEA EAX,[ESP + 0x38]
005bc9d2 PUSH EAX
005bc9d3 CALL 0x005cfce4
005bc9d8 MOV ECX,dword ptr [ESP + 0x3c]
005bc9dc MOV EDX,EAX
005bc9de ADD ESP,0x10
005bc9e1 NEG EDX
005bc9e3 SBB EDX,EDX
005bc9e5 AND EDX,ECX
005bc9e7 TEST ESI,ESI
005bc9e9 MOV dword ptr [ESP + 0x14],EDX
005bc9ed JZ 0x005bcc89
005bc9f3 TEST EDX,EDX
005bc9f5 JZ 0x005bcc80
005bc9fb MOV ECX,dword ptr [0x00b8faa0]
005bca01 XOR EBX,EBX
005bca03 XOR ESI,ESI
005bca05 CMP ECX,0x7
005bca08 MOV dword ptr [ESP + 0x10],EBX
005bca0c MOV dword ptr [ESP + 0xc],EBX
005bca10 JLE 0x005bca67
005bca12 LEA ESI,[ECX + -0x3]
005bca15 XOR EAX,EAX
005bca17 MOV ECX,dword ptr [EBP + 0xc]
005bca1a FLD dword ptr [ESP + 0xc]
005bca1e MOV EDX,dword ptr [ECX + ESI*0x4]
005bca21 FADD dword ptr [ECX + ESI*0x4]
005bca24 LEA ECX,[ESI*0x8 + 0x0]
005bca2b MOV dword ptr [ESP + EAX*0x1 + 0x48],EDX
005bca2f MOV EDX,dword ptr [EBP + 0x8]
005bca32 SUB ECX,ESI
005bca34 INC ESI
005bca35 FSTP dword ptr [ESP + 0xc]
005bca39 FLD dword ptr [EDX + ECX*0x4 + 0x14]
005bca3d LEA ECX,[EDX + ECX*0x4 + 0x14]
005bca41 FSTP dword ptr [ESP + EAX*0x1 + 0x64]
005bca45 FLD dword ptr [ECX]
005bca47 MOV ECX,dword ptr [0x00b8faa0]
005bca4d FADD dword ptr [ESP + 0x10]
005bca51 CMP ESI,ECX
005bca53 FSTP dword ptr [ESP + 0x10]
005bca57 JL 0x005bca5b
005bca59 XOR ESI,ESI
005bca5b ADD EAX,0x4
005bca5e CMP EAX,0x1c
005bca61 JL 0x005bca17
005bca63 MOV EDX,dword ptr [ESP + 0x14]
005bca67 TEST ECX,ECX
005bca69 MOV dword ptr [ESP + 0x18],0x0
005bca71 JLE 0x005bcc25
005bca77 MOV EAX,dword ptr [ESP + 0x20]
005bca7b MOV dword ptr [ESP + 0x28],EAX
005bca7f MOV EAX,dword ptr [EBP + 0x8]
005bca82 ADD EAX,0x14
005bca85 MOV dword ptr [ESP + 0x1c],EAX
005bca89 MOV EAX,EDX
005bca8b SUB EAX,dword ptr [ESP + 0x20]
005bca8f MOV dword ptr [ESP + 0x30],EAX
005bca93 CMP ECX,0x7
005bca96 JLE 0x005bcaff
005bca98 FLD dword ptr [ESP + 0xc]
005bca9c FMUL dword ptr [0x006f5930]   ; [006f5930] f32=0.142857149243 i32=1041385765 f64=6.36798317689e-32
005bcaa2 FLD dword ptr [ESP + 0x10]
005bcaa6 FMUL dword ptr [0x006f5930]   ; [006f5930] f32=0.142857149243 i32=1041385765 f64=6.36798317689e-32
005bcaac MOV EDX,dword ptr [EBP + 0xc]
005bcaaf LEA EAX,[ESI*0x8 + 0x0]
005bcab6 SUB EAX,ESI
005bcab8 INC EBX
005bcab9 CMP EBX,0x7
005bcabc FSTP dword ptr [ESP + 0x24]
005bcac0 FLD dword ptr [EDX + ESI*0x4]
005bcac3 FLD dword ptr [ESP + EBX*0x4 + 0x44]
005bcac7 FSUBR ST0,ST1
005bcac9 MOV EDX,dword ptr [EBP + 0x8]
005bcacc FADD dword ptr [ESP + 0xc]
005bcad0 FSTP dword ptr [ESP + 0xc]
005bcad4 FSTP dword ptr [ESP + EBX*0x4 + 0x44]
005bcad8 FLD dword ptr [EDX + EAX*0x4 + 0x14]
005bcadc FLD dword ptr [ESP + EBX*0x4 + 0x60]
005bcae0 FSUBR ST0,ST1
005bcae2 FADD dword ptr [ESP + 0x10]
005bcae6 FSTP dword ptr [ESP + 0x10]
005bcaea FSTP dword ptr [ESP + EBX*0x4 + 0x60]
005bcaee JL 0x005bcaf2
005bcaf0 XOR EBX,EBX
005bcaf2 MOV EDX,dword ptr [ESP + 0x14]
005bcaf6 INC ESI
005bcaf7 CMP ESI,ECX
005bcaf9 JL 0x005bcb13
005bcafb XOR ESI,ESI
005bcafd JMP 0x005bcb13
005bcaff MOV EAX,dword ptr [EBP + 0xc]
005bcb02 MOV ECX,dword ptr [ESP + 0x18]
005bcb06 FLD dword ptr [EAX + ECX*0x4]
005bcb09 MOV EAX,dword ptr [ESP + 0x1c]
005bcb0d MOV ECX,dword ptr [EAX]
005bcb0f MOV dword ptr [ESP + 0x24],ECX
005bcb13 FMUL qword ptr [0x006f75f8]   ; [006f75f8] f32=-1.14234420275e+19 i32=-551647176 f64=132.110091743
005bcb19 FCOM qword ptr [0x006ea4b0]   ; [006ea4b0] f32=0.0 i32=0 f64=0.0
005bcb1f FST qword ptr [ESP + 0x38]
005bcb23 FNSTSW AX
005bcb25 AND EAX,0x4100
005bcb2a JNZ 0x005bcb90
005bcb2c MOV EAX,dword ptr [EBP + 0x8]
005bcb2f LEA EDX,[ESI*0x8 + 0x0]
005bcb36 SUB EDX,ESI
005bcb38 FSTP ST0
005bcb3a FLD dword ptr [EAX + EDX*0x4 + 0x18]
005bcb3e FMUL qword ptr [0x006f75f0]   ; [006f75f0] f32=-4875367936.0 i32=-812561381 f64=1284.43243243
005bcb44 FSTP qword ptr [ESP + 0x40]
005bcb48 CALL 0x0050a160
005bcb4d FSTP dword ptr [ESP + 0x2c]
005bcb51 CALL 0x0050a160
005bcb56 FMUL dword ptr [ESP + 0x2c]
005bcb5a MOV EDX,dword ptr [ESP + 0x14]
005bcb5e FDIVR qword ptr [ESP + 0x40]
005bcb62 FMUL qword ptr [ESP + 0x38]
005bcb66 FMUL qword ptr [ESP + 0x38]
005bcb6a FCHS
005bcb6c FLDL2E
005bcb6e FMULP
005bcb70 FLD ST0
005bcb72 FRNDINT
005bcb74 FXCH
005bcb76 FSUB ST0,ST1
005bcb78 F2XM1
005bcb7a FLD1
005bcb7c FADDP
005bcb7e FSCALE
005bcb80 FSTP ST1
005bcb82 FMUL qword ptr [0x006ea668]   ; [006ea668] f32=0.0 i32=0 f64=0.5
005bcb88 FSUBR qword ptr [0x006e9808]   ; [006e9808] f32=0.0 i32=0 f64=1.0
005bcb8e JMP 0x005bcbb8
005bcb90 FLD ST0
005bcb92 FMUL ST1
005bcb94 FMUL qword ptr [0x006ea4b8]   ; [006ea4b8] f32=0.0 i32=0 f64=-1.0
005bcb9a FLDL2E
005bcb9c FMULP
005bcb9e FLD ST0
005bcba0 FRNDINT
005bcba2 FXCH
005bcba4 FSUB ST0,ST1
005bcba6 F2XM1
005bcba8 FLD1
005bcbaa FADDP
005bcbac FSCALE
005bcbae FSTP ST1
005bcbb0 FMUL qword ptr [0x006ea668]   ; [006ea668] f32=0.0 i32=0 f64=0.5
005bcbb6 FSTP ST1
005bcbb8 FCOM qword ptr [0x006ea4b0]   ; [006ea4b0] f32=0.0 i32=0 f64=0.0
005bcbbe FNSTSW AX
005bcbc0 TEST AH,0x5
005bcbc3 JP 0x005bcbcf
005bcbc5 FSTP ST0
005bcbc7 FLD qword ptr [0x006ea4b0]   ; [006ea4b0] f32=0.0 i32=0 f64=0.0
005bcbcd JMP 0x005bcbe6
005bcbcf FCOM qword ptr [0x006e9808]   ; [006e9808] f32=0.0 i32=0 f64=1.0
005bcbd5 FNSTSW AX
005bcbd7 AND EAX,0x4100
005bcbdc JNZ 0x005bcbe6
005bcbde FSTP ST0
005bcbe0 FLD qword ptr [0x006e9808]   ; [006e9808] f32=0.0 i32=0 f64=1.0
005bcbe6 MOV ECX,dword ptr [ESP + 0x30]
005bcbea MOV EAX,dword ptr [ESP + 0x28]
005bcbee FSTP qword ptr [ECX + EAX*0x1]
005bcbf1 MOV ECX,dword ptr [ESP + 0x18]
005bcbf5 ADD EAX,0x8
005bcbf8 FLD dword ptr [ESP + 0x24]
005bcbfc INC ECX
005bcbfd FSTP qword ptr [EAX + -0x8]
005bcc00 MOV dword ptr [ESP + 0x18],ECX
005bcc04 MOV ECX,dword ptr [ESP + 0x1c]
005bcc08 ADD ECX,0x1c
005bcc0b MOV dword ptr [ESP + 0x28],EAX
005bcc0f MOV EAX,dword ptr [ESP + 0x18]
005bcc13 MOV dword ptr [ESP + 0x1c],ECX
005bcc17 MOV ECX,dword ptr [0x00b8faa0]
005bcc1d CMP EAX,ECX
005bcc1f JL 0x005bca93
005bcc25 MOV EAX,dword ptr [ESP + 0x20]
005bcc29 MOV ESI,dword ptr [EBP + 0x10]
005bcc2c MOV dword ptr [EDI + 0x1c],EAX
005bcc2f MOV ECX,0x40000000
005bcc34 MOV EAX,0x3fd33333
005bcc39 MOV dword ptr [EDI + 0x20],EDX
005bcc3c MOV EDX,dword ptr [ESP + 0x34]
005bcc40 MOV dword ptr [EDI + 0x24],ECX
005bcc43 MOV dword ptr [EDI + 0x28],EAX
005bcc46 MOV dword ptr [EDI + 0x2c],ECX
005bcc49 MOV dword ptr [EDI + 0x30],EAX
005bcc4c FLD dword ptr [0x006f75d0]   ; [006f75d0] f32=3.0 i32=1077936128 f64=5.32571209256e-315
005bcc52 FSTP qword ptr [EDI + 0x14]
005bcc55 MOV ECX,dword ptr [0x00b8faa0]
005bcc5b MOV dword ptr [EDI + 0x10],EDX
005bcc5e MOV dword ptr [EDI + 0xc],ECX
005bcc61 MOV EAX,dword ptr [ESI + 0x28]
005bcc64 TEST EAX,EAX
005bcc66 JZ 0x005bcc71
005bcc68 PUSH EAX
005bcc69 CALL 0x005cff12
005bcc6e ADD ESP,0x4
005bcc71 MOV dword ptr [ESI + 0x28],EDI
005bcc74 MOV EAX,0x1
005bcc79 POP EDI
005bcc7a POP ESI
005bcc7b POP EBX
005bcc7c MOV ESP,EBP
005bcc7e POP EBP
005bcc7f RET
005bcc80 PUSH ESI
005bcc81 CALL 0x005cfccc
005bcc86 ADD ESP,0x4
005bcc89 MOV EAX,dword ptr [EBP + 0xc]
005bcc8c TEST EAX,EAX
005bcc8e JZ 0x005bcc99
005bcc90 PUSH EAX
005bcc91 CALL 0x005cfccc
005bcc96 ADD ESP,0x4
005bcc99 PUSH EBX
005bcc9a CALL 0x005cff12
005bcc9f ADD ESP,0x4
005bcca2 PUSH EBX
005bcca3 CALL 0x005cff12
005bcca8 ADD ESP,0x4
005bccab POP EDI
005bccac POP ESI
005bccad XOR EAX,EAX
005bccaf POP EBX
005bccb0 MOV ESP,EBP
005bccb2 POP EBP
005bccb3 RET
