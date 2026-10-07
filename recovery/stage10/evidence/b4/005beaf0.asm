005beaf0 FILD dword ptr [ESP + 0x8]
005beaf4 MOV EAX,dword ptr [ESP + 0x4]
005beaf8 FMUL dword ptr [EAX + 0x8]
005beafb FPTAN
005beafd FSTP ST0
005beaff FMUL dword ptr [EAX + 0xc]
005beb02 RET
