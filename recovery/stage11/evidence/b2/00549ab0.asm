00549ab0 SUB ESP,0x24
00549ab3 PUSH ESI
00549ab4 MOV ESI,dword ptr [ESP + 0x2c]
00549ab8 PUSH EDI
00549ab9 MOV EDI,dword ptr [ESI]
00549abb PUSH EDI
00549abc CALL 0x00562f70
00549ac1 MOV ECX,dword ptr [EAX + 0x4]
00549ac4 ADD ESP,0x4
00549ac7 TEST ECX,ECX
00549ac9 JZ 0x00549bcf
00549acf MOV EAX,dword ptr [ESI + 0x1c]
00549ad2 LEA ECX,[EAX + 0x34]
00549ad5 MOV EDX,dword ptr [EAX + 0x34]
00549ad8 MOV dword ptr [ESP + 0x14],EDX
00549adc MOV EDX,dword ptr [ECX + 0x4]
00549adf MOV dword ptr [ESP + 0x18],EDX
00549ae3 LEA EDX,[EAX + 0x40]
00549ae6 MOV ECX,dword ptr [ECX + 0x8]
00549ae9 MOV EAX,dword ptr [EAX]
00549aeb MOV dword ptr [ESP + 0x1c],ECX
00549aef MOV ECX,dword ptr [EDX]
00549af1 MOV dword ptr [ESP + 0x8],ECX
00549af5 MOV ECX,dword ptr [EDX + 0x4]
00549af8 MOV dword ptr [ESP + 0xc],ECX
00549afc MOV ECX,dword ptr [EAX + 0x4]
00549aff MOV EDX,dword ptr [EDX + 0x8]
00549b02 MOV EAX,dword ptr [ECX + 0x1a4]
00549b08 MOV dword ptr [ESP + 0x10],EDX
00549b0c CMP EDI,EAX
00549b0e JZ 0x00549b4c
00549b10 FLD dword ptr [ESP + 0x14]
00549b14 FCHS
00549b16 FSTP dword ptr [ESP + 0x14]
00549b1a FLD dword ptr [ESP + 0x18]
00549b1e FCHS
00549b20 FSTP dword ptr [ESP + 0x18]
00549b24 FLD dword ptr [ESP + 0x1c]
00549b28 FCHS
00549b2a FSTP dword ptr [ESP + 0x1c]
00549b2e FLD dword ptr [ESP + 0x8]
00549b32 FCHS
00549b34 FSTP dword ptr [ESP + 0x8]
00549b38 FLD dword ptr [ESP + 0xc]
00549b3c FCHS
00549b3e FSTP dword ptr [ESP + 0xc]
00549b42 FLD dword ptr [ESP + 0x10]
00549b46 FCHS
00549b48 FSTP dword ptr [ESP + 0x10]
00549b4c CMP dword ptr [ESI + 0x8],0x40000000
00549b53 JNZ 0x00549bcf
00549b55 FLD dword ptr [ESP + 0x10]
00549b59 FMUL dword ptr [ESP + 0x1c]
00549b5d FLD dword ptr [ESP + 0xc]
00549b61 FMUL dword ptr [ESP + 0x18]
00549b65 MOV EDX,dword ptr [ESI + 0x18]
00549b68 MOV EAX,dword ptr [ESI + 0x4]
00549b6b PUSH EDX
00549b6c PUSH EAX
00549b6d FADDP
00549b6f FLD dword ptr [ESP + 0x10]
00549b73 FMUL dword ptr [ESP + 0x1c]
00549b77 LEA ECX,[ESP + 0x28]
00549b7b PUSH EDI
00549b7c ADD ESI,0xc
00549b7f PUSH ECX
00549b80 FADDP
00549b82 PUSH ESI
00549b83 FMUL dword ptr [0x006f5858]   ; [006f5858] f32=1.70000004768 i32=1071225242 f64=1.44960984061e-56
00549b89 FLD dword ptr [ESP + 0x1c]
00549b8d FMUL ST1
00549b8f FLD ST1
00549b91 FMUL dword ptr [ESP + 0x20]
00549b95 FSTP dword ptr [ESP + 0x38]
00549b99 FXCH
00549b9b FMUL dword ptr [ESP + 0x24]
00549b9f FSTP dword ptr [ESP + 0x3c]
00549ba3 FLD dword ptr [ESP + 0x28]
00549ba7 FSUB ST0,ST1
00549ba9 FSTP dword ptr [ESP + 0x34]
00549bad FSTP ST0
00549baf FLD dword ptr [ESP + 0x2c]
00549bb3 FSUB dword ptr [ESP + 0x38]
00549bb7 FSTP dword ptr [ESP + 0x38]
00549bbb FLD dword ptr [ESP + 0x30]
00549bbf FSUB dword ptr [ESP + 0x3c]
00549bc3 FSTP dword ptr [ESP + 0x3c]
00549bc7 CALL 0x00585e30
00549bcc ADD ESP,0x14
00549bcf POP EDI
00549bd0 POP ESI
00549bd1 ADD ESP,0x24
00549bd4 RET
