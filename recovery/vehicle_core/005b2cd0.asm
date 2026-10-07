005b2cd0 MOV EAX,dword ptr [ESP + 0x4]
005b2cd4 MOV ECX,dword ptr [EAX + 0x40]
005b2cd7 TEST CL,0x1
005b2cda JNZ 0x005b2ce5
005b2cdc SAR ECX,0x7
005b2cdf AND ECX,0x7
005b2ce2 DEC ECX
005b2ce3 JNZ 0x005b2d1f
005b2ce5 MOV ECX,dword ptr [EAX + 0x2cd]
005b2ceb MOV EDX,dword ptr [ECX]
005b2ced MOV ECX,dword ptr [0x00e847c8]
005b2cf3 MOV dword ptr [ECX],EDX
005b2cf5 MOV ECX,dword ptr [0x00e847c8]
005b2cfb ADD ECX,0x4
005b2cfe MOV dword ptr [0x00e847c8],ECX
005b2d04 MOV EDX,dword ptr [EAX + 0x385]
005b2d0a MOV EDX,dword ptr [EDX]
005b2d0c MOV dword ptr [ECX],EDX
005b2d0e MOV ECX,dword ptr [0x00e847c8]
005b2d14 ADD ECX,0x4
005b2d17 MOV dword ptr [0x00e847c8],ECX
005b2d1d JMP 0x005b2d25
005b2d1f MOV ECX,dword ptr [0x00e847c8]
005b2d25 MOV EDX,dword ptr [EAX + 0x40]
005b2d28 TEST DL,0x2
005b2d2b JNZ 0x005b2d39
005b2d2d SAR EDX,0x7
005b2d30 AND EDX,0x7
005b2d33 DEC EDX
005b2d34 CMP EDX,0x1
005b2d37 JNZ 0x005b2d6b
005b2d39 MOV EDX,dword ptr [EAX + 0x2d1]
005b2d3f MOV EDX,dword ptr [EDX]
005b2d41 MOV dword ptr [ECX],EDX
005b2d43 MOV ECX,dword ptr [0x00e847c8]
005b2d49 ADD ECX,0x4
005b2d4c MOV dword ptr [0x00e847c8],ECX
005b2d52 MOV EDX,dword ptr [EAX + 0x389]
005b2d58 MOV EDX,dword ptr [EDX]
005b2d5a MOV dword ptr [ECX],EDX
005b2d5c MOV ECX,dword ptr [0x00e847c8]
005b2d62 ADD ECX,0x4
005b2d65 MOV dword ptr [0x00e847c8],ECX
005b2d6b MOV EDX,dword ptr [EAX + 0x40]
005b2d6e TEST DL,0x4
005b2d71 JNZ 0x005b2d7f
005b2d73 SAR EDX,0x7
005b2d76 AND EDX,0x7
005b2d79 DEC EDX
005b2d7a CMP EDX,0x2
005b2d7d JNZ 0x005b2db1
005b2d7f MOV EDX,dword ptr [EAX + 0x2d5]
005b2d85 MOV EDX,dword ptr [EDX]
005b2d87 MOV dword ptr [ECX],EDX
005b2d89 MOV ECX,dword ptr [0x00e847c8]
005b2d8f ADD ECX,0x4
005b2d92 MOV dword ptr [0x00e847c8],ECX
005b2d98 MOV EDX,dword ptr [EAX + 0x38d]
005b2d9e MOV EDX,dword ptr [EDX]
005b2da0 MOV dword ptr [ECX],EDX
005b2da2 MOV ECX,dword ptr [0x00e847c8]
005b2da8 ADD ECX,0x4
005b2dab MOV dword ptr [0x00e847c8],ECX
005b2db1 MOV EDX,dword ptr [EAX + 0x40]
005b2db4 PUSH ESI
005b2db5 MOV ESI,EDX
005b2db7 SAR ESI,0x7
005b2dba AND ESI,0x7
005b2dbd DEC ESI
005b2dbe CMP ESI,0x2
005b2dc1 POP ESI
005b2dc2 JLE 0x005b2df2
005b2dc4 MOV EDX,dword ptr [EAX + 0x35d]
005b2dca MOV EDX,dword ptr [EDX]
005b2dcc MOV dword ptr [ECX],EDX
005b2dce MOV ECX,dword ptr [0x00e847c8]
005b2dd4 ADD ECX,0x4
005b2dd7 MOV dword ptr [0x00e847c8],ECX
005b2ddd MOV EDX,dword ptr [EAX + 0x40]
005b2de0 SAR EDX,0x7
005b2de3 AND EDX,0x7
005b2de6 MOV EDX,dword ptr [EAX + EDX*0x4 + 0x381]
005b2ded JMP 0x005b2eca
005b2df2 TEST DL,0x18
005b2df5 JZ 0x005b2e25
005b2df7 MOV EDX,dword ptr [EAX + 0x35d]
005b2dfd MOV EDX,dword ptr [EDX]
005b2dff MOV dword ptr [ECX],EDX
005b2e01 MOV ECX,dword ptr [0x00e847c8]
005b2e07 ADD ECX,0x4
005b2e0a MOV dword ptr [0x00e847c8],ECX
005b2e10 MOV EDX,dword ptr [EAX + 0x40]
005b2e13 SAR EDX,0x3
005b2e16 AND EDX,0x3
005b2e19 MOV EDX,dword ptr [EAX + EDX*0x4 + 0x38d]
005b2e20 JMP 0x005b2eca
005b2e25 TEST DL,0x20
005b2e28 JZ 0x005b2edd
005b2e2e MOV EDX,dword ptr [EAX + 0x35d]
005b2e34 MOV EDX,dword ptr [EDX]
005b2e36 MOV dword ptr [ECX],EDX
005b2e38 MOV ECX,dword ptr [0x00e847c8]
005b2e3e ADD ECX,0x4
005b2e41 MOV dword ptr [0x00e847c8],ECX
005b2e47 MOV EDX,dword ptr [EAX + 0x361]
005b2e4d MOV EDX,dword ptr [EDX]
005b2e4f MOV dword ptr [ECX],EDX
005b2e51 MOV ECX,dword ptr [0x00e847c8]
005b2e57 ADD ECX,0x4
005b2e5a MOV dword ptr [0x00e847c8],ECX
005b2e60 MOV EDX,dword ptr [EAX + 0x365]
005b2e66 MOV EDX,dword ptr [EDX]
005b2e68 MOV dword ptr [ECX],EDX
005b2e6a MOV ECX,dword ptr [0x00e847c8]
005b2e70 ADD ECX,0x4
005b2e73 MOV dword ptr [0x00e847c8],ECX
005b2e79 MOV EDX,dword ptr [EAX + 0x369]
005b2e7f MOV EDX,dword ptr [EDX]
005b2e81 MOV dword ptr [ECX],EDX
005b2e83 MOV ECX,dword ptr [0x00e847c8]
005b2e89 ADD ECX,0x4
005b2e8c MOV dword ptr [0x00e847c8],ECX
005b2e92 MOV EDX,dword ptr [EAX + 0x391]
005b2e98 MOV EDX,dword ptr [EDX]
005b2e9a MOV dword ptr [ECX],EDX
005b2e9c MOV ECX,dword ptr [0x00e847c8]
005b2ea2 ADD ECX,0x4
005b2ea5 MOV dword ptr [0x00e847c8],ECX
005b2eab MOV EDX,dword ptr [EAX + 0x395]
005b2eb1 MOV EDX,dword ptr [EDX]
005b2eb3 MOV dword ptr [ECX],EDX
005b2eb5 MOV ECX,dword ptr [0x00e847c8]
005b2ebb ADD ECX,0x4
005b2ebe MOV dword ptr [0x00e847c8],ECX
005b2ec4 MOV EDX,dword ptr [EAX + 0x399]
005b2eca MOV EDX,dword ptr [EDX]
005b2ecc MOV dword ptr [ECX],EDX
005b2ece MOV ECX,dword ptr [0x00e847c8]
005b2ed4 ADD ECX,0x4
005b2ed7 MOV dword ptr [0x00e847c8],ECX
005b2edd PUSH 0x5b2cd0
005b2ee2 PUSH EAX
005b2ee3 CALL 0x005b2ef0
005b2ee8 ADD ESP,0x8
005b2eeb RET
