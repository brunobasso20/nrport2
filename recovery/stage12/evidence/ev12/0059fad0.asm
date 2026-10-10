0059fad0 SUB ESP,0x58
0059fad3 PUSH EBX
0059fad4 PUSH EBP
0059fad5 MOV EBP,dword ptr [ESP + 0x68]
0059fad9 PUSH ESI
0059fada MOV ESI,ECX
0059fadc MOV AL,byte ptr [ESP + 0x74]
0059fae0 FLD dword ptr [EBP]
0059fae3 FSUB dword ptr [ESI + 0x4]
0059fae6 FLD dword ptr [EBP + 0x4]
0059fae9 FSUB dword ptr [ESI + 0x8]
0059faec FLD dword ptr [EBP + 0x8]
0059faef FSUB dword ptr [ESI + 0xc]
0059faf2 XOR EBX,EBX
0059faf4 CMP AL,BL
0059faf6 FSTP dword ptr [ESP + 0x24]
0059fafa FILD dword ptr [ESP + 0x68]
0059fafe FSTP dword ptr [ESP + 0x10]
0059fb02 FLD dword ptr [ESP + 0x70]
0059fb06 FDIV dword ptr [ESP + 0x10]
0059fb0a FSTP dword ptr [ESP + 0x70]
0059fb0e FXCH
0059fb10 FMUL dword ptr [ESP + 0x70]
0059fb14 FSTP dword ptr [ESP + 0x1c]
0059fb18 FMUL dword ptr [ESP + 0x70]
0059fb1c FSTP dword ptr [ESP + 0x20]
0059fb20 FLD dword ptr [ESP + 0x24]
0059fb24 FMUL dword ptr [ESP + 0x70]
0059fb28 FSTP dword ptr [ESP + 0x24]
0059fb2c JZ 0x0059fbd8
0059fb32 TEST byte ptr [ESI + 0x324],0x4
0059fb39 JZ 0x0059fb8d
0059fb3b FLD dword ptr [ESP + 0x24]
0059fb3f FMUL dword ptr [ESP + 0x24]
0059fb43 FLD dword ptr [ESP + 0x20]
0059fb47 FMUL dword ptr [ESP + 0x20]
0059fb4b FADDP
0059fb4d FLD dword ptr [ESP + 0x1c]
0059fb51 FMUL dword ptr [ESP + 0x1c]
0059fb55 FADDP
0059fb57 FSQRT
0059fb59 FMUL dword ptr [0x006f6ea4]   ; [006f6ea4] f32=0.104000002146 i32=1037368820 f64=1.23541921605e-05
0059fb5f FLD dword ptr [0x00b8f258]
0059fb65 FMUL dword ptr [0x006f6ea0]   ; [006f6ea0] f32=12.5439996719 i32=1095283769 f64=7.63684812619e-11
0059fb6b FDIVP
0059fb6d FLD ST0
0059fb6f FMUL dword ptr [ESI + 0xb4]
0059fb75 FADD dword ptr [ESP + 0x1c]
0059fb79 FSTP dword ptr [ESP + 0x58]
0059fb7d FMUL dword ptr [ESI + 0xb8]
0059fb83 FADD dword ptr [ESP + 0x20]
0059fb87 FSTP dword ptr [ESP + 0x5c]
0059fb8b JMP 0x0059fb9d
0059fb8d MOV EAX,dword ptr [ESP + 0x1c]
0059fb91 MOV ECX,dword ptr [ESP + 0x20]
0059fb95 MOV dword ptr [ESP + 0x58],EAX
0059fb99 MOV dword ptr [ESP + 0x5c],ECX
0059fb9d LEA EDX,[EBP + 0x24]
0059fba0 LEA EAX,[ESP + 0x58]
0059fba4 PUSH EDX
0059fba5 LEA ECX,[ESP + 0x78]
0059fba9 PUSH EAX
0059fbaa LEA EDX,[ESP + 0x70]
0059fbae PUSH ECX
0059fbaf LEA EAX,[ESP + 0x78]
0059fbb3 PUSH EDX
0059fbb4 PUSH EAX
0059fbb5 CALL 0x005f5d60
0059fbba MOV ECX,dword ptr [ESP + 0x88]
0059fbc1 MOV EDX,dword ptr [ESP + 0x7c]
0059fbc5 MOV EAX,dword ptr [ESP + 0x80]
0059fbcc PUSH ECX
0059fbcd PUSH EDX
0059fbce PUSH EAX
0059fbcf PUSH EBP
0059fbd0 CALL 0x005f5a90
0059fbd5 ADD ESP,0x24
0059fbd8 TEST byte ptr [ESI + 0x324],0x2
0059fbdf JZ 0x0059ffd7
0059fbe5 FLD dword ptr [EBP + 0x7c]
0059fbe8 FSUB dword ptr [ESI + 0x80]
0059fbee PUSH EDI
0059fbef LEA EDI,[EBP + 0x7c]
0059fbf2 LEA ECX,[ESI + 0x80]
0059fbf8 FSTP dword ptr [ESP + 0x44]
0059fbfc FLD dword ptr [EDI + 0x4]
0059fbff FSUB dword ptr [ECX + 0x4]
0059fc02 FSTP dword ptr [ESP + 0x48]
0059fc06 FLD dword ptr [EDI + 0x8]
0059fc09 FSUB dword ptr [ECX + 0x8]
0059fc0c FSTP dword ptr [ESP + 0x4c]
0059fc10 FLD dword ptr [EBP + 0x88]
0059fc16 FSUB dword ptr [ESI + 0x8c]
0059fc1c FLD dword ptr [ESP + 0x4c]
0059fc20 FMUL dword ptr [ESP + 0x4c]
0059fc24 FLD dword ptr [ESP + 0x48]
0059fc28 FMUL dword ptr [ESP + 0x48]
0059fc2c FADDP
0059fc2e FLD dword ptr [ESP + 0x44]
0059fc32 FMUL dword ptr [ESP + 0x44]
0059fc36 FADDP
0059fc38 FLD ST1
0059fc3a FMUL ST2
0059fc3c FADDP
0059fc3e FCOMP dword ptr [0x006e97d8]   ; [006e97d8] f32=1.0 i32=1065353216 f64=3.63170317588e+19
0059fc44 FNSTSW AX
0059fc46 AND EAX,0x100
0059fc4b JNZ 0x0059fc91
0059fc4d MOV dword ptr [ESP + 0x10],ECX
0059fc51 LEA ECX,[ESP + 0x44]
0059fc55 FSTP ST0
0059fc57 MOV dword ptr [ESP + 0x18],EDI
0059fc5b MOV dword ptr [ESP + 0x1c],ECX
0059fc5f MOV EAX,dword ptr [ESP + 0x1c]
0059fc63 MOV EBX,dword ptr [ESP + 0x18]
0059fc67 MOV ECX,dword ptr [ESP + 0x10]
0059fc6b FLD dword ptr [EBX]
0059fc6d FADD dword ptr [ECX]
0059fc6f FLD dword ptr [EBX + 0x4]
0059fc72 FADD dword ptr [ECX + 0x4]
0059fc75 FLD dword ptr [EBX + 0x8]
0059fc78 FADD dword ptr [ECX + 0x8]
0059fc7b FXCH ST2
0059fc7d FSTP dword ptr [EAX]
0059fc7f FSTP dword ptr [EAX + 0x4]
0059fc82 FSTP dword ptr [EAX + 0x8]
0059fc85 FLD dword ptr [ESI + 0x8c]
0059fc8b FADD dword ptr [EBP + 0x88]
0059fc91 FLD dword ptr [EBP + 0x88]
0059fc97 FLD dword ptr [ESP + 0x44]
0059fc9b FMUL ST1
0059fc9d FSTP dword ptr [ESP + 0x2c]
0059fca1 FLD dword ptr [ESP + 0x48]
0059fca5 FMUL ST1
0059fca7 FSTP dword ptr [ESP + 0x30]
0059fcab FLD dword ptr [ESP + 0x4c]
0059fcaf FMUL ST1
0059fcb1 FSTP dword ptr [ESP + 0x34]
0059fcb5 FSTP ST0
0059fcb7 FLD ST0
0059fcb9 FMUL dword ptr [EDI]
0059fcbb FSTP dword ptr [ESP + 0x38]
0059fcbf FLD ST0
0059fcc1 FMUL dword ptr [EDI + 0x4]
0059fcc4 FSTP dword ptr [ESP + 0x3c]
0059fcc8 FMUL dword ptr [EDI + 0x8]
0059fccb FLD dword ptr [ESP + 0x2c]
0059fccf FSUB dword ptr [ESP + 0x38]
0059fcd3 FLD dword ptr [ESP + 0x30]
0059fcd7 FSUB dword ptr [ESP + 0x3c]
0059fcdb FSTP dword ptr [ESP + 0x30]
0059fcdf FLD dword ptr [ESP + 0x34]
0059fce3 FSUB ST0,ST2
0059fce5 FSTP dword ptr [ESP + 0x34]
0059fce9 FLD dword ptr [ESP + 0x48]
0059fced FMUL dword ptr [EDI]
0059fcef FLD dword ptr [ESP + 0x44]
0059fcf3 FMUL dword ptr [EDI + 0x4]
0059fcf6 FSUBP
0059fcf8 FSTP dword ptr [ESP + 0x40]
0059fcfc FLD dword ptr [ESP + 0x4c]
0059fd00 FMUL dword ptr [EDI + 0x4]
0059fd03 FLD dword ptr [ESP + 0x48]
0059fd07 FMUL dword ptr [EDI + 0x8]
0059fd0a FSUBP
0059fd0c FLD dword ptr [ESP + 0x44]
0059fd10 FMUL dword ptr [EDI + 0x8]
0059fd13 FLD dword ptr [ESP + 0x4c]
0059fd17 FMUL dword ptr [EDI]
0059fd19 FSUBP
0059fd1b FSTP dword ptr [ESP + 0x3c]
0059fd1f FXCH
0059fd21 FSUB ST0,ST1
0059fd23 FSTP ST2
0059fd25 FSTP ST0
0059fd27 FLD dword ptr [ESP + 0x30]
0059fd2b FSUB dword ptr [ESP + 0x3c]
0059fd2f FLD dword ptr [ESP + 0x34]
0059fd33 FSUB dword ptr [ESP + 0x40]
0059fd37 FSTP dword ptr [ESP + 0x34]
0059fd3b FLD dword ptr [ESP + 0x74]
0059fd3f FADD ST0,ST0
0059fd41 FST dword ptr [ESP + 0x10]
0059fd45 FMUL ST2
0059fd47 FSTP dword ptr [ESP + 0x2c]
0059fd4b FMUL dword ptr [ESP + 0x10]
0059fd4f FSTP dword ptr [ESP + 0x30]
0059fd53 FSTP ST0
0059fd55 FLD dword ptr [ESP + 0x34]
0059fd59 FMUL dword ptr [ESP + 0x10]
0059fd5d FSTP dword ptr [ESP + 0x34]
0059fd61 FLD dword ptr [ESI + 0x9c]
0059fd67 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059fd6d FSTP dword ptr [ESP + 0x38]
0059fd71 FLD dword ptr [ESI + 0xa0]
0059fd77 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059fd7d FSTP dword ptr [ESP + 0x3c]
0059fd81 FLD dword ptr [ESI + 0xa4]
0059fd87 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059fd8d FSTP dword ptr [ESP + 0x40]
0059fd91 FLD dword ptr [ESP + 0x20]
0059fd95 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059fd9b FSTP dword ptr [ESP + 0x20]
0059fd9f FLD dword ptr [ESP + 0x24]
0059fda3 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059fda9 FSTP dword ptr [ESP + 0x24]
0059fdad FLD dword ptr [ESP + 0x28]
0059fdb1 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059fdb7 LEA EDX,[ESP + 0x38]
0059fdbb LEA EAX,[ESP + 0x20]
0059fdbf LEA ECX,[ESP + 0x20]
0059fdc3 MOV dword ptr [ESP + 0x1c],EDX
0059fdc7 MOV dword ptr [ESP + 0x18],EAX
0059fdcb MOV dword ptr [ESP + 0x10],ECX
0059fdcf FSTP dword ptr [ESP + 0x28]
0059fdd3 MOV EAX,dword ptr [ESP + 0x10]
0059fdd7 MOV EBX,dword ptr [ESP + 0x18]
0059fddb MOV ECX,dword ptr [ESP + 0x1c]
0059fddf FLD dword ptr [EBX]
0059fde1 FADD dword ptr [ECX]
0059fde3 FLD dword ptr [EBX + 0x4]
0059fde6 FADD dword ptr [ECX + 0x4]
0059fde9 FLD dword ptr [EBX + 0x8]
0059fdec FADD dword ptr [ECX + 0x8]
0059fdef FXCH ST2
0059fdf1 FSTP dword ptr [EAX]
0059fdf3 FSTP dword ptr [EAX + 0x4]
0059fdf6 FSTP dword ptr [EAX + 0x8]
0059fdf9 FLD dword ptr [ESP + 0x14]
0059fdfd FMUL dword ptr [0x006ed6c8]   ; [006ed6c8] f32=0.75 i32=1061158912 f64=5.24282163197e-315
0059fe03 FLD dword ptr [ESI + 0xc4]
0059fe09 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059fe0f MOV AL,byte ptr [ESI + 0x324]
0059fe15 MOV EDX,0x4
0059fe1a TEST DL,AL
0059fe1c FADDP
0059fe1e POP EDI
0059fe1f FSTP dword ptr [ESI + 0xc4]
0059fe25 FLD dword ptr [ESP + 0x1c]
0059fe29 FSUB dword ptr [ESI + 0x9c]
0059fe2f FLD dword ptr [ESP + 0x20]
0059fe33 FSUB dword ptr [ESI + 0xa0]
0059fe39 FLD dword ptr [ESP + 0x24]
0059fe3d FSUB dword ptr [ESI + 0xa4]
0059fe43 FSTP dword ptr [ESP + 0x54]
0059fe47 FXCH
0059fe49 FMUL dword ptr [ESP + 0x70]
0059fe4d FSTP dword ptr [ESP + 0x4c]
0059fe51 FMUL dword ptr [ESP + 0x70]
0059fe55 FSTP dword ptr [ESP + 0x50]
0059fe59 FLD dword ptr [ESP + 0x54]
0059fe5d FMUL dword ptr [ESP + 0x70]
0059fe61 JZ 0x0059ff97
0059fe67 FLD dword ptr [ESI + 0xb4]
0059fe6d FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059fe73 LEA EAX,[ESP + 0x34]
0059fe77 LEA ECX,[ESP + 0x4c]
0059fe7b MOV dword ptr [ESP + 0x70],EAX
0059fe7f LEA EAX,[ESP + 0x4c]
0059fe83 MOV dword ptr [ESP + 0x18],ECX
0059fe87 MOV dword ptr [ESP + 0x14],EAX
0059fe8b FSTP dword ptr [ESP + 0x34]
0059fe8f FLD dword ptr [ESI + 0xb8]
0059fe95 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059fe9b FSTP dword ptr [ESP + 0x38]
0059fe9f FLD dword ptr [ESI + 0xbc]
0059fea5 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059feab FSTP dword ptr [ESP + 0x3c]
0059feaf FLD dword ptr [ESP + 0x4c]
0059feb3 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059feb9 FSTP dword ptr [ESP + 0x4c]
0059febd FLD dword ptr [ESP + 0x50]
0059fec1 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059fec7 FSTP dword ptr [ESP + 0x50]
0059fecb FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059fed1 FSTP dword ptr [ESP + 0x54]
0059fed5 MOV EAX,dword ptr [ESP + 0x14]
0059fed9 MOV EBX,dword ptr [ESP + 0x18]
0059fedd MOV ECX,dword ptr [ESP + 0x70]
0059fee1 FLD dword ptr [EBX]
0059fee3 FADD dword ptr [ECX]
0059fee5 FLD dword ptr [EBX + 0x4]
0059fee8 FADD dword ptr [ECX + 0x4]
0059feeb FLD dword ptr [EBX + 0x8]
0059feee FADD dword ptr [ECX + 0x8]
0059fef1 FXCH ST2
0059fef3 FSTP dword ptr [EAX]
0059fef5 FSTP dword ptr [EAX + 0x4]
0059fef8 FSTP dword ptr [EAX + 0x8]
0059fefb FLD dword ptr [ESI + 0xa8]
0059ff01 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059ff07 LEA ECX,[ESP + 0x34]
0059ff0b LEA EAX,[ESP + 0x28]
0059ff0f MOV dword ptr [ESP + 0x70],ECX
0059ff13 LEA ECX,[ESP + 0x28]
0059ff17 MOV dword ptr [ESP + 0x18],EAX
0059ff1b MOV dword ptr [ESP + 0x14],ECX
0059ff1f FSTP dword ptr [ESP + 0x34]
0059ff23 FLD dword ptr [ESI + 0xac]
0059ff29 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059ff2f FSTP dword ptr [ESP + 0x38]
0059ff33 FLD dword ptr [ESI + 0xb0]
0059ff39 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059ff3f FSTP dword ptr [ESP + 0x3c]
0059ff43 FLD dword ptr [ESP + 0x28]
0059ff47 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059ff4d FSTP dword ptr [ESP + 0x28]
0059ff51 FLD dword ptr [ESP + 0x2c]
0059ff55 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059ff5b FSTP dword ptr [ESP + 0x2c]
0059ff5f FLD dword ptr [ESP + 0x30]
0059ff63 FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059ff69 FSTP dword ptr [ESP + 0x30]
0059ff6d MOV EAX,dword ptr [ESP + 0x14]
0059ff71 MOV EBX,dword ptr [ESP + 0x18]
0059ff75 MOV ECX,dword ptr [ESP + 0x70]
0059ff79 FLD dword ptr [EBX]
0059ff7b FADD dword ptr [ECX]
0059ff7d FLD dword ptr [EBX + 0x4]
0059ff80 FADD dword ptr [ECX + 0x4]
0059ff83 FLD dword ptr [EBX + 0x8]
0059ff86 FADD dword ptr [ECX + 0x8]
0059ff89 FXCH ST2
0059ff8b FSTP dword ptr [EAX]
0059ff8d FSTP dword ptr [EAX + 0x4]
0059ff90 FSTP dword ptr [EAX + 0x8]
0059ff93 FLD dword ptr [ESP + 0x54]
0059ff97 MOV EAX,dword ptr [ESP + 0x4c]
0059ff9b MOV ECX,dword ptr [ESP + 0x50]
0059ff9f FSTP dword ptr [ESI + 0xbc]
0059ffa5 MOV dword ptr [ESI + 0xb4],EAX
0059ffab MOV EAX,dword ptr [ESP + 0x28]
0059ffaf MOV dword ptr [ESI + 0xb8],ECX
0059ffb5 MOV ECX,dword ptr [ESP + 0x2c]
0059ffb9 MOV dword ptr [ESI + 0xa8],EAX
0059ffbf MOV EAX,dword ptr [ESP + 0x30]
0059ffc3 MOV dword ptr [ESI + 0xac],ECX
0059ffc9 MOV dword ptr [ESI + 0xb0],EAX
0059ffcf OR dword ptr [ESI + 0x324],EDX
0059ffd5 JMP 0x0059fff9
0059ffd7 FLD dword ptr [ESP + 0x10]
0059ffdb FMUL dword ptr [0x006ea44c]   ; [006ea44c] f32=0.5 i32=1056964608 f64=1.71188778959e-12
0059ffe1 MOV dword ptr [ESI + 0xa8],EBX
0059ffe7 MOV dword ptr [ESI + 0xac],EBX
0059ffed MOV dword ptr [ESI + 0xb0],EBX
0059fff3 FSTP dword ptr [ESI + 0xc4]
0059fff9 MOV ECX,dword ptr [ESP + 0x1c]
0059fffd MOV EDX,dword ptr [ESP + 0x20]
005a0001 MOV EAX,dword ptr [ESP + 0x24]
005a0005 MOV dword ptr [ESI + 0x9c],ECX
005a000b MOV dword ptr [ESI + 0xa0],EDX
005a0011 MOV dword ptr [ESI + 0xa4],EAX
005a0017 MOV EAX,dword ptr [ESI + 0x324]
005a001d OR AL,0x2
005a001f MOV dword ptr [ESI + 0x324],EAX
005a0025 POP ESI
005a0026 POP EBP
005a0027 POP EBX
005a0028 ADD ESP,0x58
005a002b RET 0x10
