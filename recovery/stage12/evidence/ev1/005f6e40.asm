005f6e40 SUB ESP,0x14
005f6e43 MOV EAX,dword ptr [ESP + 0x1c]
005f6e47 FLD dword ptr [EAX + 0xc]
005f6e4a FADD ST0,ST0
005f6e4c FLD ST0
005f6e4e FMUL dword ptr [EAX]
005f6e50 FLD ST1
005f6e52 FMUL dword ptr [EAX + 0x4]
005f6e55 FLD ST2
005f6e57 FMUL dword ptr [EAX + 0x8]
005f6e5a FXCH ST3
005f6e5c FMUL dword ptr [EAX + 0xc]
005f6e5f FSTP dword ptr [ESP + 0x1c]
005f6e63 FLD dword ptr [EAX]
005f6e65 FADD ST0,ST0
005f6e67 FLD ST0
005f6e69 FMUL dword ptr [EAX + 0x4]
005f6e6c FSTP dword ptr [ESP]
005f6e70 FLD ST0
005f6e72 FMUL dword ptr [EAX + 0x8]
005f6e75 FSTP dword ptr [ESP + 0x4]
005f6e79 FLD dword ptr [EAX + 0x4]
005f6e7c FADD ST0,ST0
005f6e7e FLD ST0
005f6e80 FMUL dword ptr [EAX + 0x8]
005f6e83 FSTP dword ptr [ESP + 0x8]
005f6e87 FMUL dword ptr [EAX + 0x4]
005f6e8a FSTP dword ptr [ESP + 0xc]
005f6e8e FLD dword ptr [EAX + 0x8]
005f6e91 FLD ST0
005f6e93 FMUL ST1
005f6e95 FADD ST0,ST0
005f6e97 FSTP dword ptr [ESP + 0x10]
005f6e9b FSTP ST0
005f6e9d FMUL dword ptr [EAX]
005f6e9f MOV EAX,dword ptr [ESP + 0x18]
005f6ea3 FADD dword ptr [ESP + 0x1c]
005f6ea7 FSUB dword ptr [0x006e97d8]   ; [006e97d8] f32=1.0 i32=1065353216 f64=3.63170317588e+19
005f6ead FSTP dword ptr [EAX]
005f6eaf FLD dword ptr [ESP]
005f6eb3 FSUB ST0,ST3
005f6eb5 FSTP dword ptr [EAX + 0x4]
005f6eb8 FLD dword ptr [ESP + 0x4]
005f6ebc FADD ST0,ST1
005f6ebe FSTP dword ptr [EAX + 0x8]
005f6ec1 FLD dword ptr [ESP]
005f6ec5 FADD ST0,ST3
005f6ec7 FSTP dword ptr [EAX + 0xc]
005f6eca FSTP ST2
005f6ecc FLD dword ptr [ESP + 0xc]
005f6ed0 FADD dword ptr [ESP + 0x1c]
005f6ed4 FSUB dword ptr [0x006e97d8]   ; [006e97d8] f32=1.0 i32=1065353216 f64=3.63170317588e+19
005f6eda FSTP dword ptr [EAX + 0x10]
005f6edd FLD dword ptr [ESP + 0x8]
005f6ee1 FSUB ST0,ST1
005f6ee3 FSTP dword ptr [EAX + 0x14]
005f6ee6 FLD dword ptr [ESP + 0x4]
005f6eea FSUB ST0,ST2
005f6eec FSTP dword ptr [EAX + 0x18]
005f6eef FSTP ST1
005f6ef1 FLD dword ptr [ESP + 0x8]
005f6ef5 FADD ST0,ST1
005f6ef7 FSTP dword ptr [EAX + 0x1c]
005f6efa FSTP ST0
005f6efc FLD dword ptr [ESP + 0x10]
005f6f00 FADD dword ptr [ESP + 0x1c]
005f6f04 FSUB dword ptr [0x006e97d8]   ; [006e97d8] f32=1.0 i32=1065353216 f64=3.63170317588e+19
005f6f0a FSTP dword ptr [EAX + 0x20]
005f6f0d ADD ESP,0x14
005f6f10 RET
