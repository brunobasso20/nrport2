00565c30 PUSH ESI
00565c31 MOV ESI,dword ptr [ESP + 0x8]
00565c35 LEA EAX,[ESI + 0x58e]
00565c3b PUSH EAX
00565c3c CALL 0x004284f0
00565c41 MOV dword ptr [ESI + 0x1594],0x3eeb851f
00565c4b MOV dword ptr [ESI + 0x159c],0x3ee147ae
00565c55 FLD dword ptr [EAX + 0x1b4]
00565c5b FCOMP dword ptr [0x006ea454]   ; [006ea454] f32=0.0 i32=0 f64=-2048.0
00565c61 ADD ESP,0x4
00565c64 MOV dword ptr [ESI + 0x15a8],0x0
00565c6e FNSTSW AX
00565c70 TEST AH,0x5
00565c73 JP 0x00565c9c
00565c75 MOV EAX,0xbfa66666
00565c7a MOV dword ptr [ESI + 0x1598],0xbe4ccccd
00565c84 MOV dword ptr [ESI + 0x15a4],EAX
00565c8a MOV dword ptr [ESI + 0x15a0],0x3dcccccd
00565c94 MOV dword ptr [ESI + 0x15a4],EAX
00565c9a POP ESI
00565c9b RET
00565c9c MOV dword ptr [ESI + 0x1598],0x3e4ccccd
00565ca6 MOV dword ptr [ESI + 0x15a0],0xbdcccccd
00565cb0 MOV dword ptr [ESI + 0x15a4],0xbfa66666
00565cba POP ESI
00565cbb RET
