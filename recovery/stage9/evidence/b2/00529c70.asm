00529c70 PUSH EBX
00529c71 PUSH ESI
00529c72 MOV ESI,ECX
00529c74 CALL 0x005a1730
00529c79 MOV EAX,dword ptr [ESI + 0x5b2]
00529c7f PUSH EAX
00529c80 CALL 0x00538ab0
00529c85 MOV ECX,EAX
00529c87 CALL 0x0053a590
00529c8c CMP EAX,-0x1
00529c8f JZ 0x00529c97
00529c91 MOV dword ptr [ESI + 0x139b],EAX
00529c97 MOV EAX,dword ptr [ESI + 0x5b2]
00529c9d PUSH EAX
00529c9e CALL 0x00538ab0
00529ca3 MOV ECX,EAX
00529ca5 CALL 0x0053a580
00529caa CMP EAX,0x7ffffffe
00529caf JZ 0x00529cb7
00529cb1 MOV dword ptr [ESI + 0x1397],EAX
00529cb7 MOV EAX,dword ptr [ESI]
00529cb9 MOV ECX,ESI
00529cbb CALL dword ptr [EAX + 0x24]
00529cbe XOR EBX,EBX
00529cc0 MOV EDX,0x3f800000
00529cc5 MOV dword ptr [ESI + 0x139f],0x10
00529ccf MOV dword ptr [ESI + 0x13b7],EBX
00529cd5 MOV dword ptr [ESI + 0x1b91],EBX
00529cdb MOV dword ptr [ESI + 0x1862],EBX
00529ce1 MOV dword ptr [ESI + 0x1866],EBX
00529ce7 MOV dword ptr [ESI + 0x186a],EBX
00529ced MOV dword ptr [ESI + 0x186e],EBX
00529cf3 MOV dword ptr [ESI + 0x1872],EBX
00529cf9 MOV dword ptr [ESI + 0x1876],EBX
00529cff MOV dword ptr [ESI + 0x187a],EDX
00529d05 MOV dword ptr [ESI + 0x1886],EBX
00529d0b MOV dword ptr [ESI + 0x188a],EBX
00529d11 MOV dword ptr [ESI + 0x188e],EBX
00529d17 MOV dword ptr [ESI + 0x1892],EBX
00529d1d MOV dword ptr [ESI + 0x1896],EBX
00529d23 MOV dword ptr [ESI + 0x18a6],EBX
00529d29 MOV dword ptr [ESI + 0x18aa],EBX
00529d2f MOV dword ptr [ESI + 0x18ae],EBX
00529d35 MOV dword ptr [ESI + 0x18b2],EBX
00529d3b MOV dword ptr [ESI + 0x18b6],0x3ee9e6ef
00529d45 MOV dword ptr [ESI + 0x18ba],EBX
00529d4b MOV dword ptr [ESI + 0x18be],EBX
00529d51 FLD dword ptr [0x00b8f258]
00529d57 FMUL dword ptr [0x0074ab10]   ; [0074ab10] f32=0.0850000008941 i32=1034818683 f64=5.11268360945e-315
00529d5d FSTP dword ptr [ESI + 0x18c2]
00529d63 FLD dword ptr [0x00b8f258]
00529d69 FSQRT
00529d6b FMUL dword ptr [0x0074ab28]   ; [0074ab28] f32=0.280000001192 i32=1049582633 f64=5.18562721437e-315
00529d71 MOV dword ptr [ESI + 0x1af6],EDX
00529d77 MOV dword ptr [ESI + 0x18ca],EBX
00529d7d MOV dword ptr [ESI + 0x18ce],EBX
00529d83 MOV dword ptr [ESI + 0x18d2],EBX
00529d89 FCHS
00529d8b FSTP dword ptr [ESI + 0x18c6]
00529d91 FLD dword ptr [0x006e9818]   ; [006e9818] f32=0.0075619998388 i32=1006095015 f64=0.000292968757974
00529d97 FDIV dword ptr [ESI + 0x18c2]
00529d9d MOV dword ptr [ESI + 0x18d6],EBX
00529da3 MOV dword ptr [ESI + 0x18da],0x3c8ce704
00529dad MOV dword ptr [ESI + 0x18de],EBX
00529db3 FADD dword ptr [0x006f5148]   ; [006f5148] f32=0.456840008497 i32=1055516399 f64=1.11689284269e+18
00529db9 FST dword ptr [ESI + 0x1aee]
00529dbf FSTP dword ptr [ESI + 0x1af2]
00529dc5 MOV EAX,[0x00bddde0]
00529dca CMP EAX,EBX
00529dcc JLE 0x00529dda
00529dce MOV dword ptr [ESI + 0x18e2],0xbc87fcb9
00529dd8 JMP 0x00529dee
00529dda JGE 0x00529de8
00529ddc MOV dword ptr [ESI + 0x18e2],0x3c87fcb9
00529de6 JMP 0x00529dee
00529de8 MOV dword ptr [ESI + 0x18e2],EBX
00529dee MOV dword ptr [ESI + 0x18e6],EBX
00529df4 MOV dword ptr [ESI + 0x18ea],EBX
00529dfa MOV dword ptr [ESI + 0x18ee],EBX
00529e00 MOV dword ptr [ESI + 0x18f2],0x3ff3a5e3
00529e0a MOV dword ptr [ESI + 0x18f6],0x2
00529e14 MOV dword ptr [ESI + 0x18fa],EBX
00529e1a MOV dword ptr [ESI + 0x18fe],EBX
00529e20 MOV dword ptr [ESI + 0x1906],EBX
00529e26 MOV dword ptr [ESI + 0x1902],EBX
00529e2c MOV dword ptr [ESI + 0x190a],EBX
00529e32 MOV dword ptr [ESI + 0x190e],0x440fc000
00529e3c MOV ECX,dword ptr [0x0074ac78]   ; [0074ac78] f32=0.949999988079 i32=1064514355 f64=5.2593997231e-315
00529e42 MOV EAX,0x3c39d7fd
00529e47 MOV dword ptr [ESI + 0x1912],ECX
00529e4d MOV dword ptr [ESI + 0x196e],EAX
00529e53 MOV dword ptr [ESI + 0x1972],EAX
00529e59 MOV ECX,0x6
00529e5e MOV EAX,0x3e2aaaab
00529e63 MOV dword ptr [ESI + 0x1ae2],0x3fc00000
00529e6d MOV dword ptr [ESI + 0x196a],EDX
00529e73 MOV dword ptr [ESI + 0x197a],EBX
00529e79 MOV dword ptr [ESI + 0x197e],EBX
00529e7f MOV dword ptr [ESI + 0x1982],EBX
00529e85 MOV dword ptr [ESI + 0x198a],ECX
00529e8b MOV dword ptr [ESI + 0x198e],EAX
00529e91 MOV dword ptr [ESI + 0x1992],EBX
00529e97 MOV dword ptr [ESI + 0x1996],ECX
00529e9d MOV dword ptr [ESI + 0x199a],EAX
00529ea3 MOV dword ptr [ESI + 0x199e],EBX
00529ea9 MOV dword ptr [ESI + 0x19a2],ECX
00529eaf MOV dword ptr [ESI + 0x19a6],EAX
00529eb5 MOV dword ptr [ESI + 0x19aa],EBX
00529ebb MOV dword ptr [ESI + 0x19ae],ECX
00529ec1 MOV dword ptr [ESI + 0x19b2],EAX
00529ec7 MOV ECX,0x3
00529ecc MOV EAX,0x3eaaaaab
00529ed1 MOV dword ptr [ESI + 0x19b6],EBX
00529ed7 PUSH EBP
00529ed8 MOV dword ptr [ESI + 0x19ba],ECX
00529ede MOV dword ptr [ESI + 0x19be],EAX
00529ee4 MOV dword ptr [ESI + 0x19c2],EBX
00529eea LEA EBP,[ESI + 0x19de]
00529ef0 MOV dword ptr [ESI + 0x19c6],ECX
00529ef6 MOV dword ptr [ESI + 0x19ca],EAX
00529efc PUSH EDI
00529efd MOV dword ptr [ESI + 0x19ce],EBX
00529f03 MOV ECX,0x26
00529f08 XOR EAX,EAX
00529f0a MOV EDI,EBP
00529f0c MOV dword ptr [ESI + 0x19d2],0x4
00529f16 MOV dword ptr [ESI + 0x19d6],0x3e800000
00529f20 MOV dword ptr [ESI + 0x19da],EBX
00529f26 STOSD.REP ES:EDI
00529f28 MOV dword ptr [ESI + 0x1a76],EBP
00529f2e MOV dword ptr [ESI + 0x1a7a],EBX
00529f34 MOV dword ptr [ESI + 0x1a7e],EBX
00529f3a MOV dword ptr [ESI + 0x1a82],EBX
00529f40 MOV dword ptr [ESI + 0x1a86],0x3f6147ae
00529f4a MOV dword ptr [ESI + 0x1a8e],EBX
00529f50 MOV dword ptr [ESI + 0x1a92],EBX
00529f56 MOV dword ptr [ESI + 0x1a96],EBX
00529f5c MOV dword ptr [ESI + 0x1a9a],EDX
00529f62 MOV dword ptr [ESI + 0x1a9e],EBX
00529f68 MOV dword ptr [ESI + 0x1aa2],EDX
00529f6e MOV dword ptr [ESI + 0x1abe],EDX
00529f74 MOV dword ptr [ESI + 0x1ac2],EDX
00529f7a MOV dword ptr [ESI + 0x1ac6],EBX
00529f80 MOV dword ptr [ESI + 0x1aca],EBX
00529f86 MOV dword ptr [ESI + 0x1ace],EBX
00529f8c MOV dword ptr [ESI + 0x1ad2],EBX
00529f92 MOV dword ptr [ESI + 0x1ad6],EBX
00529f98 MOV EAX,[0x0074aca8]   ; [0074aca8] f32=0.00680579990149 i32=1004471088 f64=4.96274656822e-315
00529f9d MOV dword ptr [ESI + 0x1ada],EAX
00529fa3 MOV ECX,dword ptr [0x0074aca8]   ; [0074aca8] f32=0.00680579990149 i32=1004471088 f64=4.96274656822e-315
00529fa9 MOV dword ptr [ESI + 0x1ade],ECX
00529faf MOV EAX,[0x0074acc0]   ; [0074acc0] f32=0.899999976158 i32=1063675494 f64=5.25525519909e-315
00529fb4 MOV dword ptr [ESI + 0x1ae6],EAX
00529fba MOV dword ptr [ESI + 0x1aea],EBX
00529fc0 MOV dword ptr [ESI + 0x59e],EDX
00529fc6 MOV dword ptr [ESI + 0x5a2],EDX
00529fcc MOV dword ptr [ESI + 0x5a6],EDX
00529fd2 MOV dword ptr [ESI + 0x1afa],EBX
00529fd8 MOV dword ptr [ESI + 0x1b06],EBX
00529fde MOV dword ptr [ESI + 0x1b0a],EBX
00529fe4 MOV dword ptr [ESI + 0x1b0e],EBX
00529fea MOV dword ptr [ESI + 0x1b12],EBX
00529ff0 MOV dword ptr [ESI + 0x1b16],EBX
00529ff6 MOV dword ptr [ESI + 0x1b1a],EBX
00529ffc MOV dword ptr [ESI + 0x1b1e],EBX
0052a002 MOV dword ptr [ESI + 0x1b26],EBX
0052a008 MOV dword ptr [ESI + 0x1b2a],EBX
0052a00e MOV dword ptr [ESI + 0x1b2e],EBX
0052a014 MOV byte ptr [ESI + 0x1b32],BL
0052a01a MOV dword ptr [ESI + 0x1b33],EBX
0052a020 MOV byte ptr [ESI + 0x1b37],BL
0052a026 MOV dword ptr [ESI + 0x1b38],EBX
0052a02c MOV dword ptr [ESI + 0x1b3c],EBX
0052a032 MOV dword ptr [ESI + 0x1b50],EBX
0052a038 MOV dword ptr [ESI + 0x1b54],EBX
0052a03e MOV dword ptr [ESI + 0x1b58],EBX
0052a044 MOV dword ptr [ESI + 0x1b5c],EBX
0052a04a MOV EAX,0x3f419652
0052a04f MOV dword ptr [ESI + 0x1986],EBX
0052a055 MOV dword ptr [ESI + 0x1b71],EAX
0052a05b MOV dword ptr [ESI + 0x1b75],EAX
0052a061 MOV ECX,dword ptr [ESI + 0x1b71]
0052a067 MOV dword ptr [ESI + 0x1b79],ECX
0052a06d MOV dword ptr [ESI + 0x1b85],EBX
0052a073 MOV dword ptr [ESI + 0x1bad],EBX
0052a079 MOV dword ptr [ESI + 0x1b89],EBX
0052a07f MOV dword ptr [ESI + 0x1bb1],EBX
0052a085 MOV EAX,dword ptr [ESI + 0x1bad]
0052a08b MOV dword ptr [ESI + 0x1bd2],EAX
0052a091 MOV ECX,dword ptr [ESI + 0x1bb1]
0052a097 MOV dword ptr [ESI + 0x1bd6],ECX
0052a09d MOV dword ptr [ESI + 0x1bce],EBX
0052a0a3 MOV EAX,dword ptr [ESI + 0x1bad]
0052a0a9 MOV dword ptr [ESI + 0x1bb9],EAX
0052a0af MOV ECX,dword ptr [ESI + 0x1bb1]
0052a0b5 MOV EAX,0x41a00000
0052a0ba MOV dword ptr [ESI + 0x1bbd],ECX
0052a0c0 MOV dword ptr [ESI + 0x1bc5],EAX
0052a0c6 MOV dword ptr [ESI + 0x1bc9],EAX
0052a0cc MOV dword ptr [ESI + 0x1b95],EBX
0052a0d2 MOV dword ptr [ESI + 0x1b99],EBX
0052a0d8 MOV dword ptr [ESI + 0x1b9d],EBX
0052a0de MOV dword ptr [ESI + 0x1b8d],EBX
0052a0e4 MOV dword ptr [ESI + 0x195e],EBX
0052a0ea MOV dword ptr [ESI + 0x1962],EBX
0052a0f0 MOV dword ptr [ESI + 0x1966],EBX
0052a0f6 MOV dword ptr [ESI + 0x1be6],EDX
0052a0fc MOV dword ptr [ESI + 0x1bea],EDX
0052a102 MOV ECX,ESI
0052a104 MOV dword ptr [ESI + 0x1bee],EDX
0052a10a CALL 0x0052b4c0
0052a10f MOV dword ptr [ESI + 0x1b40],EBX
0052a115 MOV dword ptr [ESI + 0x1b44],EBX
0052a11b MOV dword ptr [ESI + 0x1b4c],EBX
0052a121 MOV dword ptr [ESI + 0x1b48],EBX
0052a127 MOV AL,byte ptr [ESI + 0x59b]
0052a12d POP EDI
0052a12e CMP AL,BL
0052a130 POP EBP
0052a131 JZ 0x0052a15f
0052a133 PUSH 0x3
0052a135 MOV ECX,ESI
0052a137 CALL 0x0052e4e0
0052a13c MOV EAX,dword ptr [ESI + 0x5b2]
0052a142 PUSH EAX
0052a143 CALL 0x00567610
0052a148 ADD ESP,0x4
0052a14b MOV ECX,ESI
0052a14d PUSH EAX
0052a14e PUSH EBX
0052a14f CALL 0x0052e270
0052a154 LEA ECX,[ESI + 0x16be]
0052a15a CALL 0x004f74b0
0052a15f MOV dword ptr [ESI + 0x21f0],EBX
0052a165 LEA EAX,[ESI + 0x21f4]
0052a16b FLD dword ptr [0x00b8fa5c]
0052a171 FMUL dword ptr [0x006ed070]   ; [006ed070] f32=1.25 i32=1067450368 f64=5.27390555469e-315
0052a177 MOV ECX,0x5
0052a17c FST dword ptr [ESI + 0x2208]
0052a182 FLD dword ptr [0x006e97d8]   ; [006e97d8] f32=1.0 i32=1065353216 f64=3.63170317588e+19
0052a188 FDIV ST0,ST1
0052a18a FSTP dword ptr [ESI + 0x220c]
0052a190 FSTP ST0
0052a192 MOV EDX,dword ptr [ESI + 0x2208]
0052a198 MOV dword ptr [EAX],EDX
0052a19a ADD EAX,0x4
0052a19d DEC ECX
0052a19e JNZ 0x0052a192
0052a1a0 MOV dword ptr [ESI + 0x2210],EBX
0052a1a6 POP ESI
0052a1a7 POP EBX
0052a1a8 RET 0x4
