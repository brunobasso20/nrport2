005f6f20 SUB ESP,0x10
005f6f23 FLD dword ptr [ESP + 0x18]
005f6f27 FSINCOS
005f6f29 FSTP dword ptr [ESP + 0x4]
005f6f2d FSTP dword ptr [ESP]
005f6f31 FLD dword ptr [ESP + 0x1c]
005f6f35 FSINCOS
005f6f37 FSTP dword ptr [ESP + 0x8]
005f6f3b FSTP dword ptr [ESP + 0xc]
005f6f3f FLD dword ptr [ESP + 0x20]
005f6f43 FSINCOS
005f6f45 FSTP dword ptr [ESP + 0x1c]
005f6f49 FSTP dword ptr [ESP + 0x18]
005f6f4d FLD dword ptr [ESP + 0x8]
005f6f51 FMUL dword ptr [ESP + 0x4]
005f6f55 MOV EAX,dword ptr [ESP + 0x14]
005f6f59 FSTP dword ptr [EAX]
005f6f5b FLD dword ptr [ESP + 0x18]
005f6f5f FMUL dword ptr [ESP + 0xc]
005f6f63 FLD dword ptr [ESP + 0x4]
005f6f67 FMUL ST1
005f6f69 FLD dword ptr [ESP + 0x1c]
005f6f6d FMUL dword ptr [ESP]
005f6f71 FSUBP
005f6f73 FSTP dword ptr [EAX + 0x4]
005f6f76 FLD dword ptr [ESP + 0x1c]
005f6f7a FMUL dword ptr [ESP + 0xc]
005f6f7e FLD dword ptr [ESP + 0x4]
005f6f82 FMUL ST1
005f6f84 FLD dword ptr [ESP + 0x18]
005f6f88 FMUL dword ptr [ESP]
005f6f8c FADDP
005f6f8e FSTP dword ptr [EAX + 0x8]
005f6f91 FLD dword ptr [ESP + 0x8]
005f6f95 FMUL dword ptr [ESP]
005f6f99 FSTP dword ptr [EAX + 0xc]
005f6f9c FXCH
005f6f9e FMUL dword ptr [ESP]
005f6fa2 FLD dword ptr [ESP + 0x1c]
005f6fa6 FMUL dword ptr [ESP + 0x4]
005f6faa FADDP
005f6fac FSTP dword ptr [EAX + 0x10]
005f6faf FMUL dword ptr [ESP]
005f6fb3 FLD dword ptr [ESP + 0x18]
005f6fb7 FMUL dword ptr [ESP + 0x4]
005f6fbb FSUBP
005f6fbd FSTP dword ptr [EAX + 0x14]
005f6fc0 FLD dword ptr [ESP + 0xc]
005f6fc4 FCHS
005f6fc6 FSTP dword ptr [EAX + 0x18]
005f6fc9 FLD dword ptr [ESP + 0x18]
005f6fcd FMUL dword ptr [ESP + 0x8]
005f6fd1 FSTP dword ptr [EAX + 0x1c]
005f6fd4 FLD dword ptr [ESP + 0x1c]
005f6fd8 FMUL dword ptr [ESP + 0x8]
005f6fdc FSTP dword ptr [EAX + 0x20]
005f6fdf ADD ESP,0x10
005f6fe2 RET
