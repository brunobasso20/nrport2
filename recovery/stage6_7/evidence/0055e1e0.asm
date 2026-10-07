0055e1e0 PUSH EBX
0055e1e1 PUSH ESI
0055e1e2 MOV ESI,dword ptr [ESP + 0x1c]
0055e1e6 MOV EDX,dword ptr [ESP + 0x10]
0055e1ea FLD dword ptr [ESP + 0x24]
0055e1ee MOV EAX,dword ptr [ESI + 0xc]
0055e1f1 PUSH EDI
0055e1f2 MOV [0x00c08620],EAX
0055e1f7 MOV ECX,dword ptr [ESI + 0x10]
0055e1fa MOV EAX,dword ptr [ESP + 0x24]
0055e1fe MOV dword ptr [0x00c0828c],ECX
0055e204 MOV dword ptr [0x00c08444],EDX
0055e20a LEA ECX,[EAX + EAX*0x2]
0055e20d LEA ECX,[ECX + ECX*0x8]
0055e210 LEA ECX,[EAX + ECX*0x4]
0055e213 LEA EDX,[ECX + ECX*0x2]
0055e216 MOV ECX,dword ptr [ESP + 0x38]
0055e21a LEA EDI,[EAX + EDX*0x8]
0055e21d MOV EDX,dword ptr [0x00c08628]
0055e223 MOV dword ptr [EDI + 0xbf3ce0],ECX
0055e229 FSTP dword ptr [EDX]
0055e22b FLD dword ptr [ESP + 0x2c]
0055e22f MOV ECX,dword ptr [0x00c0862c]
0055e235 FSTP dword ptr [ECX]
0055e237 FLD dword ptr [ESP + 0x30]
0055e23b MOV EDX,dword ptr [0x00c08630]
0055e241 FSTP dword ptr [EDX]
0055e243 FLD dword ptr [ESP + 0x34]
0055e247 MOV ECX,dword ptr [0x00c08568]
0055e24d FSTP dword ptr [ECX]
0055e24f MOV ECX,dword ptr [ESP + 0x1c]
0055e253 MOV EBX,dword ptr [0x00c08304]
0055e259 MOV EDX,dword ptr [ECX]
0055e25b MOV dword ptr [EBX],EDX
0055e25d MOV EBX,dword ptr [0x00c08308]
0055e263 MOV EDX,dword ptr [ECX + 0x4]
0055e266 MOV dword ptr [EBX],EDX
0055e268 MOV EDX,dword ptr [0x00c0830c]
0055e26e MOV ECX,dword ptr [ECX + 0x8]
0055e271 MOV dword ptr [EDX],ECX
0055e273 MOV EDX,dword ptr [0x00c08538]
0055e279 MOV ECX,dword ptr [ESI]
0055e27b MOV dword ptr [EDX],ECX
0055e27d MOV EDX,dword ptr [0x00c0853c]
0055e283 MOV ECX,dword ptr [ESI + 0x4]
0055e286 MOV dword ptr [EDX],ECX
0055e288 MOV EDX,dword ptr [0x00c08540]
0055e28e MOV ECX,dword ptr [ESI + 0x8]
0055e291 MOV dword ptr [EDX],ECX
0055e293 MOV EAX,dword ptr [EAX*0x4 + 0xe84b90]
0055e29a PUSH EAX
0055e29b CALL 0x005b9d10
0055e2a0 MOV ECX,dword ptr [0x00c085cc]
0055e2a6 ADD ESP,0x4
0055e2a9 MOV EDX,dword ptr [ECX]
0055e2ab MOV ECX,dword ptr [ESP + 0x10]
0055e2af MOV dword ptr [ECX],EDX
0055e2b1 MOV EAX,[0x00c085d0]
0055e2b6 MOV EDX,dword ptr [EAX]
0055e2b8 MOV dword ptr [ECX + 0x4],EDX
0055e2bb MOV EAX,[0x00c085d4]
0055e2c0 MOV EDX,dword ptr [EAX]
0055e2c2 MOV dword ptr [ECX + 0x8],EDX
0055e2c5 MOV EAX,[0x00c08620]
0055e2ca MOV dword ptr [ESI + 0xc],EAX
0055e2cd MOV EDX,dword ptr [0x00c0828c]
0055e2d3 MOV dword ptr [ESI + 0x10],EDX
0055e2d6 MOV EAX,[0x00c08554]
0055e2db MOV EDX,dword ptr [EAX]
0055e2dd MOV EAX,dword ptr [ESP + 0x18]
0055e2e1 MOV dword ptr [EAX],EDX
0055e2e3 MOV EDX,dword ptr [0x00c08558]
0055e2e9 MOV EDX,dword ptr [EDX]
0055e2eb MOV dword ptr [EAX + 0x4],EDX
0055e2ee MOV EDX,dword ptr [0x00c0855c]
0055e2f4 MOV EDX,dword ptr [EDX]
0055e2f6 MOV dword ptr [EAX + 0x8],EDX
0055e2f9 MOV EDX,dword ptr [0x00c08284]
0055e2ff CMP EDX,0x2
0055e302 JNZ 0x0055e316
0055e304 MOV EDX,dword ptr [EAX]
0055e306 MOV dword ptr [ESI],EDX
0055e308 MOV EDX,dword ptr [EAX + 0x4]
0055e30b MOV dword ptr [ESI + 0x4],EDX
0055e30e MOV EDX,dword ptr [EAX + 0x8]
0055e311 MOV dword ptr [ESI + 0x8],EDX
0055e314 JMP 0x0055e355
0055e316 CMP EDX,0x1
0055e319 JNZ 0x0055e355
0055e31b MOV EDX,dword ptr [0x00c08594]
0055e321 FLD dword ptr [0x00c08624]
0055e327 FMUL dword ptr [EDX]
0055e329 FSUBR dword ptr [EAX]
0055e32b FSTP dword ptr [ESI]
0055e32d MOV EDX,dword ptr [0x00c08598]
0055e333 FLD dword ptr [0x00c08624]
0055e339 FMUL dword ptr [EDX]
0055e33b FSUBR dword ptr [EAX + 0x4]
0055e33e FSTP dword ptr [ESI + 0x4]
0055e341 MOV EDX,dword ptr [0x00c0859c]
0055e347 FLD dword ptr [0x00c08624]
0055e34d FMUL dword ptr [EDX]
0055e34f FSUBR dword ptr [EAX + 0x8]
0055e352 FSTP dword ptr [ESI + 0x8]
0055e355 MOV EDX,dword ptr [0x00c082a0]
0055e35b MOV EDX,dword ptr [EDX]
0055e35d MOV dword ptr [EDI + 0xbf4418],EDX
0055e363 MOV EDX,dword ptr [0x00c082a4]
0055e369 MOV EDX,dword ptr [EDX]
0055e36b MOV dword ptr [EDI + 0xbf441c],EDX
0055e371 MOV EDX,dword ptr [0x00c082a8]
0055e377 MOV EDX,dword ptr [EDX]
0055e379 MOV dword ptr [EDI + 0xbf4420],EDX
0055e37f MOV EDX,dword ptr [EAX]
0055e381 MOV dword ptr [EDI + 0xbf440c],EDX
0055e387 MOV EDX,dword ptr [EAX + 0x4]
0055e38a MOV dword ptr [EDI + 0xbf4410],EDX
0055e390 MOV EAX,dword ptr [EAX + 0x8]
0055e393 MOV dword ptr [EDI + 0xbf4414],EAX
0055e399 MOV EDX,dword ptr [ECX]
0055e39b MOV dword ptr [ESP + 0x20],EDX
0055e39f MOV EAX,dword ptr [ESP + 0x20]
0055e3a3 AND EAX,0x7fffffff
0055e3a8 MOV dword ptr [ESP + 0x14],EAX
0055e3ac MOV EAX,dword ptr [ECX + 0x4]
0055e3af MOV dword ptr [ESP + 0x20],EAX
0055e3b3 MOV EAX,dword ptr [ESP + 0x20]
0055e3b7 AND EAX,0x7fffffff
0055e3bc MOV dword ptr [ESP + 0x24],EAX
0055e3c0 FLD dword ptr [ESP + 0x14]
0055e3c4 FMUL dword ptr [0x006ea50c]   ; [006ea50c] f32=0.25 i32=1048576000 f64=9.270366941701625E-18
0055e3ca POP EDI
0055e3cb POP ESI
0055e3cc POP EBX
0055e3cd FADD dword ptr [ESP + 0x18]
0055e3d1 RET
