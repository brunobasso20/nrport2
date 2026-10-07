00516daa FLD dword ptr [ESP + 0x8]
00516dae FSUB dword ptr [ESP + 0x4]
00516db2 FCOM dword ptr [0x006ea454]   ; [006ea454] f32=0.0 i32=0 f64=-2048.0
00516db8 FNSTSW AX
00516dba TEST AH,0x5
00516dbd JP 0x00516dd2
00516dbf FADD dword ptr [0x00bad918]
00516dc5 FCOM dword ptr [0x006ea454]   ; [006ea454] f32=0.0 i32=0 f64=-2048.0
00516dcb FNSTSW AX
00516dcd TEST AH,0x5
00516dd0 JNP 0x00516dbf
00516dd2 RET
