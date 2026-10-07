0057d4b0 MOV EAX,dword ptr [ESP + 0x8]
0057d4b4 MOV ECX,dword ptr [EAX]
0057d4b6 MOV EAX,dword ptr [ESP + 0x4]
0057d4ba MOV EDX,dword ptr [EAX]
0057d4bc MOV ECX,dword ptr [ECX]
0057d4be MOV dword ptr [EDX],ECX
0057d4c0 MOV ECX,dword ptr [EAX]
0057d4c2 FLD float ptr [ECX]
0057d4c4 FCOMP float ptr [0x006ea454]
0057d4ca FNSTSW AX
0057d4cc AND EAX,0x4100
0057d4d1 JNZ 0x0057d4d9
0057d4d3 MOV dword ptr [ECX],0x0
0057d4d9 RET
