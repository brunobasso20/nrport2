0059fa90 XOR EAX,EAX
0059fa92 MOV dword ptr [ECX + 0x278],0x3f800000
0059fa9c MOV dword ptr [ECX + 0xc8],EAX
0059faa2 MOV dword ptr [ECX + 0x320],EAX
0059faa8 MOV dword ptr [ECX + 0x31c],EAX
0059faae MOV dword ptr [ECX + 0x324],EAX
0059fab4 MOV dword ptr [ECX + 0x268],EAX
0059faba ADD ECX,0xcc
0059fac0 PUSH ECX
0059fac1 CALL 0x005f5f80
0059fac6 POP ECX
0059fac7 RET
