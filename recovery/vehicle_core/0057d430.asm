0057d430 MOV EAX,dword ptr [ESP + 0x8]
0057d434 MOV EDX,dword ptr [ESP + 0x4]
0057d438 MOV ECX,dword ptr [EAX]
0057d43a MOV EAX,dword ptr [EDX]
0057d43c FLD float ptr [ECX]
0057d43e FSQRT
0057d440 FSTP float ptr [EAX]
0057d442 RET
