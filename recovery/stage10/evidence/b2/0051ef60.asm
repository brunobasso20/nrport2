0051ef60 MOV ECX,dword ptr [ESP + 0x4]
0051ef64 FLD dword ptr [ECX + 0x18b6]
0051ef6a FCOMP dword ptr [ECX + 0x1af2]
0051ef70 FNSTSW AX
0051ef72 AND EAX,0x4100
0051ef77 JNZ 0x0051ef87
0051ef79 MOV EAX,dword ptr [ECX + 0x1ad6]
0051ef7f MOV dword ptr [ECX + 0x18be],EAX
0051ef85 JMP 0x0051efb3
0051ef87 FLD dword ptr [ECX + 0x1af2]
0051ef8d FSUB dword ptr [ECX + 0x18b6]
0051ef93 FMUL dword ptr [ECX + 0x18c2]
0051ef99 FLD dword ptr [ECX + 0x18c6]
0051ef9f FMUL dword ptr [ECX + 0x18ba]
0051efa5 FADDP
0051efa7 FADD dword ptr [ECX + 0x1ad6]
0051efad FSTP dword ptr [ECX + 0x18be]
0051efb3 FLD dword ptr [ECX + 0x18be]
0051efb9 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0051efbf FADD dword ptr [ECX + 0x18ba]
0051efc5 FADD dword ptr [ECX + 0x18b6]
0051efcb FSTP dword ptr [ECX + 0x18b6]
0051efd1 FLD dword ptr [ECX + 0x18be]
0051efd7 FADD dword ptr [ECX + 0x18ba]
0051efdd FSTP dword ptr [ECX + 0x18ba]
0051efe3 RET
