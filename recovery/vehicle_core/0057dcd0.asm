0057dcd0 MOV EAX,dword ptr [ESP + 0x4]
0057dcd4 MOV [0x00d47d6c],EAX
0057dcd9 SUB EAX,0x0
0057dcdc JZ 0x0057dd0e
0057dcde DEC EAX
0057dcdf JZ 0x0057dcf9
0057dce1 DEC EAX
0057dce2 JNZ 0x0057dd22
0057dce4 MOV dword ptr [0x0074fe48],0x74fe14
0057dcee MOV dword ptr [0x0074fe4c],0x74fe24
0057dcf8 RET
0057dcf9 MOV dword ptr [0x0074fe48],0x74fde0
0057dd03 MOV dword ptr [0x0074fe4c],0x74fdf0
0057dd0d RET
0057dd0e MOV dword ptr [0x0074fe48],0x74fdac
0057dd18 MOV dword ptr [0x0074fe4c],0x74fdbc
0057dd22 RET
