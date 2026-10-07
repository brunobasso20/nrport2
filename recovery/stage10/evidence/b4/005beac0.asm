005beac0 FLD dword ptr [ESP + 0x8]
005beac4 PUSH ESI
005beac5 MOV ESI,dword ptr [ESP + 0x8]
005beac9 FMUL dword ptr [ESI]
005beacb FLD1
005beacd FPATAN
005beacf FMUL dword ptr [ESI + 0x4]
005bead2 CALL 0x006c5018
005bead7 MOV ECX,dword ptr [ESI + 0x10]
005beada CMP EAX,ECX
005beadc JGE 0x005beae2
005beade MOV EAX,ECX
005beae0 POP ESI
005beae1 RET
005beae2 MOV ESI,dword ptr [ESI + 0x14]
005beae5 CMP EAX,ESI
005beae7 JLE 0x005beaeb
005beae9 MOV EAX,ESI
005beaeb POP ESI
005beaec RET
