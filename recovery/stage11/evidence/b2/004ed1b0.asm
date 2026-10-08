004ed1b0 MOV EAX,dword ptr [ECX]
004ed1b2 TEST EAX,EAX
004ed1b4 JZ 0x004ed1ba
004ed1b6 FLD dword ptr [EAX + 0x20]
004ed1b9 RET
004ed1ba FLD dword ptr [0x006ea454]   ; [006ea454] f32=0.0 i32=0 f64=-2048.0
004ed1c0 RET
