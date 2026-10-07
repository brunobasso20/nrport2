0057d450 MOV EAX,dword ptr [ESP + 0x8]
0057d454 MOV EDX,dword ptr [ESP + 0x4]
0057d458 MOV ECX,dword ptr [EAX]
0057d45a MOV EAX,dword ptr [EDX]
0057d45c FLD float ptr [ECX]
0057d45e FSIN
0057d460 FSTP float ptr [EAX]
0057d462 RET
