# r2ghidra behaviour
e r2ghidra.vars=true
e r2ghidra.roprop=2
e r2ghidra.rawptr=false
e r2ghidra.maximplref=4

# reconstructed types
to ./study/include/types.h

# main prototype
aaaa
s sym.main
afs int main(int ac, char **av)

# recovered args
afvb 8 ac int
afvb 12 av char**

# recovered locals
afvn i1 var_1ch
afvt i1 'struct internet *'
afvn i2 var_18h
afvt i2 'struct internet *'
