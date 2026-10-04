# Research notes

This is the working log, including experiments that did not succeed. The verified VM procedure is in `../walkthrough`. Addresses from local experiments may differ from the ISO VM.


## Initial configuration

```text
  GCC stack protector support:            Enabled
  Strict user copy checks:                Disabled
  Restrict /dev/mem access:               Enabled
  Restrict /dev/kmem access:              Enabled
  grsecurity / PaX: No GRKERNSEC
  Kernel Heap Hardening: No KERNHEAP
 System-wide ASLR (kernel.randomize_va_space): Off (Setting: 0)
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
No RELRO        No canary found   NX enabled    No PIE          No RPATH   No RUNPATH   /home/user/level0/level0
```

## Examine the ELF binary

```bash

level0@RainFall:~$ file ./level0
./level0: setuid ELF 32-bit LSB executable, Intel 80386, version 1 (GNU/Linux),\
  statically linked, for GNU/Linux 2.6.24,\
  BuildID[sha1]=0x85cf4024dbe79c7ccf4f30e7c601a356ce04f412, not stripped

.../RainFall/level0$ objdump -M intel -d --visualize-jumps=extended-color ./level0 | grep '<main>' -A62
08048ec0 <main>:
 8048ec0:	       55                   	push   ebp
 8048ec1:	       89 e5                	mov    ebp,esp
 8048ec3:	       83 e4 f0             	and    esp,0xfffffff0
 8048ec6:	       83 ec 20             	sub    esp,0x20
 8048ec9:	       8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 8048ecc:	       83 c0 04             	add    eax,0x4
 8048ecf:	       8b 00                	mov    eax,DWORD PTR [eax]
 8048ed1:	       89 04 24             	mov    DWORD PTR [esp],eax
 8048ed4:	       e8 37 08 00 00       	call   8049710 <atoi>
 8048ed9:	       3d a7 01 00 00       	cmp    eax,0x1a7                 ; <== Interesing!
 8048ede:	/----- 75 78                	jne    8048f58 <main+0x98>
 8048ee0:	|      c7 04 24 48 53 0c 08 	mov    DWORD PTR [esp],0x80c5348
 8048ee7:	|      e8 04 7d 00 00       	call   8050bf0 <__strdup>
 8048eec:	|      89 44 24 10          	mov    DWORD PTR [esp+0x10],eax
 8048ef0:	|      c7 44 24 14 00 00 00 	mov    DWORD PTR [esp+0x14],0x0
 8048ef7:	|      00 
 8048ef8:	|      e8 83 b7 00 00       	call   8054680 <__getegid>
 8048efd:	|      89 44 24 1c          	mov    DWORD PTR [esp+0x1c],eax
 8048f01:	|      e8 6a b7 00 00       	call   8054670 <__geteuid>
 8048f06:	|      89 44 24 18          	mov    DWORD PTR [esp+0x18],eax
 8048f0a:	|      8b 44 24 1c          	mov    eax,DWORD PTR [esp+0x1c]
 8048f0e:	|      89 44 24 08          	mov    DWORD PTR [esp+0x8],eax
 8048f12:	|      8b 44 24 1c          	mov    eax,DWORD PTR [esp+0x1c]
 8048f16:	|      89 44 24 04          	mov    DWORD PTR [esp+0x4],eax
 8048f1a:	|      8b 44 24 1c          	mov    eax,DWORD PTR [esp+0x1c]
 8048f1e:	|      89 04 24             	mov    DWORD PTR [esp],eax
 8048f21:	|      e8 da b7 00 00       	call   8054700 <__setresgid>
 8048f26:	|      8b 44 24 18          	mov    eax,DWORD PTR [esp+0x18]
 8048f2a:	|      89 44 24 08          	mov    DWORD PTR [esp+0x8],eax
 8048f2e:	|      8b 44 24 18          	mov    eax,DWORD PTR [esp+0x18]
 8048f32:	|      89 44 24 04          	mov    DWORD PTR [esp+0x4],eax
 8048f36:	|      8b 44 24 18          	mov    eax,DWORD PTR [esp+0x18]
 8048f3a:	|      89 04 24             	mov    DWORD PTR [esp],eax
 8048f3d:	|      e8 4e b7 00 00       	call   8054690 <__setresuid>
 8048f42:	|      8d 44 24 10          	lea    eax,[esp+0x10]
 8048f46:	|      89 44 24 04          	mov    DWORD PTR [esp+0x4],eax
 8048f4a:	|      c7 04 24 48 53 0c 08 	mov    DWORD PTR [esp],0x80c5348 ; <== Interesing!
 8048f51:	|      e8 ea b6 00 00       	call   8054640 <execv>
 8048f56:	|  /-- eb 28                	jmp    8048f80 <main+0xc0>
 8048f58:	\--|-> a1 70 e1 0e 08       	mov    eax,ds:0x80ee170
 8048f5d:	   |   89 c2                	mov    edx,eax
 8048f5f:	   |   b8 50 53 0c 08       	mov    eax,0x80c5350
 8048f64:	   |   89 54 24 0c          	mov    DWORD PTR [esp+0xc],edx
 8048f68:	   |   c7 44 24 08 05 00 00 	mov    DWORD PTR [esp+0x8],0x5
 8048f6f:	   |   00 
 8048f70:	   |   c7 44 24 04 01 00 00 	mov    DWORD PTR [esp+0x4],0x1
 8048f77:	   |   00 
 8048f78:	   |   89 04 24             	mov    DWORD PTR [esp],eax
 8048f7b:	   |   e8 b0 12 00 00       	call   804a230 <_IO_fwrite>
 8048f80:	   \-> b8 00 00 00 00       	mov    eax,0x0
 8048f85:	       c9                   	leave  
 8048f86:	       c3                   	ret    
 8048f87:	       90                   	nop
 8048f88:	       90                   	nop
 8048f89:	       90                   	nop
 8048f8a:	       90                   	nop
 8048f8b:	       90                   	nop
 8048f8c:	       90                   	nop
 8048f8d:	       90                   	nop
 8048f8e:	       90                   	nop
 8048f8f:	       90                   	nop
```

```bash
level0@RainFall:~$ gdb ./level0 
Reading symbols from /home/user/level0/level0...(no debugging symbols found)...done.
(gdb) start
Temporary breakpoint 1 at 0x8048ec3
   0x8048eb3 <frame_dummy+51>:	je     0x8048ebe <frame_dummy+62>
   0x8048eb5 <frame_dummy+53>:	mov    DWORD PTR [esp],0x80ee0bc
   0x8048ebc <frame_dummy+60>:	call   eax
   0x8048ebe <frame_dummy+62>:	leave  
   0x8048ebf <frame_dummy+63>:	ret    
   0x8048ec0 <main>:	push   ebp
   0x8048ec1 <main+1>:	mov    ebp,esp
=> 0x8048ec3 <main+3>:	and    esp,0xfffffff0
   0x8048ec6 <main+6>:	sub    esp,0x20
   0x8048ec9 <main+9>:	mov    eax,DWORD PTR [ebp+0xc]
   0x8048ecc <main+12>:	add    eax,0x4
   0x8048ecf <main+15>:	mov    eax,DWORD PTR [eax]
   0x8048ed1 <main+17>:	mov    DWORD PTR [esp],eax
   0x8048ed4 <main+20>:	call   0x8049710 <atoi>
   0x8048ed9 <main+25>:	cmp    eax,0x1a7
   0x8048ede <main+30>:	jne    0x8048f58 <main+152>

Temporary breakpoint 1, 0x08048ec3 in main ()

(gdb) p/d 0x1a7
$1 = 423

(gdb) x/s 0x80c5348
0x80c5348:	 "/bin/sh"

```

## Finally

```bash
level0@RainFall:~$ ./level0 423
$ echo $0
/bin/sh
$ id
uid=2030(level1) gid=2020(level0) groups=2030(level1),100(users),2020(level0)
$

```