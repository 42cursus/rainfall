# Research notes

This is the working log, including experiments that did not succeed. The verified VM procedure is in `../walkthrough`. Addresses from local experiments may differ from the ISO VM.

```bash
p -array on -array-indexes on -- /a *(void **) 0x08049908 @ 12
set output-radix 10
set print array on
set print symbol on
set print array-indexes on

p/a *(void **) 0x08049908 @ 12
(gdb) p/a *(void **) 0x08049908 @ 12
$1 = {
  [0x0] = 0x804983c,
  [0x1] = 0x0,
  [0x2] = 0x0,
  [0x3] = 0x80483b6 <printf@plt+6>,
  [0x4] = 0x80483c6 <fgets@plt+6>,
  [0x5] = 0x80483d6 <time@plt+6>,
  [0x6] = 0x80483e6 <strcpy@plt+6>,
  [0x7] = 0x80483f6 <malloc@plt+6>,
  [0x8] = 0x8048406 <puts@plt+6>,
  [0x9] = 0x8048416 <__gmon_start__@plt+6>,
  [0xa] = 0x8048426 <__libc_start_main@plt+6>,
  [0xb] = 0x8048436 <fopen@plt+6>
}


set language c
macro define func_ptr_t void(*)(void)
p *(func_ptr_t *) 0x8049a2c @ 12

(gdb) p *(func_ptr_t *) 0x8049a2c @ 12
$9 =   {[0] = 0x8049960 <_DYNAMIC>,
[1] = 0,
[2] = 0,
[3] = 0x8048416 <printf@plt+6>,
[4] = 0x8048426 <free@plt+6>,
[5] = 0x8048436 <strdup@plt+6>,
[6] = 0x8048446 <fgets@plt+6>,
[7] = 0x8048456 <fwrite@plt+6>,
[8] = 0x8048466 <strcpy@plt+6>,
[9] = 0x8048476 <malloc@plt+6>,
[10] = 0x8048486 <system@plt+6>,
[11] = 0x8048496 <__gmon_start__@plt+6>}

```

```bash
(gdb) pipe mt pr msymbols | grep -E '\.bss|\.data'
[30] D 0x8048808 _fp_hw section .rodata  level8.c
[31] D 0x804880c _IO_stdin_used section .rodata  level8.c
[53] D 0x8049a60 __data_start section .data  level8.c
[54] D 0x8049a60 data_start section .data  level8.c
[55] D 0x8049a64 __dso_handle section .data  level8.c
[57] A 0x8049a68 _edata section *ABS*  level8.c
[58] B 0x8049a80 stdin section .bss
[59] B 0x8049a80 stdin@@GLIBC_2.0 section .bss  level8.c
[60] B 0x8049aa0 stdout section .bss
[61] B 0x8049aa0 stdout@@GLIBC_2.0 section .bss  level8.c
[62] b 0x8049aa4 completed.6159 section .bss  completed  crtstuff.c
[63] b 0x8049aa8 dtor_idx.6161 section .bss  dtor_idx  crtstuff.c
[64] B 0x8049aac auth section .bss  level8.c
[65] B 0x8049ab0 service section .bss  level8.c

```
