005bdc60 PUSH ESI
005bdc61 MOV ESI,dword ptr [ESP + 0x8]
005bdc65 LEA EAX,[ESP + 0x8]
005bdc69 PUSH ESI
005bdc6a PUSH EAX
005bdc6b CALL 0x005bd610
005bdc70 ADD ESP,0x8
005bdc73 TEST EAX,EAX
005bdc75 JZ 0x005bdc7d
005bdc77 MOV EAX,dword ptr [ESP + 0x8]
005bdc7b POP ESI
005bdc7c RET
005bdc7d MOV ECX,dword ptr [ESI]
005bdc7f PUSH ESI
005bdc80 CALL 0x005bd200
005bdc85 ADD ESP,0x4
005bdc88 TEST CL,0x2
005bdc8b JZ 0x005bdcdb
005bdc8d TEST EAX,EAX
005bdc8f JZ 0x005bdccd
005bdc91 SAR ECX,0x2
005bdc94 PUSH ECX
005bdc95 CALL 0x005bdd00
005bdc9a ADD ESP,0x4
005bdc9d TEST EAX,EAX
005bdc9f MOV EAX,dword ptr [ESI]
005bdca1 JZ 0x005bdca8
005bdca3 SAR EAX,0x2
005bdca6 POP ESI
005bdca7 RET
005bdca8 SAR EAX,0x2
005bdcab MOV ECX,dword ptr [EAX*0x4 + 0xec02c8]
005bdcb2 TEST ECX,ECX
005bdcb4 JNZ 0x005bdcfc
005bdcb6 CMP dword ptr [EAX*0x4 + 0xed7840],ESI
005bdcbd JZ 0x005bdcfc
005bdcbf MOV ECX,dword ptr [ESP + 0x8]
005bdcc3 POP ESI
005bdcc4 MOV dword ptr [ESP + 0x4],ECX
005bdcc8 JMP 0x005bd5a0
005bdccd MOV EDX,dword ptr [ESP + 0x8]
005bdcd1 POP ESI
005bdcd2 MOV dword ptr [ESP + 0x4],EDX
005bdcd6 JMP 0x005bd5a0
005bdcdb TEST EAX,EAX
005bdcdd JZ 0x005bdce6
005bdcdf MOV EAX,ECX
005bdce1 POP ESI
005bdce2 SAR EAX,0x2
005bdce5 RET
005bdce6 CMP dword ptr [ESI + 0xc],0x1
005bdcea JLE 0x005bdcfa
005bdcec MOV EAX,dword ptr [ESP + 0x8]
005bdcf0 POP ESI
005bdcf1 MOV dword ptr [ESP + 0x4],EAX
005bdcf5 JMP 0x005bd5a0
005bdcfa XOR EAX,EAX
005bdcfc POP ESI
005bdcfd RET
