0054a760 PUSH EBX
0054a761 MOV EBX,dword ptr [ESP + 0x8]
0054a765 MOV EAX,EBX
0054a767 PUSH ESI
0054a768 SAR EAX,0x4
0054a76b AND EAX,0x1f
0054a76e PUSH EDI
0054a76f MOV ESI,dword ptr [EAX*0x4 + 0xbf0940]
0054a776 TEST ESI,ESI
0054a778 JZ 0x0054a785
0054a77a CMP dword ptr [ESI],EBX
0054a77c JZ 0x0054a7c4
0054a77e MOV ESI,dword ptr [ESI + 0x58]
0054a781 TEST ESI,ESI
0054a783 JNZ 0x0054a77a
0054a785 MOV ESI,dword ptr [0x00bf09c0]
0054a78b TEST ESI,ESI
0054a78d JZ 0x0054a8be
0054a793 MOV ECX,dword ptr [ESI]
0054a795 MOV EDX,dword ptr [0x00bf39f0]
0054a79b MOV dword ptr [0x00bf09c0],ECX
0054a7a1 MOV dword ptr [ESI + 0x5c],EDX
0054a7a4 MOV ECX,dword ptr [EAX*0x4 + 0xbf0940]
0054a7ab MOV dword ptr [0x00bf39f0],ESI
0054a7b1 MOV dword ptr [ESI + 0x58],ECX
0054a7b4 MOV dword ptr [EAX*0x4 + 0xbf0940],ESI
0054a7bb MOV dword ptr [ESI + 0x4],0xbf800000
0054a7c2 MOV dword ptr [ESI],EBX
0054a7c4 FLD dword ptr [ESP + 0x14]
0054a7c8 FCOMP dword ptr [ESI + 0x4]
0054a7cb FNSTSW AX
0054a7cd AND EAX,0x4100
0054a7d2 JNZ 0x0054a8be
0054a7d8 MOV EAX,dword ptr [ESP + 0x18]
0054a7dc MOV EDX,dword ptr [ESP + 0x14]
0054a7e0 MOV ECX,dword ptr [ESP + 0x1c]
0054a7e4 MOV dword ptr [ESI + 0x8],EAX
0054a7e7 MOV EAX,dword ptr [ESP + 0x20]
0054a7eb MOV dword ptr [ESI + 0x4],EDX
0054a7ee MOV dword ptr [ESI + 0xc],ECX
0054a7f1 LEA EDX,[ESI + 0x10]
0054a7f4 MOV ECX,dword ptr [EAX]
0054a7f6 MOV dword ptr [EDX],ECX
0054a7f8 MOV ECX,dword ptr [EAX + 0x4]
0054a7fb MOV dword ptr [EDX + 0x4],ECX
0054a7fe LEA ECX,[ESI + 0x1c]
0054a801 MOV EAX,dword ptr [EAX + 0x8]
0054a804 MOV dword ptr [EDX + 0x8],EAX
0054a807 MOV EDX,dword ptr [ESP + 0x24]
0054a80b MOV EAX,dword ptr [EDX]
0054a80d MOV dword ptr [ECX],EAX
0054a80f MOV EAX,dword ptr [EDX + 0x4]
0054a812 MOV dword ptr [ECX + 0x4],EAX
0054a815 LEA EAX,[ESI + 0x28]
0054a818 MOV EDX,dword ptr [EDX + 0x8]
0054a81b MOV dword ptr [ECX + 0x8],EDX
0054a81e MOV ECX,dword ptr [ESP + 0x28]
0054a822 MOV EDX,dword ptr [ECX]
0054a824 MOV dword ptr [EAX],EDX
0054a826 MOV EDX,dword ptr [ECX + 0x4]
0054a829 MOV dword ptr [EAX + 0x4],EDX
0054a82c LEA EDX,[ESI + 0x34]
0054a82f MOV ECX,dword ptr [ECX + 0x8]
0054a832 MOV dword ptr [EAX + 0x8],ECX
0054a835 MOV EAX,dword ptr [ESP + 0x2c]
0054a839 MOV ECX,dword ptr [EAX]
0054a83b MOV dword ptr [EDX],ECX
0054a83d MOV ECX,dword ptr [EAX + 0x4]
0054a840 MOV dword ptr [EDX + 0x4],ECX
0054a843 MOV ECX,dword ptr [ESP + 0x3c]
0054a847 MOV EAX,dword ptr [EAX + 0x8]
0054a84a MOV dword ptr [EDX + 0x8],EAX
0054a84d MOV EDI,dword ptr [ECX]
0054a84f LEA EAX,[ESI + 0x40]
0054a852 MOV EDX,EAX
0054a854 PUSH EAX
0054a855 MOV dword ptr [EDX],EDI
0054a857 MOV EDI,dword ptr [ECX + 0x4]
0054a85a MOV dword ptr [EDX + 0x4],EDI
0054a85d MOV ECX,dword ptr [ECX + 0x8]
0054a860 MOV dword ptr [EDX + 0x8],ECX
0054a863 CALL 0x005f6a70
0054a868 FLD dword ptr [ESP + 0x38]
0054a86c FCOMP dword ptr [0x006ea454]   ; [006ea454] f32=0.0 i32=0 f64=-2048.0
0054a872 MOV EDX,dword ptr [ESP + 0x34]
0054a876 ADD ESP,0x4
0054a879 FLD dword ptr [ESP + 0x34]
0054a87d MOV dword ptr [ESI + 0x4c],EDX
0054a880 FNSTSW AX
0054a882 TEST AH,0x5
0054a885 JP 0x0054a889
0054a887 FCHS
0054a889 MOV EDI,dword ptr [ESP + 0x38]
0054a88d PUSH 0x1
0054a88f FSTP dword ptr [ESI + 0x50]
0054a892 MOV dword ptr [ESI + 0x54],EDI
0054a895 MOV EAX,dword ptr [EBX + 0x4]
0054a898 MOV ECX,dword ptr [EAX + 0x1a4]
0054a89e PUSH ECX
0054a89f PUSH ESI
0054a8a0 CALL 0x0054a8d0
0054a8a5 ADD ESP,0xc
0054a8a8 TEST EDI,EDI
0054a8aa JZ 0x0054a8be
0054a8ac MOV EDX,dword ptr [EDI + 0x1a4]
0054a8b2 PUSH 0x0
0054a8b4 PUSH EDX
0054a8b5 PUSH ESI
0054a8b6 CALL 0x0054a8d0
0054a8bb ADD ESP,0xc
0054a8be POP EDI
0054a8bf POP ESI
0054a8c0 POP EBX
0054a8c1 RET
