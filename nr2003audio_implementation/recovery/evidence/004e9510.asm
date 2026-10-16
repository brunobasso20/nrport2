004e9510 MOV EAX,dword ptr [ESP + 0x10]
004e9514 MOV EDX,dword ptr [ESP + 0x8]
004e9518 FLD dword ptr [ECX + 0xc]
004e951b FSUB dword ptr [EAX + EDX*0x8 + 0x4]
004e951f FMUL dword ptr [ESP + 0xc]
004e9523 FSUBR dword ptr [EAX + EDX*0x8 + 0x4]
004e9527 MOV EAX,dword ptr [ESP + 0x4]
004e952b FSTP dword ptr [EAX + 0x4]
004e952e RET 0x14
