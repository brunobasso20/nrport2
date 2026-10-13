00511c9a PUSH EBP
00511c9b MOV EBP,ESP
00511c9d AND ESP,0xfffffff8
00511ca0 SUB ESP,0x8c
00511ca6 PUSH EBX
00511ca7 PUSH ESI
00511ca8 MOV ESI,dword ptr [EBP + 0xc]
00511cab PUSH EDI
00511cac MOV EAX,dword ptr [ESI + 0x60]
00511caf TEST EAX,EAX
00511cb1 JGE 0x00511cb9
00511cb3 MOV EAX,dword ptr [ESI + 0x5c]
00511cb6 MOV dword ptr [ESI + 0x60],EAX
00511cb9 MOV EAX,dword ptr [ESI + 0x5c]
00511cbc MOV EBX,dword ptr [EBP + 0x8]
00511cbf MOV EDX,dword ptr [EBP + 0x10]
00511cc2 MOV dword ptr [ESI + 0x64],EAX
00511cc5 INC EAX
00511cc6 MOV dword ptr [ESI + 0x5c],EAX
00511cc9 MOV ECX,dword ptr [EBX + 0x56]
00511ccc MOV EDI,dword ptr [ECX + EDX*0x4]
00511ccf MOV ECX,EAX
00511cd1 SHL ECX,0x5
00511cd4 MOV EDX,dword ptr [EDI + 0x51]
00511cd7 ADD ECX,EAX
00511cd9 PUSH EDX
00511cda LEA ESI,[ESI + ECX*0x8 + 0x7d0]
00511ce1 CALL 0x00579d60
00511ce6 MOV dword ptr [ESI],EAX
00511ce8 MOV EAX,dword ptr [EDI + 0x55]
00511ceb ADD ESP,0x4
00511cee LEA ECX,[ESI + 0x6c]
00511cf1 MOV dword ptr [ESI + 0x4],EAX
00511cf4 MOV AL,byte ptr [EDI + 0x14]
00511cf7 FLD dword ptr [EDI + 0x10]
00511cfa FADD qword ptr [EDI + 0x3d]
00511cfd LEA EDX,[ESI + 0x58]
00511d00 PUSH ECX
00511d01 PUSH EDX
00511d02 PUSH EAX
00511d03 SUB ESP,0x10
00511d06 FSTP qword ptr [ESP + 0x8]
00511d0a FLD dword ptr [EDI + 0xc]
00511d0d FADD qword ptr [EDI + 0x35]
00511d10 FSTP qword ptr [ESP]
00511d13 PUSH EBX
00511d14 CALL 0x005f65a0
00511d19 MOV AL,byte ptr [EDI + 0x14]
00511d1c ADD ESP,0x20
00511d1f FLD dword ptr [EDI + 0x10]
00511d22 FSUB qword ptr [EDI + 0x3d]
00511d25 LEA ECX,[ESI + 0xa8]
00511d2b LEA EDX,[ESI + 0x94]
00511d31 PUSH ECX
00511d32 PUSH EDX
00511d33 PUSH EAX
00511d34 SUB ESP,0x10
00511d37 FSTP qword ptr [ESP + 0x8]
00511d3b FLD dword ptr [EDI + 0xc]
00511d3e FSUB qword ptr [EDI + 0x35]
00511d41 FSTP qword ptr [ESP]
00511d44 PUSH EBX
00511d45 CALL 0x005f65a0
00511d4a MOV ECX,dword ptr [EDI + 0xc]
00511d4d ADD ESP,0x20
00511d50 MOV dword ptr [ESI + 0x50],ECX
00511d53 MOV EDX,dword ptr [EDI + 0x10]
00511d56 MOV dword ptr [ESI + 0x54],EDX
00511d59 FLD qword ptr [EDI + 0x35]
00511d5c FSTP dword ptr [ESI + 0xf8]
00511d62 FLD qword ptr [EDI + 0x3d]
00511d65 FSUB qword ptr [EDI + 0x35]
00511d68 FSTP dword ptr [ESI + 0xfc]
00511d6e MOV ECX,dword ptr [EBX + 0x42]
00511d71 SUB ECX,0x2
00511d74 JS 0x00511d93
00511d76 MOV EAX,dword ptr [EBX + 0x4e]
00511d79 LEA EDX,[EAX + ECX*0x4]
00511d7c MOV EAX,dword ptr [EDX]
00511d7e FLD dword ptr [EDI + 0xc]
00511d81 FCOMP dword ptr [EAX + 0xc]
00511d84 FNSTSW AX
00511d86 TEST AH,0x5
00511d89 JP 0x00511d93
00511d8b DEC ECX
00511d8c SUB EDX,0x4
00511d8f TEST ECX,ECX
00511d91 JGE 0x00511d7c
00511d93 MOV EAX,dword ptr [EBX + 0x4e]
00511d96 MOV EDX,dword ptr [EAX + ECX*0x4]
00511d99 MOV EAX,dword ptr [EAX + ECX*0x4 + 0x4]
00511d9d MOV dword ptr [ESP + 0x10],EAX
00511da1 MOV EAX,dword ptr [EBP + 0xc]
00511da4 FLD qword ptr [EDX + 0x15]
00511da7 LEA ECX,[ECX + ECX*0x8]
00511daa LEA EAX,[EAX + ECX*0x8 + 0xb0]
00511db1 MOV ECX,dword ptr [ESP + 0x10]
00511db5 FSUB qword ptr [ECX + 0x15]
00511db8 FLD dword ptr [ECX + 0xc]
00511dbb FSUB dword ptr [EDX + 0xc]
00511dbe FPATAN
00511dc0 FSTP qword ptr [ESP + 0x40]
00511dc4 FLD qword ptr [EDX + 0x25]
00511dc7 FSUB qword ptr [ECX + 0x25]
00511dca FLD dword ptr [ECX + 0x10]
00511dcd FSUB dword ptr [EDX + 0x10]
00511dd0 MOV ECX,dword ptr [EBP + 0x10]
00511dd3 TEST ECX,ECX
00511dd5 FPATAN
00511dd7 FSTP qword ptr [ESP + 0x48]
00511ddb JNZ 0x00511df3
00511ddd MOV dword ptr [ESI + 0x100],0x49742400
00511de7 MOV dword ptr [ESI + 0x104],0x0
00511df1 JMP 0x00511e15
00511df3 FLD qword ptr [ESP + 0x40]
00511df7 FCOS
00511df9 FMUL qword ptr [EDI + 0x15]
00511dfc FST dword ptr [ESI + 0x100]
00511e02 FLD qword ptr [ESP + 0x48]
00511e06 FCOS
00511e08 FMUL qword ptr [EDI + 0x1d]
00511e0b FSUB ST0,ST1
00511e0d FSTP dword ptr [ESI + 0x104]
00511e13 FSTP ST0
00511e15 FLD dword ptr [ESI + 0xfc]
00511e1b FMUL dword ptr [0x006ea454]
00511e21 FADD dword ptr [ESI + 0xf8]
00511e27 FLD dword ptr [EAX + 0x4]
00511e2a FMUL dword ptr [0x006ea454]
00511e30 FADD dword ptr [EAX]
00511e32 FLD dword ptr [EAX + 0xc]
00511e35 FMUL dword ptr [0x006ea454]
00511e3b FADD dword ptr [EAX + 0x8]
00511e3e FLD dword ptr [ESI + 0x50]
00511e41 FSUB ST0,ST3
00511e43 FSUB ST0,ST2
00511e45 FDIV ST0,ST1
00511e47 FSTP dword ptr [ESP + 0x1c]
00511e4b FXCH ST2
00511e4d FADD dword ptr [ESI + 0x50]
00511e50 FSUB ST0,ST1
00511e52 FDIV ST0,ST2
00511e54 FSTP dword ptr [ESP + 0x18]
00511e58 FSTP ST1
00511e5a FSTP ST0
00511e5c FLD dword ptr [ESI + 0xfc]
00511e62 FADD dword ptr [ESI + 0xf8]
00511e68 FLD dword ptr [EAX]
00511e6a FADD dword ptr [EAX + 0x4]
00511e6d FLD dword ptr [EAX + 0xc]
00511e70 FADD dword ptr [EAX + 0x8]
00511e73 FLD dword ptr [ESI + 0x54]
00511e76 FSUB ST0,ST3
00511e78 FSUB ST0,ST2
00511e7a FDIV ST0,ST1
00511e7c FSTP dword ptr [ESP + 0x14]
00511e80 FXCH ST2
00511e82 FADD dword ptr [ESI + 0x54]
00511e85 FSUB ST0,ST1
00511e87 FDIV ST0,ST2
00511e89 FSTP dword ptr [ESP + 0x10]
00511e8d FSTP ST1
00511e8f FSTP ST0
00511e91 FLD dword ptr [ESP + 0x1c]
00511e95 FMUL dword ptr [EAX + 0x30]
00511e98 FADD dword ptr [EAX + 0x18]
00511e9b FLD dword ptr [ESP + 0x1c]
00511e9f FMUL dword ptr [EAX + 0x34]
00511ea2 FADD dword ptr [EAX + 0x1c]
00511ea5 FSTP dword ptr [ESP + 0x54]
00511ea9 FLD dword ptr [ESP + 0x1c]
00511ead FMUL dword ptr [EAX + 0x38]
00511eb0 FADD dword ptr [EAX + 0x20]
00511eb3 FSTP dword ptr [ESP + 0x58]
00511eb7 FLD dword ptr [ESP + 0x1c]
00511ebb FMUL dword ptr [EAX + 0x3c]
00511ebe FADD dword ptr [EAX + 0x24]
00511ec1 FLD dword ptr [ESP + 0x18]
00511ec5 FMUL dword ptr [EAX + 0x30]
00511ec8 FADD dword ptr [EAX + 0x18]
00511ecb FSTP dword ptr [ESP + 0x20]
00511ecf FLD dword ptr [ESP + 0x18]
00511ed3 FMUL dword ptr [EAX + 0x34]
00511ed6 FADD dword ptr [EAX + 0x1c]
00511ed9 FSTP dword ptr [ESP + 0x24]
00511edd FLD dword ptr [ESP + 0x18]
00511ee1 FMUL dword ptr [EAX + 0x38]
00511ee4 FADD dword ptr [EAX + 0x20]
00511ee7 FSTP dword ptr [ESP + 0x28]
00511eeb FLD dword ptr [ESP + 0x18]
00511eef FMUL dword ptr [EAX + 0x3c]
00511ef2 FADD dword ptr [EAX + 0x24]
00511ef5 FLD dword ptr [ESP + 0x14]
00511ef9 FMUL dword ptr [EAX + 0x30]
00511efc FADD dword ptr [EAX + 0x18]
00511eff FLD dword ptr [ESP + 0x14]
00511f03 FMUL dword ptr [EAX + 0x34]
00511f06 FADD dword ptr [EAX + 0x1c]
00511f09 FLD dword ptr [ESP + 0x14]
00511f0d FMUL dword ptr [EAX + 0x38]
00511f10 FADD dword ptr [EAX + 0x20]
00511f13 FSTP dword ptr [ESP + 0x68]
00511f17 FLD dword ptr [ESP + 0x14]
00511f1b FMUL dword ptr [EAX + 0x3c]
00511f1e LEA ECX,[ESP + 0x84]
00511f25 LEA EDX,[ESP + 0x70]
00511f29 PUSH ECX
00511f2a PUSH EDX
00511f2b FADD dword ptr [EAX + 0x24]
00511f2e PUSH 0x0
00511f30 SUB ESP,0x10
00511f33 FSTP dword ptr [ESP + 0x88]
00511f3a FLD dword ptr [ESP + 0x2c]
00511f3e FMUL dword ptr [EAX + 0x30]
00511f41 FADD dword ptr [EAX + 0x18]
00511f44 FSTP dword ptr [ESP + 0x4c]
00511f48 FLD dword ptr [ESP + 0x2c]
00511f4c FMUL dword ptr [EAX + 0x34]
00511f4f FADD dword ptr [EAX + 0x1c]
00511f52 FSTP dword ptr [ESP + 0x50]
00511f56 FLD dword ptr [ESP + 0x2c]
00511f5a FMUL dword ptr [EAX + 0x38]
00511f5d FADD dword ptr [EAX + 0x20]
00511f60 FSTP dword ptr [ESP + 0x54]
00511f64 FLD dword ptr [ESP + 0x2c]
00511f68 FMUL dword ptr [EAX + 0x3c]
00511f6b FADD dword ptr [EAX + 0x24]
00511f6e FSTP dword ptr [ESP + 0x58]
00511f72 FXCH
00511f74 FSUB ST0,ST4
00511f76 FSTP dword ptr [ESI + 0xbc]
00511f7c FADD ST0,ST3
00511f7e FSUB dword ptr [ESP + 0x70]
00511f82 FSTP dword ptr [ESI + 0xc0]
00511f88 FLD dword ptr [ESP + 0x84]
00511f8f FADD dword ptr [ESP + 0x70]
00511f93 FSUB dword ptr [ESP + 0x74]
00511f97 FSTP dword ptr [ESI + 0xc4]
00511f9d FLD dword ptr [ESP + 0x88]
00511fa4 FADD dword ptr [ESP + 0x74]
00511fa8 FSUB ST0,ST2
00511faa FSTP dword ptr [ESI + 0xc8]
00511fb0 FXCH
00511fb2 FSTP dword ptr [ESI + 0xcc]
00511fb8 FLD dword ptr [ESP + 0x4c]
00511fbc FSUB dword ptr [ESP + 0x3c]
00511fc0 FSTP dword ptr [ESI + 0x80]
00511fc6 FLD dword ptr [ESP + 0x50]
00511fca FADD dword ptr [ESP + 0x3c]
00511fce FSUB dword ptr [ESP + 0x40]
00511fd2 FSTP dword ptr [ESI + 0x84]
00511fd8 FLD dword ptr [ESP + 0x54]
00511fdc FADD dword ptr [ESP + 0x40]
00511fe0 FSUB dword ptr [ESP + 0x44]
00511fe4 FSTP dword ptr [ESI + 0x88]
00511fea FLD dword ptr [ESP + 0x58]
00511fee FADD dword ptr [ESP + 0x44]
00511ff2 FSUB ST0,ST1
00511ff4 FSTP dword ptr [ESI + 0x8c]
00511ffa FSTP dword ptr [ESI + 0x90]
00512000 FSTP ST0
00512002 FLD dword ptr [EDI + 0x10]
00512005 FSTP qword ptr [ESP + 0x8]
00512009 FLD dword ptr [EDI + 0xc]
0051200c FSTP qword ptr [ESP]
0051200f PUSH EBX
00512010 CALL 0x005f65a0
00512015 FLD qword ptr [ESP + 0x68]
00512019 FSIN
0051201b ADD ESP,0x20
0051201e LEA EAX,[ESI + 0xe4]
00512024 ADD ESI,0xd0
0051202a MOV dword ptr [ESP + 0x10],EAX
0051202e PUSH EAX
0051202f PUSH ESI
00512030 PUSH 0x0
00512032 SUB ESP,0x10
00512035 FMUL qword ptr [EDI + 0x1d]
00512038 FADD dword ptr [EDI + 0x10]
0051203b FSTP qword ptr [ESP + 0x8]
0051203f FLD qword ptr [ESP + 0x5c]
00512043 FSIN
00512045 FMUL qword ptr [EDI + 0x15]
00512048 FADD dword ptr [EDI + 0xc]
0051204b FSTP qword ptr [ESP]
0051204e PUSH EBX
0051204f CALL 0x005f65a0
00512054 MOV EAX,dword ptr [ESP + 0x30]
00512058 ADD ESP,0x20
0051205b XOR ECX,ECX
0051205d FLD dword ptr [EAX + -0x14]
00512060 FSUB dword ptr [ESP + ECX*0x1 + 0x70]
00512064 ADD ECX,0x4
00512067 ADD EAX,0x4
0051206a CMP ECX,0x14
0051206d FSTP dword ptr [EAX + -0x18]
00512070 FLD dword ptr [EAX + -0x4]
00512073 FSUB dword ptr [ESP + ECX*0x1 + 0x80]
0051207a FSTP dword ptr [EAX + -0x4]
0051207d JL 0x0051205d
0051207f POP EDI
00512080 POP ESI
00512081 POP EBX
00512082 MOV ESP,EBP
00512084 POP EBP
00512085 RET
