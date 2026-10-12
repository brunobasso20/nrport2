00465b80 MOV DL,byte ptr [ESP + 0x8]
00465b84 MOV EAX,ECX
00465b86 MOV CL,byte ptr [ESP + 0xc]
00465b8a MOV byte ptr [EAX],CL
00465b8c MOV CL,byte ptr [ESP + 0x4]
00465b90 MOV byte ptr [EAX + 0x1],DL
00465b93 MOV DL,byte ptr [ESP + 0x10]
00465b97 MOV byte ptr [EAX + 0x2],CL
00465b9a MOV byte ptr [EAX + 0x3],DL
00465b9d RET 0x10
