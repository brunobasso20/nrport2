0055e180 SUB ESP,0x8
0055e183 MOV ECX,dword ptr [ESP + 0xc]
0055e187 FLD float ptr [ECX + 0x4]
0055e18a MOV EAX,dword ptr [ECX]
0055e18c FSTP float ptr [ESP + 0xc]
0055e190 MOV dword ptr [ESP],EAX
0055e194 MOV EAX,dword ptr [ESP + 0xc]
0055e198 AND EAX,0x7fffffff
0055e19d MOV dword ptr [ESP + 0x4],EAX
0055e1a1 FLD float ptr [ECX + 0x8]
0055e1a4 FMUL float ptr [0x006ea4cc]
0055e1aa PUSH ECX
0055e1ab MOV ECX,dword ptr [ESP + 0x4]
0055e1af MOV EDX,dword ptr [0x00c085dc]
0055e1b5 MOV EAX,[0x00c08250]
0055e1ba FADD float ptr [0x00c081ec]
0055e1c0 FSTP float ptr [ESP]
0055e1c3 FLD float ptr [ESP + 0x8]
0055e1c7 FADD float ptr [0x006ea4a4]
0055e1cd PUSH ECX
0055e1ce PUSH ECX
0055e1cf FSTP float ptr [ESP]
0055e1d2 PUSH EDX
0055e1d3 PUSH EAX
0055e1d4 CALL 0x00554e70
0055e1d9 ADD ESP,0x1c
0055e1dc RET
