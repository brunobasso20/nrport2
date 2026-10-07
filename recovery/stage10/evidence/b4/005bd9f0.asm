005bd9f0 MOV EAX,[0x00ebbcec]
005bd9f5 MOV CL,byte ptr [ESP + 0x4]
005bd9f9 MOV DL,byte ptr [ESP + 0x8]
005bd9fd MOV byte ptr [EAX],CL
005bd9ff MOV EAX,[0x00ebbcec]
005bda04 INC EAX
005bda05 MOV [0x00ebbcec],EAX
005bda0a MOV byte ptr [EAX],DL
005bda0c MOV EAX,[0x00ebbcec]
005bda11 INC EAX
005bda12 MOV [0x00ebbcec],EAX
005bda17 RET
