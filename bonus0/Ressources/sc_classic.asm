xor eax, eax
push eax                 ; NUL terminator
push 0x68732f2f          ; "//sh"
push 0x6e69622f          ; "/bin"
mov  ebx, esp            ; ebx = "/bin//sh"

push eax                 ; argv[1] = NULL
push ebx                 ; argv[0] = "/bin//sh"
mov  ecx, esp            ; ecx = argv

mov  al, 0xb
int  0x80
