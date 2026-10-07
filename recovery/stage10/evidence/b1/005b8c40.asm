005b8c40 SUB ESP,0x10
005b8c43 FLD dword ptr [ESP + 0x18]
005b8c47 FCOS
005b8c49 PUSH ESI
005b8c4a MOV ESI,dword ptr [ESP + 0x18]
005b8c4e PUSH ECX
005b8c4f FSTP dword ptr [ESP + 0x8]
005b8c53 FLD dword ptr [ESP + 0x20]
005b8c57 FSIN
005b8c59 FSTP dword ptr [ESP + 0x20]
005b8c5d FLD dword ptr [ESP + 0x24]
005b8c61 FCOS
005b8c63 FSTP dword ptr [ESP + 0x10]
005b8c67 FLD dword ptr [ESP + 0x24]
005b8c6b FSIN
005b8c6d FSTP dword ptr [ESP + 0x14]
005b8c71 FLD dword ptr [ESP + 0x28]
005b8c75 FCOS
005b8c77 FSTP dword ptr [ESP + 0xc]
005b8c7b FLD dword ptr [ESP + 0x28]
005b8c7f FSIN
005b8c81 FSTP dword ptr [ESP + 0x24]
005b8c85 FLD dword ptr [ESP + 0x10]
005b8c89 FMUL dword ptr [ESP + 0x8]
005b8c8d FSTP dword ptr [ESP]
005b8c90 PUSH ESI
005b8c91 CALL 0x0057ca60
005b8c96 FLD dword ptr [ESP + 0x28]
005b8c9a FMUL dword ptr [ESP + 0x18]
005b8c9e ADD ESP,0x4
005b8ca1 LEA EAX,[ESI + 0x4]
005b8ca4 FST dword ptr [ESP + 0x28]
005b8ca8 FMUL dword ptr [ESP + 0x8]
005b8cac FLD dword ptr [ESP + 0xc]
005b8cb0 FMUL dword ptr [ESP + 0x20]
005b8cb4 FSUBP
005b8cb6 FSTP dword ptr [ESP]
005b8cb9 PUSH EAX
005b8cba CALL 0x0057ca60
005b8cbf FLD dword ptr [ESP + 0x10]
005b8cc3 FMUL dword ptr [ESP + 0x18]
005b8cc7 ADD ESP,0x4
005b8cca LEA ECX,[ESI + 0x8]
005b8ccd FST dword ptr [ESP + 0x1c]
005b8cd1 FMUL dword ptr [ESP + 0x8]
005b8cd5 FLD dword ptr [ESP + 0x24]
005b8cd9 FMUL dword ptr [ESP + 0x20]
005b8cdd FADDP
005b8cdf FSTP dword ptr [ESP]
005b8ce2 PUSH ECX
005b8ce3 CALL 0x0057ca60
005b8ce8 FLD dword ptr [ESP + 0x14]
005b8cec FMUL dword ptr [ESP + 0x24]
005b8cf0 ADD ESP,0x4
005b8cf3 LEA EDX,[ESI + 0xc]
005b8cf6 FSTP dword ptr [ESP]
005b8cf9 PUSH EDX
005b8cfa CALL 0x0057ca60
005b8cff FLD dword ptr [ESP + 0x2c]
005b8d03 FMUL dword ptr [ESP + 0x24]
005b8d07 FLD dword ptr [ESP + 0x10]
005b8d0b FMUL dword ptr [ESP + 0xc]
005b8d0f ADD ESP,0x4
005b8d12 LEA EAX,[ESI + 0x10]
005b8d15 FADDP
005b8d17 FSTP dword ptr [ESP]
005b8d1a PUSH EAX
005b8d1b CALL 0x0057ca60
005b8d20 FLD dword ptr [ESP + 0x20]
005b8d24 FMUL dword ptr [ESP + 0x24]
005b8d28 FLD dword ptr [ESP + 0x28]
005b8d2c FMUL dword ptr [ESP + 0xc]
005b8d30 ADD ESP,0x4
005b8d33 LEA ECX,[ESI + 0x14]
005b8d36 FSUBP
005b8d38 FSTP dword ptr [ESP]
005b8d3b PUSH ECX
005b8d3c CALL 0x0057ca60
005b8d41 FLD dword ptr [ESP + 0x18]
005b8d45 ADD ESP,0x4
005b8d48 FCHS
005b8d4a FSTP dword ptr [ESP]
005b8d4d LEA EDX,[ESI + 0x18]
005b8d50 PUSH EDX
005b8d51 CALL 0x0057ca60
005b8d56 FLD dword ptr [ESP + 0x28]
005b8d5a FMUL dword ptr [ESP + 0x14]
005b8d5e ADD ESP,0x4
005b8d61 LEA EAX,[ESI + 0x1c]
005b8d64 FSTP dword ptr [ESP]
005b8d67 PUSH EAX
005b8d68 CALL 0x0057ca60
005b8d6d FLD dword ptr [ESP + 0x10]
005b8d71 FMUL dword ptr [ESP + 0x14]
005b8d75 ADD ESP,0x4
005b8d78 ADD ESI,0x20
005b8d7b FSTP dword ptr [ESP]
005b8d7e PUSH ESI
005b8d7f CALL 0x0057ca60
005b8d84 ADD ESP,0x8
005b8d87 POP ESI
005b8d88 ADD ESP,0x10
005b8d8b RET
