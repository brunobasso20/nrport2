0057d3d0 MOV EAX,dword ptr [ESP + 0x8]
0057d3d4 MOV EDX,dword ptr [ESP + 0x4]
0057d3d8 MOV ECX,dword ptr [EAX]
0057d3da MOV EAX,dword ptr [EDX]
0057d3dc FLD float ptr [ECX]
0057d3de FCHS
0057d3e0 FSTP float ptr [EAX]
0057d3e2 RET
