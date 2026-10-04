# Research notes

This is the working log, including experiments that did not succeed. The verified VM procedure is in `../walkthrough`. Addresses from local experiments may differ from the ISO VM.

```bash
# install ghidra r2 plugin
r2pm -U
r2pm -ci r2ghidra
r2pm -ci r2dec

# verify
r2 -q

r2 -e bin.relocs.apply=true -AA ./level7
s sym.main
afvn i2 var_18h
afvt i2 'struct internet *'
afvn i1 var_1ch
afvt i1 'struct internet *'
afs int main(int ac, char **av)
afvb 8 ac int
afvb 12 av char**
afv

afs int main(int ac, char **av)
afvb 8 ac int
afvb 12 av char**
"td struct internet { int priority; char *name; }"
e r2ghidra.roprop=2

afs #int main (int ac, char **av);
pdg

int main(int ac,char **av) {
  char *dest;
  uint *puVar1;
  int iVar2;

  dest = sym.imp.malloc(0x40);
  puVar1 = sym.imp.malloc(4);
  *puVar1 = sym.m;
  strcpy(dest,av[1]);
  iVar2 = (**puVar1)();
  return iVar2;
}


[0x08048521]> afv
var char * size @ esp+0x4
var file* stream @ esp+0x8
var void * var_18h @ esp+0x18
var void * var_1ch @ esp+0x1c
arg char ** envp @ ebp+0xc

```

```bash
$(python -c 'import struct; \
print "_"*72 + \
struct.pack("<I", 0x08048454)')

```
